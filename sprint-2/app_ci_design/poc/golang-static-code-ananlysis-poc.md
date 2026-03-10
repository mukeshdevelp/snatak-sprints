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

Run these commands from your machine. Replace the path with your Go project directory (e.g. `API/employee-api` or `~/go-app`).

**Step 1.1 — Navigate to the Go project directory**

```bash
cd /path/to/your/go-project
# Example: cd API/employee-api
```

**Step 1.2 — Format code**

```bash
go fmt ./...
```

**Step 1.3 — Build the project**

```bash
go build -o app .
# Or, if the project uses Make: make build
```

**Step 1.4 — Confirm build succeeded**

If the build completes without errors, proceed to Step 2. SonarQube will analyze the same codebase.

---

## 4. Step 2 — Configure and run SonarQube

Run these steps in the same Go project directory. The **report is visible in the SonarQube web UI** after the scan.

**Step 2.1 — Create the project in SonarQube (if not already created)**

1. Log in to your SonarQube server (e.g. `http://localhost:9000`).
2. Click **Create project manually** (or use existing project).
3. **Project key:** e.g. `go-employee-api` (must be unique).
4. **Display name:** e.g. `Go Employee API`.
5. Generate a token for the project (or use an existing token). Save the token; you will use it in Step 2.2.

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

Replace `your-sonarqube-token-here` with the token from Step 2.1. Prefer setting the token via environment variable and omit `sonar.token` from the file:

```bash
export SONAR_TOKEN=your-sonarqube-token-here
```

Then in `sonar-project.properties` you can use (if your SonarScanner version supports it): leave `sonar.token` out and pass it via `-Dsonar.token=$SONAR_TOKEN` when running the scanner, or set it in the file only for local POC and add the file to `.gitignore`.

**Step 2.3 — Run the SonarScanner**

From the Go project root:

```bash
sonar-scanner
# Or, if sonar-scanner is not in PATH: /path/to/sonar-scanner/bin/sonar-scanner
```

If the token is in an environment variable:

```bash
sonar-scanner -Dsonar.token=$SONAR_TOKEN
```

Wait for the scan to finish. The scanner prints a link to the analysis result (e.g. **Dashboard** URL).

**Step 2.4 — Open the report in SonarQube**

1. In the terminal output, find the **dashboard URL** (e.g. `http://localhost:9000/dashboard?id=go-employee-api`).
2. Open that URL in your browser.
3. You will see the **SonarQube report**: Issues, Code Smells, Security Hotspots, Coverage (if tests are run and reported), and the **Quality Gate** status (Passed / Failed).

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