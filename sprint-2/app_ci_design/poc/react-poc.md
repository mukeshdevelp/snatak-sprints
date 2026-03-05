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

1. Download using `curl` (example for latest cross-platform ZIP):
   ```bash
   mkdir -p ~/tools
   cd ~/tools
   sudo apt install openjdk-17-jdk -y
   wget https://github.com/zaproxy/zaproxy/releases/download/v2.17.0/ZAP_2_17_0_unix.sh
   chmod +x ZAP_2_17_0_unix.sh
   ./ZAP_2_17_0_unix.sh
   
   ```
   (Adjust the version/URL if needed based on the ZAP download page.)
2. Extract the ZIP, e.g. to `~/tools/zap`:
   ```bash
   unzip zap.zip -d zap
   ```
2. Use `~/tools/zap/zap.sh` (Linux/macOS) or `zap.bat` (Windows).

Verify:

```bash
zap.sh -version
# or, if using ZIP: ~/tools/zap/zap.sh -version
```

Use the full path to `zap.sh` in the next steps if it is not on your `PATH`.

---

## 6. Step 4 — Run ZAP quick scan

With the frontend still running at `http://localhost:3000`, open a **new terminal** and run:

```bash
zap.sh -cmd \
  -quickurl http://localhost:3000 \
  -quickout zap_quick_report.html \
  -quickprogress
```

- `-cmd` — headless (no GUI)
- `-quickurl` — target URL
- `-quickout` — HTML report path
- `-quickprogress` — show progress in the terminal

When it finishes, `zap_quick_report.html` is in the current directory.

---

## 7. Step 5 — View and interpret the report

Open the report:

```bash
# Linux
xdg-open zap_quick_report.html
# macOS
open zap_quick_report.html
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
