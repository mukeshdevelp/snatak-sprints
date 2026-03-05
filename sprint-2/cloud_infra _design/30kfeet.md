# 30k Feet — High-Level View

This document provides a **30,000-foot view** of the cloud infrastructure and system design: introduction, prerequisites, system development approaches, 30k-feet details, infrastructure diagram, and references.

---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 20-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  | aniruddh sir | faisal sir | ashwani sir |





---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Prerequisites](#2-prerequisites)
3. [System development approaches](#3-system-development-approaches)
4. [30k-feet details](#4-30k-feet-details)
5. [Infra diagram](#5-infra-diagram)
6. [Conclusion](#6-conclusion)
7. [FAQ](#7-faq)
8. [Contact Information](#8-contact-information)
9. [References](#9-references)

---

## 1. Introduction

A **30k-feet view** is a high-level overview of a system or infrastructure—enough to understand the main components, how they connect, and how development and operations are organised, without diving into implementation details. This document describes the high-level cloud infrastructure and system design: what is in scope, what you need before you start, which system development approaches apply, the main architectural details, and an infrastructure diagram. **Stable** sections (e.g. Introduction, Prerequisites, system development approaches) change rarely; **evolving** sections (e.g. 30k-feet details, infra diagram, references) are updated with iterations. Use it to onboard stakeholders, align on scope, or prepare for deeper design documents.

---

## 2. Prerequisites



| Prerequisite | Description |
|--------------|-------------|
| **Basic understanding of cloud and infra** | Familiarity with concepts such as VPC, subnets, compute (e.g. EC2), and networking. |
| **Context on the product or system** | Knowledge of what the system is meant to do (e.g. applications, CI/CD, data flows). |
| **Access to design artefacts** | Where applicable, access to diagrams, runbooks, or architecture docs referenced here. |
| **Stakeholder alignment** | Agreement on scope (e.g. single region, multi-account) and non-goals for this high-level view. |

---

## 3. System development approaches


| Approach | Brief description | Relevance to 30k-feet view |
|----------|-------------------|----------------------------|
| **Waterfall** | Sequential phases (requirements → design → build → test → deploy). | Infra is often designed up front; the 30k-feet view may reflect a fixed or slowly changing architecture. |
| **Agile** | Iterative delivery in sprints; requirements and design evolve. | Infra may need to support frequent releases and changing scope; the 30k-feet view shows current state and main building blocks. |
| **DevOps** | Development and operations combined; automation, CI/CD, and infra as code. | The 30k-feet view typically includes CI/CD, pipelines, and how infra is provisioned and updated. |



---

## 4. 30k-feet details

At a high level, the design is summarised as follows. 


**1. Cloud provider and scope.** The system runs on a cloud provider (e.g. AWS) with a defined scope: whether it is single region or multi-region, and whether a single account or multiple accounts (e.g. dev, stage, prod) are used. This sets the boundary for where resources live and how environments are separated.

**2. Networking.** Traffic is organised using VPC(s), with public and private subnets. How traffic is allowed in and out—for example via internet gateway, NAT, and security groups—is described at a high level, without listing every rule or subnet CIDR.

**3. Compute.** The document describes what runs the workloads in broad terms: for example EC2 for virtual machines, containers (EKS/ECS) for containerised apps, or serverless (Lambda) for event-driven workloads. The level of detail is “EC2 for app servers, EKS for microservices,” not instance types or counts.

**4. Data and storage.** It explains where persistent data lives (e.g. RDS for relational data, S3 for object storage, or other NoSQL stores) and how it is accessed in general terms, without schema or connection strings.

**5. CI/CD and pipelines.** It outlines how code is built, tested, and deployed—for example Jenkins or GitLab on EC2 or a shared AMI, with pipelines that deploy to EC2 or Kubernetes. The focus is on which tools and targets are used, not job-level configuration.

**6. Security and identity.** Access control is described at a high level: how identity and access are managed (e.g. IAM, SSO, network segmentation), without listing every policy or role.

**7. Observability.** The view covers logging, metrics, and alerting (e.g. CloudWatch or centralised logging) and where they sit in the design, without implementation detail such as log formats or dashboard definitions.



---

## 5. Infra diagram



| Component | Description |
|-----------|-------------|
| **Users / clients** | Access the system via internet or VPN. |
| **Edge / DNS** | e.g. Route 53 or CDN for DNS and optional edge caching. |
| **Load balancer** | Distributes traffic to compute (e.g. ALB/NLB). |
| **Application layer** | EC2, ECS/EKS, or serverless; the 30k-feet view does not specify instance counts or sizing. |
| **Data layer** | RDS, S3, caches, or other data stores. |
| **CI/CD** | Pipeline controller and agents (e.g. Jenkins, GitLab Runner) and how they deploy into the app/data layers. |
| **Security and monitoring** | IAM, security groups, and observability (logs, metrics). |

**Diagram (text flow):**




---

## 6. Conclusion

The **30k-feet view** summarises the overall picture: cloud scope (provider, region, account), networking (VPC, subnets, traffic), compute (EC2, containers, serverless), data and storage, CI/CD and pipelines, security and identity, and observability—how these building blocks fit together at a high level, without implementation details, IPs, or low-level config.


---

## 7. FAQ

| Question | Answer |
|----------|--------|
| **What is a 30k-feet view?** | A high-level overview of a system or infrastructure that shows main components, how they connect, and how development/operations are organised, without implementation detail. |
| **When should I use a 30k-feet view?** | When you need to align stakeholders on scope, onboard new people quickly, plan before diving into design, or communicate the big picture without technical depth. |
| **What does a 30k-feet view typically include?** | Cloud scope, networking, compute, data/storage, CI/CD, security and identity, and observability—how these building blocks fit together, not IPs or low-level config. |
| **What is left out of a 30k-feet view?** | Implementation details such as specific IPs, CIDR blocks, instance types, connection strings, job-level pipeline config, and detailed security policies. |
| **How does a 30k-feet view differ from a detailed design?** | The 30k-feet view answers “what exists and how it fits together”; detailed design documents answer “how it is built and configured.” |
| **Who benefits from a 30k-feet view?** | Product, management, new engineers, and anyone who needs to understand the system’s structure and scope before or alongside deeper technical docs. |

---

## 7. FAQ

| Question | Answer |
|----------|--------|
| **What is a 30k-feet view?** | A high-level overview of a system or infrastructure that shows main components, how they connect, and how development/operations are organised, without implementation detail. |
| **When should I use a 30k-feet view?** | When you need to align stakeholders on scope, onboard new people quickly, plan before diving into design, or communicate the big picture without technical depth. |
| **What does a 30k-feet view typically include?** | Cloud scope, networking, compute, data/storage, CI/CD, security and identity, and observability—how these building blocks fit together, not IPs or low-level config. |
| **What is left out of a 30k-feet view?** | Implementation details such as specific IPs, CIDR blocks, instance types, connection strings, job-level pipeline config, and detailed security policies. |
| **How does a 30k-feet view differ from a detailed design?** | The 30k-feet view answers “what exists and how it fits together”; detailed design documents answer “how it is built and configured.” |
| **Who benefits from a 30k-feet view?** | Product, management, new engineers, and anyone who needs to understand the system’s structure and scope before or alongside deeper technical docs. |

---

## 8. Contact Information


| Name|Email Address |
|----------------|----------------|
|Mukesh kumar Sharma|msmukeshkumarsharma95@gmail.com|


---

## 9. References

| Link | Description |
|------|-------------|
| [AWS – Well-Architected Framework](https://aws.amazon.com/architecture/well-architected/) | AWS guidance on architecture best practices. |
| [AWS – VPC and networking](https://docs.aws.amazon.com/vpc/latest/userguide/) | VPC and subnet concepts. |
| [Generic CI AMI](sprint-2/app_ci_design/generic_ci_ami.md) | CI AMI and pipeline context (if applicable). |

---
