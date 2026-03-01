# Generic CI AMI Document


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 03-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  | aniruddh sir | faisal sir | ashwani sir |




---

## Table of Contents

1. [Introduction](#1-introduction)
2. [What is Generic CI AMI](#2-what-is-generic-ci-ami)
3. [Why use Generic CI AMI](#3-why-use-generic-ci-ami)
4. [Workflow diagram](#4-workflow-diagram)
5. [Advantages](#5-advantages)
6. [POC](#6-poc)
7. [Best practices](#7-best-practices)
8. [Conclusion](#8-conclusion)
9. [Contact Information](#9-contact-information)
10. [References](#10-references)

---

## 1. Introduction

A **Generic CI AMI** is a preconfigured **Amazon Machine Image (AMI)** used to run CI (Continuous Integration) jobs in a consistent environment. Instead of installing tools and dependencies on every run, pipelines launch EC2 instances (or use similar compute) from this AMI so that build, test, and packaging steps run on the same base image. This document describes what the Generic CI AMI is, why teams use it, how it fits into the workflow, its advantages, a POC approach, and best practices.

---

## 2. What is Generic CI AMI

The **Generic CI AMI** is an Amazon Machine Image that includes:

- **Base OS** — A supported Linux distribution (e.g. Amazon Linux 2 or Ubuntu) with security updates applied.
- **CI runtimes and tools** — Preinstalled runtimes (e.g. Java, Node.js, Python, Go) and tools (e.g. Git, Docker CLI, build tools) commonly needed for CI pipelines.
- **Agent or runner software** — Optional: Jenkins agent, GitLab Runner, or other CI agent so instances can join the pipeline controller.
- **Minimal customisation** — Only what is needed for CI; no application-specific code, so the same AMI can serve multiple repos or pipelines.

Teams bake this image once, register it as an AMI, and configure their CI system (e.g. Jenkins, GitLab CI) to launch instances from it for build jobs.

---

## 3. Why use Generic CI AMI

| Reason | Description |
|--------|-------------|
| **Consistency** | Every CI job runs on the same OS, runtimes, and tools. Reduces "works on my machine" and environment drift between runs. |
| **Speed** | No need to install dependencies on every job; launch from the AMI and start the build. Speeds up job start time compared to installing from scratch. |
| **Reproducibility** | Builds are reproducible when the same AMI and commit are used. Easier to debug and audit. |
| **Security and compliance** | One image to harden, patch, and scan. Simplifies compliance (e.g. approved base OS, no ad-hoc installs during the job). |
| **Cost control** | Short-lived instances from a known image; no long-running "golden" servers that drift over time. |

---

## 4. Workflow diagram

The Generic CI AMI fits into the CI workflow as follows:

1. **Build the AMI** — Create an instance from a base AMI, install runtimes and CI agent, harden and patch, then create a new AMI from that instance.
2. **Pipeline triggers** — On commit or PR, the CI controller (e.g. Jenkins) requests a runner or agent.
3. **Launch from AMI** — The controller (or scaling group) launches an EC2 instance from the Generic CI AMI; the instance registers as a runner/agent.
4. **Run job** — The job runs on that instance (clone repo, build, test, package); logs and artifacts are sent back to the controller.
5. **Terminate** — After the job, the instance is terminated (or returned to a pool). The next job gets a fresh or pooled instance from the same AMI.

```
[Code commit / PR] → [CI Controller] → [Launch instance from Generic CI AMI] → [Run build/test] → [Report results, upload artifacts] → [Terminate instance]
```

---

## 5. Advantages

| Advantage | Description |
|-----------|-------------|
| **Faster job startup** | No per-job install of runtimes or tools; instance is ready once booted and agent is connected. |
| **Consistent environment** | Same OS, versions, and tools for all jobs using the AMI; easier to reason about failures. |
| **Easier maintenance** | Update the AMI periodically (e.g. new runtime versions, security patches); all new jobs pick it up. |
| **Scalability** | Scale by launching more instances from the AMI when queue depth increases. |
| **Separation of concerns** | Build and test run on dedicated CI instances; no impact on developer machines or long-lived servers. |

---

## 6. POC

For a **proof of concept** with the Generic CI AMI, Check the Link:

<LINK>

---

## 7. Best practices

| Practice | Description |
|----------|-------------|
| **Version and tag the AMI** | Use a clear naming and tagging scheme (e.g. `generic-ci-ami-v1.2`, tags for OS and creation date) so you know which image is in use. |
| **Automate AMI build** | Use Packer or similar to build the AMI from code; avoid manual steps so the image is reproducible. |
| **Keep the image minimal** | Install only what CI needs; fewer packages mean smaller image, faster launch, and smaller attack surface. |
| **Patch regularly** | Rebuild the AMI on a schedule (e.g. monthly) to pull in OS and runtime security updates. |
| **Use a dedicated account or OU** | Build and store AMIs in a controlled AWS account or OU for governance and sharing. |
| **Document contents** | Maintain a list of installed runtimes and versions in the AMI so teams know what is available. |
| **Test before rollout** | Run a subset of pipelines on a new AMI version before switching all jobs. |

---

## 8. Conclusion

A **Generic CI AMI** provides a consistent, preconfigured environment for CI jobs, reducing setup time and drift. Use it when you want reproducible builds, faster job startup, and a single image to maintain and secure. Define what goes in the image (What), why you use it (Why), how it fits in the workflow (Workflow diagram), and follow best practices for building, versioning, and patching. A small POC with one or two pipelines helps validate the approach before broader rollout.

---

## 9. Contact Information


| Name|Email Address |
|----------------|----------------|
|Mukesh kumar Sharma|msmukeshkumarsharma95@gmail.com|


---

## 10. References

| Link | Description |
|------|-------------|
| [AWS – Amazon Machine Images (AMIs)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) | What is an AMI and how to use it. |
| [Packer – Amazon AMI builder](https://www.packer.io/plugins/builders/amazon/ebs) | Automate AMI builds with Packer. |
| [Jenkins – EC2 Fleet plugin](https://plugins.jenkins.io/ec2-fleet/) | Run Jenkins agents on EC2 (e.g. from an AMI). |
| [GitLab – Runner autoscaling](https://docs.gitlab.com/runner/configuration/autoscale.html) | Use GitLab Runner with autoscaling (e.g. EC2 from AMI). |

---
