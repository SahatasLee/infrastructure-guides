FROM quay.io/strimzi/kafka:0.38.0-kafka-3.6.0

USER root:root

# Install required utilities
RUN microdnf install -y curl tar gzip

# Create plugins directory
RUN mkdir -p /opt/kafka/plugins/debezium

# Download and extract Debezium Postgres Connector
# Version 2.5.0.Final
RUN curl -L https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/2.5.0.Final/debezium-connector-postgres-2.5.0.Final-plugin.tar.gz | tar -xz -C /opt/kafka/plugins/debezium

USER 1001
