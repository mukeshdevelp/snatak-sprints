# React CI Checks & DAST using OWASP ZAP — POC (Proof of Concept)

This document describes the **steps to perform DAST (Dynamic Application Security Testing)** on the frontend using **OWASP ZAP installed locally**. No Docker and no pipeline—just commands run on your machine.

---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 26-02-2026 | v1.0 | Mukesh Sharma | 26-02-2026 |  |  |  |  |

---

## Table of Contents

1. [Scope and context](#1-scope-and-context)
2. [Prerequisites](#2-prerequisites)
3. [Step 1 — Build the frontend](#3-step-1--build-the-frontend)
4. [Step 2 — Serve the frontend locally](#4-step-2--serve-the-frontend-locally)
5. [Step 3 — Install OWASP ZAP locally](#5-step-3--install-owasp-zap-locally)
6. [Step 4 — Run ZAP quick scan](#6-step-4--run-zap-quick-scan)
7. [Step 5 — View and interpret the report](#7-step-5--view-and-interpret-the-report)
8. [Success criteria](#8-success-criteria)
9. [Contact Information](#9-contact-information)
10. [References](#10-references)

---

## 1. Scope and context

| Item | Description |
|------|-------------|
| **Application** | Frontend — React (react-scripts) at **~/frontend**; build output in `build/`. |
| **POC goal** | Perform DAST on the frontend using **OWASP ZAP** (local install, no Docker). |
| **Target URL** | `http://localhost:3000` when the build is served locally. |

---

## 2. Prerequisites

| Requirement | Description |
|-------------|-------------|
| **Node.js and npm** | Node 16+; npm for install and build. |
| **Frontend repo** | **~/frontend** with `package.json`. |
| **Java** | Java 11+ (required by ZAP). |
| **OWASP ZAP** | Installed locally. |
| **Port 3000** | Free for serving the frontend. |

---

## 3. Step 1 — Build the frontend

```bash
cd ~/frontend

# buid the frontend
npm run build
# Or use
make build
```

Confirm the build exists:

```bash
ls -la build/
```


---

## 4. Step 2 — Serve the frontend locally

The frontend must be **running** for ZAP to scan it.

In a terminal, from **~/frontend**:

```bash
npm install -g serve
serve -s build

```

Leave this terminal open. In **browser**, check that the app responds:



---

## 5. Step 3 — Install OWASP ZAP locally


**Ubuntu (ZIP from website):**

1. Download using `wget` (example for latest cross-platform ZIP):
   ```bash
   mkdir -p ~/tools
   cd ~/tools
   sudo apt install openjdk-17-jdk -y
   wget https://github.com/zaproxy/zaproxy/releases/download/v2.17.0/ZAP_2_17_0_unix.sh
   chmod +x ZAP_2_17_0_unix.sh
   ./ZAP_2_17_0_unix.sh
   
   ```

**Expected Output**

<img width="1920" height="889" alt="image" src="https://github.com/user-attachments/assets/840cefc1-b4eb-4932-be81-a0fa47402d11" />

<img width="1920" height="919" alt="image" src="https://github.com/user-attachments/assets/9808cc9e-7dd6-48e0-9374-24ed97467f34" />

<img width="1920" height="919" alt="image" src="https://github.com/user-attachments/assets/b34dd382-cb36-454c-8044-8b4605a03326" />


<img width="1920" height="919" alt="image" src="https://github.com/user-attachments/assets/3efb75d9-7422-4457-b938-2de85c08f30e" />


<img width="1920" height="249" alt="image" src="https://github.com/user-attachments/assets/c3354bec-3cf4-4b43-8e58-d548b2b336d4" />

2. Use `~/tools/zap/zap.sh` (Linux/macOS).

Verify:

```bash
zap.sh -version

```
<img width="1920" height="362" alt="image" src="https://github.com/user-attachments/assets/cb485685-af9c-4615-a785-f02b24ef1c96" />


Use the full path to `zap.sh` in the next steps if it is not on your `PATH`.

---

## 6. Step 4 — Run ZAP quick scan

With the frontend still running at `http://localhost:3000`, open a **new terminal** and run:

```bash
cd /usr/local/zaproxy/
# Enter any private key
sudo /usr/local/zaproxy/zap.sh -daemon -port 8090 -host 0.0.0.0 -config api.key=12345
```

<img width="1920" height="426" alt="image" src="https://github.com/user-attachments/assets/265d947c-45fc-4208-98d0-cd456a255d8a" />
<img width="1920" height="755" alt="image" src="https://github.com/user-attachments/assets/3af708f1-28a8-4faf-a190-d9e054473b3b" />
<img width="1920" height="900" alt="image" src="https://github.com/user-attachments/assets/af77131d-ebb1-4cb6-a33c-e683f106b017" />
<img width="1920" height="900" alt="image" src="https://github.com/user-attachments/assets/f119bd86-d00a-4fd3-ae68-87de8c64142e" />






---

## 7. Step 5 — View and interpret the report

Open the report:

```bash
# Linux




```


**Risk levels:**

| Level | Action |
|-------|--------|
| **High/Critical** | Fix before release. |
| **Medium** | Plan to fix. |
| **Low/Info** | Review; often informational. |

Typical frontend findings: missing security headers (CSP, X-Frame-Options), cookie flags. Use the report to adjust your app or reverse proxy configuration.

---

## 8. Success criteria

| Criterion | Status |
|-----------|--------|
| Frontend builds (`npm run build` or `make build`). | Pending |
| Frontend is served at http://localhost:3000 (`npx serve -s build -l 3000`). | Pending |
| ZAP is installed locally (`zap.sh -version` works). | Pending |
| ZAP quick scan completes and produces `zap_quick_report.html`. | Pending |
| Report is reviewed; high/critical findings addressed or accepted. | Pending |

---

## 9. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 10. References

| Link | Description |
|------|-------------|
| [React CI checks — DAST](../react-ci-checks-dast.md) | Main design document. |
| [OWASP ZAP](https://www.zaproxy.org/) | OWASP ZAP. |
| [ZAP Quick Start](https://www.zaproxy.org/getting-started/) | ZAP headless/CLI usage. |

---
