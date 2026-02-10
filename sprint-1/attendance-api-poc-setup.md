# Setup and Run the App for POC — Attendance API

---

| Author | Created on | Version | Last updated by | Last edited on |
|--------|------------|---------|-----------------|----------------|
| Mukesh Sharma | 03-02-2026 | 1.0 | Mukesh Sharma | 03-02-2026 |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [POC Architecture (AWS)](#2-poc-architecture-aws)
3. [Prerequisites](#3-prerequisites)
4. [Step 1: Create and Access EC2 Instances](#4-step-1-create-and-access-ec2-instances)
5. [Step 2: Set Up DB & Redis Server (DB server)](#5-step-2-set-up-db--redis-server-db-server)
6. [Step 3: Set Up and Run the API (API server)](#6-step-3-set-up-and-run-the-api-api-server)
7. [Step 4: Verify the Deployment](#7-step-4-verify-the-deployment)
8. [Troubleshooting](#8-troubleshooting)
9. [Contact Information](#9-contact-information)
10. [References](#10-references)

---

## 1. Introduction

This guide walks you through deploying the **Attendance API** (Python, Flask, PostgreSQL, Redis) on AWS for a **Proof of Concept (POC)**. The API runs on one EC2 instance (API server) in a private subnet; PostgreSQL and Redis run on another EC2 instance (DB server) in a different private subnet. Follow the steps in order so a beginner can complete the deployment.

**What you will do:**

- Use two EC2 instances (Ubuntu) in separate private subnets.
- On the **DB server**: install and run PostgreSQL and Redis, create the database, and allow connections from the API server.
- On the **API server**: clone the repo, install dependencies (Poetry), configure the API to point to the DB server, run migrations, and start the API.

---

## 2. POC Architecture (AWS)

| Component | Location | Role |
|-----------|----------|------|
| **DB server (PostgreSQL & Redis)** | Private subnet A | Runs PostgreSQL (port 5432) and Redis (port 6379). Only the API server needs to reach it. |
| **API server (Attendance API)** | Private subnet B | Runs the Attendance API (port 8080). Connects to the DB server for DB and cache. |

**Network:** Both instances use private IPs. The API server must be able to reach the DB server on ports **5432** (PostgreSQL) and **6379** (Redis). Use Security Groups: on the DB server, allow inbound **5432** and **6379** from the API server’s private IP or from the API subnet CIDR.

**Data flow:** Client → (optional) Load Balancer / Bastion → API server (API:8080) → DB server (PostgreSQL, Redis).

---

## 3. Prerequisites

Before starting, ensure you have:

| Requirement | Description |
|-------------|-------------|
| AWS account | With permissions to create VPC, subnets, and EC2 instances. |
| Two private subnets | In the same VPC (or with routing so they can talk). |
| SSH key pair | To log in to both EC2 instances. |
| Basic familiarity | SSH, terminal, and editing text files (e.g. `vi` or `nano`). |

**Software (installed on the instances in the steps below):** Ubuntu 22.04 LTS on both EC2s; on the DB server you will install PostgreSQL and Redis; on the API server you will install Python 3.11, Poetry, and Liquibase.

---

## 4. Step 1: Create and Access EC2 Instances

### 4.1 Launch two EC2 instances

1. In AWS Console, go to **EC2 → Launch Instance**.
2. **DB server (PostgreSQL & Redis):**
   - Name: `attendance-poc-db-redis`
   - AMI: **Ubuntu Server 22.04 LTS**
   - Instance type: e.g. **t3.small** (or t3.medium for more headroom).
   - Key pair: select or create an SSH key pair.
   - Network: choose a **private subnet** (Subnet A). Ensure the subnet has a route (e.g. via NAT) if you need to install packages from the internet.
   - Security group: create one (e.g. `sg-db-redis`). Add inbound rules:
     - **SSH (22)** from your bastion or IP so you can administer the server.
     - **5432** (PostgreSQL) from the API server’s private IP or from the API subnet CIDR.
     - **6379** (Redis) from the API server’s private IP or from the API subnet CIDR.
   - Launch the instance. Note its **Private IP** (e.g. `10.0.1.50`).

3. **API server (Attendance API):**
   - Name: `attendance-poc-api`
   - AMI: **Ubuntu Server 22.04 LTS**
   - Instance type: e.g. **t3.small**
   - Same key pair.
   - Network: choose a **different private subnet** (Subnet B).
   - Security group: allow **SSH (22)** for you, and **8080** (or 80) if you need to reach the API from a browser or load balancer.
   - Launch the instance. Note its **Private IP**.

### 4.2 Update DB server Security Group for API server

After the API server is created, edit the DB server’s security group: set the source for **5432** and **6379** to the API server’s private IP (e.g. `10.0.2.20/32`) or to the CIDR of Subnet B.

### 4.3 SSH into the instances

From your machine (or bastion), SSH using the key and the **private IP** (or public IP if they have one):

```bash
# path to your .pem key and DB server private IP
ssh -i /path/to/your-key.pem ubuntu@<DB-Server-Private-IP>

# path to your .pem key and API server private IP
ssh -i /path/to/your-key.pem ubuntu@<API-Server-Private-IP>
```

Use `ubuntu` as the user for Ubuntu AMI. Keep both terminals open; we will use the **DB server** first, then the **API server**.

---

## 5. Step 2: Set Up DB & Redis Server (DB server)

All commands in this section are run on the **DB server** (PostgreSQL & Redis).

### 5.1 Install PostgreSQL 16

```bash
sudo apt update
# Add PostgreSQL official repo for version 16
sudo apt install -y postgresql-common
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update
sudo apt install -y postgresql-16 postgresql-contrib-16
sudo systemctl start postgresql
sudo systemctl enable postgresql
```

Allow PostgreSQL to accept connections from the API server (replace `10.0.2.0/24` with your API subnet CIDR if different).

**Step A — Confirm PostgreSQL 16 is installed**

```bash
ls /etc/postgresql/
```

You should see a folder named `16`. This guide uses **PostgreSQL 16**.

**Step B — Edit the main config so PostgreSQL listens on the network**

```bash
sudo nano /etc/postgresql/16/main/postgresql.conf
```

Find the line that says `#listen_addresses = 'localhost'`. Remove the `#` at the start and change `'localhost'` to `'*'` so the line becomes:

```text
listen_addresses = '*'
```

Save and exit (in nano: `Ctrl+O`, Enter, then `Ctrl+X`).

**Step C — Allow the API server’s subnet to connect**

```bash
sudo vi /etc/postgresql/16/main/pg_hba.conf
```

Add this line at the end of the file:

```text
# set to your API server subnet (e.g. 10.0.2.0/24)
host    all    all    10.0.2.0/24    scram-sha-256
```

In vi: press `i` to enter insert mode, move to the end of the file (or a new line), type the line above, then press `Esc`, type `:wq` and press Enter to save and exit.

**Step D — Restart PostgreSQL**

```bash
sudo systemctl restart postgresql
```

Set the `postgres` user password (needed for remote login):

```bash
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '12345';"
```

### 5.2 Add DB variables to bashrc and create the database

Add these lines to your shell config so they load in every new terminal:

```bash
vi ~/.bashrc
```

At the end of the file, add:

```text
# postgres user (change if different)
export POSTGRESQL_USERNAME=postgres
# postgres password (change if different)
export PGPASSWORD=12345
export POSTGRESQL_HOST=localhost
```

Save and exit (`Esc`, then `:wq` in vi). Load them in the current terminal:

```bash
source ~/.bashrc
```

Create only the database (the table will be created by Liquibase from the API server later):

```bash
psql -U postgres -h localhost -c 'CREATE DATABASE attendance_db;'
```

(If `psql` asks for a password, type `12345`.)

Check that the database exists:

```bash
sudo -u postgres psql -c "\l" | grep attendance_db
```

### 5.3 Install and run Redis

```bash
sudo apt install -y redis-server
```

Edit the Redis config so the API server can connect (Redis listens on all interfaces):

```bash
sudo vi /etc/redis/redis.conf
```

Make three changes:

1. **supervised** — Find the line `supervised no` and change it to:
   ```text
   # use systemd for supervision
   supervised systemd
   ```
2. **bind** — Find the line `bind 127.0.0.1 -::1` and change it to:
   ```text
   # so the API server can connect
   bind 0.0.0.0 -::1
   ```
3. **requirepass** — Find the line `# requirepass foobared` (or add a new line if missing) and set the Redis password:
   ```text
   # set to 12345 (same as in config.yaml on API server)
   requirepass 12345
   ```

In vi: press `i` to insert, edit the line, press `Esc`, then `:wq` and Enter to save and exit.

Restart and enable Redis:

```bash
sudo systemctl restart redis-server
sudo systemctl enable redis-server
```

Test Redis locally (use the password you set):

```bash
redis-cli -a 12345 ping
# Should reply: PONG
```

Note the DB server’s **private IP** (e.g. `10.0.1.50`). You will use it in `config.yaml` and Liquibase on the API server.

---

## 6. Step 3: Set Up and Run the API (API server)

All commands in this section are run on the **API server**.

### 6.1 Install Python, Poetry, Java, and Liquibase

```bash
sudo apt update
sudo apt install -y python3.11 python3.11-venv python3-pip curl default-jre unzip

# Install Poetry
curl -sSL https://install.python-poetry.org | python3 -
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Install Liquibase (needed for database migrations):

```bash
cd ~
wget -q https://github.com/liquibase/liquibase/releases/download/v4.24.0/liquibase-4.24.0.tar.gz
tar xzf liquibase-4.24.0.tar.gz
sudo mv liquibase /opt/
echo 'export PATH="/opt/liquibase:$PATH"' >> ~/.bashrc
source ~/.bashrc
liquibase --version
```

(If the download URL changes, get the latest from [Liquibase releases](https://github.com/liquibase/liquibase/releases).)

### 6.2 Clone the repository and install dependencies

```bash
cd ~
git clone https://github.com/OT-MICROSERVICES/attendance-api.git
cd attendance-api
```

Install Make (required for the project Makefile), then install project dependencies:

```bash
sudo apt install -y make
make build
```

### 6.3 Configure the API to use the DB server (PostgreSQL and Redis)

Edit `config.yaml`:

```bash
vi config.yaml
```

Use the structure below. The lines marked with comments are the ones you must set for your environment:

```yaml
---
postgres:
  database: attendance_db
  # set to DB server private IP
  host: ""         
  port: 5432
  user: postgres
  # set to 12345 (same as on DB server)
  password: ""      

redis:
  # set to DB server private IP
  host: ""
  port: 6379
  # set to 12345 (same as on DB server)
  password: ""
```

Save and exit.

### 6.4 Run Liquibase migrations (create the schema)

The DB server only has the empty database; the `records` table is created by Liquibase from the API server. Edit `liquibase.properties` so the JDBC URL points to the DB server:

```bash
vi liquibase.properties
```

Use the structure below (comment above each value you must set):

```properties
# set to DB server private IP
url=jdbc:postgresql://DB-SERVER-PRIVATE-IP:5432/attendance_db
driver=org.postgresql.Driver
username=postgres
# set to 12345 (same as on DB server)
password=12345
changeLogFile=migration/db.changelog-master.xml
```

Run the migration to create the `records` table:

```bash
liquibase update --driver-properties-file=liquibase.properties
```

Or use the project Makefile:

```bash
make run-migrations
```

### 6.5 Create a systemd service and start the API

Create a systemd service so the API runs in the background, survives reboots, and can be managed with `systemctl` (no `nohup` needed).

Create the service file:

```bash
sudo vi /etc/systemd/system/attendance-api.service
```

Use the following unit. Adjust `WorkingDirectory` if your repo is not in `ubuntu`’s home:

```ini
[Unit]
Description=Attendance API (Gunicorn)
After=network.target

[Service]
Type=simple
User=ubuntu
Group=ubuntu
# set to the path where you cloned attendance-api (e.g. /home/ubuntu/attendance-api)
WorkingDirectory=/home/ubuntu/attendance-api
ExecStart=/home/ubuntu/.local/bin/gunicorn app:app --log-config log.conf -b 0.0.0.0:8080
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
```

If Gunicorn is installed elsewhere (e.g. in a venv), set `ExecStart` to the full path of that `gunicorn` (e.g. `/home/ubuntu/attendance-api/.venv/bin/gunicorn ...`).

Reload systemd, enable the service (start on boot), and start it:

```bash
sudo systemctl daemon-reload
sudo systemctl enable attendance-api
sudo systemctl start attendance-api
```

Check status and logs:

```bash
sudo systemctl status attendance-api
sudo journalctl -u attendance-api -f
```

To restart after changing config or code:

```bash
sudo systemctl restart attendance-api
```

The API listens on **port 8080** on the API server. Swagger UI: `http://<API-SERVER-IP>:8080/apidocs` (use the API server’s private or public IP depending on how you access it).

---

## 7. Step 4: Verify the Deployment

Run these from your laptop or a machine that can reach the API server. Use the same IP in every command below.

**Health (shallow):**

```bash
# replace with API server private or public IP
curl http://API-SERVER-IP:8080/api/v1/attendance/health
```

**Health (detailed; checks PostgreSQL and Redis):**

```bash
# replace with API server private or public IP
curl http://API-SERVER-IP:8080/api/v1/attendance/health/detail
```

**Metrics:**

```bash
# replace with API server private or public IP
curl http://API-SERVER-IP:8080/metrics
```

**Swagger UI:** Open in a browser: `http://API-SERVER-IP:8080/apidocs` (replace `API-SERVER-IP` with the API server’s IP).

**Create a test record (POST):**

```bash
# replace with API server private or public IP
curl -X POST http://API-SERVER-IP:8080/api/v1/attendance/create \
  -H "Content-Type: application/json" \
  -d '{"id":"emp-001","name":"John Doe","status":"present","date":"2026-02-03"}'
```

**Search:**

```bash
# replace with API server private or public IP
curl "http://API-SERVER-IP:8080/api/v1/attendance/search?id=emp-001"
curl "http://API-SERVER-IP:8080/api/v1/attendance/search/all"
```

If all responses look correct, the POC deployment is successful.

---

## 8. Troubleshooting

| Issue | What to check |
|-------|----------------|
| **Cannot SSH to EC2** | Key permissions (`chmod 400 key.pem`), security group allows your IP on port 22, correct user (`ubuntu`). |
| **API cannot connect to PostgreSQL** | DB server security group allows 5432 from API server; `listen_addresses = '*'` and `pg_hba.conf` include API subnet; password `12345` in `config.yaml`. |
| **API cannot connect to Redis** | DB server security group allows 6379 from API server; Redis bound to `0.0.0.0`; password in `config.yaml` must be `12345`. |
| **Liquibase / migration fails** | `liquibase.properties` uses DB server IP and password `12345`; DB `attendance_db` exists; table may already exist (you can skip migrations). |
| **502 / connection refused to API** | Service running: `sudo systemctl status attendance-api`; if not, `sudo systemctl start attendance-api` and check logs with `sudo journalctl -u attendance-api -n 50`; API server security group allows 8080 from your IP or LB. |
| **Health detail shows postgres/redis down** | Run health again after fixing connectivity; check `config.yaml` and DB server firewall. |

---

## 9. Contact Information

| Name | Email address |
|------|----------------|
| Mukesh Kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 10. References

| Links | Descriptions |
|-------|--------------|
| [Attendance API (OT-MICROSERVICES)](https://github.com/OT-MICROSERVICES/attendance-api) | Repository and README. |
| [PostgreSQL on Ubuntu](https://www.postgresql.org/download/linux/ubuntu/) | Install PostgreSQL on Ubuntu. |
| [Redis on Ubuntu](https://redis.io/docs/getting-started/installation/install-redis-on-linux/) | Install Redis on Linux. |
| [Poetry](https://python-poetry.org/docs/) | Python dependency management. |
| [Liquibase](https://docs.liquibase.com/) | Database migrations. |
