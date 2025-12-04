# ClickHouse Cluster on Ubuntu

> **Description:** Guide for deploying a ClickHouse cluster (Sharded & Replicated) on Ubuntu 20.04/22.04.
> **Prerequisites:** 3+ Servers (Ubuntu), Sudo Access.

---

## 🏗️ Architecture Overview

For a robust production setup, we will configure:
- **3 ClickHouse Nodes:** Serving as both shards and replicas.
- **3 Zookeeper Nodes:** For replication coordination (can be co-located or separate).

---

## 🚀 Step 1: Install Zookeeper

ClickHouse requires Zookeeper for replication.

**On all 3 nodes:**

1. **Install Java & Zookeeper:**
   ```bash
   sudo apt update
   sudo apt install -y default-jre zookeeperd
   ```

2. **Configure Zookeeper ID:**
   On Node 1: `echo "1" | sudo tee /var/lib/zookeeper/myid`
   On Node 2: `echo "2" | sudo tee /var/lib/zookeeper/myid`
   On Node 3: `echo "3" | sudo tee /var/lib/zookeeper/myid`

3. **Configure `zoo.cfg`:**
   Edit `/etc/zookeeper/conf/zoo.cfg`:
   ```ini
   server.1=node1-ip:2888:3888
   server.2=node2-ip:2888:3888
   server.3=node3-ip:2888:3888
   ```

4. **Restart Zookeeper:**
   ```bash
   sudo systemctl restart zookeeper
   ```

---

## 🚀 Step 2: Install ClickHouse

**On all 3 nodes:**

1. **Add Repository:**
   ```bash
   sudo apt-get install -y apt-transport-https ca-certificates dirmngr
   sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E0C56BD4
   echo "deb https://repo.clickhouse.com/deb/stable/ main/" | sudo tee \
       /etc/apt/sources.list.d/clickhouse.list
   sudo apt-get update
   ```

2. **Install Server & Client:**
   ```bash
   sudo apt-get install -y clickhouse-server clickhouse-client
   ```

3. **Start Service:**
   ```bash
   sudo systemctl start clickhouse-server
   ```

---

## ⚙️ Step 3: Configure Cluster

Edit `/etc/clickhouse-server/config.xml` (or create a file in `/etc/clickhouse-server/config.d/`).

### 1. Network Access
Allow listening on all interfaces:
```xml
<listen_host>0.0.0.0</listen_host>
```

### 2. Zookeeper Config
Add Zookeeper nodes:
```xml
<zookeeper>
    <node>
        <host>node1-ip</host>
        <port>2181</port>
    </node>
    <node>
        <host>node2-ip</host>
        <port>2181</port>
    </node>
    <node>
        <host>node3-ip</host>
        <port>2181</port>
    </node>
</zookeeper>
```

### 3. Cluster Definition (`remote_servers`)
Define the cluster topology (e.g., 1 shard, 3 replicas):
```xml
<remote_servers>
    <my_cluster>
        <shard>
            <internal_replication>true</internal_replication>
            <replica>
                <host>node1-ip</host>
                <port>9000</port>
            </replica>
            <replica>
                <host>node2-ip</host>
                <port>9000</port>
            </replica>
            <replica>
                <host>node3-ip</host>
                <port>9000</port>
            </replica>
        </shard>
    </my_cluster>
</remote_servers>
```

### 4. Macros (Per Node)
Edit `/etc/clickhouse-server/config.d/macros.xml` on each node to identify itself.

**Node 1:**
```xml
<macros>
    <shard>01</shard>
    <replica>node1</replica>
</macros>
```
*(Repeat for Node 2 and 3 with unique replica names)*

---

## ✅ Step 4: Verification

1. **Restart ClickHouse:**
   ```bash
   sudo systemctl restart clickhouse-server
   ```

2. **Check Cluster:**
   ```sql
   SELECT * FROM system.clusters;
   ```

3. **Create Replicated Table:**
   ```sql
   CREATE TABLE visits (
       id UInt64,
       url String
   ) ENGINE = ReplicatedMergeTree('/clickhouse/tables/{shard}/visits', '{replica}')
   ORDER BY id;
   ```
   *Note: The `{shard}` and `{replica}` macros will be automatically replaced.*

4. **Test Replication:**
   Insert on Node 1, check on Node 2.
