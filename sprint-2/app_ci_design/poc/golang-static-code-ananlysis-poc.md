# GoLang CI Checks | Static Code Analysis — POC



---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 26-02-2026 | v1.0 | Mukesh Sharma | 26-02-2026 |  |  |  |  |

---

## Table of Contents

1. [Scope and context](#1-scope-and-context)
2. [Prerequisites](#2-prerequisites)
3. [Step 1 — Build and format the Go project](#3-step-1--build-and-format-the-go-project)
4. [Step 2 — Configure and run SonarQube](#4-step-2--configure-and-run-sonarqube)
5. [Step 3 — Document and tune](#5-step-3--document-and-tune)
6. [Advantages of SonarQube over traditional tools](#6-advantages-of-sonarqube-over-traditional-tools)
7. [Contact Information](#7-contact-information)
8. [References](#8-references)

---

## 1. Scope and context

| Item | Description |
|------|-------------|
| **Application** | Go (Golang) microservice; e.g. REST API with Gin; packages such as api, client, config, middleware, routes. |
| **Repo location** | Go project directory (e.g. **~/go-app** or **API/employee-api**). |
| **Build** | `go build` (or `make build`); `go fmt ./...`. |
| **POC goal** | Run **SonarQube** static code analysis on the Go project; view the report in the SonarQube web UI (issues, code smells, security, quality gate). |

---

## 2. Prerequisites

| Requirement | Description |
|-------------|-------------|
| **Go** | Go 1.20+ (or version required by the project). |
| **Go project repo** | Clone or use the existing Go module directory; ensure `go.mod` and `.go` sources are present. |
| **SonarQube server** | A running SonarQube instance (e.g. local or company server). You need the server URL (e.g. `http://localhost:9000` or `https://sonarqube.example.com`). |
| **SonarQube token** | A user token generated in SonarQube (My Account → Security → Generate Token) for the scanner. |
| **SonarScanner** | SonarScanner CLI installed on your machine. Download from [SonarQube Scanner](https://docs.sonarqube.org/latest/analyzing-source-code/scanners/sonarscanner/). |

---

## 3. Step 1 — Build and format the Go project

Run these commands from your machine. Replace the path with your Go project directory (e.g. `employee/employee-api`).

**Step 1.1 — Navigate to the Go project directory**

```bash
cd ~/emploeyee/employee-api

```
<img width="1915" height="202" alt="image" src="https://github.com/user-attachments/assets/62c83541-8a1d-4cb6-897e-f505d53fd9cc" />


**Step 1.2 — Format code**

```bash
go fmt ./...
```
<img width="1915" height="98" alt="image" src="https://github.com/user-attachments/assets/0cfe2dd6-a2c6-46dc-91ed-e56aafa384bf" />


**Step 1.3 — Build the project**

```bash
go build
# Or use Make: make build
```

**Step 1.4 — Confirm build succeeded**

If the build completes without errors, proceed to Step 2. SonarQube will analyze the same codebase.

---

## 4. Step 2 — Configure and run SonarQube

Run these steps in the same Go project directory. The **report is visible in the SonarQube web UI** after the scan.

**Step 2.1 — Create the project in SonarQube (if not already created)**

1. Log in to your SonarQube server (e.g. `http://localhost:9000`).
2. Click **Create a local project** (or use existing project).
3. **Project key:** e.g. `go-employee-api` (must be unique).
4. **Display name:** e.g. `Go Employee API`.
5. Generate a token for the project (or use an existing token). Save the token; you will use it in Step 2.2.

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b03657fb-28c6-42cd-acd8-573928f669f8" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b89af40d-bbfc-423d-b4e8-d37b1dc5bfd5" />


**Step 2.2 — Add `sonar-project.properties` in the project root**

Create a file named **`sonar-project.properties`** in the Go project root (same folder as `go.mod`):

```properties
# SonarQube server
sonar.host.url=http://localhost:9000
# Or: sonar.host.url=https://sonarqube.example.com

# Project identification (use the key from Step 2.1)
sonar.projectKey=go-employee-api
sonar.projectName=Go Employee API

# Source code (paths relative to this file)
sonar.sources=.

# Go-specific: exclude vendor and generated files if needed
sonar.exclusions=**/vendor/**,**/*_test.go
# To include tests in analysis, remove **/*_test.go from exclusions

# Token (use environment variable in production; do not commit secrets)
sonar.token=your-sonarqube-token-here
```
<img width="1915" height="464" alt="image" src="https://github.com/user-attachments/assets/e31a1219-c4fe-48f4-aba7-339fa6355fd9" />

Replace `your-sonarqube-token-here` with the token from Step 2.1. Prefer setting the token via environment variable and omit `sonar.token` from the file:

```bash
export SONAR_TOKEN=your-sonarqube-token-here
```

Then in `sonar-project.properties` you can use (if your SonarScanner version supports it): leave `sonar.token` out and pass it via `-Dsonar.token=$SONAR_TOKEN` when running the scanner, or set it in the file only for local POC and add the file to `.gitignore`.

**Step 2.3 — Run the SonarScanner**

From the Go project root:

```bash
# Downlaod sonar-scanner
cd /data
mkdir sonar-scanner
cd sonar-scanner
curl -O https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-8.0.1.6346-linux-x64.zip

unzip sonar-scanner-cli-8.0.1.6346-linux-x64.zip 
# scp -i ~/secretkey.pem sonar-scanner-cli-8.0.1.6346-linux-x64.zip  ubuntu@3.90.17.235:~/
# scp -i ~/secretkey.pem sonar-scanner-cli-8.0.1.6346-linux-x64.zip  ubuntu@10.0.2.75:~/employee/employee-api

export PATH="/data/sonar-scanner/sonar-scanner-8.0.1.6346-linux-x64/bin:$PATH"
which sonar-scanner
cd ~/employee/employee-api/

# edit in conf/sonar.properties
sonar.web.host=0.0.0.0
sonar.web.port=9000
# run sonarqube again on the local machine
sonar-scanner

# install ngrok
# Download ngrok
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt update && sudo apt install ngrok

# Verify installation
ngrok version

export SONAR_SCANNER_OPTS="-Djava.io.tmpdir=/data/tmp_sonar_scanner -Xmx512m"


---

sudo mkdir -p /data/sonar_cache
sudo mkdir -p /data/tmp_sonar
sudo chown -R ubuntu:ubuntu /data/sonar_cache /data/tmp_sonar

export SONAR_SCANNER_OPTS="-Djava.io.tmpdir=/data/tmp_sonar -Xmx512m"
export SONAR_USER_HOME="/data/sonar_cache"

export PATH="/data/sonar-scanner/sonar-scanner-8.0.1.6346-linux-x64/bin:$PATH"

which sonar-scanner
echo $SONAR_SCANNER_OPTS
echo $SONAR_USER_HOME
df -h /data
sonar-scanner

```

<img width="1915" height="909" alt="image" src="https://github.com/user-attachments/assets/8002727e-570d-4f9e-8864-b9f781e2c9e1" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/c80e71b0-0485-4847-a0c2-f0d43420d90b" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/eb91d225-5bf9-498b-bc23-d21ad16e4e63" />


<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/f2bc47a3-9dc0-44bc-a1b2-d34933f256e9" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/ca3fc35a-bec4-416c-9b52-f1251b1d2d99" />

<img width="1915" height="347" alt="image" src="https://github.com/user-attachments/assets/69757117-c2a8-4185-abae-cf73059fda1f" />

<img width="1915" height="347" alt="image" src="https://github.com/user-attachments/assets/d95baf03-e3c9-49be-8c73-c45bd58326f3" />


<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/6a60d581-8773-44f3-8dd4-d5a47006de8d" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/33c802e6-f22e-44fd-a905-083804b8a0d8" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/272b9fc3-9ec3-4db7-8afe-c5b53eb24a4d" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/ccba0c7b-4755-432f-be9c-1a2fb6913d82" />

<img width="1915" height="1044" alt="image" src="https://github.com/user-attachments/assets/c88a658e-8e3c-4f0e-9316-6e901bfedbc2" />
<img width="1915" height="1044" alt="image" src="https://github.com/user-attachments/assets/2990922a-425a-4015-8cf7-768cbe522484" />
<img width="1915" height="1044" alt="image" src="https://github.com/user-attachments/assets/d2256d04-9cd1-443b-a5c7-e20eee020359" />

<img width="1915" height="194" alt="image" src="https://github.com/user-attachments/assets/1ffa7fd5-07a6-4280-986e-809ed166683e" />
<img width="1915" height="194" alt="image" src="https://github.com/user-attachments/assets/4f7a3fb1-b924-4552-b1c0-b249bcbd9b38" />

<img width="1915" height="718" alt="image" src="https://github.com/user-attachments/assets/28eb7ca3-3f8f-43b5-b5c0-4cb4b5a60042" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/7ddc130e-ab5d-4a05-b886-6d14744abbed" />

**Final Output**

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/de2f9eb4-d429-4260-befe-c373f1696976" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/352ebdbc-41e6-439e-914e-ee8e3a3af230" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b56373e1-98ac-425c-8785-9e00bca41eb2" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/9eb07cfe-3e77-4228-9822-4aaad39900b5" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/e8efc02e-2148-4095-a1a7-da5cd97b38a5" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/8e41ced3-d273-45d7-a533-8f45fa9be04d" />


If the token is in an environment variable:

```bash
sonar-scanner -Dsonar.token=$SONAR_TOKEN
```

Wait for the scan to finish. The scanner prints a link to the analysis result (e.g. **Dashboard** URL).

**Step 2.4 — Open the report in SonarQube**

1. In the terminal output, find the **dashboard URL** (e.g. `http://localhost:9000/dashboard?id=go-employee-api`).
2. Open that URL in your browser.
3. You will see the **SonarQube report**: Issues, Code Smells, Security Hotspots, Coverage (if tests are run and reported), and the **Quality Gate** status (Passed / Failed).

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/fe373204-8748-48de-8dd4-458e60a57326" />
<img width="1915" height="718" alt="image" src="https://github.com/user-attachments/assets/a0289530-4759-44d2-a93a-830be3ac5bf0" />
<img width="1915" height="718" alt="image" src="https://github.com/user-attachments/assets/8b0138c5-10be-4bed-a3a0-00b6349dc396" />
<img width="1915" height="718" alt="image" src="https://github.com/user-attachments/assets/462a8007-dd26-4bc3-99d7-c6b5e8c513ac" />
<img width="1915" height="718" alt="image" src="https://github.com/user-attachments/assets/c2718a93-134e-41fe-a154-26a84713b871" />


<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/56be412e-f5df-4935-a7b9-333a83ddc0da" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/a7414e69-b2d3-4926-8bd9-40868b0e17d7" />


**Report in SonarQube UI (summary)**

| Section | Contents |
|---------|----------|
| **Dashboard** | Overview: bugs, vulnerabilities, code smells, duplication, quality gate. |
| **Issues** | List of findings with file, line, severity, and rule. |
| **Security Hotspots** | Security-related findings to review. |
| **Quality Gate** | Pass / Fail status based on configured conditions. |

The report is **visible and shareable** via the SonarQube web interface; no local report file is required for viewing.

---

## 5. Step 3 — Document and tune

1. **Document** — Note the SonarQube server URL, project key, and that you run `sonar-scanner` from the project root. Add `sonar-project.properties` to the repo (without secrets) or document the required properties.
2. **Tune** — In SonarQube, adjust Quality Gate conditions or exclude files (e.g. `sonar.exclusions`) if needed. Fix critical and blocker issues first, then re-run `sonar-scanner` to refresh the report.

---

## 6. Advantages of SonarQube over traditional tools

| Advantage | Description |
|-----------|-------------|
| **Single dashboard** | One web UI for issues, code smells, security hotspots, duplication, and quality gate—unlike go vet or golangci-lint, which only print to the terminal or text files. |
| **Quality gate** | Built-in pass/fail criteria (e.g. no new bugs, coverage threshold) so you can enforce quality at a glance; traditional tools have no standard “gate” concept. |
| **Historical trend** | SonarQube stores history and shows trends over time (e.g. issue count, technical debt); go vet and linters are single-run only. |
| **Multi-language** | Same server and workflow for Go, Java, JS, and others; traditional Go tools (go vet, golangci-lint, staticcheck) are Go-only. |
| **Centralized reporting** | Reports are visible to the whole team via URL; no need to share local lint or vet output files. |
| **Security and hotspots** | Dedicated security and hotspot views with remediation guidance; traditional Go linters focus more on correctness and style. |
| **Configurable rules** | Enable, disable, or tune rules and quality profiles in the UI; with go vet and many linters you edit config files only. |

---

## 7. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 8. References

| Link | Description |
|------|-------------|
| [SonarQube documentation](https://docs.sonarqube.org/latest/) | SonarQube user and analysis documentation. |
| [SonarScanner](https://docs.sonarqube.org/latest/analyzing-source-code/scanners/sonarscanner/) | Download and use SonarScanner CLI. |
| [Analyzing Go with SonarQube](https://docs.sonarqube.org/latest/analysis/languages/go/) | Go language support in SonarQube. |
| [GoLang CI Checks — Static Code Analysis (main doc)](../golang-static-code-analysis.md) | Main design document for Go static code analysis. |

---
