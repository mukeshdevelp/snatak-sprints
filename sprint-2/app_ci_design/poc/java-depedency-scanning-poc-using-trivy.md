# Java CI Checks Dependency Scanning with Trivy — POC


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 11-03-2026 | v1.0 | Mukesh Sharma | 11-03-2026 |  |  |  |  |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Scope and context](#2-scope-and-context)
3. [Prerequisites](#3-prerequisites)
4. [Step 1 — Install Trivy](#4-step-1--install-trivy)
5. [Step 2 — Build the Maven project](#5-step-2--build-the-maven-project)
6. [Step 3 — Scan the project and generate SARIF report](#6-step-3--scan-the-project-and-generate-sarif-report)
7. [Step 4 — Visualize the SARIF report](#7-step-4--visualize-the-sarif-report)
8. [Step 5 — Ignore specific vulnerabilities](#8-step-5--ignore-specific-vulnerabilities)
9. [Advantages of using Trivy](#9-advantages-of-using-trivy)
10. [Contact Information](#10-contact-information)
11. [References](#11-references)

---

## 1. Introduction

This guide explains how to scan a Maven project for **dependency vulnerabilities** using **Trivy** and generate a **SARIF report** for visualization.

---

## 2. Scope and context

| Item | Description |
|------|-------------|
| **Application** | Java/Spring Boot Maven project (e.g. salary-api). |
| **Repo location** | Maven project directory containing `pom.xml`. |
| **Build** | `mvn clean package`; produces the JAR in `target/`. |
| **POC goal** | Run Trivy filesystem scan, generate SARIF report, and visualize vulnerabilities. |

---

## 3. Prerequisites

| Requirement | Description |
|-------------|-------------|
| **Java and Maven** | Java 17+, Maven (per project `pom.xml`). |
| **Trivy** | Trivy CLI installed (see Step 1). |

---

## 4. Step 1 — Install Trivy

### On Ubuntu

```bash
sudo apt-get update
sudo apt-get install wget apt-transport-https gnupg lsb-release -y

# Add Trivy repo key and source
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo "deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main" | sudo tee -a /etc/apt/sources.list.d/trivy.list

# Install Trivy
sudo apt-get update
sudo apt-get install trivy -y

# Verify installation
trivy --version
```
**Expected Output**

<img width="1917" height="894" alt="image" src="https://github.com/user-attachments/assets/4b36a9a0-54c7-464d-b7ae-ac216b25031c" />
<img width="1917" height="894" alt="image" src="https://github.com/user-attachments/assets/a2cfe4d9-92e9-4288-93fd-46c9292a7cf5" />
<img width="1917" height="320" alt="image" src="https://github.com/user-attachments/assets/4fa75171-7790-4bba-8227-74db514dd7fd" />


---

## 5. Step 2 — Build the Maven project

Build your Maven project to generate the JAR:

```bash
mvn clean package
```

This will produce the artifact in:

```
target/salary-0.1.0-RELEASE.jar
```
<img width="1920" height="879" alt="image" src="https://github.com/user-attachments/assets/242efaad-bed0-49e5-85bd-07c843302445" />
<img width="1920" height="879" alt="image" src="https://github.com/user-attachments/assets/e1a6bc03-5af9-44e8-9ac5-90b07b30d10a" />

---

## 6. Step 3 — Scan the project and generate SARIF report

Run Trivy on the project folder and output a SARIF report:

```bash
trivy fs .
trivy fs -f json -o trivy-report.json .
cat trivy-report.json
trivy fs --format sarif -o trivy-report.sarif .
scp -i secretkey.pem ubuntu@10.0.2.75:~/trivy-report.sarif ~/

```

- `--format sarif` → produces SARIF report compatible with GitHub Security Tab
- `-o trivy-report.sarif` → outputs the report file

**Expected Output**

<img width="1920" height="879" alt="image" src="https://github.com/user-attachments/assets/94cbabc8-e24b-4ab0-b661-7cc087885beb" />
<img width="1920" height="987" alt="image" src="https://github.com/user-attachments/assets/87e8e11f-6034-446e-8cff-7064aff8d702" />
<img width="1920" height="987" alt="image" src="https://github.com/user-attachments/assets/a76e64e5-b930-4017-98c3-cb3dd4c9ff99" />
<img width="1920" height="987" alt="image" src="https://github.com/user-attachments/assets/28b6f16b-5c46-4bf9-8ed3-d561fc36d5c5" />
<img width="1920" height="314" alt="image" src="https://github.com/user-attachments/assets/b311cd25-2bc6-42ea-8de8-56d117cfc84a" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b8e4d768-5e8c-4f53-8d64-e14a6e705c6e" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/579ea746-3d8a-4c9e-a4bd-d7d72ce511df" />
<img width="1920" height="503" alt="image" src="https://github.com/user-attachments/assets/40ec8f7e-c13c-4120-88b9-1afe16e740a8" />

<img width="1920" height="503" alt="image" src="https://github.com/user-attachments/assets/a03c025c-54ed-4c83-965e-60a2ea1cc70c" />
<img width="1920" height="121" alt="image" src="https://github.com/user-attachments/assets/b535c31d-c5e1-4a05-af9b-f4aeea60761c" />


---

## 7. Step 4 — Visualize the SARIF report

### Option 1: Local visualization

Use a SARIF viewer website:

1. Go to: <https://sarifweb.azurewebsites.net/>
2. Upload `trivy-report.sarif`
3. Explore vulnerabilities, severity, and affected dependencies visually

<img width="1920" height="521" alt="image" src="https://github.com/user-attachments/assets/e97356e2-feb2-4e89-b626-d2f2eb52defe" />


---

## 8. Step 5 — Ignore specific vulnerabilities

Create a `.trivyignore` file in the project root:

```text
CVE-2023-12345
CVE-2022-98765
```

Trivy will skip these during scans:

```bash
trivy fs .
```

---

## 9. Advantages of using Trivy

- Uses a single binary, easy to install and run
- Scans filesystem, images, and SBOMs with one tool
- Supports multiple output formats (table, JSON, SARIF) for CI integration

---

## 10. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh Kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 11. References

| Link | Description |
|------|-------------|
| [Trivy Official Docs](https://aquasecurity.github.io/trivy/) | Trivy documentation. |
| [Trivy SARIF Template](https://aquasecurity.github.io/trivy/latest/docs/configuration/others/#sarif-template) | SARIF output configuration. |
| [GitHub Code Scanning with SARIF](https://docs.github.com/en/code-security/code-scanning/integrating-with-code-scanning/sarif-support-for-code-scanning) | Uploading SARIF to GitHub Security tab. |

---
