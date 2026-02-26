# SonarQube Infrastructure Setup on AWS


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 03-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  | aniruddh sir | faisal sir | ashwani sir |








---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Architecture diagram](#2-architecture-diagram)
3. [VPC and Internet Gateway](#3-vpc-and-internet-gateway)
4. [Subnets](#4-subnets)
5. [NACL rules (least access)](#5-nacl-rules-least-access)
6. [Security group rules (least access)](#6-security-group-rules-least-access)
7. [PostgreSQL installation (same server as SonarQube)](#7-postgresql-installation-same-server-as-sonarqube)
8. [Conclusion](#8-conclusion)
9. [FAQ](#9-faq)
10. [Contact Information](#10-contact-information)
11. [References](#11-references)

---

## 1. Introduction

This setup places **SonarQube** and **PostgreSQL** on the **same server** in a **private subnet**; access is only through a **bastion host** in a **public subnet**. The design uses a single **VPC**, an **Internet Gateway (IGW)** for public access, **Network ACLs (NACLs)** and **Security Groups (SGs)** on both subnets with **least-privilege** rules, including port **5432** for PostgreSQL where access from the bastion is required. The bastion is the only internet-facing host; SonarQube and PostgreSQL have no direct internet exposure.

---

## 2. Architecture diagram

<img width="851" height="851" alt="sonar-setup drawio (1)" src="https://github.com/user-attachments/assets/263d3a54-b3a3-45eb-883a-afa6e834b088" />

The **private subnet** host runs **SonarQube** and **PostgreSQL** on the same EC2 instance: SonarQube uses the database on localhost (port 5432). Optionally, PostgreSQL (5432) is reachable from the bastion for administration (psql).

**Flow:** Users reach the **Bastion** via the Internet Gateway (SSH). From the bastion they SSH to the **SonarQube** host or use port forwarding to access SonarQube UI (port 9000) and, if allowed, PostgreSQL (port 5432) for admin. SonarQube has no direct path to the internet in this minimal setup.

---

## 3. VPC and Internet Gateway

| Item | Description |
|------|-------------|
| **VPC** | One VPC (e.g. CIDR `10.0.0.0/17`). DNS hostnames and DNS resolution can be enabled as needed. |
| **Internet Gateway** | One IGW attached to the VPC. The **public subnet** route table has a default route `0.0.0.0/0` → IGW. The **private subnet** route table has **no** route to the IGW (only a local route for the VPC CIDR). |

---

## 4. Subnets

| Subnet | CIDR (example) | Purpose | Route to IGW |
|--------|----------------|---------|---------------|
| **Public** | `10.0.1.0/24` | Bastion server only. | Yes (default route via IGW). |
| **Private** | `10.0.2.0/24` | SonarQube + PostgreSQL server (same host). | No. |

Bastion and SonarQube/PostgreSQL host each have an associated **NACL** and **Security Group**.

---

## 5. NACL rules (least access)

NACLs are **stateless**: allow both **inbound** and **outbound** for a given flow. Use rule numbers to order (e.g. 100, 110, …). Default rules (e.g. 65535 deny all) stay at the end.

**Ephemeral ports** for return traffic: allow destination port range **1024–65535** (or your OS ephemeral range) for traffic that was initiated from the other side.

### 5.1 Public subnet NACL (Bastion)

| Rule # | Type | Protocol | Port | Source/Dest | Allow/Deny |
|--------|------|----------|------|-------------|------------|
| 100 | Inbound | TCP | 22 | Your allowed IP or CIDR (e.g. office/VPN) | ALLOW |
| 110 | Inbound | TCP | 1024-65535 | 0.0.0.0/0 | ALLOW (return for outbound) |
| 120 | Inbound | All | All | 0.0.0.0/0 | DENY (implicit if not matched) |
| 100 | Outbound | TCP | 22 | Private subnet CIDR (10.0.2.0/24) | ALLOW (SSH to SonarQube) |
| 110 | Outbound | TCP | 1024-65535 | 0.0.0.0/0 | ALLOW (return for inbound) |
| 120 | Outbound | All | All | 0.0.0.0/0 | DENY (implicit if not matched) |

Restrict **Rule 100 Inbound** source to the smallest CIDR you need (e.g. VPN or jump-host IPs), not `0.0.0.0/0`.

### 5.2 Private subnet NACL (SonarQube + PostgreSQL)

| Rule # | Type | Protocol | Port | Source/Dest | Allow/Deny |
|--------|------|----------|------|-------------|------------|
| 100 | Inbound | TCP | 22 | Public subnet CIDR (10.0.1.0/24) | ALLOW (SSH from bastion) |
| 110 | Inbound | TCP | 9000 | Public subnet CIDR (10.0.1.0/24) | ALLOW (SonarQube UI via bastion) |
| 115 | Inbound | TCP | 5432 | Public subnet CIDR (10.0.1.0/24) | ALLOW (PostgreSQL from bastion for admin) |
| 120 | Inbound | TCP | 1024-65535 | Public subnet CIDR (10.0.1.0/24) | ALLOW (return for outbound) |
| 130 | Inbound | All | All | 0.0.0.0/0 | DENY |
| 100 | Outbound | TCP | 1024-65535 | Public subnet CIDR (10.0.1.0/24) | ALLOW (return for inbound) |
| 110 | Outbound | All | All | 0.0.0.0/0 | DENY |

If SonarQube must reach the internet (e.g. for updates or plugins), add a **NAT Gateway** in the public subnet and a default route in the private subnet to the NAT, then add outbound rules (e.g. TCP 80/443 to 0.0.0.0/0) in this NACL as needed; keep scope minimal.

---

## 6. Security group rules (least access)

Security groups are **stateful**: you allow the initiation direction; return traffic is allowed automatically.

### 6.1 Bastion security group

| Type | Protocol | Port | Source | Description |
|------|----------|------|--------|-------------|
| Inbound | TCP | 22 | Your allowed IP or CIDR (e.g. office/VPN) | SSH only from known IPs. |
| Outbound | All | All | 0.0.0.0/0 | Required for SSH to private subnet and for outbound (e.g. package updates). Restrict to 10.0.2.0/24 + 0.0.0.0/0 for TCP 80/443 if you want to limit egress. |

Tighten **Inbound** to a single CIDR or IP range; avoid 0.0.0.0/0.

### 6.2 SonarQube + PostgreSQL security group

| Type | Protocol | Port | Source | Description |
|------|----------|------|--------|-------------|
| Inbound | TCP | 22 | Bastion security group ID | SSH from bastion only. |
| Inbound | TCP | 9000 | Bastion security group ID (or public subnet CIDR 10.0.1.0/24) | SonarQube UI from bastion only. |
| Inbound | TCP | 5432 | Bastion security group ID | PostgreSQL from bastion only (for admin, e.g. psql). SonarQube uses localhost:5432 on the same server. |
| Outbound | All | All | 0.0.0.0/0 | Required if SonarQube talks to internet (e.g. plugins). If no NAT, can restrict to VPC CIDR only. |

Using **Bastion SG** as source is preferred over subnet CIDR so only the bastion host can reach SonarQube and PostgreSQL.

---

## 7. PostgreSQL installation (same server as SonarQube)

PostgreSQL is installed on the **same EC2 instance** as SonarQube in the private subnet. SonarQube connects to the database on **localhost:5432**. The steps below are for a typical Linux host (Amazon Linux 2 or Ubuntu). SSH to the SonarQube host via the bastion before running the commands.

### 7.1 Install PostgreSQL

Install PostgreSQL, initialise the data directory if required, then enable and start the service. In `postgresql.conf`, set `listen_addresses = 'localhost'` so the DB listens only on localhost unless you need remote access from the bastion (port 5432 is already allowed from the bastion in NACL/SG).



**Ubuntu:**

```bash
# install
sudo apt update && sudo apt install -y postgresql-14 postgresql-contrib

# enable and start (service may already be running)
sudo systemctl enable postgresql
sudo systemctl start postgresql

# optional: update and restart later
sudo apt update && sudo apt upgrade -y postgresql postgresql-contrib
sudo systemctl restart postgresql
```

### 7.2 Create database and user for SonarQube

Switch to the `postgres` user and create a dedicated user and database for SonarQube. Revoke public access on the database if desired so only the `sonarqube` user can connect.

```bash
sudo -u postgres psql
```

In the `psql` prompt:

```sql
CREATE USER sonarqube WITH PASSWORD '<secure-password>';
CREATE DATABASE sonarqube OWNER sonarqube;

-- optional: revoke public access
REVOKE CONNECT ON DATABASE sonarqube FROM PUBLIC;
```

### 7.3 Configure SonarQube to use PostgreSQL

In SonarQube config (e.g. `$SONAR_HOME/conf/sonar.properties` or environment variables), set the JDBC URL, username, and password to use PostgreSQL on localhost. Then restart SonarQube so it uses PostgreSQL instead of the default H2.

```properties
sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube
sonar.jdbc.username=sonarqube
sonar.jdbc.password=<secure-password>
```

```bash
# restart SonarQube (path depends on your install)
sudo systemctl restart sonarqube
```

PostgreSQL port **5432** is included in the **private subnet NACL** and **SonarQube security group** so that, if needed, you can connect from the bastion (e.g. `psql -h <private-host-ip> -U sonarqube -d sonarqube`) for administration; day-to-day SonarQube traffic is localhost only.

---

## 8. Conclusion

This setup provides a **least-privilege** SonarQube infra on AWS: one **VPC**, one **Internet Gateway**, a **public subnet** with a **bastion** and a **private subnet** with **SonarQube and PostgreSQL on the same server**. **NACLs** and **security groups** limit traffic to SSH (22), SonarQube UI (9000), and PostgreSQL (5432) from the bastion only, and SSH to the bastion from allowed IPs only. Restrict NACL and SG source CIDRs to the minimum required (e.g. VPN or CI subnet) and add NAT and outbound rules only if SonarQube needs internet access.

---

## 9. FAQ

---

- **Why use a private subnet for SonarQube and PostgreSQL?**
  - A private subnet has no direct route to the internet, so the SonarQube and PostgreSQL server is not reachable from the public internet. Access is only via the bastion, reducing attack surface and helping meet least-privilege and compliance requirements.
- **What is the difference between NACL and Security Group in AWS?**
  - **NACLs** are stateless, subnet-level firewalls: you must allow both inbound and outbound for each flow, and rules are evaluated in order. **Security Groups** are stateful, instance-level: allowing inbound automatically allows the return traffic. Both apply in this setup; NACLs add a second layer of control at the subnet.
- **Why allow PostgreSQL port 5432 from the bastion if SonarQube uses localhost?**
  - SonarQube connects to PostgreSQL on localhost and does not need 5432 open from the network. Opening 5432 from the bastion allows DBAs or admins to run `psql` or other tools from the bastion (e.g. backups, schema changes, troubleshooting). If you never need remote admin, you can omit the 5432 rule in the NACL and security group.
- **Can I use Amazon RDS for PostgreSQL instead of installing on the same server?**
  - Yes. You can create an RDS PostgreSQL instance in the same VPC (e.g. in the private subnet or a dedicated DB subnet), allow the SonarQube security group to connect to the RDS security group on port 5432, and point SonarQube’s JDBC URL to the RDS endpoint. You would then remove or tighten the 5432 rule from the bastion if only SonarQube needs access.
- **How do I connect to PostgreSQL from my laptop via the bastion?**
  - Use SSH port forwarding from your laptop: `ssh -L 5432:<private-ip-of-sonarqube-host>:5432 ec2-user@<bastion-public-ip>`. Then connect your local client to `localhost:5432`; traffic is tunnelled through the bastion to the SonarQube server’s PostgreSQL.

---

## 10. Contact Information


| Name|Email Address |
|----------------|----------------|
|Mukesh kumar Sharma|msmukeshkumarsharma95@gmail.com|


---

## 11. References

| Link | Description |
|------|-------------|
| [AWS VPC](https://docs.aws.amazon.com/vpc/latest/userguide/) | VPC, subnets, route tables. |
| [AWS Network ACLs](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html) | NACL rules and behaviour. |
| [AWS Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html) | Security group rules. |
| [SonarQube documentation](https://docs.sonarqube.org/) | SonarQube installation and configuration. |
| [PostgreSQL documentation](https://www.postgresql.org/docs/) | PostgreSQL installation and configuration. |

---
