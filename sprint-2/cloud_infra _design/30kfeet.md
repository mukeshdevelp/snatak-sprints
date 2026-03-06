# 30k Feet — High-Level View

This document provides a **30,000-foot view** of the cloud infrastructure based on the current architecture: a single **AWS Region** with one **VPC** across **two Availability Zones**, public and private subnets, Internet Gateway, NAT Gateway, and EC2 instances (bastion host and app servers).

---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 20-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  | aniruddh sir | faisal sir | ashwani sir |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Prerequisites](#2-prerequisites)
3. [Architecture overview](#3-architecture-overview)
4. [30k-feet details](#4-30k-feet-details)
5. [Infra diagram](#5-infra-diagram)
6. [Traffic flow](#6-traffic-flow)
7. [Conclusion](#7-conclusion)
8. [FAQ](#8-faq)
9. [Contact Information](#9-contact-information)
10. [References](#10-references)

---

## 1. Introduction

A **30k-feet view** is a high-level overview of a system or infrastructure—enough to understand the main components, how they connect, and how traffic flows, without diving into implementation details. This document describes the **current AWS architecture**: one Region, one VPC spanning two Availability Zones, with public subnets (bastion host, NAT Gateway), private subnets (app servers), Internet Gateway, route tables, and NACLs. Use it to onboard stakeholders, align on scope, or prepare for deeper design documents.

---

## 2. Prerequisites

| Prerequisite | Description |
|--------------|-------------|
| **Basic understanding of cloud and infra** | Familiarity with VPC, subnets, EC2, Internet Gateway, NAT Gateway, route tables, NACLs, and security groups. |
| **Context on the product or system** | Knowledge of what the system is meant to do (e.g. applications, access patterns, data flows). |
| **Access to design artefacts** | Where applicable, access to diagrams, runbooks, or architecture docs referenced here. |
| **Stakeholder alignment** | Agreement on scope (e.g. single region, two AZs) and non-goals for this high-level view. |

---

## 3. Architecture overview

| Layer | Description |
|-------|-------------|
| **AWS Cloud → Region** | The system runs in a single **AWS Region**. |
| **VPC** | One **Virtual Private Cloud (VPC)** in that Region; contains all subnets and isolates network traffic. |
| **Availability Zones** | The VPC spans **two Availability Zones** for high availability and fault tolerance. |
| **Public subnets** | Internet-facing; host **bastion host** (EC2) and **NAT Gateway** in AZ1; AZ2 has a second public subnet (e.g. reserved for load balancers or future use). |
| **Private subnets** | No direct internet; host **app-server** EC2 instances in both AZs (e.g. `private_subnet_1` in AZ1, `private_subnet_2` in AZ2). |
| **Internet Gateway** | **main_igw** attached to the VPC; primary entry/exit for internet traffic. |
| **NAT Gateway** | **nat_gw** in the public subnet (AZ1); allows instances in private subnets to initiate outbound internet traffic. |
| **Route tables** | **pub_rt** (public subnets); **private_rt** (private subnets). Route tables reference CIDRs such as `172.16.0.0`, `172.16.1.0`, `172.16.2.0`. |
| **NACLs** | **public_nacl** (public subnets); **private_nacl** (private subnets). Stateless subnet-level filtering. |
| **Security groups** | **pub_sec-grp** (bastion host); **private_sec-grp** (app servers). Stateful instance-level filtering. |

---

## 4. 30k-feet details

**1. Cloud provider and scope.** The system runs on **AWS** in a **single Region**, with one **VPC** and **two Availability Zones**. This sets the boundary for where resources live.

**2. Networking.** Traffic is organised as follows:
- **Internet Gateway (main_igw)** — Connects the VPC to the internet.
- **Public subnets** — In AZ1: `public_subnet` (bastion_host, nat_gw). In AZ2: `Public_subnet_2` (available for future use). Associated with **pub_rt** and **public_nacl**.
- **Private subnets** — In AZ1: `private_subnet_1` (app-server). In AZ2: `private_subnet_2` (app-server). Associated with **private_rt** and **private_nacl**.
- **NAT Gateway (nat_gw)** — In the public subnet (AZ1). Private subnet route table sends outbound internet traffic via nat_gw so app servers can reach the internet without being directly exposed.

**3. Compute.** **EC2** is used for:
- **Bastion host** — In the public subnet; secured by **pub_sec-grp**; used for secure administrative access to instances in private subnets.
- **App servers** — In private subnets (one per AZ); secured by **private_sec-grp**; run application workloads.

**4. Security.** **Security groups** (pub_sec-grp, private_sec-grp) control instance-level traffic. **NACLs** (public_nacl, private_nacl) add subnet-level filtering. No direct internet access to private subnets; outbound only via NAT Gateway.

**5. High availability.** Two Availability Zones and app servers in both private subnets support resilience against single-AZ failures.

---

## 5. Infra diagram

The following diagram illustrates the architecture: VPC across two Availability Zones, Internet Gateway, NAT Gateway, public subnets (bastion, NAT), private subnets (app servers), route tables, and NACLs.

<img width="1019" height="714" alt="image" src="https://github.com/user-attachments/assets/796031d1-39f5-40d9-9f4e-d21be63693cf" />


| Component | Description |
|-----------|-------------|
| **main_igw** | Internet Gateway; ingress/egress for internet traffic. |
| **nat_gw** | NAT Gateway in public subnet (AZ1); outbound internet for private subnets. |
| **pub_rt** / **private_rt** | Public and private route tables; e.g. CIDRs 172.16.0.0, 172.16.1.0, 172.16.2.0. |
| **public_nacl** / **private_nacl** | Network ACLs for public and private subnets. |
| **bastion_host** | EC2 in public subnet; **pub_sec-grp**. |
| **app-server** | EC2 in private subnets (both AZs); **private_sec-grp**. |

---

## 6. Traffic flow

| Flow | Path |
|------|------|
| **Inbound (e.g. to bastion)** | Internet → main_igw → public_nacl → pub_rt → public_subnet → bastion_host (pub_sec-grp). |
| **Outbound from private subnets** | app-server → private_sec-grp → private_nacl → private_rt → nat_gw → public_nacl → main_igw → Internet. |
| **Access to app servers** | Administrators connect to the bastion host, then from the bastion to app servers in private subnets (per security group and NACL rules). |

---

## 7. Conclusion

The **30k-feet view** summarises the current AWS architecture: one Region, one VPC, two Availability Zones, public subnets (bastion host, NAT Gateway), private subnets (app servers), Internet Gateway, route tables, and NACLs. Traffic from the internet reaches the bastion via the Internet Gateway; private instances use the NAT Gateway for outbound access. This document stays at a high level; detailed design (CIDRs, exact rules, instance types) lives in other docs.

---

## 8. FAQ

**What is a 30k-feet view?**  
A high-level overview of a system or infrastructure that shows main components, how they connect, and how traffic flows, without implementation detail.

**When should I use a 30k-feet view?**  
When you need to align stakeholders on scope, onboard new people quickly, or communicate the big picture without technical depth.
**What does this 30k-feet view include?**  
AWS Region, VPC, two AZs, public/private subnets, Internet Gateway, NAT Gateway, bastion host, app servers, route tables, NACLs, and security groups.

**What is left out?**  
Implementation details such as exact CIDR blocks, NACL rule numbers, security group rules, instance types, and connection strings.


---

## 9. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 10. References

| Link | Description |
|------|-------------|
| [AWS – Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/) | AWS guidance on architecture best practices. |
| [AWS – VPC and networking](https://docs.aws.amazon.com/vpc/latest/userguide/) | VPC, subnets, route tables, NACLs. |
| [AWS – NAT Gateway](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-gateway.html) | NAT Gateway for private subnet outbound access. |

---
