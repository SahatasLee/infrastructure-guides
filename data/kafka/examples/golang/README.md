# Kafka Go Examples

This directory contains simple examples of a Kafka Producer and Consumer written in Go, using the `github.com/IBM/sarama` library.

## Prerequisites

- Go 1.21+ installed.
- A running Kafka cluster (accessible via `localhost:9092` or configured via env vars).

## Setup

1. **Initialize Module (if not already done):**
   ```bash
   go mod tidy
   ```

2. **Configure Environment:**
   Copy `.env.example` to `.env` and update the values:
   ```bash
   cp .env.example .env
   ```

## Producer

The producer sends a message every second to the specified topic.

### Run
```bash
cd produce
go run main.go
```

## Consumer

The consumer joins a consumer group and reads messages from the specified topic.

### Run
```bash
cd consume
go run main.go
```


## Configuration

You can configure the examples using the following environment variables:

| Variable | Default | Description |
| :--- | :--- | :--- |
| `KAFKA_BROKERS` | `10.10.1.6:9094` | Comma-separated list of broker addresses. |
| `KAFKA_TOPIC` | `test-topic` | The Kafka topic to produce to or consume from. |
| `KAFKA_GROUP_ID` | `test-group` | The Consumer Group ID (Consumer only). |
| `KAFKA_USERNAME` | `""` | SASL Username (if required). |
| `KAFKA_PASSWORD` | `""` | SASL Password (if required). |
