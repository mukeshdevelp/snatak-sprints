# Step-by-Step Deployment Guide — OT-Microservices (APIs and Frontend)

This document is a **complete deployment guide** for all services in the API tree: **Employee API**, **Attendance API**, **Salary API**, **Notification Worker**, and **Frontend**. It covers infrastructure prerequisites, configuration, database migrations, building and running each service (locally and via Docker), and how to wire the frontend to the backends. There is no word limit; all necessary steps are included.

---

## Table of Contents

1. [Overview of the Stack](#1-overview-of-the-stack)
2. [Prerequisites](#2-prerequisites)
3. [Infrastructure Setup](#3-infrastructure-setup)
4. [Employee API — Deployment](#4-employee-api--deployment)
5. [Attendance API — Deployment](#5-attendance-api--deployment)
6. [Salary API — Deployment](#6-salary-api--deployment)
7. [Notification Worker — Deployment](#7-notification-worker--deployment)
8. [Frontend — Deployment](#8-frontend--deployment)
9. [Reverse Proxy / API Gateway (Frontend and APIs Together)](#9-reverse-proxy--api-gateway-frontend-and-apis-together)
10. [Verification and Health Checks](#10-verification-and-health-checks)
11. [Troubleshooting](#11-troubleshooting)

---

## 1. Overview of the Stack

| Component           | Technology      | Port (default) | Database / Dependencies                    |
|--------------------|-----------------|----------------|--------------------------------------------|
| **Employee API**   | Go (Gin)        | 8080           | ScyllaDB (mandatory), Redis (optional)     |
| **Attendance API**  | Python (Flask)  | 8080           | PostgreSQL (mandatory), Redis (optional)   |
| **Salary API**     | Java (Spring)   | 8080           | ScyllaDB, Redis                            |
| **Notification Worker** | Python   | N/A (worker)   | SMTP server, Elasticsearch                  |
| **Frontend**       | React           | 3000           | Depends on all three APIs (and optionally notification) |

- **Employee API** and **Salary API** share the same **ScyllaDB** keyspace (`employee_db`) for their data; Employee API manages employee info, Salary API manages salary records.
- **Attendance API** uses **PostgreSQL** for attendance records.
- **Redis** is used by Employee, Attendance, and Salary APIs for caching (optional for Employee and Attendance, expected by Salary).
- **Notification Worker** sends emails via SMTP and reads user/email data from **Elasticsearch** (e.g. index `employee-management`).
- The **Frontend** talks to the backends via relative paths (e.g. `/employee/create`, `/attendance/search`, `/salary/search/all`). In production, a **reverse proxy** or API gateway must route these paths to the correct API services.

---

## 2. Prerequisites

### 2.1 Infrastructure (to be running before deploying APIs)

- **ScyllaDB** — For Employee API and Salary API (keyspace `employee_db`).
- **PostgreSQL** — For Attendance API (database `attendance_db`).
- **Redis** — For caching (optional for Employee and Attendance; expected by Salary API).
- **Elasticsearch** — For Notification Worker (to fetch user/email data).
- **SMTP server** — For Notification Worker to send emails.

### 2.2 Tools and runtimes (on the machine where you build/run)

| Service            | Required tools / runtimes |
|--------------------|---------------------------|
| Employee API       | Go 1.20+, `migrate` (golang-migrate), `jq` (for Makefile), Docker (optional) |
| Attendance API     | Python 3.11+, Poetry, Liquibase, Docker (optional) |
| Salary API         | Java 17+, Maven, `migrate` (golang-migrate), `jq`, Docker (optional) |
| Notification Worker| Python 3.6+ (see Dockerfile), pip, Docker (optional) |
| Frontend           | Node.js 16+ (and npm or yarn), Docker (optional) |

### 2.3 Optional but recommended

- **Docker** and **Docker Compose** for running databases and services in containers.
- **Make** for using the provided Makefiles.

---

## 3. Infrastructure Setup

### 3.1 ScyllaDB

- Install and start ScyllaDB (single node or cluster) and note the host and port (default CQL port **9042**).
- Create the keyspace and tables either manually or via migrations (migrations are run in the Employee API and Salary API steps below). The keyspace name used in config is **`employee_db`**.
- Ensure the CQL user (e.g. `scylladb`) has permissions on this keyspace.

**Example (manual CQL):**

```cql
CREATE KEYSPACE IF NOT EXISTS employee_db WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 1};
```

Tables `employee_info` and `employee_salary` are created by the **migrate** tool when you run Employee API and Salary API migrations.

### 3.2 PostgreSQL

- Install and start PostgreSQL. Create a database named **`attendance_db`** and a user with full access (e.g. `postgres` / your password).

**Example:**

```bash
sudo -u postgres psql -c "CREATE DATABASE attendance_db;"
```

Tables (e.g. `records`) are created by **Liquibase** when you run Attendance API migrations.

### 3.3 Redis

- Install and start Redis (default port **6379**). If you use a password, note it for the API configs.

### 3.4 Elasticsearch (for Notification Worker)

- Install and run Elasticsearch (default port **9200**). The Notification Worker expects an index (e.g. `employee-management`) with documents containing at least `email_id` for sending mails. Configure username/password if you use security.

### 3.5 SMTP server

- Have an SMTP server (or relay) available. Note host, port, username, password, and “from” address for the Notification Worker config.

---

## 4. Employee API — Deployment

### 4.1 Clone / navigate to the repository

```bash
cd /path/to/snatak-sprints/API/employee-api
```

### 4.2 Install Go and project dependencies

- Ensure **Go 1.20** (or compatible version) is installed.

```bash
go mod download
```

### 4.3 Configuration

Edit **`config.yaml`** so that ScyllaDB (and optionally Redis) match your environment.

**Example `config.yaml`:**

```yaml
scylladb:
  host: ["<SCYLLA_HOST>:9042"]   # e.g. ["172.17.0.3:9042"] or ["localhost:9042"]
  username: scylladb
  password: password
  keyspace: employee_db

redis:
  enabled: false                  # set true if using Redis
  host: 172.17.0.4:6379
  password: password
  database: 0
```

Replace `<SCYLLA_HOST>`, credentials, and Redis settings as needed.

### 4.4 Migration configuration

Edit **`migration.json`** so the connection string matches your ScyllaDB.

**Example `migration.json`:**

```json
{"database":"cassandra://<SCYLLA_HOST>:9042/employee_db?username=scylladb&password=password"}
```

Use the same host, port, keyspace, username, and password as in `config.yaml`.

### 4.5 Install the migrate tool

- Install [golang-migrate](https://github.com/golang-migrate/migrate) (e.g. from GitHub releases or your package manager). Ensure `migrate` and `jq` are on your `PATH` for the Makefile.

### 4.6 Create keyspace (if not already created)

- If the keyspace does not exist, create it in ScyllaDB (see section 3.1). The migrate tool will create tables inside `employee_db`.

### 4.7 Run migrations

From the **employee-api** root:

```bash
make run-migrations
```

This runs `migrate -source file://migration -database "<connection_string>" up` and creates the **employee_info** table (see `migration/000001_create_employee_info_table.up.sql`).

### 4.8 Build the application

```bash
make build
```

This runs `go fmt` and builds the binary **`employee-api`** in the current directory.

### 4.9 Run the application (local)

```bash
export GIN_MODE=release
./employee-api
```

For debugging you can set `GIN_MODE=development`. The API listens on **port 8080** by default. Ensure `config.yaml` is in the working directory or the path the application expects.

### 4.10 Docker build and run (optional)

**Build image:**

```bash
make docker-build
```

Default image: `quay.io/opstree/employee-api:v0.1.0`. Override with:

```bash
APP_VERSION=v0.2.0 IMAGE_REGISTRY=myreg IMAGE_NAME=employee-api make docker-build
```

**Run container:**

You must mount **config.yaml** (and optionally `migration.json` if you run migrations from the host). Example:

```bash
docker run -d \
  --name employee-api \
  -p 8080:8080 \
  -v /path/to/your/config.yaml:/path/in/container/config.yaml \
  -e CONFIG_PATH=/path/in/container/config.yaml \
  <your-image>
```

Adjust the image name, config path, and environment variable to match how the binary reads config (e.g. current directory or env). Migrations are typically run once from the host or a job, not inside the app container.

### 4.11 Endpoints (for verification)

| Endpoint                         | Method | Description                    |
|----------------------------------|--------|--------------------------------|
| /metrics                         | GET    | Prometheus metrics             |
| /api/v1/employee/health          | GET    | Shallow health                 |
| /api/v1/employee/health/detail   | GET    | Detailed health (DB, Redis)    |
| /api/v1/employee/create          | POST   | Create employee                |
| /api/v1/employee/search          | GET    | Search employees               |
| /api/v1/employee/search/all      | GET    | List all employees             |
| /api/v1/employee/search/location | GET    | By location                    |
| /api/v1/employee/search/designation | GET | By designation                 |
| /swagger/index.html              | GET    | Swagger UI                     |

---

## 5. Attendance API — Deployment

### 5.1 Clone / navigate to the repository

```bash
cd /path/to/snatak-sprints/API/attendance-api
```

### 5.2 Python and Poetry

- Install **Python 3.11** (or version required by the project).
- Install [Poetry](https://python-poetry.org/).

### 5.3 Install dependencies

```bash
make build
```

This runs `poetry config virtualenvs.create false` and `poetry install --no-root --no-interaction --no-ansi` to install dependencies.

### 5.4 Configuration

Edit **`config.yaml`** for PostgreSQL and Redis.

**Example `config.yaml`:**

```yaml
---
postgres:
  database: attendance_db
  host: <POSTGRES_HOST>    # e.g. 172.17.0.3 or localhost
  port: 5432
  user: postgres
  password: <password>

redis:
  host: <REDIS_HOST>       # e.g. 172.17.0.4 or localhost
  port: 6379
  password: ""
```

### 5.5 Liquibase configuration

Edit **`liquibase.properties`** so the JDBC URL and credentials match your PostgreSQL.

**Example `liquibase.properties`:**

```
url=jdbc:postgresql://<POSTGRES_HOST>:5432/attendance_db
driver=org.postgresql.Driver
username=postgres
password=<password>
changeLogFile=migration/db.changelog-master.xml
```

### 5.6 Run migrations

Ensure PostgreSQL is running and the database `attendance_db` exists. Then:

```bash
make run-migrations
```

This runs `liquibase update`, which applies the changelog in **`migration/db.changelog-master.xml`** (e.g. creates the **records** table).

### 5.7 Run the application (local)

From the project root, with dependencies installed:

```bash
gunicorn app:app --log-config log.conf -b 0.0.0.0:8080
```

The API listens on **port 8080**. Ensure `config.yaml` is in the working directory (or the path the app reads).

### 5.8 Docker build and run (optional)

**Build:**

```bash
make docker-build
```

Default image: `quay.io/opstree/attendance-api:v0.1.0`.

**Run:**

Mount your **config.yaml** and ensure the container can reach PostgreSQL and Redis. Example:

```bash
docker run -d \
  --name attendance-api \
  -p 8080:8080 \
  -v /path/to/your/config.yaml:/api/config.yaml \
  <your-image>
```

Adjust the app’s config path if it reads from a different location. Run migrations once from the host or a separate job.

### 5.9 Endpoints (for verification)

| Endpoint                          | Method | Description         |
|-----------------------------------|--------|---------------------|
| /metrics                          | GET    | Prometheus metrics  |
| /apidocs                          | GET    | Swagger UI          |
| /api/v1/attendance/create         | POST   | Create attendance   |
| /api/v1/attendance/search         | GET    | Search attendance   |
| /api/v1/attendance/search/all     | GET    | List all            |
| /api/v1/attendance/health         | GET    | Shallow health      |
| /api/v1/attendance/health/detail  | GET    | Detailed health     |

---

## 6. Salary API — Deployment

### 6.1 Clone / navigate to the repository

```bash
cd /path/to/snatak-sprints/API/salary-api
```

### 6.2 Java and Maven

- Install **Java 17** and **Maven**.

### 6.3 Configuration

Edit **`src/main/resources/application.yml`** for ScyllaDB and Redis.

**Example (excerpt):**

```yaml
spring:
  cassandra:
    keyspace-name: employee_db
    contact-points: <SCYLLA_HOST>   # e.g. 172.17.0.3
    port: 9042
    username: scylladb
    password: password
    local-datacenter: datacenter1
  data:
    redis:
      host: <REDIS_HOST>            # e.g. 172.17.0.4
      port: 6379
      password: password
```

Use the same ScyllaDB keyspace as Employee API (`employee_db`).

### 6.4 Migration configuration

Edit **`migration.json`** for ScyllaDB (same keyspace as Employee API).

**Example `migration.json`:**

```json
{"database":"cassandra://<SCYLLA_HOST>:9042/employee_db?username=scylladb&password=password"}
```

### 6.5 Install the migrate tool and jq

- Ensure **migrate** (golang-migrate) and **jq** are installed; the Makefile uses them for `run-migrations`.

### 6.6 Run migrations

From the **salary-api** root:

```bash
make run-migrations
```

This creates the **employee_salary** table (see `migration/000001_create_employee_salary_table.up.sql`).

### 6.7 Build the application

```bash
make build
```

This runs `mvn clean package` and produces **`target/salary-0.1.0-RELEASE.jar`**.

### 6.8 Run the application (local)

```bash
java -jar target/salary-0.1.0-RELEASE.jar
```

The application listens on **port 8080**.

### 6.9 Docker build and run (optional)

**Build:**

```bash
make docker-build
```

Default image: `quay.io/opstree/salary-api:v0.1.0`.

**Run:**

Spring Boot can read config from environment variables or mounted files. Example:

```bash
docker run -d \
  --name salary-api \
  -p 8080:8080 \
  -e SPRING_DATA_CASSANDRA_CONTACT-POINTS=<SCYLLA_HOST> \
  -e SPRING_DATA_CASSANDRA_USERNAME=scylladb \
  -e SPRING_DATA_CASSANDRA_PASSWORD=password \
  -e SPRING_DATA_REDIS_HOST=<REDIS_HOST> \
  <your-image>
```

Adjust variables to match your Spring Boot property names (e.g. `spring.data.redis.host`).

### 6.10 Endpoints (for verification)

| Endpoint                     | Method | Description        |
|-----------------------------|--------|--------------------|
| /api/v1/salary/create/record| POST   | Create salary record |
| /api/v1/salary/search       | GET    | Search salary      |
| /api/v1/salary/search/all   | GET    | List all           |
| /actuator/prometheus        | GET    | Prometheus metrics |
| /actuator/health             | GET    | Health             |
| /salary-documentation       | GET    | Swagger UI         |

---

## 7. Notification Worker — Deployment

### 7.1 Clone / navigate to the repository

```bash
cd /path/to/snatak-sprints/API/notification-worker
```

### 7.2 Dependencies

Install Python dependencies:

```bash
make build
```

This runs `pip3 install -r requirements.txt` (packages include `emails`, `elasticsearch`, `config-with-yaml`, `schedule`).

### 7.3 Configuration

Create or edit **`config.yaml`** with SMTP and Elasticsearch settings.

**Example `config.yaml`:**

```yaml
---
smtp:
  from: "noreply@example.com"
  username: "smtp_user"
  password: "smtp_password"
  smtp_server: "smtp.example.com"
  smtp_port: "587"

elasticsearch:
  username: "elastic"
  password: "elastic"
  host: "<ES_HOST>"    # e.g. 172.17.0.2 or empms-es
  port: 9200
```

### 7.4 Environment variables (alternative to config file)

The **entrypoint.sh** can generate **config.yaml** from environment variables if the config file is not present. Variables:

| Variable          | Description                |
|-------------------|----------------------------|
| CONFIG_FILE       | Path to config file (default `/app/config.yaml`) |
| FROM              | Sender email               |
| SMTP_USERNAME     | SMTP username              |
| SMTP_PASSWORD     | SMTP password              |
| SMTP_SERVER       | SMTP host                  |
| SMTP_PORT         | SMTP port                  |
| ELASTIC_USERNAME  | Elasticsearch username     |
| ELASTIC_PASSWORD  | Elasticsearch password     |
| ELASTIC_HOST      | Elasticsearch host         |
| ELASTIC_PORT      | Elasticsearch port         |

### 7.5 Run modes

- **Scheduled:** Runs every hour and sends mails to all users fetched from Elasticsearch (index `employee-management`, field `email_id`).
- **External (one-shot):** Runs once and exits.

**Run locally (scheduled):**

```bash
export CONFIG_FILE=/path/to/config.yaml
python3 notification_api.py --mode scheduled
```

**Run once (external):**

```bash
export CONFIG_FILE=/path/to/config.yaml
python3 notification_api.py --mode external
```

### 7.6 Docker build and run (optional)

**Build:**

```bash
make build-image
```

Default image: `opstree/empms-notification:1.0`.

**Run:**

Pass config via mount or environment variables. Example with env:

```bash
docker run -d \
  --name notification-worker \
  -e FROM=noreply@example.com \
  -e SMTP_USERNAME=user \
  -e SMTP_PASSWORD=pass \
  -e SMTP_SERVER=smtp.example.com \
  -e SMTP_PORT=587 \
  -e ELASTIC_USERNAME=elastic \
  -e ELASTIC_PASSWORD=elastic \
  -e ELASTIC_HOST=elasticsearch \
  -e ELASTIC_PORT=9200 \
  opstree/empms-notification:1.0 \
  python3 notification_api.py --mode scheduled
```

Override entrypoint if you need a different command. Ensure Elasticsearch has the expected index and document shape.

---

## 8. Frontend — Deployment

### 8.1 Clone / navigate to the repository

```bash
cd /path/to/snatak-sprints/API/frontend
```

### 8.2 Node.js and npm

- Install **Node.js 16+** (and npm or yarn). The Dockerfile uses Node 16.15.1.

### 8.3 Install dependencies

```bash
make install
# or
npm install
```

### 8.4 Build

```bash
make build
# or
npm run build
```

This produces the **`build`** directory with static assets.

### 8.5 Run in development

```bash
npm run start
```

The app runs on **port 3000**. The frontend uses **relative paths** for API calls (e.g. `/employee/search/all`, `/attendance/create`, `/salary/search/all`, `/employee/create`, `/notification/send`). In development, you typically configure a **proxy** (e.g. in `package.json` or via a dev server) so these paths are forwarded to the correct API backends. The current `package.json` has `"proxy":"http://localhost:3000"`; for dev you would usually point the proxy to your API server(s) or a reverse proxy that routes to them.

### 8.6 Production build and serve

The Dockerfile builds the app and uses **serve** to serve the `build` folder on port 3000:

```bash
make docker-build
make docker-run
```

Default image: `quay.io/opstree/frontend-app:v0.1.0`. Example run:

```bash
docker run -it -p 3000:3000 quay.io/opstree/frontend-app:v0.1.0
```

**Important:** The browser will send requests to the **same origin** as the frontend (e.g. `http://localhost:3000`). So in production you **must** put a **reverse proxy** (or API gateway) in front that:

- Serves the frontend static files from `/`.
- Routes `/employee/*` to Employee API (e.g. `http://employee-api:8080/api/v1/employee/*`).
- Routes `/attendance/*` to Attendance API (e.g. `http://attendance-api:8080/api/v1/attendance/*`).
- Routes `/salary/*` to Salary API (e.g. `http://salary-api:8080/api/v1/salary/*`).
- Routes `/notification/*` to the notification service if you expose an HTTP endpoint for it.

See section 9 for a concise reverse-proxy example.

---

## 9. Reverse Proxy / API Gateway (Frontend and APIs Together)

To use the frontend and all APIs together, you need something that:

1. Serves the **frontend** static files (e.g. from the `build` directory or from the frontend container).
2. Proxies **/employee/** to Employee API (base path in Employee API is `/api/v1/employee`).
3. Proxies **/attendance/** to Attendance API (base path is `/api/v1/attendance`).
4. Proxies **/salary/** to Salary API (base path is `/api/v1/salary`).
5. Optionally proxies **/notification/** to a notification HTTP endpoint if you add one.

Below is a minimal **nginx** example. Adjust paths and upstream addresses to match your environment (hostnames, ports, Docker network).

**Example nginx.conf (fragment):**

```nginx
server {
    listen 80;
    server_name _;

    root /var/www/frontend/build;
    index index.html;
    location / {
        try_files $uri $uri/ /index.html;
    }

    location /employee/ {
        proxy_pass http://employee-api:8080/api/v1/employee/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /attendance/ {
        proxy_pass http://attendance-api:8080/api/v1/attendance/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /salary/ {
        proxy_pass http://salary-api:8080/api/v1/salary/;
        proxy_http_version 1.1;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

- **employee-api**, **attendance-api**, **salary-api** should resolve to the hosts/containers where each API runs (e.g. Docker service names or IPs).
- If you run the frontend as static files, set `root` to the path of the `build` folder; if you run it in a container, you can proxy `/` to the frontend container instead of serving files from disk.

Deploy nginx (or another reverse proxy) with this config, and point users’ browsers to the nginx host. All API calls from the frontend will then go to the same origin and be routed to the correct backend.

---

## 10. Verification and Health Checks

After deployment:

1. **Employee API:**  
   `curl http://<host>:8080/api/v1/employee/health`

2. **Attendance API:**  
   `curl http://<host>:8080/api/v1/attendance/health`

3. **Salary API:**  
   `curl http://<host>:8080/actuator/health`

4. **Frontend:**  
   Open `http://<frontend-host>/` and check that employee list, attendance, and salary pages load and that API calls succeed (check browser Network tab for requests to `/employee/`, `/attendance/`, `/salary/`).

5. **Notification Worker:**  
   Check logs when running in scheduled or external mode; ensure SMTP and Elasticsearch connections succeed and that the index and document structure match what the code expects.

---

## 11. Troubleshooting

| Issue | What to check |
|-------|----------------|
| Employee API: "connection refused" or "keyspace not found" | ScyllaDB running; keyspace `employee_db` created; `config.yaml` and `migration.json` host/port/credentials correct; migrations run. |
| Attendance API: DB connection error | PostgreSQL running; database `attendance_db` exists; `config.yaml` and `liquibase.properties` correct; Liquibase migrations run. |
| Salary API: Cassandra or Redis error | ScyllaDB and Redis running; `application.yml` (or env) contact-points and Redis host correct; migrations run for `employee_salary`. |
| Migrate tool fails (Employee or Salary) | `migration.json` connection string correct; ScyllaDB accessible; `jq` installed for Makefile; migrate binary on PATH. |
| Liquibase fails (Attendance) | PostgreSQL reachable; JDBC URL and credentials in `liquibase.properties`; changelog path correct. |
| Frontend: API calls 404 or wrong host | Reverse proxy (or dev proxy) must route `/employee/`, `/attendance/`, `/salary/` to the right backends; base paths in proxies must match APIs (e.g. `/api/v1/employee/`). |
| Notification Worker: no mails or ES errors | SMTP credentials and server/port correct; Elasticsearch reachable; index `employee-management` exists and documents have `email_id`; config file or env vars set. |
| Docker: container cannot reach DB/Redis | Use same Docker network for app and DB containers; or use host network; or correct hostnames (e.g. `host.docker.internal` on Docker Desktop). |

---

This completes the step-by-step deployment guide for all APIs and the frontend in the API tree. Follow the sections in order for each service, then configure the reverse proxy so the frontend can communicate with all backends.
