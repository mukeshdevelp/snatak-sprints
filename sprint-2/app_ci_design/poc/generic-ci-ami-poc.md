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
| **Base AMI** | Ubuntu Server (e.g. 22.04 LTS) in the target region. |
| **Build automation (optional)** | Packer or scripts to build the AMI reproducibly; POC can be console-only. |

---

## 4. POC steps

This POC installs **Nginx** on the AMI and validates by opening the Nginx default page in a browser. All steps use the **AWS EC2 console** and SSH; exact commands are below (Ubuntu).

---

**Step 1 — Define scope**

- **Goal:** Build an AMI with Nginx preinstalled and show the Nginx default page in the browser from an instance launched from that AMI.



---

**Step 2 — Launch a base instance (console)**

1. In **EC2 console** → **Launch instance**.
2. **Name:** e.g. `nginx-ami-builder`.
3. **AMI:** Ubuntu Server (e.g. 22.04 LTS).
4. **Instance type:** e.g. `t2.micro`.
5. **Key pair:** Create or select a key pair (needed for SSH).
6. **Security group:** Create or use one that allows:
   - **SSH (22)** from your IP.
   - **HTTP (80)** from your IP (or `0.0.0.0/0` for POC only).
7. Launch the instance. Note the **public IP** after it is running.

**Expected Output**

<img width="1920" height="1080" alt="Screenshot from 2026-03-09 10-52-12" src="https://github.com/user-attachments/assets/a3526ed7-b09a-443b-ad80-9a310e1d005f" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/fdde848c-e9ca-415d-ba6d-fe6371e107d3" />

---

**Step 3 — Connect and install Nginx (commands)**

From your laptop, SSH into the instance (use the key and public IP from Step 2):

```bash
ssh -i /path/to/your-key.pem ubuntu@<public-ip>
```
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/2cf376c5-8a86-4629-9d92-e6f35f589baf" />


On the instance, run these commands to install and enable Nginx (Ubuntu):

```bash
# Update package lists and upgrade 
sudo apt update && sudo apt upgrade -y

# Install Nginx
sudo apt install nginx -y

# Start Nginx and enable it on boot
sudo systemctl start nginx
sudo systemctl enable nginx

# Verify Nginx is running
sudo systemctl status nginx
```
**Expected Output**

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/13574ff7-2f49-42ea-80b7-944755acf8fe" />

<img width="1910" height="910" alt="image" src="https://github.com/user-attachments/assets/3869ed81-6440-406b-96d6-4ab1591dec77" />


<img width="1910" height="651" alt="image" src="https://github.com/user-attachments/assets/6110ea87-099e-40f0-a39f-ab8cad1074dd" />


Leave the SSH session open or disconnect, the instance will keep Nginx running. Check if the nginx welcome page is available on browser.

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/2bf9a3c1-f46f-4216-9cbf-156abbc34845" />


---

**Step 4 — Create the AMI from the instance (console)**

1. In the **EC2 console** → **Instances**, select the instance (`nginx-ami-builder`).
2. **Actions** → **Image and templates** → **Create image**.
3. **Image name:** e.g. `generic-ami-nginx-poc-v1`.
4. **Image description:** e.g. `POC AMI with Nginx preinstalled`.
5. Click **Create image**.
6. Go to **EC2** → **Images** → **AMIs**. Wait until the AMI status is **Available** (a few minutes).
7. (Optional) Terminate the original builder instance after the AMI is available to avoid extra cost.

---

**Step 5 — Launch an instance from the new AMI (console)**

1. In **EC2 console** → **Launch instance**.
2. **Name:** e.g. `nginx-poc-test`. After filling the description click on `create image`.
3. **AMI:** Click **Browse** and select **My AMIs**; choose `generic-ami-nginx-poc-v1` (or the name you gave). Click on `Launch instance from AMI`.
4. **Instance type:** e.g. `t2.micro`. Also fill the necessary details to launch and ec2 instance.
5. **Key pair:** Same as before (for SSH if needed).
6. **Security group:** Use one that allows **HTTP (80)** from your IP (or `0.0.0.0/0` for POC).
7. Launch. Note the **public IP** of the new instance.

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/82090990-9168-4760-b6c6-a50f3fa5dd63" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/93255ea8-2409-4282-9ef1-62f12e880479" />

<img width="1910" height="651" alt="image" src="https://github.com/user-attachments/assets/bab5ffdb-6202-46a3-bb75-18d948167d1b" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/661d9a0f-ea69-44c2-80c4-231ea280773a" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/c2410780-722b-42cc-8f85-77d5b3746cc4" />


---

**Step 6 — Show Nginx in the browser (validate)**

1. Wait for the instance to pass **Status check** (running).
2. Open a browser and go to: **`http://<public-ip-of-new-instance>`**
3. You should see the **Nginx default welcome page** (e.g. “Welcome to nginx!”).
4. This confirms the AMI was built correctly and Nginx starts on boot from the new AMI.

**Expected Output:**

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/006db4cc-db83-4f31-908d-a4fec4452c41" />

---

**Step 7 — Document and clean up**

- Document: base AMI used, Nginx install commands, and that the image was created from the console.
- **Terminate** the test instance when done: EC2 → Instances → Select instance → **Instance state** → **Terminate instance**.

---

## 5. Success criteria

The POC is considered successful when:

| Criterion | Description |
|-----------|-------------|
| **AMI created successfully** | The AMI with Nginx is created from the console and appears in **AMIs** with status **Available**. |
| **Instance launches from the AMI** | An instance launched from the new AMI (via console) starts and passes status checks. |
| **Nginx visible in browser** | Opening `http://<public-ip>` in a browser shows the Nginx default welcome page (no SSH or extra setup required). |
| **No blocking issues** | No critical failures (e.g. Nginx not starting, port 80 blocked) that cannot be resolved with security group or install steps. |

If all of the above are met, the POC can be signed off and the approach can be extended (e.g. more packages, automation, or production use).

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



---
