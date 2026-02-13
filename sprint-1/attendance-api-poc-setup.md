# Setup and Run the App for POC — Attendance API Final working V1

| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 03-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  |  |  |  |


## Table of Contents

1. [Introduction](#1-introduction)
2. [POC Architecture (AWS)](#2-poc-architecture-aws)
   - 2.1 [Architecture](#21-architecture)
   - 2.2 [Dataflow Diagram](#22-dataflow-diagram)
3. [Prerequisites](#3-prerequisites)
4. [Step 1: Create and Access EC2 Instances](#4-step-1-create-and-access-ec2-instances)
   - 4.1 [Launch two EC2 instances](#41-launch-two-ec2-instances)
   - 4.2 [Update DB server Security Group](#42-update-db-server-security-group)
   - 4.3 [SSH into the instances (via bastion)](#43-ssh-into-the-instances-via-bastion)
5. [Step 2: Set Up and Run the API (API server)](#5-step-2-set-up-and-run-the-api-api-server)
   - 5.1 [Install tools, clone repo, build](#51-install-tools-clone-repo-build)
   - 5.2 [Configure config.yaml](#52-configure-configyaml)
   - 5.3 [Run Liquibase migrations](#53-run-liquibase-migrations)
   - 5.4 [Systemd service and start API](#54-systemd-service-and-start-api)
6. [Step 3: Verify the Deployment](#6-step-3-verify-the-deployment)
7. [Troubleshooting](#7-troubleshooting)
8. [FAQ](#8-faq)
9. [Contact Information](#9-contact-information)
10. [References](#10-references)

---

## 1. Introduction

Deploy the **Attendance API** (Python, Flask, PostgreSQL, Redis) on AWS for a POC: two Ubuntu EC2s — **DB server** (PostgreSQL 5432, Redis 6379) and **API server** (API on 8080). Follow steps in order.

---

## 2. POC Architecture (AWS)

| Component | Location | Role |
|-----------|----------|------|
| **Bastion** | Public subnet | Jump host for SSH. You connect here first (public IP), then SSH to DB/API servers. SG: 22 from your IP. |
| **DB server** | Private subnet A | PostgreSQL (5432), Redis (6379). SG: 22 from bastion, 5432 and 6379 from API server. |
| **API server** | Private subnet B | Attendance API (8080). SG: 22 from bastion, 8080 if needed. |

**IPs used in this doc:** Bastion has a **public IP** (use your own). DB server **10.0.1.25**, API server **10.0.2.75** (private).

### 2.1 Architecture

The diagram below shows the POC layout on AWS: the **bastion** in a public subnet with a public IP; the **DB server** (PostgreSQL and Redis) and **API server** (Attendance API) in separate private subnets. Administrators reach the bastion over SSH, then jump to the DB or API server using private IPs. The API server is the only component that talks to the DB server (ports 5432 and 6379).

<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/0f35bef4-a3a0-4e77-a455-57d4287c649c" />

<img width="1536" height="1024" alt="e1f38ea0-17a0-4416-bc14-2d43a21c4787" src="https://github.com/user-attachments/assets/89e0f54b-0efc-4705-9f2a-737bbf172012" />

### 2.2 Dataflow Diagram


The diagram below illustrates how traffic flows in this POC: clients (or a load balancer) send HTTP requests to the **API server** on port 8080; the API server uses **PostgreSQL** for persistent attendance data and **Redis** for caching. All access to the DB server (10.0.1.25) is from the API server only; user access to the instances is via the **bastion** over SSH.

<img width="1515" height="563" alt="Screenshot from 2026-02-10 21-47-55" src="https://github.com/user-attachments/assets/0b95d317-b76d-4804-8eef-fb018f265a1e" />

---

## 3. Prerequisites

| Requirement | Version / Notes |
|-------------|-----------------|
| AWS account | With permissions for VPC, subnets, EC2 |
| Private subnets | Two in same VPC (with routing) |
| Ubuntu | 22.04 LTS |
| PostgreSQL | 16 |
| Redis | From apt (e.g. 6.x / 7.x) |
| Python | 3.11 |
| Poetry | Latest (install in steps) |
| Liquibase | 4.24.0 (install in steps) |

<<<<<<< HEAD
---
=======
## Architecture
<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/0f35bef4-a3a0-4e77-a455-57d4287c649c" />

<img width="1536" height="1024" alt="e1f38ea0-17a0-4416-bc14-2d43a21c4787" src="https://github.com/user-attachments/assets/89e0f54b-0efc-4705-9f2a-737bbf172012" />


## Dataflow Diagram
<img width="1515" height="563" alt="Screenshot from 2026-02-10 21-47-55" src="https://github.com/user-attachments/assets/0b95d317-b76d-4804-8eef-fb018f265a1e" />

>>>>>>> 2e9ab8c0e7be0c730deb6145e8ec4bc6e4adec3a

## 4. Step 1: Create and Access EC2 Instances

### 4.1 Launch two EC2 instances

**Bastion (optional but used in this POC):** One EC2 in a **public subnet** with a public IP. SG: SSH (22) from your IP. Use the same key pair. You SSH to the bastion first, then from the bastion to the DB and API servers (in private subnets).

**DB server:** `attendance-poc-db-redis`, Ubuntu 22.04, t3.small, private subnet A. SG: SSH (22) from **bastion** (or bastion SG), 5432 and 6379 from API server (set after creating API server). Note **private IP**.

**API server:** `attendance-poc-api`, Ubuntu 22.04, t3.small, same key, private subnet B. SG: SSH (22) from **bastion**, 8080 if needed. Note **private IP**.

### 4.2 Update DB server Security Group

Set source for 5432 and 6379 to API server private IP (e.g. `10.0.2.75/32`) or Subnet B CIDR.

### 4.3 SSH into the instances (via bastion)


Access is through a **bastion server** (public). From your machine, SSH to the bastion; then from the bastion, SSH to the DB or API server using their **private IPs**. Use the same `.pem` key (copy it to the bastion or use agent forwarding).

**Step 1 — SSH to the bastion (from your laptop):**

```bash
# Replace with your .pem path and bastion public IP or hostname
ssh -i /path/to/your-key.pem ubuntu@<BASTION-PUBLIC-IP>
```

**Step 2 — From the bastion, SSH to DB server or API server:**

```bash
# On the bastion: ensure the .pem key is present (e.g. copy via scp from your machine first), then:
# SSH to DB server (private IP)
ssh -i /path/to/your-key.pem ubuntu@10.0.1.25

# Or SSH to API server (private IP)
ssh -i /path/to/your-key.pem ubuntu@10.0.2.75
```

If you use **agent forwarding** (no need to copy the key to the bastion), from your machine:

```bash
# Start agent and add key (on your machine)
eval $(ssh-agent -s)
ssh-add /path/to/your-key.pem

# SSH to bastion with forwarding
ssh -A -i /path/to/your-key.pem ubuntu@<BASTION-PUBLIC-IP>

# Then on the bastion you can run:
ssh ubuntu@10.0.1.25
ssh ubuntu@10.0.2.75
```

User is `ubuntu` on all hosts. Run **Step 2** on DB server, **Step 3** on API server.

---

## 5. Step 2: Set Up DB & Redis (DB server)

All commands in this section on **DB server**.

### 5.1 Install and configure PostgreSQL 16

```bash
# Refresh package lists
sudo apt update

# Install helper for adding PG repo
sudo apt install -y postgresql-common

# Add PostgreSQL 16 official repo for this Ubuntu release
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Add PostgreSQL signing key
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo apt update

# Install PostgreSQL 16 and contrib
sudo apt install -y postgresql-16 postgresql-contrib-16

# Start and enable PostgreSQL service
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Confirm version 16 is installed
ls /etc/postgresql/
```

**Edit PostgreSQL so it accepts network connections:**

1. Open the main config: `sudo vi /etc/postgresql/16/main/postgresql.conf`  
   Find the line `#listen_addresses = 'localhost'`, remove the `#` and change to `listen_addresses = '*'`. Save and exit.

2. Open the access config: `sudo vi /etc/postgresql/16/main/pg_hba.conf`  
   Add the following line at the end of the file (use your API server subnet if not 10.0.2.0/24):

   ```text
   host    all    all    10.0.2.0/24    scram-sha-256
   ```

   Save and exit.

```bash

# Restart PostgreSQL to apply config changes
sudo systemctl restart postgresql

# Set postgres user password for remote auth
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '12345';"
```

### 5.2 Bashrc and create database

Edit your shell config so the same credentials are available in every session:


```bash
vi ~/.bashrc
```

Add these lines at the **end** of the file (save and exit with `:wq`):

```text
export POSTGRESQL_USERNAME=postgres
export PGPASSWORD=12345
export POSTGRESQL_HOST=localhost
```

Then run:

```bash

# Load new env vars in current shell
source ~/.bashrc

# Create the attendance database (table created later by Liquibase)
psql -U postgres -h localhost -c 'CREATE DATABASE attendance_db;'

# Verify database exists
sudo -u postgres psql -c "\l" | grep attendance_db
```

### 5.3 Install and configure Redis

```bash
# Install Redis server
sudo apt install -y redis-server
```

Edit the Redis config so the API server can connect and a password is set:

```bash
sudo vi /etc/redis/redis.conf
```

Change these three settings (find the existing line and edit, or add if missing):

| Setting | Value | Purpose |
|---------|--------|---------|
| `supervised` | `systemd` | Use systemd for supervision |
| `bind` | `0.0.0.0 -::1` | Listen on all interfaces |
| `requirepass` | `12345` | Password (must match config.yaml on API server) |

Save and exit (`:wq`), then run:

```bash

# Restart Redis to apply config
sudo systemctl restart redis-server

# Start Redis on boot
sudo systemctl enable redis-server

# Test Redis with password (expect PONG)
redis-cli -a 12345 ping
```

Expect `PONG`. DB server IP used below: **10.0.1.25**.

---

## 5. Step 2: Set Up and Run the API (API server)

All commands in this section on **API server**.

### 5.1 Install tools, clone repo, build

```bash

# Refresh packages and install Python 3.11, pip, curl, Java (for Liquibase), unzip
sudo apt update
sudo apt install -y python3.11 python3.11-venv python3-pip curl default-jre unzip

# Install Poetry (Python dependency manager)
curl -sSL https://install.python-poetry.org | python3 -


# Download and install Liquibase for DB migrations
sudo snap install liquibase

# Verify Liquibase is on PATH
liquibase --version


# Clone the Attendance API repo
git clone https://github.com/OT-MICROSERVICES/attendance-api.git
cd ~/attendance/attendance-api

# Install Make and pylint (Makefile build runs pylint before poetry install)
sudo apt install -y make pylint

# Install project dependencies via Makefile (runs fmt then poetry install)
make build
```
<img width="1904" height="729" alt="Screenshot from 2026-02-13 12-35-39" src="https://github.com/user-attachments/assets/02f7cedc-2611-45f0-bc75-e01d62fb15c8" />

### 6.2 Configure config.yaml

Edit the API configuration so it connects to the DB server. From the project root (`~/attendance-api`), run:


```bash
vi config.yaml
```

Use the structure below. Set **postgres.host** and **redis.host** to the DB server private IP (**10.0.1.25**), and set both **postgres.password** and **redis.password** to **12345**. Save and exit (`:wq` in vi).

```yaml
postgres:
  # database name (create on DB server)
  database: attendance_db
  # DB server private IP
  host: "10.0.1.25"
  # PostgreSQL default port        
  port: 5432
  # DB user (same as on DB server)                
  user: postgres
  # must match ALTER USER on DB server          
  password: "12345"         
redis:
  # DB server private IP (Redis on same host)
  host: "10.0.1.25"
  # Redis default port   
  port: 6379
  # must match requirepass in redis.conf on DB server             
  password: "12345"         
```
<img width="1904" height="466" alt="Screenshot from 2026-02-13 12-51-13" src="https://github.com/user-attachments/assets/7bbad585-a761-466a-b467-2ec145beccd9" />

### 5.3 Run Liquibase migrations

Liquibase needs the DB connection details. Edit the properties file from the project root:


```bash
vi liquibase.properties
```

Set **url** to the DB server (e.g. `jdbc:postgresql://10.0.1.25:5432/attendance_db`), **username** to `postgres`, **password** to `12345`, and **changeLogFile** to `migration/db.changelog-master.xml`. Save and exit. Then run:

```bash
# Run Liquibase migrations to create the records table
liquibase update --driver-properties-file=liquibase.properties

# Alternative: make run-migrations
```
<img width="1904" height="276" alt="Screenshot from 2026-02-13 13-03-34" src="https://github.com/user-attachments/assets/d451f963-6fef-456e-a8d4-d95f02f22001" />



### 5.4 Systemd service and start API

Create a systemd unit so the API runs as a service and starts on boot. Create the unit file:


```bash
# Create systemd unit file for the API service
sudo vi /etc/systemd/system/attendance-api.service
```

Paste the unit below. If your repo path is not `/home/ubuntu/attendance-api` or Gunicorn is elsewhere (e.g. in a venv), change **WorkingDirectory** and **ExecStart** accordingly. Save and exit (`:wq`).

```ini
[Unit]
Description=Attendance API (Gunicorn)
After=network.target
[Service]
Type=simple
User=ubuntu
Group=ubuntu
WorkingDirectory=/home/ubuntu/attendance-api
ExecStart=/home/ubuntu/.local/bin/gunicorn app:app --log-config log.conf -b 0.0.0.0:8080
Restart=always
RestartSec=5
[Install]
WantedBy=multi-user.target
```
<img width="1904" height="687" alt="Screenshot from 2026-02-13 12-52-54" src="https://github.com/user-attachments/assets/929802c5-bf45-477d-a400-ec939a8fbce0" />

```bash

# Reload systemd after adding new unit file
sudo systemctl daemon-reload

# Enable service to start on boot
sudo systemctl enable attendance-api

# Start the API service now
sudo systemctl start attendance-api

# Check service status
sudo systemctl status attendance-api

# Follow service logs (Ctrl+C to exit)
sudo journalctl -u attendance-api -f
```
<img width="1904" height="945" alt="Screenshot from 2026-02-13 12-55-04" src="https://github.com/user-attachments/assets/8546b0f7-b46a-4a90-879b-17f9e016c17c" />

Restart after changes: `sudo systemctl restart attendance-api`. Swagger: `http://10.0.2.75:8080/apidocs`.

---

## 6. Step 3: Verify the Deployment

Run from a machine that can reach the API server (10.0.2.75). Base URL: `http://10.0.2.75:8080`.

| Purpose | Method | Command |
|---------|--------|---------|
| Shallow health check | GET | `curl http://10.0.2.75:8081/api/v1/attendance/health` |
| Detailed health (PostgreSQL + Redis) | GET | `curl http://10.0.2.75:8081/api/v1/attendance/health/detail` |
| Prometheus-style metrics | GET | `curl http://10.0.2.75:8081/metrics` |
| Create a test attendance record | POST | `curl -X POST http://10.0.2.75:8081/api/v1/attendance/create -H "Content-Type: application/json" -d '{"id":"emp-001","name":"John Doe","status":"present","date":"2026-02-03"}'` |
| Search by id | GET | `curl "http://10.0.2.75:8081/api/v1/attendance/search?id=emp-001"` |
| Search all | GET | `curl "http://10.0.2.75:8081/api/v1/attendance/search/all"` |

**Swagger UI:** `http://10.0.2.75:8081/apidocs`
<img width="1904" height="945" alt="Screenshot from 2026-02-13 12-57-18" src="https://github.com/user-attachments/assets/0af839f6-9231-4002-80e6-df4212acd986" />
<img width="1904" height="597" alt="Screenshot from 2026-02-13 12-59-28" src="https://github.com/user-attachments/assets/ee861553-511b-4455-a3ba-5c92ddbfa5f8" />

---

## 7. Troubleshooting

| Issue | What to check |
|-------|----------------|
| **Cannot SSH** | To bastion: `chmod 400 key.pem`; bastion SG allows your IP on 22. To DB/API from bastion: use private IPs; DB/API SG allow SSH from bastion; user `ubuntu`. |
| **API → PostgreSQL** | DB SG allows 5432 from API server; `listen_addresses = '*'`; pg_hba has API subnet; config.yaml password `12345`. |
| **API → Redis** | DB SG allows 6379 from API server; Redis `bind 0.0.0.0`; config.yaml password `12345`. |
| **Liquibase fails** | liquibase.properties has DB server IP and password `12345`; DB `attendance_db` exists. If "Driver not found": install PostgreSQL JDBC driver (e.g. download jar and add to `/opt/liquibase/lib` or use `liquibase install jdbc-driver postgresql` if available). |
| **502 / API refused** | `sudo systemctl status attendance-api`; `sudo systemctl start attendance-api`; `sudo journalctl -u attendance-api -n 50`; SG allows 8081. |
| **Health postgres/redis down** | Check config.yaml and DB server firewall. |

---

## 8. FAQ

| Question | Answer |
|----------|--------|
| **Do I need to install PostgreSQL and Redis to deploy the API?** | No. This guide only covers deploying the Attendance API on the API server. PostgreSQL and Redis must already be running on a DB server (or elsewhere); use that server’s IP and credentials in config.yaml and liquibase.properties. |
| **Which ports does the API use?** | The API listens on **8080**. It connects to PostgreSQL on **5432** and Redis on **6379** on the DB server. |
| **How do I access the API from my laptop?** | SSH to the bastion, then to the API server. From a machine that can reach the API server (e.g. via VPN or port forwarding), use the base URL `http://<API-SERVER-IP>:8080`. Swagger UI: `http://<API-SERVER-IP>:8080/apidocs`. |
| **Where do I set the DB and Redis credentials?** | In **config.yaml** (postgres and redis sections) on the API server, and in **liquibase.properties** for the JDBC URL, username, and password. |
| **How do I restart the API after a config change?** | Run `sudo systemctl restart attendance-api`. Check status with `sudo systemctl status attendance-api` and logs with `sudo journalctl -u attendance-api -f`. |
| **What if Liquibase says “Driver not found”?** | Install the PostgreSQL JDBC driver (e.g. download the JAR and place it in `/opt/liquibase/lib`, or use `liquibase install jdbc-driver postgresql` if supported by your Liquibase version). |
| **Can I run the API without a bastion?** | Yes, if your API and DB servers have another way to be reached (e.g. public IPs or direct VPN). The steps are the same; only the SSH path and security groups change. |

---

## 9. Contact Information

| Name | Email |
|------|-------|
| Mukesh Kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 10. References

| Link | Description |
|------|-------------|
| [Attendance API](https://github.com/OT-MICROSERVICES/attendance-api) | Repository and README |
| [PostgreSQL Ubuntu](https://www.postgresql.org/download/linux/ubuntu/) | Install PostgreSQL on Ubuntu |
| [Redis Linux](https://redis.io/docs/getting-started/installation/install-redis-on-linux/) | Install Redis on Linux |
| [Poetry](https://python-poetry.org/docs/) | Python dependency management |
| [Liquibase](https://docs.liquibase.com/) | Database migrations |

