# Software Template — PostgreSQL

---

| Author | Created on | Version | Last updated by | Last edited on |
|--------|------------|---------|-----------------|----------------|
| Mukesh | 10-08-23 | 1.0 | Mukesh | 24-08-23 |

## Introduction

This document creates a basic software template for PostgreSQL. A software template is a pre-designed structure that serves as a starting point for creating software documentation. This template provides an organized layout and content structure for documenting PostgreSQL installation, configuration, and operations on Ubuntu.

## Purposes

Scenarios that demonstrate how a product, service, or system can be applied or utilized to solve specific problems or meet particular needs. For PostgreSQL: transactional applications, web and mobile backends, data warehousing and analytics, geospatial data (PostGIS), document and semi-structured data (JSON/JSONB), and high availability with replication.

## Key features

Write key features that are the most important and standout parts of something that make it special or useful. For PostgreSQL: ACID compliance; rich SQL and extensions (PostGIS, pg_cron); JSON/JSONB support; streaming and logical replication; advanced query planner and indexing (B-tree, GiST, GIN, BRIN); RBAC, SSL/TLS, row-level security; cross-platform (Linux, Windows, macOS).

## Getting Started

### Pre-requisites

| License Type | Description | Commercial Use | Open Source |
|--------------|-------------|----------------|-------------|
| PostgreSQL License | Permissive open-source; free to use, modify, and distribute. | Yes | Yes |

### Software Overview

| Software | Version |
|----------|---------|
| PostgreSQL | 16.x |

### System Requirement

| Requirement | Minimum Recommendation |
|-------------|------------------------|
| Processor/Instance Type | Dual-Core / t2.medium instance |
| RAM | 4 Gigabyte or Higher |
| ROM (Disk Space) | 10 Gigabyte or Higher |
| OS Required | Ubuntu 22.04 LTS |

### Important Ports

| Ports | Description |
|-------|-------------|
| 5432 | Default TCP port for PostgreSQL server; used by clients to connect to the database. |
| 5433 | Alternative port when running a second PostgreSQL instance on the same host. |

## Dependencies

### Run-time Dependency

Mention the Run-time dependency to be installed and also specify the version.

| Run-time Dependency | Version | Description |
|---------------------|---------|-------------|
| libreadline | 8.x | Terminal line editing (optional, for psql) |
| zlib | 1.2.x | Compression support |
| OpenSSL | 1.1.x / 3.x | Encrypted connections (optional but recommended) |

### Other Dependency

Mention the Other dependency to be installed and also specify the version.

| Other Dependency | Version | Description |
|------------------|---------|-------------|
| systemd | — | Service management for PostgreSQL (Ubuntu) |
| gcc / build-essential | — | Required only when building from source |

## How to Setup/Install [PostgreSQL]

### Step-by-step Installation Instruction

Run the following commands to install PostgreSQL. Run the command to start the software.

```bash
sudo apt update
sudo apt install -y postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
sudo systemctl status postgresql
```

### Configuration

Configuration refers to the process of setting up and customizing a program or system to work according to specific requirements. For PostgreSQL: edit `postgresql.conf` and `pg_hba.conf` under `/etc/postgresql/<version>/main/`. For example, set `listen_addresses = '*'` to allow remote connections; add host entries in `pg_hba.conf` (e.g. `host all all 192.168.1.0/24 scram-sha-256`). Reload with `sudo systemctl reload postgresql`.

**Allow external connections:**

1. Edit `postgresql.conf`: `sudo vi /etc/postgresql/16/main/postgresql.conf` — set `listen_addresses = '*'`.
2. Edit `pg_hba.conf`: `sudo vi /etc/postgresql/16/main/pg_hba.conf` — add a line such as `host all all 192.168.1.0/24 scram-sha-256`.
3. Reload: `sudo systemctl reload postgresql`.

## Maintenance

Follow these commands: # For Update # To upgrade software version # For restart

```bash
sudo apt update && sudo apt upgrade -y postgresql postgresql-contrib
sudo systemctl restart postgresql
sudo -u postgres psql -c "VACUUM ANALYZE;"
```

## Monitoring

After installation of the software, we need to ensure the software is in a working state. You can mention the command to know the software is running correctly. In case of any issues related to the software, always check the log files for better understanding and troubleshooting the issue.

```bash
sudo systemctl status postgresql
sudo -u postgres psql -c "SELECT version();"
sudo ss -tlnp | grep 5432
```

Log files: `/var/log/postgresql/postgresql-16-main.log` (or check `log_directory` in `postgresql.conf`).

## Disaster Recovery

Disaster recovery refers to the processes, strategies, and tools used to ensure the continuity and recovery of software systems in the event of unexpected failures or data loss. For PostgreSQL: use `pg_dump` and `pg_dumpall` for backups; enable WAL archiving and `pg_basebackup` for point-in-time recovery. Ensure best DR practices are followed for your application.

## High Availability

High Availability refers to the strategies and measures implemented to ensure that software systems and applications remain operational and accessible with minimal downtime, even in the presence of hardware failures, software glitches, or other unexpected disruptions. For PostgreSQL: streaming replication, synchronous replication, failover tools (Patroni, repmgr), connection pooling (PgBouncer, pgpool-II), and read replicas.

## Troubleshooting

Mention all the common issues that you encountered while performing setup of the Application. If you think there are some specific errors that are seen, you can add their screenshots or give a brief explanation of the issue and offer a solution to resolve it or guide the user to troubleshoot easily.

| Issue | Solution |
|-------|----------|
| Connection refused on 5432 | Start service; check `listen_addresses` in `postgresql.conf`; allow port in firewall. |
| Authentication failed | Check password and `pg_hba.conf`; add host line with `scram-sha-256`; reload PostgreSQL. |
| Database "X" does not exist | `sudo -u postgres createdb X` or `CREATE DATABASE X;` as superuser. |
| Out of memory | Lower `shared_buffers`, `work_mem` in `postgresql.conf`; restart. |
| Disk full | Free disk space; check logs. |

## FAQs

- **Is this application free?**
  - Yes, it is an open-source application. PostgreSQL License allows commercial use.
- **Can I deploy this application on all Cloud platforms?**
  - Yes, it can be deployed on any cloud platform (AWS, GCP, Azure, on-premises, containers).
- **Do you offer an enterprise version of this application?**
  - No, this is open-source. Commercial support is offered by third parties (e.g. EDB, Crunchy Data, AWS RDS).

## Contact Information

| Name | Email address |
|------|----------------|
| Mukesh Kumar Sharma | msmukeshkumarsharma95@gmail.com |

## References

| Links | Descriptions |
|------|--------------|
| [PostgreSQL Official Documentation](https://www.postgresql.org/docs/) | Official documentation (installation, configuration, SQL, administration). |
| [pg_hba.conf](https://www.postgresql.org/docs/current/auth-pg-hba-conf.html) | Client authentication configuration reference. |
| [PostgreSQL Wiki – Backup and Restore](https://wiki.postgresql.org/wiki/Backup_and_Restore) | Backup and recovery strategies. |
| [Software Template](https://github.com/OT-MICROSERVICES/documentation-template/wiki/Software-Template) | Document format followed from this link. |
