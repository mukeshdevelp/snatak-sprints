# Generic CI AMI — POC (Proof of Concept)

This document describes the **Proof of Concept (POC)** for the Generic CI AMI: scope, steps, success criteria, and how to run and evaluate the POC.

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

The **Generic CI AMI POC** validates that a preconfigured Amazon Machine Image (AMI) can be used to run CI jobs in a consistent, repeatable way. The POC answers: Can we build the AMI, connect it to our CI system, and run real build/test jobs with acceptable startup time and reliability? This document defines the POC scope, prerequisites, steps, success criteria, and risks. For the broader concept and design, see [Generic CI AMI](generic_ci_ami.md).

---

## 2. Scope

| In scope | Out of scope |
|----------|--------------|
| One CI system (e.g. Jenkins or GitLab) | Multiple CI systems in one POC |
| One or two sample pipelines (e.g. Java, Node) | All existing pipelines |
| Building one Generic CI AMI and using it for agents/runners | High availability or multi-region |
| Measuring job success and startup time | Full production hardening (e.g. compliance, SSO) |
| Documenting how to update the AMI | Automated AMI refresh pipelines (can be phase 2) |

The POC is time-boxed (e.g. 1–2 sprints) and focuses on proving the approach, not on migrating all pipelines.

---

## 3. Prerequisites

| Requirement | Description |
|--------------|-------------|
| **AWS account** | Access to create AMIs, launch EC2 instances, and use IAM roles for the CI agent. |
| **CI system** | Jenkins, GitLab, or similar with the ability to launch agents/runners on EC2 (e.g. EC2 Fleet plugin, GitLab Runner autoscale). |
| **Base AMI** | A supported base (e.g. Amazon Linux 2, Ubuntu) in the target region. |
| **Build automation (optional)** | Packer or scripts to build the AMI reproducibly. |
| **Sample repos** | At least one repo (e.g. Java or Node) with a simple build and test that can run on the POC AMI. |

---

## 4. POC steps

**Step 1 — Define scope**

- Choose one CI system (e.g. Jenkins).
- Choose one or two representative pipelines (e.g. one Java build, one Node build).
- Agree on the runtimes and tools that must be on the AMI (e.g. Java 17, Node 20, Git, Docker CLI).

**Step 2 — Build the AMI**

- Start an EC2 instance from the chosen base AMI (e.g. Amazon Linux 2).
- Install required runtimes, tools, and the CI agent (e.g. Jenkins agent JAR or GitLab Runner).
- Harden minimally (e.g. security updates, no unnecessary services).
- Create a new AMI from the instance; tag it (e.g. `generic-ci-ami-poc-v1`).
- Optionally automate this with Packer and document the steps.

**Step 3 — Configure CI to use the AMI**

- In the CI system, configure the cloud/EC2 plugin to launch agents or runners from the new AMI (instance type, subnet, IAM role, security group).
- Ensure the agent can reach the CI controller (network, security groups, credentials or keys).

**Step 4 — Run sample jobs**

- Trigger the chosen pipelines (e.g. on a branch or PR).
- Confirm that instances launch from the AMI, register as agents/runners, and that the jobs complete successfully.
- Note job startup time (time from “job scheduled” to “job started”) and any failures or misconfigurations.

**Step 5 — Document and iterate**

- Document the AMI build steps (manual or Packer).
- Document how to add or update runtimes and how to publish a new AMI version.
- Capture lessons learned and refine (e.g. add a missing tool, adjust instance size).

---

## 5. Success criteria

The POC is considered successful when:

| Criterion | Description |
|-----------|-------------|
| **Jobs run successfully** | The chosen pipelines (e.g. Java, Node) complete build and test when run on instances launched from the Generic CI AMI. |
| **Startup time acceptable** | Time from job scheduled to job start is within an agreed threshold (e.g. under 3–5 minutes for EC2 launch + agent connect). |
| **Update process clear** | There is documented steps (or a Packer template) to update the AMI (e.g. new runtime version, security patch) and roll it out. |
| **No blocking issues** | No critical failures (e.g. agent unable to connect, missing dependency) that cannot be resolved with small changes to the AMI or CI config. |

If all of the above are met, the POC can be signed off and the approach can be extended to more pipelines or to production hardening.

---

## 6. Risks and limitations

| Risk / limitation | Mitigation |
|-------------------|------------|
| **AMI drift** | Document and automate AMI build; rebuild on a schedule. |
| **Cold start latency** | Accept for POC or use a small pool of warm instances if needed. |
| **Missing tools** | Start with a minimal set; add tools based on first runs and document them. |
| **Cost** | Use small instance types and ensure instances terminate when idle; monitor cost during POC. |
| **Single region/account** | POC can be single region/account; multi-region or multi-account can be phase 2. |

---

## 7. Conclusion

The Generic CI AMI POC validates building and using a standard AMI for CI jobs. Follow the steps: define scope, build the AMI, configure the CI system, run sample jobs, and document the update process. Success is measured by jobs completing successfully, acceptable startup time, and a clear path to update the AMI. Address risks (e.g. drift, cost) and then plan next steps (e.g. more pipelines, automation, production standards).

---

## 8. Contact Information


| Name|Email Address |
|----------------|----------------|
|Mukesh kumar Sharma|msmukeshkumarsharma95@gmail.com|


---

## 9. References

| Link | Description |
|------|-------------|
| [Generic CI AMI](generic_ci_ami.md) | Main document: what, why, workflow, advantages, best practices. |
| [AWS – Creating an AMI](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/creating-an-ami.html) | How to create an AMI from an instance. |
| [Packer – Amazon AMI](https://www.packer.io/plugins/builders/amazon/ebs) | Automate AMI build with Packer. |
| [Jenkins – EC2 Fleet plugin](https://plugins.jenkins.io/ec2-fleet/) | Run Jenkins agents on EC2. |

---
