# SonarQube Infrastructure Setup on AWS


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 23-02-2026 | v1.0 | Mukesh Sharma | 05-03-2026 |  | aniruddh sir | faisal sir | ashwani sir |








---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Architecture diagram](#2-architecture-diagram)
3. [VPC and Internet Gateway](#3-vpc-and-internet-gateway)
4. [Subnets](#4-subnets)
5. [NACL rules (least access)](#5-nacl-rules-least-access)
6. [Security group rules (least access)](#6-security-group-rules-least-access)
7. [Conclusion](#7-conclusion)
8. [FAQ](#8-faq)
9. [Contact Information](#9-contact-information)
10. [References](#10-references)

---

## 1. Introduction

This setup places **SonarQube** on a server in a **private subnet**; access is only through a **bastion host** in a **public subnet**. The design uses a single **VPC**, an **Internet Gateway (IGW)** for public access, **Network ACLs (NACLs)** and **Security Groups (SGs)** on both subnets with **least-privilege** rules. The bastion is the only internet-facing host; SonarQube has no direct internet exposure. SonarQube uses its embedded database.

---

## 2. Architecture diagram



The **private subnet** host runs **SonarQube**; SonarQube uses its embedded database.

<img width="1225" height="721" alt="image" src="https://github.com/user-attachments/assets/ffe34988-8dbb-4075-afa1-72e31eb88bc4" />

**Flow:** Users reach the **Bastion** via the Internet Gateway (SSH). From the bastion they SSH to the **SonarQube** host or use port forwarding to access SonarQube UI (port 9000). SonarQube has no direct path to the internet in this minimal setup.

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
| **Private** | `10.0.2.0/24` | SonarQube server. | No. |

Bastion and SonarQube host each have an associated **NACL** and **Security Group**.

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

### 5.2 Private subnet NACL (SonarQube)

| Rule # | Type | Protocol | Port | Source/Dest | Allow/Deny |
|--------|------|----------|------|-------------|------------|
| 100 | Inbound | TCP | 22 | Public subnet CIDR (10.0.1.0/24) | ALLOW (SSH from bastion) |
| 110 | Inbound | TCP | 9000 | Public subnet CIDR (10.0.1.0/24) | ALLOW (SonarQube UI via bastion) |
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

### 6.2 SonarQube security group

| Type | Protocol | Port | Source | Description |
|------|----------|------|--------|-------------|
| Inbound | TCP | 22 | Bastion security group ID | SSH from bastion only. |
| Inbound | TCP | 9000 | Bastion security group ID (or public subnet CIDR 10.0.1.0/24) | SonarQube UI from bastion only. |
| Outbound | All | All | 0.0.0.0/0 | Required if SonarQube talks to internet (e.g. plugins). If no NAT, can restrict to VPC CIDR only. |

Using **Bastion SG** as source is preferred over subnet CIDR so only the bastion host can reach SonarQube.

---

## 7. Conclusion

This setup provides a **least-privilege** SonarQube infra on AWS: one **VPC**, one **Internet Gateway**, a **public subnet** with a **bastion** and a **private subnet** with **SonarQube** (using its embedded database). **NACLs** and **security groups** limit traffic to SSH (22) and SonarQube UI (9000) from the bastion only, and SSH to the bastion from allowed IPs only. Restrict NACL and SG source CIDRs to the minimum required (e.g. VPN or CI subnet) and add NAT and outbound rules only if SonarQube needs internet access.

---

## 8. FAQ

---

- **Why use a private subnet for SonarQube?**
  - A private subnet has no direct route to the internet, so the SonarQube server is not reachable from the public internet. Access is only via the bastion, reducing attack surface and helping meet least-privilege and compliance requirements.
- **What is the difference between NACL and Security Group in AWS?**
  - **NACLs** are stateless, subnet-level firewalls: you must allow both inbound and outbound for each flow, and rules are evaluated in order. **Security Groups** are stateful, instance-level: allowing inbound automatically allows the return traffic. Both apply in this setup; NACLs add a second layer of control at the subnet.

---

## 9. Contact Information


| Name | Email Address |
|------|----------------|
| Mukesh kumar Sharma | msmukeshkumarsharma95@gmail.com |


---

## 10. References

| Link | Description |
|------|-------------|
| [AWS VPC](https://docs.aws.amazon.com/vpc/latest/userguide/) | VPC, subnets, route tables. |
| [AWS Network ACLs](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-network-acls.html) | NACL rules and behaviour. |
| [AWS Security Groups](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-security-groups.html) | Security group rules. |
| [SonarQube documentation](https://docs.sonarqube.org/) | SonarQube installation and configuration. |

---
