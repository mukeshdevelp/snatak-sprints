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
   - 4.3 [SSH into the instances](#43-ssh-into-the-instances)
5. [Step 2: Set Up DB & Redis (DB server)](#5-step-2-set-up-db--redis-db-server)
   - 5.1 [Install and configure PostgreSQL 16](#51-install-and-configure-postgresql-16)
   - 5.2 [Bashrc and create database](#52-bashrc-and-create-database)
   - 5.3 [Install and configure Redis](#53-install-and-configure-redis)
6. [Step 3: Set Up and Run the API (API server)](#6-step-3-set-up-and-run-the-api-api-server)
   - 6.1 [Install tools, clone repo, build](#61-install-tools-clone-repo-build)
   - 6.2 [Configure config.yaml](#62-configure-configyaml)
   - 6.3 [Run Liquibase migrations](#63-run-liquibase-migrations)
   - 6.4 [Run the app using Poetry and Gunicorn](#64-run-the-app-using-poetry-and-gunicorn)
   - 6.5 [Systemd service and start API](#65-systemd-service-and-start-api)
7. [Step 4: Verify the Deployment](#7-step-4-verify-the-deployment)
8. [Troubleshooting](#8-troubleshooting)
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
| PostgreSQL | 16.0+ |
| Python | 3.11 |
| Poetry | Latest (install in steps) |
| Liquibase | 4.24.0 (install in steps) |
| Redis | 7.0+ |
| make | 4.0+|


---


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
<img width="1904" height="276" alt="Screenshot from 2026-02-13 13-07-17" src="https://github.com/user-attachments/assets/7883ff08-6fc2-401f-8438-4288cd41a812" />


### 5.3 Install and configure Redis

```bash
# Install Redis server
sudo apt install -y redis-server
```
<img width="1904" height="246" alt="Screenshot from 2026-02-13 13-30-13" src="https://github.com/user-attachments/assets/4e781bbf-6f99-4fb9-8f0c-63ef5f79a004" />

Edit the Redis config so the API server can connect and a password is set:

```bash
sudo vi /etc/redis/redis.conf
```

Change these three settings (find the existing line and edit, or add if missing):

| Setting | Value | Purpose |
|---------|--------|---------|
| `bind` | `127.0.01 10.0.1.25` | Listen on all interfaces |
| `requirepass` | `12345` | Password (must match config.yaml on API server) |
| `port` | `6379` | port should be different if some serive is listening on 6379 |


<img width="1904" height="246" alt="Screenshot from 2026-02-13 13-31-59" src="https://github.com/user-attachments/assets/8a17dc49-6c01-4790-8741-dd2a902f97ac" />

Save and exit (`:wq`), then run:

```bash

# Restart Redis to apply config
sudo systemctl restart redis-server

# Start Redis on boot
sudo systemctl enable redis-server

# Test Redis with password (expect PONG)
redis-cli -a 12345 ping
```

**Expect output 10.0.1.25**
<img width="1904" height="133" alt="Screenshot from 2026-02-13 13-19-48" src="https://github.com/user-attachments/assets/6b640fd7-d7e1-45f5-b01e-5db54ac914e1" />



---

## 6. Step 3: Set Up and Run the API (API server)

All commands in this section on **API server**.

### 6.1 Install tools, clone repo, build

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

mkdir attendance
cd attendance/
# Clone the Attendance API repo
git clone https://github.com/OT-MICROSERVICES/attendance-api.git
cd attendance-api/

# Install Make and pylint (Makefile build runs pylint before poetry install)
sudo apt install -y make pylint

# Install project dependencies via Makefile (runs fmt then poetry install)
make build
```
<img width="1904" height="729" alt="Screenshot from 2026-02-13 12-35-39" src="https://github.com/user-attachments/assets/02f7cedc-2611-45f0-bc75-e01d62fb15c8" />

<img width="1904" height="729" alt="image" src="https://github.com/user-attachments/assets/21f67cb5-12d6-41e4-adeb-eb2f4f8c9f42" />
<img width="1904" height="466" alt="Screenshot from 2026-02-13 12-38-08" src="https://github.com/user-attachments/assets/bdf03068-2826-4140-82cc-98df07ba4e54" />
<img width="1904" height="466" alt="Screenshot from 2026-02-13 12-39-17" src="https://github.com/user-attachments/assets/b46d2a92-f643-4a98-99e8-35ca24bf3076" />
liquibase version
<img width="1904" height="626" alt="Screenshot from 2026-02-13 13-22-32" src="https://github.com/user-attachments/assets/5465d430-f32d-4a07-83a6-94d71c8a1113" />


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

### 6.3 Run Liquibase migrations

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

### 6.4 Run the app using Poetry and Gunicorn

Before creating the systemd service, you can run the API manually with Poetry and Gunicorn to confirm it starts and connects to PostgreSQL and Redis. From the project root (e.g. `~/attendance/attendance-api`):

```bash
# Ensure you are in the project directory
cd ~/attendance/attendance_api

# keep the poetry env activated
source $(poetry env info --path)/bin/activate

# or activate the env
poetry env activate

# install the dependency
poetry install

# show all the dependecies
poetry show

vi ~/.bashrc
export CONFIG_FILE=/home/ubuntu/attendance/attendance_api/config.yaml
exec bash

# Run the app with Gunicorn (Poetry installs gunicorn; use the path where it is available)
# If Poetry added gunicorn to PATH:
gunicorn app:app --log-config log.conf -b 0.0.0.0:8081

# Or run via Poetry's environment (if using a venv):
poetry run gunicorn app:app --log-config log.conf -b 0.0.0.0:8081
```

- **app:app** — first `app` is the module (app.py), second is the Flask application instance.
- **--log-config log.conf** — uses the project's logging configuration.
- **-b 0.0.0.0:8080** — bind to all interfaces on port 8080.

<img width="1920" height="1080" alt="Screenshot from 2026-02-13 14-29-34" src="https://github.com/user-attachments/assets/950c6a4e-9c02-42e7-a1d7-f36e95e687a1" />
<img width="1904" height="496" alt="Screenshot from 2026-02-13 14-29-44" src="https://github.com/user-attachments/assets/5e77ec54-ea5b-4eff-a4c7-2824d4029dc5" />
<img width="1904" height="316" alt="Screenshot from 2026-02-13 14-56-29" src="https://github.com/user-attachments/assets/080be8c1-7033-4b0b-99c0-0c7b9ab39696" />

Leave this running in the foreground to test. In another terminal (or from another machine that can reach the API server), run a quick health check:

```bash
curl http://localhost:8080/api/v1/attendance/health
# Or use the server's IP, e.g. curl http://10.0.2.75:8080/api/v1/attendance/health
```



### 6.5 Systemd service and start API

Create a systemd unit so the API runs as a service and starts on boot. Create the unit file:


```bash
# Create systemd unit file for the API service
sudo vi /etc/systemd/system/attendance-api.service
```

Paste the unit below. If your repo path is not `/home/ubuntu/attendance/attendance-api` or Gunicorn is elsewhere (e.g. in a venv), change **WorkingDirectory** and **ExecStart** accordingly. Save and exit (`:wq`).

```ini
[Unit]
Description=Attendance API Gunicorn Service
After=network.target

[Service]
User=ubuntu
Group=www-data
WorkingDirectory=/home/ubuntu/attendance/attendance_api
Environment="CONFIG_FILE=/home/ubuntu/attendance/attendance_api/config.yaml"
Environment="PYTHONUNBUFFERED=1"
ExecStart=/home/ubuntu/attendance/attendance_api/.venv/bin/gunicorn \
          app:app \
          --workers 4 \
          --bind 0.0.0.0:8081 \
          --log-config log.conf

Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target

```
<img width="1904" height="687" alt="Screenshot from 2026-02-13 12-52-54" src="https://github.com/user-attachments/assets/929802c5-bf45-477d-a400-ec939a8fbce0" />

```bash

sudo systemctl daemon-reexec

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

## 7. Step 4: Verify the Deployment

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

## 8. Troubleshooting

| Issue | What to check |
|-------|----------------|
| **Cannot SSH** | To bastion: `chmod 400 key.pem`; bastion SG allows your IP on 22. To DB/API from bastion: use private IPs; DB/API SG allow SSH from bastion; user `ubuntu`. |
| **API → PostgreSQL** | DB SG allows 5432 from API server; `listen_addresses = '*'`; pg_hba has API subnet; config.yaml password `12345`. |
| **API → Redis** | DB SG allows 6379 from API server; Redis `bind 0.0.0.0`; config.yaml password `12345`. |
| **Liquibase fails** | liquibase.properties has DB server IP and password `12345`; DB `attendance_db` exists. If "Driver not found": install PostgreSQL JDBC driver (e.g. download jar and add to `/opt/liquibase/lib` or use `liquibase install jdbc-driver postgresql` if available). |
| **502 / API refused** | `sudo systemctl status attendance-api`; `sudo systemctl start attendance-api`; `sudo journalctl -u attendance-api -n 50`; SG allows 8081. |
| **Health postgres/redis down** | Check config.yaml and DB server firewall. |

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

