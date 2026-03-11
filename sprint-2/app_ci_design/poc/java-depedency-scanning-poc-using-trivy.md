# Maven Project Dependency Scanning with Trivy — POC


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
9. [Step 6 — Quick full workflow](#9-step-6--quick-full-workflow)
10. [Contact Information](#10-contact-information)
11. [References](#11-references)

---

## 1. Introduction

This guide explains how to scan a Maven project for **dependency vulnerabilities** using **Trivy** and generate a **SARIF report** for visualization.

**Advantages of using SARIF:**

- Standardized report format
- GitHub Security tab compatible
- Can be visualized locally in a browser

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

---

## 6. Step 3 — Scan the project and generate SARIF report

Run Trivy on the project folder and output a SARIF report:

```bash
trivy fs --format sarif -o trivy-report.sarif .
```

- `--format sarif` → produces SARIF report compatible with GitHub Security Tab
- `-o trivy-report.sarif` → outputs the report file

---

## 7. Step 4 — Visualize the SARIF report

### Option 1: Local visualization

Use a SARIF viewer website:

1. Go to: <https://sarifweb.azurewebsites.net/>
2. Upload `trivy-report.sarif`
3. Explore vulnerabilities, severity, and affected dependencies visually

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

## 9. Step 6 — Quick full workflow

```bash
# 1. Build the project
mvn clean package

# 2. Run Trivy and generate SARIF
trivy fs --format sarif -o trivy-report.sarif .

# 3. Visualize locally
# Upload trivy-report.sarif to https://sarifweb.azurewebsites.net/
```

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
