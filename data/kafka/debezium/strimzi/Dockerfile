FROM quay.io/strimzi/kafka:0.38.0-kafka-3.6.0

USER root:root

# Install required utilities
RUN microdnf install -y curl tar gzip

# Create plugins directory
RUN mkdir -p /opt/kafka/plugins/debezium

# 1. Postgres Connector (v2.5.0)
RUN curl -L https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/2.5.0.Final/debezium-connector-postgres-2.5.0.Final-plugin.tar.gz | tar -xz -C /opt/kafka/plugins/debezium

# 2. MySQL Connector (v2.5.0)
RUN curl -L https://repo1.maven.org/maven2/io/debezium/debezium-connector-mysql/2.5.0.Final/debezium-connector-mysql-2.5.0.Final-plugin.tar.gz | tar -xz -C /opt/kafka/plugins/debezium

# 3. SQL Server Connector (v2.5.0)
RUN curl -L https://repo1.maven.org/maven2/io/debezium/debezium-connector-sqlserver/2.5.0.Final/debezium-connector-sqlserver-2.5.0.Final-plugin.tar.gz | tar -xz -C /opt/kafka/plugins/debezium

USER 1001
