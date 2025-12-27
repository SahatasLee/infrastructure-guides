package main

import (
	"context"
	"crypto/sha256"
	"crypto/sha512"
	"hash"
	"log"
	"os"
	"os/signal"
	"path/filepath"
	"strconv"
	"strings"
	"sync"

	"github.com/IBM/sarama"
	"github.com/joho/godotenv"
	"github.com/xdg-go/scram"
)

func main() {
	// Load .env file
	envPath := findEnvFile()
	if envPath != "" {
		if err := godotenv.Load(envPath); err != nil {
			log.Printf("Error loading .env file: %v", err)
		} else {
			log.Printf("Loaded configuration from %s", envPath)
		}
	} else {
		log.Println("No .env file found, using system environment variables or defaults")
	}

	// Configuration
	brokers := os.Getenv("KAFKA_BROKERS")
	if brokers == "" {
		brokers = "10.10.1.6:9094"
	}
	topic := os.Getenv("KAFKA_TOPIC")
	if topic == "" {
		topic = "test-topic"
	}
	groupID := os.Getenv("KAFKA_GROUP_ID")
	if groupID == "" {
		groupID = "test-group"
	}
	username := os.Getenv("KAFKA_USERNAME")
	password := os.Getenv("KAFKA_PASSWORD")

	config := sarama.NewConfig()
	config.Consumer.Group.Rebalance.Strategy = sarama.BalanceStrategyRoundRobin
	config.Consumer.Offsets.Initial = sarama.OffsetOldest

	// SASL/SCRAM Configuration
	if username != "" && password != "" {
		config.Net.SASL.Enable = true
		config.Net.SASL.User = username
		config.Net.SASL.Password = password
		config.Net.SASL.Mechanism = sarama.SASLTypeSCRAMSHA512
		config.Net.SASL.SCRAMClientGeneratorFunc = func() sarama.SCRAMClient { return &XDGSCRAMClient{HashGeneratorFcn: SHA512} }
	}

	// Create Consumer Group
	consumer, err := sarama.NewConsumerGroup(strings.Split(brokers, ","), groupID, config)
	if err != nil {
		log.Fatalf("Error creating consumer group client: %v", err)
	}

	// Worker Configuration
	numWorkers := 1
	if workersEnv := os.Getenv("KAFKA_WORKERS"); workersEnv != "" {
		if n, err := strconv.Atoi(workersEnv); err == nil && n > 0 {
			numWorkers = n
		}
	}

	enableCommit := true
	if commitEnv := os.Getenv("KAFKA_ENABLE_COMMIT"); commitEnv != "" {
		if val, err := strconv.ParseBool(commitEnv); err == nil {
			enableCommit = val
		}
	}
	log.Printf("Commit messages enabled: %v", enableCommit)

	ctx, cancel := context.WithCancel(context.Background())
	client := &Consumer{
		ready: make(chan bool),
		jobs:  make(chan Job, numWorkers*10), // Buffer jobs
	}

	// Start Workers
	log.Printf("Starting %d workers...", numWorkers)
	for w := 1; w <= numWorkers; w++ {
		go worker(w, client.jobs, enableCommit)
	}

	wg := &sync.WaitGroup{}
	wg.Add(1)
	go func() {
		defer wg.Done()
		for {
			// `Consume` should be called inside an infinite loop, when a
			// server-side rebalance happens, the consumer session will need to be
			// recreated to get the new claims
			if err := consumer.Consume(ctx, []string{topic}, client); err != nil {
				log.Fatalf("Error from consumer: %v", err)
			}
			// check if context was cancelled, signaling that the consumer should stop
			if ctx.Err() != nil {
				return
			}
			client.ready = make(chan bool)
		}
	}()

	log.Printf("Consumer started. Group: %s, Topic: %s", groupID, topic)

	// Wait for SIGINT and SIGTERM
	sigterm := make(chan os.Signal, 1)
	signal.Notify(sigterm, os.Interrupt)
	<-sigterm
	log.Println("Terminating...")
	cancel()
	wg.Wait()
	if err = consumer.Close(); err != nil {
		log.Fatalf("Error closing client: %v", err)
	}
}

// Consumer represents a Sarama consumer group consumer
type Consumer struct {
	ready chan bool
	jobs  chan Job
}

type Job struct {
	Session sarama.ConsumerGroupSession
	Message *sarama.ConsumerMessage
}

// Setup is run at the beginning of a new session, before ConsumeClaim
func (consumer *Consumer) Setup(sarama.ConsumerGroupSession) error {
	// Mark the consumer as ready
	// close(consumer.ready) // In a real app, you might use this to signal readiness
	return nil
}

// Cleanup is run at the end of a session, once all ConsumeClaim goroutines have exited
func (consumer *Consumer) Cleanup(sarama.ConsumerGroupSession) error {
	return nil
}

// ConsumeClaim must start a consumer loop of ConsumerGroupClaim's Messages().
func (consumer *Consumer) ConsumeClaim(session sarama.ConsumerGroupSession, claim sarama.ConsumerGroupClaim) error {
	for message := range claim.Messages() {
		consumer.jobs <- Job{Session: session, Message: message}
	}
	return nil
}

func worker(id int, jobs <-chan Job, enableCommit bool) {
	for job := range jobs {
		// Simulate processing time
		log.Printf("[Worker %d] Processing: value = %s, partition = %d, offset = %d",
			id, string(job.Message.Value), job.Message.Partition, job.Message.Offset)

		// Mark message as processed
		if enableCommit {
			job.Session.MarkMessage(job.Message, "")
		}
	}
}

// XDGSCRAMClient implements the sarama.SCRAMClient interface
type XDGSCRAMClient struct {
	*scram.Client
	*scram.ClientConversation
	HashGeneratorFcn scram.HashGeneratorFcn
}

func (x *XDGSCRAMClient) Begin(userName, password, authzID string) (err error) {
	x.Client, err = x.HashGeneratorFcn.NewClient(userName, password, authzID)
	if err != nil {
		return err
	}
	x.ClientConversation = x.Client.NewConversation()
	return nil
}

func (x *XDGSCRAMClient) Step(challenge string) (response string, err error) {
	response, err = x.ClientConversation.Step(challenge)
	return
}

func (x *XDGSCRAMClient) Done() bool {
	return x.ClientConversation.Done()
}

var SHA256 scram.HashGeneratorFcn = func() hash.Hash { return sha256.New() }
var SHA512 scram.HashGeneratorFcn = func() hash.Hash { return sha512.New() }

func findEnvFile() string {
	dir, err := os.Getwd()
	if err != nil {
		log.Fatal(err)
	}

	for {
		path := filepath.Join(dir, ".env")
		if _, err := os.Stat(path); err == nil {
			return path
		}

		parent := filepath.Dir(dir)
		if parent == dir {
			break
		}
		dir = parent
	}
	return ""
}
