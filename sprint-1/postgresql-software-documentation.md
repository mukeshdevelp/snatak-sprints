# PostgreSQL Documentation

---

| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 03-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  |  |  |  |



## Table of Contents

1. [Introduction](#1-introduction)
2. [Purposes](#2-purposes)
3. [Key features](#3-key-features)
4. [Getting Started](#4-getting-started)
   - 4.1 [Pre-requisites](#41-pre-requisites)
   - 4.2 [Software Overview](#42-software-overview)
   - 4.3 [System Requirement](#43-system-requirement)
   - 4.4 [Important Ports](#44-important-ports)
5. [Dependencies](#5-dependencies)
   - 5.1 [Run-time Dependency](#51-run-time-dependency)
   - 5.2 [Other Dependency](#52-other-dependency)
6. [How to Setup/Install [PostgreSQL]](#6-how-to-setupinstall-postgresql)
   - 6.1 [Step-by-step Installation Instruction](#61-step-by-step-installation-instruction)
   - 6.2 [Configuration](#62-configuration)
7. [Maintenance](#7-maintenance)
8. [Monitoring](#8-monitoring)
9. [Disaster Recovery](#9-disaster-recovery)
10. [High Availability](#10-high-availability)
11. [Troubleshooting](#11-troubleshooting)
12. [FAQs](#12-faqs)
13. [Contact Information](#13-contact-information)
14. [References](#14-references)

---

## 1. Introduction
The purpose of this document is to give a proper undestanding postgresql with installation steps. This understanding is derived by me from OT-microservie app.

Link for OT-microservice repo - [OT-microservice-repo](https://github.com/OT-MICROSERVICES)

PostgreSQL is an open-source relational database with SQL and JSON support, ACID compliance, and extensibility. This document is a concise template for installation and configuration on **Ubuntu**.


---
## 2. Purposes


| **Category**            | **Purpose**             | **Description**                                                                      |
| ----------------------- | ----------------------- | ------------------------------------------------------------------------------------ |
| **Data Storage**        | Store Structured Data   | Stores data in tables with predefined schemas and relationships.                     |
| **Data Management**     | CRUD Operations         | Supports Create, Read, Update, and Delete operations efficiently.                    |
| **Data Integrity**      | ACID Compliance         | Ensures Atomicity, Consistency, Isolation, and Durability for reliable transactions. |
| **Query Processing**    | Advanced SQL Support    | Handles complex queries, joins, subqueries, and indexing.              |
| **Concurrency Control** | Multi-user Access       | Manages simultaneous users with safe transaction handling.                    |



## 3. Key features
---

| **Feature Category**      | **Feature**                   | **Description**                                                                       |
| ------------------------- | ----------------------------- | ------------------------------------------------------------------------------------- |
| **Standards Compliance**  | SQL Compliance                | Fully supports standard SQL with advanced querying capabilities.                      |
| **Transactions**          | ACID Compliance               | Ensures reliable transactions with Atomicity, Consistency, Isolation, and Durability. |
| **Data Types**            | Advanced Data Types           | Supports JSON, JSONB, Arrays, UUID, XML, and custom data types.                       |
| **Security**              | Role-Based Access Control     | Fine-grained authentication and authorization mechanisms.                             |
| **Replication**           | High Availability             | Supports streaming replication and logical replication.                               |
| **Backup & Recovery**     | Point-in-Time Recovery        | Enables reliable backup and restore mechanisms.                                       |



---

## 4. Getting Started

---

### 4.1 Pre-requisites

| License Type | Description | Commercial Use | Open Source |
|--------------|-------------|----------------|-------------|
| PostgreSQL License | Permissive open-source; free to use, modify, and distribute. | Yes | Yes |

### 4.2 Software Overview

| Software | Version |
|----------|---------|
| PostgreSQL | 16.x |

### 4.3 System Requirement

| Requirement | Minimum Recommendation |
|-------------|------------------------|
| Processor/Instance Type | Dual-Core / t2.medium instance or equivalent |
| RAM | 4 Gigabyte or higher (8 GB+ recommended for production) |
| ROM (Disk Space) | 10 Gigabyte or higher (SSD recommended for production) |
| OS Required | Ubuntu 22.04 LTS |

### 4.4 Important Ports

| Ports | Description |
|-------|-------------|
| 5432 | Default TCP port for PostgreSQL server; used by clients to connect to the database. |
| 5433 | Alternative port when running a second PostgreSQL instance on the same host. |

---
## 5. Dependencies

---

### 5.1 Run-time Dependency


| Run-time Dependency | Version | Description |
|---------------------|---------|-------------|
| libreadline | 8.0+ | Terminal line editing (optional, for psql) |
| zlib | 1.2.0+ | Compression support |
| OpenSSL | 1.1.0+  | Encrypted connections (optional but recommended) |

### 5.2 Other Dependency


| Other Dependency | Version | Description |
|------------------|---------|-------------|
| systemd | — | Service management for PostgreSQL (Ubuntu) |
| gcc / build-essential | — | Required only when building from source |

---

## 6. How to Setup/Install [PostgreSQL]

---

### 6.1 Step-by-step Installation Instruction

Run the following command to install. Run the command to start the software.

```bash
# Import the repository signing key:
sudo apt install curl ca-certificates
sudo install -d /usr/share/postgresql-common/pgdg
sudo curl -o /usr/share/postgresql-common/pgdg/apt.postgresql.org.asc --fail https://www.postgresql.org/media/keys/ACCC4CF8.asc

# Create the repository configuration file:
. /etc/os-release
sudo sh -c "echo 'deb [signed-by=/usr/share/postgresql-common/pgdg/apt.postgresql.org.asc] https://apt.postgresql.org/pub/repos/apt $VERSION_CODENAME-pgdg main' > /etc/apt/sources.list.d/pgdg.list"

# Update the package lists:
sudo apt update

# Installing postgresql-16
sudo apt install -y postgresql-16

# checking status
sudo systemctl status postgresql
```
<img width="1920" height="1080" alt="Screenshot from 2026-02-12 10-39-15" src="https://github.com/user-attachments/assets/13c454a9-b6f7-4ed1-a308-2b4b9bf03eb7" />

<img width="1844" height="835" alt="Screenshot from 2026-02-12 10-39-44" src="https://github.com/user-attachments/assets/96a7bb05-05c4-4c83-905c-f795da30dedc" />

<img width="1888" height="435" alt="Screenshot from 2026-02-12 10-38-30" src="https://github.com/user-attachments/assets/7564a8a6-2360-4d06-a980-836744aa39f3" />

### 6.2 Configuration

Configuration refers to the process of setting up and customizing a program or system to work according to specific requirements. Config files: `postgresql.conf` and `pg_hba.conf` under `/etc/postgresql/<version>/main/`. Set `listen_addresses = '*'` to allow remote connections; add host entries in `pg_hba.conf` (e.g. `host all all 192.168.1.0/24 scram-sha-256`). Reload with `sudo systemctl reload postgresql`.

**Allow remote connections:**

1. **postgresql.conf** — set `listen_addresses = '*'`:
   ```bash
   sudo vi /etc/postgresql/16/main/postgresql.conf
   ```
   Uncomment and set: `listen_addresses = '*'`

   <img width="1844" height="835" alt="Screenshot from 2026-02-12 10-41-54" src="https://github.com/user-attachments/assets/48332279-f729-44ad-aefc-b15e006d8157" />


3. **pg_hba.conf** — add a host line (e.g. allow subnet):
   ```bash
   sudo vi /etc/postgresql/16/main/pg_hba.conf
   ```
   Add: `host    all    all    192.168.1.0/24    scram-sha-256`  
   (Use `0.0.0.0/0` for any IP only in trusted networks.)

<img width="1844" height="187" alt="Screenshot from 2026-02-12 10-46-48" src="https://github.com/user-attachments/assets/4a02610f-dfff-489e-85ab-bed41988311d" />

4. Reload: `sudo systemctl reload postgresql`

---

## 7. Maintenance

---

Follow these commands:  For update  to upgrade software version snd for restart

```bash
# for update and upgrade
sudo apt update && sudo apt upgrade -y postgresql postgresql-contrib

# for restart
sudo systemctl restart postgresql

```

<img width="1844" height="971" alt="Screenshot from 2026-02-12 10-48-41" src="https://github.com/user-attachments/assets/cc0ba51e-9e31-4ff0-be63-0647eaf6485a" />


---

## 8. Monitoring
---

After installation of the software, we need to ensure the software is in a working state. You can mention the command to know the software is running correctly. In case of any issues related to the software, always check the log files for better understanding and troubleshooting the issue.

```bash
sudo systemctl status postgresql
sudo -u postgres psql -c "SELECT version();"
sudo ss -tlnp | grep 5432
```

<img width="1844" height="391" alt="Screenshot from 2026-02-12 10-49-34" src="https://github.com/user-attachments/assets/9b0b3099-10a0-4cea-9649-4eba15c1317d" />


Logs: `/var/log/postgresql/postgresql-16-main.log` (or see `log_directory` in `postgresql.conf`).

---

## 9. Disaster Recovery

---

Disaster recovery refers to the processes, strategies, and tools used to ensure the continuity and recovery of software systems in the event of unexpected failures or data loss. For PostgreSQL: use `pg_dump` (single DB) and `pg_dumpall` (full cluster). Use WAL archiving and `pg_basebackup` for PITR. Restore with `psql` or `pg_restore`. Test restores and keep backups off-host. Ensure best DR practices are followed for your application.

---

## 10. High Availability

---

High Availability refers to the strategies and measures implemented to ensure that software systems and applications remain operational and accessible with minimal downtime, even in the presence of hardware failures, software glitches, or other unexpected disruptions. For PostgreSQL: streaming replication; synchronous replication (`synchronous_commit`, `synchronous_standby_names`); failover tools (Patroni, repmgr); connection pooling (PgBouncer, pgpool-II); read replicas for read scaling.

---

## 11. Troubleshooting

---

Mention all the common issues that you encountered while performing setup of the Application. If you think there are some specific errors that are seen, you can add their screenshots or give a brief explanation of the issue and offer a solution to resolve it or guide the user to troubleshoot easily.

| Issue | Solution |
|-------|----------|
| Connection refused on 5432 | Start service; check `listen_addresses` in `postgresql.conf`; allow port in firewall. |
| Authentication failed | Check password and `pg_hba.conf`; add host line with `scram-sha-256`; `sudo systemctl reload postgresql`. |
| No such file or directory | Use `-h localhost` for TCP; confirm server is running. |
| Database "X" does not exist | `sudo -u postgres createdb X` or `CREATE DATABASE X;` |
| Out of memory | Lower `shared_buffers`, `work_mem` in `postgresql.conf`; restart. |
| Disk full | Free space; move WAL/data if needed. Check logs in `postgresql.conf`. |

---

## 12. FAQs

---

- **Is this application free?**
  - Yes. PostgreSQL License; open source, commercial use allowed.
- **Can I deploy this application on all cloud platforms?**
  - Yes. AWS, GCP, Azure, on-prem, containers.
- **Do you offer an enterprise version of this application?**
  - No from the project; third parties (EDB, Crunchy, AWS RDS, etc.) offer support.
- **What is the default superuser and how do I connect locally?**
  - User `postgres`. Connect: `sudo -u postgres psql`.
- **How do I allow remote connections?**
  - Set `listen_addresses` in `postgresql.conf` and add host entries in `pg_hba.conf`.

---

## 13. Contact Information

---

| Name | Email address |
|------|----------------|
| Mukesh Kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 14. References

---
| Links | Descriptions |
|------|--------------|
| [PostgreSQL Official Documentation](https://www.postgresql.org/docs/) | Official documentation (installation, configuration, SQL, administration). |
| [pg_hba.conf](https://www.postgresql.org/docs/current/auth-pg-hba-conf.html) | Client authentication configuration reference. |
| [PostgreSQL Wiki – Backup and Restore](https://wiki.postgresql.org/wiki/Backup_and_Restore) | Backup and recovery strategies. |
| [Software Template](https://github.com/OT-MICROSERVICES/documentation-template/wiki/Software-Template) | Document format followed from this link. |
