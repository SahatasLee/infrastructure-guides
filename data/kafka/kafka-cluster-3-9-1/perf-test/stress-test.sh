#!/bin/bash

# Configuration
NAMESPACE="kafka"
DEPLOYMENT="kafka-perf-test"
TOPIC="perf-test-topic-01"
BOOTSTRAP="kafka-cluster-poc-3-9-1-kafka-bootstrap:9092"
REPLICAS=${1:-3} # Default to 3 replicas if not specified
RECORDS=1000000
RECORD_SIZE=1024
THROUGHPUT=-1

echo "=================================================="
echo "🚀 Starting Kafka Stress Test Automation"
echo "Target Replicas: $REPLICAS"
echo "Total Records per Pod: $RECORDS"
echo "=================================================="

# 1. Scale Deployment
echo "scaling deployment to $REPLICAS..."
kubectl scale deployment $DEPLOYMENT -n $NAMESPACE --replicas=$REPLICAS
kubectl rollout status deployment/$DEPLOYMENT -n $NAMESPACE

# 2. Get Pod List
PODS=$(kubectl get pods -n $NAMESPACE -l app=$DEPLOYMENT -o jsonpath='{.items[*].metadata.name}')
echo "active pods: $PODS"

# 3. Prepare and Run Tests in Parallel
echo "starting tests on all pods..."
mkdir -p results
rm -f results/*.log

for POD in $PODS; do
    echo "[$POD] configuring and starting..."
    (
        # Create Auth Config
        kubectl exec -n $NAMESPACE $POD -- bash -c "cat <<EOF > /tmp/client.properties
security.protocol=SASL_PLAINTEXT
sasl.mechanism=SCRAM-SHA-512
sasl.jaas.config=org.apache.kafka.common.security.scram.ScramLoginModule required username=\"admin\" password=\"Ohumq4zvaONGniN0BRPz3hKlsjZyWQXa\";
EOF"

        # Run Perf Test
        kubectl exec -n $NAMESPACE $POD -- /opt/kafka/bin/kafka-producer-perf-test.sh \
            --topic $TOPIC \
            --num-records $RECORDS \
            --record-size $RECORD_SIZE \
            --throughput $THROUGHPUT \
            --producer.config /tmp/client.properties \
            --producer-props bootstrap.servers=$BOOTSTRAP acks=all > "results/$POD.log" 2>&1
        
        echo "[$POD] finished."
    ) &
done

# Wait for all background jobs
wait

echo "=================================================="
echo "✅ Stress Test Completed"
echo "=================================================="

# 4. Aggregate Results
TOTAL_MB_SEC=0
TOTAL_RECORDS_SEC=0

for LOG in results/*.log; do
    MB_SEC=$(grep "MB/sec" $LOG | tail -1 | grep -o "[0-9.]* MB/sec" | awk '{print $1}')
    REC_SEC=$(grep "records/sec" $LOG | tail -1 | grep -o "[0-9.]* records/sec" | awk '{print $1}')
    
    if [ ! -z "$MB_SEC" ]; then
        echo "📄 $LOG: $MB_SEC MB/s | $REC_SEC records/s"
        TOTAL_MB_SEC=$(echo "$TOTAL_MB_SEC + $MB_SEC" | bc)
        TOTAL_RECORDS_SEC=$(echo "$TOTAL_RECORDS_SEC + $REC_SEC" | bc)
    else
        echo "⚠️ $LOG: No results found (Check error log)"
    fi
done

echo "--------------------------------------------------"
echo "📊 TOTAL THROUGHPUT: $TOTAL_MB_SEC MB/s"
echo "📊 TOTAL RECORDS/S:  $TOTAL_RECORDS_SEC records/s"
echo "--------------------------------------------------"
