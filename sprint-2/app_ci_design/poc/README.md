# Generic CI AMI – POC Step-by-Step Guide

This document is a **step-by-step Proof of Concept (POC) guide** for building and using a Generic CI AMI. It walks through scope definition, AMI build, CI configuration, sample jobs, documentation, and common questions.

---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 26-02-2026 | v1.0 | Mukesh Sharma | 26-02-2026 |  |  |  |  |


---

## Table of Contents

1. [Prerequisites](#1-prerequisites)
2. [Step 1 – Define scope](#2-step-1--define-scope)
3. [Step 2 – Build the AMI](#3-step-2--build-the-ami)
4. [Step 3 – Configure CI](#4-step-3--configure-ci)
5. [Step 4 – Run sample jobs](#5-step-4--run-sample-jobs)
6. [Step 5 – Document and iterate](#6-step-5--document-and-iterate)
7. [Success criteria](#7-success-criteria)
8. [FAQ](#8-faq)
9. [Contact Information](#9-contact-information)
10. [References](#10-references)

---

## 1. Prerequisites

Before starting the POC, ensure the following are in place:

| Requirement | Description |
|-------------|-------------|
| **AWS account** | An AWS account with permissions to create EC2 instances, AMIs, and (if used) IAM roles for instances. |
| **AWS CLI** | Installed and configured (`aws configure`) with credentials that can create EC2 resources. |
| **Packer (optional)** | [Packer](https://www.packer.io/downloads) installed if you use the automated AMI build. |
| **CI system** | Jenkins or GitLab (or similar) already set up and accessible. |
| **Base AMI** | Identify the base AMI ID for your region (e.g. Amazon Linux 2 or Ubuntu). |

**Quick checks:**

```bash
# Verify AWS CLI
aws sts get-caller-identity

# Verify Packer (if using)
packer version
```

---

## 2. Step 1 – Define scope

**Objective:** Decide what the POC will cover so the AMI and CI config stay focused.

| Task | Action |
|------|--------|
| **Choose pipelines** | Pick one or two pipelines (e.g. one Java app, one Node.js app) that will run on the AMI. |
| **List runtimes** | Document required runtimes and versions (e.g. Java 17, Node 20, Python 3.11). |
| **Choose CI system** | Decide: Jenkins (with EC2/agent plugin) or GitLab Runner (autoscale). |
| **Document scope** | Write a short table: pipeline name, repo, runtime, and any special tools (Docker, Maven, npm). |

**Example scope table:**

| Pipeline | Repo / project | Runtime | Tools |
|----------|----------------|---------|--------|
| Java API | myapp-backend | Java 17 | Maven, Docker CLI |
| Node frontend | myapp-frontend | Node 20 | npm, Docker CLI |

---

## 3. Step 2 – Build the AMI

**Objective:** Create a reusable AMI with the OS, runtimes, and CI agent preinstalled.

### 3.1 Option A – Build with Packer (recommended)

1. **Create a Packer project directory**, e.g. `generic-ci-ami-packer/`.

2. **Create `generic-ci-ami.pkr.hcl`** (or `.json`) with:
   - **Source block:** Use `amazon-ebs` builder, your region, base AMI ID, instance type (e.g. `t3.medium`), and IAM instance profile if needed.
   - **Build block:** Provisioners to install packages and agent.

3. **Example Packer template structure:**

   - Set variables: `region`, `source_ami`, `instance_type`.
   - In the **source**, use a recent Amazon Linux 2 or Ubuntu AMI.
   - **Provisioners:**  
     - Shell or Ansible to: update OS, install Java, Node, Python, Git, Docker CLI, and the CI agent (e.g. Jenkins agent JAR or GitLab Runner binary).

4. **Run Packer:**

   ```bash
   cd generic-ci-ami-packer
   packer init .
   packer validate generic-ci-ami.pkr.hcl
   packer build generic-ci-ami.pkr.hcl
   ```

5. **Note the output AMI ID** shown after the build.

### 3.2 Option B – Build manually

1. **Launch an EC2 instance** from the base AMI (e.g. Amazon Linux 2) in your chosen region and VPC.
2. **SSH into the instance** and run install steps (example for Amazon Linux 2):

   ```bash
   sudo yum update -y
   sudo yum install -y java-17-amazon-corretto-headless git docker
   # Install Node (e.g. via nvm or NodeSource)
   # Install CI agent (Jenkins agent or GitLab Runner)
   ```

3. **Harden and clean:** Remove history, clear logs if desired, apply security best practices.
4. **Create AMI:** In AWS Console (EC2 → Instances → right-click instance → Image and templates → Create image), or via CLI:

   ```bash
   aws ec2 create-image --instance-id i-xxxxxxxxx --name "generic-ci-ami-poc-v1" --description "POC Generic CI AMI"
   ```

5. **Tag the AMI** (e.g. `Name=generic-ci-ami-poc-v1`, `Purpose=POC`).

---

## 4. Step 3 – Configure CI

**Objective:** Configure your CI controller to launch agents/workers from the new AMI.

### 4.1 If using Jenkins

| Step | Action |
|------|--------|
| 1 | Install the **EC2 Fleet** or **EC2** plugin if not already installed. |
| 2 | In Jenkins: **Manage Jenkins → Manage Nodes and Clouds → Configure Clouds**. |
| 3 | Add **Amazon EC2** (or EC2 Fleet) cloud; set AWS credentials or IAM role. |
| 4 | Add an **AMI** configuration: use the AMI ID from Step 2, choose region, subnet, security group. |
| 5 | Set **Remote FS root** (e.g. `/home/ec2-user`) and **Launch method** (SSH or JNLP). |
| 6 | Set **Number of executors** and **Labels** (e.g. `generic-ci-ami`). |
| 7 | Save; Jenkins will launch instances from this AMI when jobs with the matching label run. |

### 4.2 If using GitLab Runner (autoscale)

| Step | Action |
|------|--------|
| 1 | In GitLab: **Settings → CI/CD → Runners**; use a runner that supports autoscale (e.g. Docker Machine or custom executor). |
| 2 | Configure the runner (e.g. `config.toml`) to use an **EC2 driver**: set AMI ID, region, instance type, subnet, security group. |
| 3 | Set **Idle count** and **Idle time** so runners scale down when not in use. |
| 4 | Register the runner with GitLab; jobs will run on instances launched from your AMI. |

---

## 5. Step 4 – Run sample jobs

**Objective:** Confirm that jobs actually run on instances from the Generic CI AMI and produce correct results.

| Step | Action |
|------|--------|
| 1 | **Trigger the chosen pipeline(s)** (e.g. push a commit or open a PR). |
| 2 | **Verify** that a new EC2 instance is launched from your AMI (check EC2 console or Jenkins/GitLab logs). |
| 3 | **Check** that the job sees the expected runtimes (e.g. `java -version`, `node -version`). |
| 4 | **Ensure** the build and tests complete successfully and artifacts (if any) are uploaded. |
| 5 | **Observe** that the instance is terminated (or returned to the pool) after the job. |

**Quick validation commands** (run inside the job or via SSH to the agent):

```bash
java -version
node -version
docker --version
git --version
```

---

## 6. Step 5 – Document and iterate

**Objective:** Leave a clear record and plan for improvement.

| Task | Action |
|------|--------|
| **Document AMI contents** | List installed runtimes and versions (e.g. in a table in this README or in the main design doc). |
| **Document build process** | Note whether you used Packer or manual steps; store Packer files in a repo. |
| **Record AMI ID and region** | Document the POC AMI ID and region so others can reuse it. |
| **Gather feedback** | Note any issues (startup time, missing tools, permissions) and refine the AMI or CI config. |
| **Plan rollout** | If the POC succeeds, plan how to roll out the AMI to more pipelines and how to patch/rebuild periodically. |

---

## 7. Success criteria

Use this checklist to confirm the POC is complete:

| Criterion | Status |
|-----------|--------|
| AMI builds successfully (Packer or manual). | ☐ |
| AMI is tagged and the ID is documented. | ☐ |
| CI controller launches instances from the AMI. | ☐ |
| At least one pipeline (e.g. Java or Node) runs end-to-end on the AMI. | ☐ |
| Job startup time is acceptable. | ☐ |
| Required runtimes and tools are available on the agent. | ☐ |
| Process to update the AMI (and optionally Packer template) is documented. | ☐ |

---

## 8. FAQ

| Question | Answer |
|----------|--------|
| **How often should we rebuild the Generic CI AMI?** | Rebuild periodically (e.g. monthly) to apply OS and runtime security updates. Use Packer so rebuilds are repeatable. |
| **Can one AMI serve both Jenkins and GitLab?** | Yes, if you install both agent types. For a POC, prefer one CI system per AMI to keep the image minimal and easier to debug. |
| **What if a job needs a tool not in the AMI?** | Either add it to the AMI and rebuild, or install it in the job (e.g. in the pipeline script). For stability, prefer adding to the AMI for common tools. |
| **Why does the agent fail to connect to Jenkins/GitLab?** | Check security groups (inbound from CI controller), subnet (routing to the controller), and IAM/credentials. Ensure the agent binary and config (URL, token) are correct on the AMI. |
| **Packer build fails with "source_ami not found".** | The base AMI ID is region-specific. Use the correct ID for your region, or use a dynamic source (e.g. `amazon-ami` data source) to look up the latest Amazon Linux 2 AMI. |
| **Instances launch but jobs never run.** | Verify labels (Jenkins) or tags (GitLab) match what the pipeline expects. Check executor count and that the agent/user has permission to run the job. |
| **How do we roll back to a previous AMI?** | Update the CI cloud/runner config to use the previous AMI ID. Keep old AMIs (with tags) until you are sure the new one is stable. |

---

## 9. Contact Information


| Name | Email Address |
|------|----------------|
| Mukesh kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 10. References

| Link | Description |
|------|-------------|
| [AWS – Amazon Machine Images (AMIs)](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/AMIs.html) | What is an AMI and how to use it. |
| [Packer – Amazon EBS builder](https://www.packer.io/plugins/builders/amazon/ebs) | Automate AMI builds with Packer. |
| [Jenkins – EC2 Fleet plugin](https://plugins.jenkins.io/ec2-fleet/) | Run Jenkins agents on EC2 from an AMI. |
| [GitLab – Runner autoscaling](https://docs.gitlab.com/runner/configuration/autoscale.html) | Use GitLab Runner with autoscale (e.g. EC2 from AMI). |
| [Generic CI AMI (design doc)](../generic_ci_ami.md) | Parent document: What, Why, workflow, and best practices. |

---
