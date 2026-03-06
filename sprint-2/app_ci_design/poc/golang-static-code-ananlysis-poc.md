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
4. [Step 2 — Add static analysis (go vet, linter)](#4-step-2--add-static-analysis-go-vet-linter)
5. [Step 3 — Configure and run in CI](#5-step-3--configure-and-run-in-ci)
6. [Step 4 — Document and tune](#6-step-4--document-and-tune)
7. [Benefits of Go static analysis in CI](#7-benefits-of-go-static-analysis-in-ci)
8. [Contact Information](#8-contact-information)
9. [References](#9-references)

---

## 1. Scope and context

| Item | Description |
|------|-------------|
| **Application** | Go (Golang) microservice; e.g. REST API with Gin; packages such as api, client, config, middleware, routes. |
| **Repo location** | Go project directory (e.g. **~/go-app** or your Go module path). |
| **Build** | `go build` (or `make build`); `go fmt ./...`, `go vet ./...`. |
| **POC goal** | Add static code analysis (go fmt, go vet, and optionally golangci-lint) to the CI pipeline; fail on format or lint errors. |

---

## 2. Prerequisites

| Requirement | Description |
|-------------|-------------|
| **Go** | Go 1.20+ (or version required by the project). |
| **Go project repo** | Clone or use the existing Go module directory; ensure `go.mod` and `.go` sources are present. |
| **Linter (optional)** | **golangci-lint** or **staticcheck** for deeper analysis; install from releases or `go install`. |

---

## 3. Step 1 — Build and format the Go project

1. Navigate to the Go project directory:
   ```bash
   cd ~/go-app
   ```
2. Format code:
   ```bash
   go fmt ./...
   # or: make fmt
   ```
3. Build the project:
   ```bash
   make build
   # or: go build -o app .
   ```
4. Ensure the build succeeds. Static analysis will run on the same codebase (e.g. `go vet ./...` and optionally golangci-lint).

---

## 4. Step 2 — Add static analysis (go vet, linter)

1. **go vet** — Run the standard analyzer:
   ```bash
   go vet ./...
   # or: make vet
   ```
   Fix any reported issues.

2. **golangci-lint (optional)** — Install and run:
   ```bash
   golangci-lint run
   ```
   Add a `.golangci.yml` in the project root to enable/disable linters and set rules. Example (minimal):
   ```yaml
   linters:
     enable:
       - vet
       - errcheck
       - staticcheck
   ```

3. Alternatively use **staticcheck** alone:
   ```bash
   staticcheck ./...
   ```

---

## 5. Step 3 — Run checks manually

Run the same checks locally that you would want in CI:

```bash
cd ~/go-app
go fmt ./...
go vet ./...
golangci-lint run    # if installed and configured
```

Ensure these commands succeed before sharing changes or opening a pull request.

---

## 6. Step 4 — Document and tune

1. **Document** — Record in this file or in the project README: tools used (go fmt, go vet, golangci-lint/staticcheck), how to run them locally (`make fmt`, `make vet`, `golangci-lint run`), and any severity thresholds you use.
2. **Tune** — If the linter reports too many findings, adjust `.golangci.yml` (disable specific linters or rules) so the output is actionable; then gradually tighten rules over time.

---

## 7. Benefits of Go static analysis in CI

| Benefit | Description |
|---------|-------------|
| **Cleaner codebase** | Ensures `go fmt` is consistently applied so all Go files follow the same formatting conventions. |
| **Detects subtle bugs early** | `go vet` and linters (golangci-lint/staticcheck) catch suspicious patterns and common mistakes before runtime. |
| **Enforces team rules automatically** | A shared linter configuration makes style and correctness rules part of the CI pipeline instead of manual review. |
| **Reduces production incidents** | Many issues (e.g. unchecked errors, dead code) are removed before deployments, lowering the risk of runtime failures. |
| **Easy local reproduction** | Developers can run the same `go fmt`, `go vet`, and linter commands locally to fix problems before pushing. |

---

## 8. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 9. References

| Link | Description |
|------|-------------|
| [GoLang CI Checks — Static Code Analysis (main doc)](../golang-static-code-analysis.md) | Main design document for Go static code analysis. |
| [go fmt](https://pkg.go.dev/cmd/gofmt) | Standard Go formatter. |
| [go vet](https://pkg.go.dev/cmd/vet) | Standard Go static analyzer. |
| [golangci-lint](https://golangci-lint.run/) | Aggregated linters for Go. |
| [staticcheck](https://staticcheck.io/) | Static analysis for Go. |

---
