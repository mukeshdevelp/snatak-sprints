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
5. [Step 3 — Document and tune](#5-step-3--document-and-tune)
6. [Success criteria](#6-success-criteria)
7. [Contact Information](#7-contact-information)
8. [References](#8-references)

---

## 1. Scope and context

| Item | Description |
|------|-------------|
| **Application** | Go (Golang) microservice; e.g. REST API with Gin; packages such as api, client, config, middleware, routes. |
| **Repo location** | Go project directory (e.g. **~/go-app** or your Go module path). |
| **Build** | `go build` (or `make build`); `go fmt ./...`, `go vet ./...`. |
| **POC goal** | Run static code analysis locally (go fmt, go vet, and optionally golangci-lint) using normal commands; fix format or lint errors. |

---

## 2. Prerequisites

| Requirement | Description |
|-------------|-------------|
| **Go** | Go 1.20+ (or version required by the project). |
| **Go project repo** | Clone or use the existing Go module directory; ensure `go.mod` and `.go` sources are present. |
| **Linter (optional)** | **golangci-lint** or **staticcheck** for deeper analysis; install from releases or `go install`. |

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

If the build completes without errors, proceed to Step 2. Fix any build errors before running static analysis.

---

## 4. Step 2 — Add static analysis (go vet, linter)

Run these commands in the same Go project directory.

**Step 2.1 — Run go vet and save a report**

```bash
go vet ./... 2>&1 | tee vet-report.txt
```

- Output is shown in the terminal and saved to **`vet-report.txt`** in the project root. Open the file to view the report.
- Fix any issues reported. Re-run until the command exits with no output (success). Then `vet-report.txt` will be empty or you can delete it.

**Step 2.2 — (Optional) Install golangci-lint**

```bash
go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
```

Ensure `$GOPATH/bin` or `$HOME/go/bin` is in your `PATH` so the `golangci-lint` command is found.

**Step 2.3 — (Optional) Run golangci-lint and save a report**

```bash
golangci-lint run ./... 2>&1 | tee lint-report.txt
```

- Output is shown in the terminal and saved to **`lint-report.txt`** in the project root. Open the file to view the report.
- Optional: save a JSON report for tooling or CI:
  ```bash
  golangci-lint run ./... --out-format json > lint-report.json
  ```

**Step 2.4 — (Optional) Add a config file for golangci-lint**

Create a file named `.golangci.yml` in the project root to enable/disable linters. Example (minimal):

```yaml
linters:
  enable:
    - vet
    - errcheck
    - staticcheck
```

Then run again and save the report:

```bash
golangci-lint run ./... 2>&1 | tee lint-report.txt
```

Open **`lint-report.txt`** to view the full report.

**Step 2.5 — (Alternative) Use staticcheck alone and save a report**

If you prefer not to use golangci-lint, install and run staticcheck:

```bash
go install honnef.co/go/tools/cmd/staticcheck@latest
staticcheck ./... 2>&1 | tee staticcheck-report.txt
```

- Output is shown in the terminal and saved to **`staticcheck-report.txt`** in the project root. Open the file to view the report.
- Fix any reported issues.

**Report files (summary)**

| File | Contents |
|------|----------|
| `vet-report.txt` | go vet output (file:line: message). |
| `lint-report.txt` | golangci-lint output (human-readable). |
| `lint-report.json` | golangci-lint output in JSON (optional). |
| `staticcheck-report.txt` | staticcheck output. |

All report files are created in the **project root**. Open them in a text editor or viewer to review the findings.

---

## 5. Step 3 — Document and tune

1. **Document** — Note which tools you used (go fmt, go vet, golangci-lint or staticcheck) and the commands you ran, so you or others can repeat the steps.
2. **Tune** — If the linter reports too many findings, edit `.golangci.yml` to disable specific linters or rules; then gradually re-enable rules as you fix issues.

---

## 6. Success criteria

| Criterion | Status |
|-----------|--------|
| Go project builds successfully (`go build` or `make build`). | ☐ |
| `go fmt ./...` runs and code is formatted (no unformatted files). | ☐ |
| `go vet ./...` runs and reports no issues. | ☐ |
| Optional: golangci-lint (or staticcheck) runs and reports no errors for configured rules. | ☐ |
| Process is documented (tools used, commands, config). | ☐ |

---

## 7. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 8. References

| Link | Description |
|------|-------------|
| [GoLang CI Checks — Static Code Analysis (main doc)](https://github.com/Snaatak-Saarthi/documentation/blob/SCRUM-180-mukesh/Applications/Understanding/Golang_CI_Checks/Static_Code_Analysis/README.md) | Main design document for Go static code analysis. |
| [go fmt](https://pkg.go.dev/cmd/gofmt) | Standard Go formatter. |
| [go vet](https://pkg.go.dev/cmd/vet) | Standard Go static analyzer. |
| [golangci-lint](https://golangci-lint.run/) | Aggregated linters for Go. |
| [staticcheck](https://staticcheck.io/) | Static analysis for Go. |

---