# Software Template — PostgreSQL

---

| Author | Created on | Version | Last updated by | Last edited on |
|--------|------------|---------|-----------------|----------------|
| Mukesh | 09-02-26 | 1.0 | Mukesh | 09-02-26 |

---

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

PostgreSQL is an open-source relational database with SQL and JSON support, ACID compliance, and extensibility. This document is a concise template for installation and configuration on **Ubuntu**.

## 2. Purposes

- Transactional apps (e-commerce, banking); web/mobile backends; data warehousing and analytics.
- Geospatial (PostGIS); document/semi-structured data (JSON/JSONB); high availability and replication.

## 3. Key features

ACID compliance; rich SQL and extensions (PostGIS, pg_cron); JSON/JSONB; streaming and logical replication; performant planner and indexing (B-tree, GiST, GIN, BRIN); RBAC, SSL/TLS, row-level security.

## 4. Getting Started

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

## 5. Dependencies

### 5.1 Run-time Dependency

Mention the Run-time dependency to be installed and also specify the version.

| Run-time Dependency | Version | Description |
|---------------------|---------|-------------|
| libreadline | 8.x | Terminal line editing (optional, for psql) |
| zlib | 1.2.x | Compression support |
| OpenSSL | 1.1.x / 3.x | Encrypted connections (optional but recommended) |

### 5.2 Other Dependency

Mention the Other dependency to be installed and also specify the version.

| Other Dependency | Version | Description |
|------------------|---------|-------------|
| systemd | — | Service management for PostgreSQL (Ubuntu) |
| gcc / build-essential | — | Required only when building from source |

## 6. How to Setup/Install [PostgreSQL]

### 6.1 Step-by-step Installation Instruction

Run the following command to install. Run the command to start the software.

```bash
sudo apt update
sudo apt install -y postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo systemctl status postgresql
```

### 6.2 Configuration

Configuration refers to the process of setting up and customizing a program or system to work according to specific requirements. Config files: `postgresql.conf` and `pg_hba.conf` under `/etc/postgresql/<version>/main/`. Set `listen_addresses = '*'` to allow remote connections; add host entries in `pg_hba.conf` (e.g. `host all all 192.168.1.0/24 scram-sha-256`). Reload with `sudo systemctl reload postgresql`.

**Allow remote connections:**

1. **postgresql.conf** — set `listen_addresses = '*'`:
   ```bash
   sudo vi /etc/postgresql/16/main/postgresql.conf
   ```
   Uncomment and set: `listen_addresses = '*'`

2. **pg_hba.conf** — add a host line (e.g. allow subnet):
   ```bash
   sudo vi /etc/postgresql/16/main/pg_hba.conf
   ```
   Add: `host    all    all    192.168.1.0/24    scram-sha-256`  
   (Use `0.0.0.0/0` for any IP only in trusted networks.)

3. Reload: `sudo systemctl reload postgresql`

## 7. Maintenance

Follow these commands:  For update  to upgrade software version snd for restart

```bash
# for update and upgrade
sudo apt update && sudo apt upgrade -y postgresql postgresql-contrib

# for restart
sudo systemctl restart postgresql

```

## 8. Monitoring

After installation of the software, we need to ensure the software is in a working state. You can mention the command to know the software is running correctly. In case of any issues related to the software, always check the log files for better understanding and troubleshooting the issue.

```bash
sudo systemctl status postgresql
sudo -u postgres psql -c "SELECT version();"
sudo ss -tlnp | grep 5432
```

Logs: `/var/log/postgresql/postgresql-16-main.log` (or see `log_directory` in `postgresql.conf`).

## 9. Disaster Recovery

Disaster recovery refers to the processes, strategies, and tools used to ensure the continuity and recovery of software systems in the event of unexpected failures or data loss. For PostgreSQL: use `pg_dump` (single DB) and `pg_dumpall` (full cluster). Use WAL archiving and `pg_basebackup` for PITR. Restore with `psql` or `pg_restore`. Test restores and keep backups off-host. Ensure best DR practices are followed for your application.

## 10. High Availability

High Availability refers to the strategies and measures implemented to ensure that software systems and applications remain operational and accessible with minimal downtime, even in the presence of hardware failures, software glitches, or other unexpected disruptions. For PostgreSQL: streaming replication; synchronous replication (`synchronous_commit`, `synchronous_standby_names`); failover tools (Patroni, repmgr); connection pooling (PgBouncer, pgpool-II); read replicas for read scaling.

## 11. Troubleshooting

Mention all the common issues that you encountered while performing setup of the Application. If you think there are some specific errors that are seen, you can add their screenshots or give a brief explanation of the issue and offer a solution to resolve it or guide the user to troubleshoot easily.

| Issue | Solution |
|-------|----------|
| Connection refused on 5432 | Start service; check `listen_addresses` in `postgresql.conf`; allow port in firewall. |
| Authentication failed | Check password and `pg_hba.conf`; add host line with `scram-sha-256`; `sudo systemctl reload postgresql`. |
| No such file or directory | Use `-h localhost` for TCP; confirm server is running. |
| Database "X" does not exist | `sudo -u postgres createdb X` or `CREATE DATABASE X;` |
| Out of memory | Lower `shared_buffers`, `work_mem` in `postgresql.conf`; restart. |
| Disk full | Free space; move WAL/data if needed. Check logs in `postgresql.conf`. |

## 12. FAQs

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

## 13. Contact Information

| Name | Email address |
|------|----------------|
| Mukesh Kumar Sharma | msmukeshkumarsharma95@gmail.com |

## 14. References

| Links | Descriptions |
|------|--------------|
| [PostgreSQL Official Documentation](https://www.postgresql.org/docs/) | Official documentation (installation, configuration, SQL, administration). |
| [pg_hba.conf](https://www.postgresql.org/docs/current/auth-pg-hba-conf.html) | Client authentication configuration reference. |
| [PostgreSQL Wiki – Backup and Restore](https://wiki.postgresql.org/wiki/Backup_and_Restore) | Backup and recovery strategies. |
| [Software Template](https://github.com/OT-MICROSERVICES/documentation-template/wiki/Software-Template) | Document format followed from this link. |
