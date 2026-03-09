# Generic AMI — POC (Proof of Concept)


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 03-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  | aniruddh sir | faisal sir | ashwani sir |




---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Scope](#2-scope)
3. [Prerequisites](#3-prerequisites)
4. [POC steps](#4-poc-steps)
5. [Success criteria](#5-success-criteria)
6. [Risks and limitations](#6-risks-and-limitations)
7. [Conclusion](#7-conclusion)
8. [Contact Information](#8-contact-information)
9. [References](#9-references)

---

## 1. Introduction

The **Generic AMI POC** validates that a preconfigured Amazon Machine Image (AMI) can be built and used via the AWS console in a consistent, repeatable way. The POC answers: Can we build the AMI in the console, launch an instance from it, and confirm the instance has the expected runtimes and tools? This document defines the POC scope, prerequisites, steps (console-based), success criteria, and risks. For the broader concept and design, see [Generic CI AMI_Documentation](https://github.com/Snaatak-Saarthi/documentation/blob/SCRUM-159-mukesh/Applications/Understanding/Generic_CI_Operation/AMI/README.md).


---

## 2. Scope

| In scope | Out of scope |
|----------|--------------|
| Building one Generic AMI via AWS console | Multiple AMIs or regions in one POC |
| Launching an instance from the AMI via console | Automation (e.g. Packer, pipelines) in POC |
| Validating runtimes and tools on the launched instance | High availability or multi-region |
| Documenting how to update the AMI | Full production hardening (e.g. compliance, SSO) |
| Console-based steps only | Automated AMI refresh (can be phase 2) |



---

## 3. Prerequisites

| Requirement | Description |
|--------------|-------------|
| **AWS account** | Access to EC2 console: create AMIs, launch instances, use key pairs and security groups. |
| **Base AMI** | A supported base (e.g. Amazon Linux 2, Ubuntu) in the target region. |
| **Build automation (optional)** | Packer or scripts to build the AMI reproducibly; POC can be console-only. |

---

## 4. POC steps

All steps are done via the **AWS EC2 console** (or equivalent CLI commands).

**Step 1 — Define scope**

- Agree on the runtimes and tools that must be on the AMI (e.g. Java 17, Node 20, Git, Docker CLI).

**Step 2 — Build the AMI (console)**

- In the EC2 console, launch an instance from the chosen base AMI (e.g. Amazon Linux 2). Use a key pair and security group that allow SSH.
- Connect to the instance (e.g. SSH). Install required runtimes and tools. Harden minimally (e.g. security updates).
- In the console: select the instance → **Actions** → **Image and templates** → **Create image**. Name and tag it (e.g. `generic-ami-poc-v1`).
- Optionally document the install steps or use Packer later for automation.

**Step 3 — Launch an instance from the new AMI (console)**

- In the EC2 console, use **Launch instance**. Choose your new Generic AMI, instance type, subnet, and security group. Launch.
- Note the instance ID and (if applicable) public/private IP.

**Step 4 — Validate the instance**

- Connect to the new instance (SSH). Verify that the expected runtimes and tools are present (e.g. `java -version`, `node -v`, `git --version`, `docker --version`).
- Note any missing dependencies or misconfigurations for the next iteration.

**Step 5 — Document and iterate**

- Document the AMI build steps (what you installed, how you created the image).
- Document how to add or update runtimes and how to create a new AMI version from the console.
- Capture lessons learned and refine (e.g. add a missing tool, adjust instance size). Terminate the test instance when done.

---

## 5. Success criteria

The POC is considered successful when:

| Criterion | Description |
|-----------|-------------|
| **AMI created successfully** | The Generic AMI is created from the console and appears in the AMI list. |
| **Instance launches and has expected tools** | An instance launched from the AMI (via console) has the required runtimes and tools (e.g. Java, Node, Git) and is usable. |
| **Update process clear** | There are documented steps to update the AMI (e.g. new runtime version, security patch) and create a new AMI version from the console. |
| **No blocking issues** | No critical failures (e.g. missing dependency, boot failure) that cannot be resolved with small changes to the AMI build steps. |

If all of the above are met, the POC can be signed off and the approach can be extended (e.g. more tools, automation, or production use).

---

## 6. Risks and limitations

| Risk / limitation | Mitigation |
|-------------------|------------|
| **AMI drift** | Document and automate AMI build; rebuild on a schedule. |
| **Instance launch time** | Accept for POC; instances take a few minutes to boot from the AMI. |
| **Missing tools** | Start with a minimal set; add tools based on first runs and document them. |
| **Cost** | Use small instance types and ensure instances terminate when idle; monitor cost during POC. |
| **Single region/account** | POC can be single region/account; multi-region or multi-account can be phase 2. |

---

## 7. Conclusion

The Generic AMI POC validates building and using a standard AMI via the AWS console. Follow the steps: define scope, build the AMI in the console, launch an instance from it, validate runtimes and tools, and document the update process. Success is measured by a working AMI, a launchable instance with the expected tools, and a clear path to update the AMI. Address risks (e.g. drift, cost) and then plan next steps (e.g. automation, production use).

---

## 8. Contact Information


| Name|Email Address |
|----------------|----------------|
|Mukesh kumar Sharma|msmukeshkumarsharma95@gmail.com|


---

## 9. References

| Link | Description |
|------|-------------|
| [Generic CI AMI_Documetation](https://github.com/Snaatak-Saarthi/documentation/blob/SCRUM-159-mukesh/Applications/Understanding/Generic_CI_Operation/AMI/README.md) | Main document: what, why, workflow, advantages, best practices. |
| [AWS – Creating an AMI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/creating-an-ami.html) | How to create an AMI from an instance (console). |
| [Packer – Amazon AMI](https://www.packer.io/plugins/builders/amazon/ebs) | Automate AMI build with Packer (optional). |


---