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
      - 5.1 [Install ScyllaDB](#51-install-scylladb)
      - 5.2 [Configure ScyllaDB for the DB server IP](#52-configure-scylladb-for-the-db-server-ip)
      - 5.3 [Start and enable ScyllaDB](#53-start-and-enable-scylladb)
   6. [Step 3: Verify the Deployment](#6-step-3-verify-the-deployment)
   7. [Troubleshooting](#7-troubleshooting)
   8. [Contact Information](#8-contact-information)
   9. [References](#9-references)

   ---


   ## 1. Introduction

   ScyllaDB is a high-performance, open-source NoSQL database designed for low latency and high throughput at scale. It is API-compatible with Apache Cassandra and Amazon DynamoDB, allowing seamless migration from those systems while delivering significantly improved performance. Written in C++, ScyllaDB supports CQL (Cassandra Query Language), strong and eventual consistency models, replication, and multi–data center deployments.


   ## 2. POC Architecture (AWS)

   ScyllaDB is kept by me in an ec2 in the private subnet. This db subnet is accessed through bastion host or jump server.

   <img width="1657" height="686" alt="Screenshot from 2026-02-13 10-41-16" src="https://github.com/user-attachments/assets/3a4698ee-576b-4408-bf73-487236366171" />


   ## 3. Prerequisites

   | Requirement | Version / Notes |
   |-------------|-----------------|
   | Ubuntu | 22.04 LTS on the DB server. |
   | Memory | 16 GB or more |



   ## 4. Step 1: Access the DB Server

   All steps in this POC are performed on the **DB server**. You must first SSH to the bastion, then from the bastion SSH to the DB server.


   ### 4.1 SSH into the DB server (via bastion)

   Access is through a **bastion server** (public). From your machine, SSH to the bastion; then from the bastion, SSH to the DB server using its **private IP**. Use the same `.pem` key (copy it to the bastion or use agent forwarding).


   ## 5. Step 2: Install ScyllaDB on the DB Server

   All commands in this section are run on the **DB server** .


   ### 5.1 Install ScyllaDB

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

   <a id="53-start-and-enable-scylladb"></a>
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


   ## 6. Step 3: Verify the Deployment

   Run these on the **DB server**  to confirm ScyllaDB is running.

   **Check service status:**

   ```bash
   # Ensure ScyllaDB is active
   sudo systemctl status scylla-server
   ```

   **Connect with the CQL shell (cqlsh):**

   ```bash
   # Connect to ScyllaDB on this host using CQL port 9042
   cqlsh -u cassandra -p cassandra


   ```

   At the `cqlsh>` prompt you can run:

   ```cql
   -- Create a role, replace `my_user` to `scylla` and `my_password` to `12345`
   CREATE ROLE my_user WITH PASSWORD = 'my_password' AND LOGIN = true;

   -- Create it as superuser
   ALTER ROLE my_user WITH SUPERUSER = true;

   -- Grant permission on a keyspace. replace `my_keyspace` with `employee` (or a keyspace present in scylla) and `my_user` with `scylla` (or desired username)
   GRANT ALL PERMISSIONS ON KEYSPACE my_keyspace TO my_user;

   -- Show the cluster name and version
   DESCRIBE CLUSTER;

   -- List keyspaces (default ones should appear)
   DESCRIBE KEYSPACES;

   --- Use a Keyspace
   use `<keyspace_name>`; ex - employee

   --- Show all tables in keyspace 
   DESCRIBE TABLES;

   -- Exit cqlsh
   EXIT;
   ```
   **Examplar Output**
   <img width="1920" height="907" alt="Screenshot from 2026-02-11 12-46-00" src="https://github.com/user-attachments/assets/958279c8-d664-4e31-b1c6-92e6e7e0eb4a" />




   | Purpose | Command |
   |---------|---------|
   | Service status | `sudo systemctl status scylla-server` |
   | CQL shell | `cqlsh 10.0.1.25 9042` |
   | Follow logs | `sudo journalctl -u scylla-server -f` |


   ## 7. Troubleshooting

   | Issue | What to check |
   |-------|----------------|
   | **ScyllaDB fails to start** | Check `sudo journalctl -u scylla-server -n 100`; ensure `listen_address` and `rpc_address` in `/etc/scylla/scylla.yaml` are set to `10.0.1.25` (or this host’s IP). |
   | **cqlsh connection refused** | ScyllaDB may still be starting (wait 1–2 min); port 9042 open on firewall; `rpc_address` set correctly. |


   ## 8. Contact Information

   | Name | Email |
   |------|-------|
   | Mukesh Kumar Sharma | msmukeshkumarsharma95@gmail.com |

   <a id="9-references"></a>
   ## 9. References

   | Link | Description |
   |------|-------------|
   | [ScyllaDB Documentation](https://docs.scylladb.com/) | Official ScyllaDB docs |
   | [Install ScyllaDB on Linux](https://docs.scylladb.com/manual/stable/getting-started/install-scylla/install-on-linux.html) | Linux package installation |
   | [ScyllaDB Web Installer](https://docs.scylladb.com/manual/stable/getting-started/installation-common/scylla-web-installer.html) | Web installer (get.scylladb.com) |
   | [ScyllaDB Networking (scylla.yaml)](https://opensource.docs.scylladb.com/stable/kb/yaml-address.html) | listen_address, rpc_address configuration |
