# Apache JMeter Guide

Apache JMeter is an open-source software, a 100% pure Java application designed to load test functional behavior and measure performance. It was originally designed for testing Web Applications but has since expanded to other test functions.

## 🚀 Installation

### macOS (Homebrew)
The easiest way to install JMeter on macOS is via Homebrew.

```bash
brew install jmeter
```

### Linux
1.  Install Java (JDK 8+ is required).
    ```bash
    sudo apt update
    sudo apt install default-jdk -y
    ```
2.  Download JMeter binaries.
    ```bash
    wget https://dlcdn.apache.org//jmeter/binaries/apache-jmeter-5.6.3.tgz
    ```
3.  Extract and add to PATH.
    ```bash
    tar -xvf apache-jmeter-5.6.3.tgz
    cd apache-jmeter-5.6.3/bin
    ./jmeter
    ```

---

## 🏗️ Core Concepts

Before creating a test plan, it's essential to understand the basic building blocks:

1.  **Test Plan**: The root of your test configuration.
2.  **Thread Group**: Mimics users. You define the **Number of Threads** (users), **Ramp-up period** (how fast they start), and **Loop Count** (iterations).
3.  **Samplers**: The actual requests (e.g., HTTP Request, JDBC Request).
4.  **Listeners**: Collect and display results (e.g., View Results Tree, Summary Report).
5.  **Config Elements**: Shared configuration (e.g., HTTP Request Defaults, CSV Data Set Config).

---

## 🖥️ Creating a Test Plan (GUI Mode)

Use the GUI **only for creating and debugging** test plans. Do not use it for load testing.

1.  **Start JMeter**:
    ```bash
    jmeter
    ```
2.  **Add a Thread Group**:
    -   Right-click `Test Plan` -> `Add` -> `Threads (Users)` -> `Thread Group`.
    -   Set **Number of Threads** (e.g., 10).
    -   Set **Ramp-Up Period** (e.g., 5 seconds).
3.  **Add an HTTP Request**:
    -   Right-click `Thread Group` -> `Add` -> `Sampler` -> `HTTP Request`.
    -   Set **Server Name or IP** (e.g., `google.com`).
    -   Set **Path** (e.g., `/`).
4.  **Add a Listener**:
    -   Right-click `Thread Group` -> `Add` -> `Listener` -> `View Results Tree`.
5.  **Run the Test**: Click the Green Play button.

---

## ⚡ Running Tests (CLI Mode)

**Critical Best Practice**: Always run actual load tests in Non-GUI (CLI) mode to save resources and ensure valid results.

### Basic Command
```bash
jmeter -n -t [test-plan.jmx] -l [results.jtl]
```

- `-n`: Non-GUI mode.
- `-t`: Path to the JMX test plan file.
- `-l`: Path to output the result log file (JTL).

### Generating HTML Reports
You can generate a dashboard report automatically after the test finishes.

```bash
jmeter -n -t test-plan.jmx -l results.jtl -e -o ./report-output
```

- `-e`: Generate report dashboard after test run.
- `-o`: Output folder for the report (must be empty or not exist).

### Overriding Properties
You can pass variables from the CLI to your test plan using `-J`.

**In Test Plan**: Use `${__P(threadCount, 10)}` instead of a hardcoded number.

**Command**:
```bash
jmeter -n -t test.jmx -l results.jtl -JthreadCount=50
```

---

## 🔧 Best Practices

1.  **Disable Listeners**: In your final JMX file, disable "View Results Tree" and other resource-heavy listeners. They consume massive amounts of memory.
2.  **Use CSV Data Set**: For dynamic data (e.g., login credentials), use the CSV Data Set Config to read from files.
3.  **Run Distributed**: For massive load, set up JMeter in a Master-Slave configuration (Remote Testing).
4.  **JVM Tuning**: If running into OOM errors, increase the heap size in the `jmeter` launch script or environment variables.
    ```bash
    HEAP="-Xms1g -Xmx4g" jmeter ...
    ```
