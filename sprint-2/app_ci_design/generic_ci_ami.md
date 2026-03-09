# Generic AMI Documentation


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 03-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  | aniruddh sir | faisal sir | ashwani sir |




---

## Table of Contents

1. [Introduction](#1-introduction)
2. [What is Generic AMI](#2-what-is-generic-ami)
3. [Why use Generic AMI](#3-why-use-generic-ami)
4. [Workflow (console-based)](#4-workflow-console-based)
5. [Advantages](#5-advantages)
6. [POC](#6-poc)
7. [Best practices](#7-best-practices)
8. [Conclusion](#8-conclusion)
9. [Contact Information](#9-contact-information)
10. [References](#10-references)

---

## 1. Introduction

A **Generic AMI** is a preconfigured **Amazon Machine Image (AMI)** that provides a consistent environment with runtimes and tools already installed. Instead of installing dependencies on every new instance, you build this image once in the AWS console (or with Packer), register it as an AMI, and launch EC2 instances from it when needed. This document describes what the Generic AMI is, why to use it, a console-based workflow, its advantages, a POC approach, and best practices.

---

## 2. What is Generic AMI

The **Generic AMI** is an Amazon Machine Image that includes:

- **Base OS** — A supported Linux distribution (e.g. Amazon Linux 2 or Ubuntu) with security updates applied.
- **Runtimes and tools** — Preinstalled runtimes (e.g. Java, Node.js, Python, Go) and tools (e.g. Git, Docker CLI, build tools) so instances are ready to use.
- **Minimal customisation** — Only what is needed for the intended use; no application-specific code, so the same AMI can serve multiple use cases.

You build this image once (e.g. via AWS console or Packer), register it as an AMI, and launch instances from it via the EC2 console or API when needed.

---

## 3. Why use Generic AMI

| Reason | Description |
|--------|-------------|
| **Consistency** | Every instance launched from the AMI has the same OS, runtimes, and tools. Reduces environment drift. |
| **Speed** | No need to install dependencies on every new instance; launch from the AMI and start working. Faster than installing from scratch. |
| **Reproducibility** | Same AMI gives the same environment every time. Easier to debug and audit. |
| **Security and compliance** | One image to harden, patch, and scan. Simplifies compliance (e.g. approved base OS, no ad-hoc installs). |
| **Cost control** | Launch instances when needed from a known image; terminate when done. No long-running servers that drift over time. |

---

## 4. Workflow (console-based)

The Generic AMI is built and used via the AWS console (or CLI/API) as follows:

```
[Launch base instance] → [Connect & install runtimes/tools] → [Create image (Generic AMI)] → [Launch instance from AMI] → [Use instance (SSH)] → [Terminate when done]
```


- **Build the AMI** — In the EC2 console, launch an instance from a base AMI (e.g. Amazon Linux 2). Connect to it, install runtimes and tools, harden and patch, then create a new AMI from that instance (Actions → Image and templates → Create image).
- **Launch from AMI** — When you need an instance, use the EC2 console (Launch Instance) and select your Generic AMI. Choose instance type, subnet, and security group; launch.
- **Use the instance** — Connect (e.g. SSH), use the preinstalled runtimes and tools. No need to install dependencies.
- **Terminate when done** — Stop or terminate the instance from the console when no longer needed.

---

## 5. Advantages

| Advantage | Description |
|-----------|-------------|
| **Faster instance readiness** | No per-instance install of runtimes or tools; instance is ready once booted. |
| **Consistent environment** | Same OS, versions, and tools for every instance launched from the AMI. |
| **Easier maintenance** | Update the AMI periodically (e.g. new runtime versions, security patches); all new instances get the update. |
| **Scalability** | Launch more instances from the AMI when needed via the console or API. |
| **Separation of concerns** | Use dedicated instances from a known image; no impact on other workloads. |

---

## 6. POC

For a **proof of concept** with the Generic CI AMI, Check the Link: [Generic_CI_AMI_POC](https://github.com/Snaatak-Saarthi/documentation/blob/SCRUM-159-mukesh/Applications/Understanding/Generic_CI_Operation/AMI/POC/README.md)

---

## 7. Best practices

| Practice | Description |
|----------|-------------|
| **Version and tag the AMI** | Use a clear naming and tagging scheme (e.g. `generic-ami-v1.2`, tags for OS and creation date) so you know which image is in use. |
| **Automate AMI build** | Use Packer or similar to build the AMI from code; avoid manual steps so the image is reproducible. |
| **Keep the image minimal** | Install only what you need; fewer packages mean smaller image, faster launch, and smaller attack surface. |
| **Patch regularly** | Rebuild the AMI on a schedule (e.g. monthly) to pull in OS and runtime security updates. |
| **Use a dedicated account or OU** | Build and store AMIs in a controlled AWS account or OU for governance and sharing. |
| **Document contents** | Maintain a list of installed runtimes and versions in the AMI so users know what is available. |
| **Test before rollout** | Launch a test instance from a new AMI version and verify tools and runtimes before using it widely. |

---

## 8. Conclusion

A **Generic AMI** provides a consistent, preconfigured environment for EC2 instances, reducing setup time and drift. Use it when you want reproducible environments, faster instance readiness, and a single image to maintain and secure. Build and use the AMI via the AWS console (or API/Packer) as described in the workflow. Follow best practices for building, versioning, and patching. A small POC (build AMI, launch instance, validate) helps validate the approach before broader use.

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
| [AWS – Creating an AMI from an instance](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/creating-an-ami.html) | Create an AMI via the console. |
| [Packer – Amazon AMI builder](https://www.packer.io/plugins/builders/amazon/ebs) | Automate AMI builds with Packer. |
| [Generic_CI_AMI_POC](https://github.com/Snaatak-Saarthi/documentation/blob/SCRUM-159-mukesh/Applications/Understanding/Generic_CI_Operation/AMI/POC/README.md) | POC Documentation Link |

---