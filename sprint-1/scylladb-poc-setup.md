# Setup and Run ScyllaDB for POC

| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 03-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  |  |  |  |

## Table of Contents

1. [Introduction](#1-introduction)
2. [POC Architecture (AWS)](#2-poc-architecture-aws)
3. [Prerequisites](#3-prerequisites)
4. [Step 1: Access the DB Server](#4-step-1-access-the-db-server)
   - 4.1 [SSH into the DB server (via bastion)](#41-ssh-into-the-db-server-via-bastion)
5. [Step 2: Install ScyllaDB on the DB Server](#5-step-2-install-scylladb-on-the-db-server)
   - 5.1 [Install ScyllaDB using the web installer](#51-install-scylladb-using-the-web-installer)
   - 5.2 [Configure ScyllaDB for the DB server IP](#52-configure-scylladb-for-the-db-server-ip)
   - 5.3 [Start and enable ScyllaDB](#53-start-and-enable-scylladb)
6. [Step 3: Verify the Deployment](#6-step-3-verify-the-deployment)
7. [Troubleshooting](#7-troubleshooting)
8. [Contact Information](#8-contact-information)
9. [References](#9-references)

---

## 1. Introduction

This document describes how to install and run **ScyllaDB** on AWS for a **Proof of Concept (POC)**. ScyllaDB is a high-performance, Apache Cassandra–compatible NoSQL database. For this POC, ScyllaDB runs on a single **DB server** (Ubuntu 22.04) in a private subnet. Access to the DB server is through a **bastion host** in a public subnet. The purpose of this document is to give a step-by-step, beginner-friendly guide so that anyone with the listed prerequisites can connect to the DB server, install ScyllaDB using the official installer, configure it to listen on the DB server’s IP, start the service, and verify that it is running using the CQL shell. Follow the sections and steps in order; later steps depend on earlier ones.

## 2. POC Architecture (AWS)

| Component | Location | Role |
|-----------|----------|------|
| **Bastion** | Public subnet | Jump host for SSH. You connect here first (public IP), then SSH to the DB server. SG: 22 from your IP. |
| **DB server** | Private subnet A | Runs ScyllaDB (CQL port 9042). SG: 22 from bastion; 9042 from clients that need to query ScyllaDB (e.g. application subnet). |

**IP used in this doc:** DB server **10.0.1.25** (private). Bastion has a **public IP** (which is chnaging).

## 3. Prerequisites

| Requirement | Version / Notes |
|-------------|-----------------|
| AWS account | With an existing DB server EC2 (or permissions to create one). |
| Bastion host | One EC2 in a public subnet with SSH (22) from your IP. Same key pair as DB server. |
| DB server | Ubuntu 22.04 LTS EC2 in a private subnet. Private IP used in this doc: **10.0.1.25**. |
| SSH key pair | For EC2 login (.pem). |
| SSH, terminal, editor | Basic use of SSH and vi or nano. |
| Ubuntu | 22.04 LTS on the DB server. |
| ScyllaDB | Installed in Step 2 (latest stable via web installer). |

## 4. Step 1: Access the DB Server

All steps in this POC are performed on the **DB server**. You must first SSH to the bastion, then from the bastion SSH to the DB server.

### 4.1 SSH into the DB server (via bastion)

Access is through a **bastion server** (public). From your machine, SSH to the bastion; then from the bastion, SSH to the DB server using its **private IP**. Use the same `.pem` key (copy it to the bastion or use agent forwarding).

**Step 1 — SSH to the bastion (from your laptop):**

```bash
# Replace with your .pem path and bastion public IP or hostname
ssh -i /path/to/your-key.pem ubuntu@<BASTION-PUBLIC-IP>
```
<img width="973" height="726" alt="image" src="https://github.com/user-attachments/assets/fb56ce10-b9f7-4157-b2e3-2551327e895d" />

**Step 2 — From the bastion, SSH to the DB server:**

```bash
# On the bastion: ensure the .pem key is present (e.g. copy via scp from your machine first), then:
# SSH to DB server (private IP)
ssh -i /path/to/your-key.pem ubuntu@10.0.1.25
```
<img width="973" height="726" alt="Screenshot from 2026-02-11 11-56-09" src="https://github.com/user-attachments/assets/1f1218f5-4c8b-4545-83a5-48a320a9772c" />


User is `ubuntu` on both bastion and DB server. Once logged in to **10.0.1.25**, proceed to Step 2.

## 5. Step 2: Install ScyllaDB on the DB Server

All commands in this section are run on the **DB server** (10.0.1.25).

### 5.1 Install ScyllaDB using the web installer

The recommended way to install ScyllaDB on Linux is the official web installer. It adds the correct repository and installs the packages.

```bash

sudo mkdir -p /etc/apt/keyrings
sudo gpg --homedir /tmp --no-default-keyring --keyring /etc/apt/keyrings/scylladb.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys a43e06657bac99e3
sudo wget -O /etc/apt/sources.list.d/scylla.list http://downloads.scylladb.com/deb/debian/scylla-2025.4.list
sudo apt-get update
sudo apt-get install -y scylla
sudo scylla_io_setup
sudo reboot
```
<img width="1876" height="962" alt="Screenshot from 2026-02-11 12-08-43" src="https://github.com/user-attachments/assets/c79d78f2-94ff-4728-b6a6-5483cc90aa83" />
<img width="1876" height="856" alt="Screenshot from 2026-02-11 12-09-13" src="https://github.com/user-attachments/assets/dc469841-268f-4d05-9d05-c4321b76714b" />

If the script asks for confirmation or your Ubuntu version, accept the defaults. Wait for the installation to finish.

### 5.2 Configure ScyllaDB for the DB server IP

ScyllaDB must be configured to listen on the DB server’s IP so that clients can connect. Edit the main config file:

```bash
# Open the ScyllaDB configuration file for editing
sudo vi /etc/scylla/scylla.yaml
# Set listen_address and broadcast address to 10.0.1.25 and rpc_address to 0.0.0.0 (see table above), then save and exit (:wq)
```
<img width="1876" height="146" alt="image" src="https://github.com/user-attachments/assets/38e719cd-5861-4dd7-8195-fe1098c71045" />

Set the following so that ScyllaDB listens on the DB server’s private IP. Find the existing lines and change them (or add them if missing):

| Setting | Value | Purpose |
|---------|--------|---------|
| `listen_address` | `10.0.1.25` | Address for inter-node communication (this POC is single-node). |
| `rpc_address` | `10.0.1.25` | Address for client (CQL) connections. |
| `seed_provider` / `seeds` | `10.0.1.25` | Seed list for cluster discovery (single node = self). |
<img width="1876" height="146" alt="image" src="https://github.com/user-attachments/assets/a850cac6-c815-4d38-bbe6-54d978565a5c" />

Example lines in `scylla.yaml` (use your DB server IP if different):

```yaml
# Replace with your DB server private IP if not 10.0.1.25
listen_address: 10.0.1.25
rpc_address: 10.0.1.25
```
Here is the complete **scylla.yml** file.

<img width="1876" height="962" alt="Screenshot from 2026-02-11 12-06-07" src="https://github.com/user-attachments/assets/d1895fa8-9933-4dd4-9cb1-fb086b67eaf9" />

**Security group:** Ensure the DB server’s security group allows **port 9042** (CQL) from the clients or subnets that will connect to ScyllaDB (e.g. an application server). For local verification only, you can skip this until you need remote access.

### 5.3 Start and enable ScyllaDB

Start the ScyllaDB service and enable it to start on boot:

```bash
# Start the ScyllaDB service now
sudo systemctl start scylla-server
# Enable ScyllaDB to start on boot
sudo systemctl enable scylla-server
# Check that the service is running (wait a minute on first start)
sudo systemctl status scylla-server

```
<img width="1876" height="856" alt="Screenshot from 2026-02-11 12-11-11" src="https://github.com/user-attachments/assets/ebc669d6-c024-4a13-ba69-f4f9a848d629" />

When the service is **active (running)**, ScyllaDB is ready. Restart after any config change: `sudo systemctl restart scylla-server`.

## 6. Step 3: Verify the Deployment

Run these on the **DB server** (10.0.1.25) to confirm ScyllaDB is running.

**Check service status:**

```bash
# Ensure ScyllaDB is active
sudo systemctl status scylla-server
```

**Connect with the CQL shell (cqlsh):**

```bash
# Connect to ScyllaDB on this host using CQL port 9042
cqlsh 10.0.1.25 9042
# At cqlsh> prompt: DESCRIBE CLUSTER; DESCRIBE KEYSPACES; EXIT;
```

At the `cqlsh>` prompt you can run:

```cql
-- Show the cluster name and version
DESCRIBE CLUSTER;
-- List keyspaces (default ones should appear)
DESCRIBE KEYSPACES;
-- Exit cqlsh
EXIT;
```

If `cqlsh` is not installed, install the Python driver and cqlsh, or use another CQL client pointing at `10.0.1.25:9042`.

| Purpose | Command |
|---------|---------|
| Service status | `sudo systemctl status scylla-server` |
| CQL shell | `cqlsh 10.0.1.25 9042` |
| Follow logs | `sudo journalctl -u scylla-server -f` |

## 7. Troubleshooting

| Issue | What to check |
|-------|----------------|
| **Cannot SSH to bastion** | `chmod 400 key.pem`; bastion SG allows your IP on 22; user `ubuntu`. |
| **Cannot SSH to DB server from bastion** | Use private IP `10.0.1.25`; DB server SG allows SSH (22) from bastion; key is on bastion or use agent forwarding. |
| **ScyllaDB fails to start** | Check `sudo journalctl -u scylla-server -n 100`; ensure `listen_address` and `rpc_address` in `/etc/scylla/scylla.yaml` are set to `10.0.1.25` (or this host’s IP). |
| **cqlsh connection refused** | ScyllaDB may still be starting (wait 1–2 min); port 9042 open on firewall; `rpc_address` set correctly. |
| **Clients cannot connect to 10.0.1.25:9042** | DB server SG must allow inbound 9042 from client subnet or IP. |

## 8. Contact Information

| Name | Email |
|------|-------|
| Mukesh Kumar Sharma | msmukeshkumarsharma95@gmail.com |

## 9. References

| Link | Description |
|------|-------------|
| [ScyllaDB Documentation](https://docs.scylladb.com/) | Official ScyllaDB docs |
| [Install ScyllaDB on Linux](https://docs.scylladb.com/manual/stable/getting-started/install-scylla/install-on-linux.html) | Linux package installation |
| [ScyllaDB Web Installer](https://docs.scylladb.com/manual/stable/getting-started/installation-common/scylla-web-installer.html) | Web installer (get.scylladb.com) |
| [ScyllaDB Networking (scylla.yaml)](https://opensource.docs.scylladb.com/stable/kb/yaml-address.html) | listen_address, rpc_address configuration |
