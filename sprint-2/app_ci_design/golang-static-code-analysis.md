# GoLang CI Checks | Static Code Analysis Documentation



---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 26-02-2026 | v1.0 | Mukesh Sharma | 26-02-2026 |  | aniruddh sir | faisal sir | ashwani sir |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [What is static code analysis for Go](#2-what-is-static-code-analysis-for-go)
3. [Why use static code analysis for Go](#3-why-use-static-code-analysis-for-go)
4. [Workflow diagram](#4-workflow-diagram)
5. [Different tools](#5-different-tools)
6. [Comparison](#6-comparison)
7. [Advantages](#7-advantages)
8. [POC](#8-poc)
9. [Best practices](#9-best-practices)
10. [Recommendation / Conclusion](#10-recommendation--conclusion)
11. [Contact Information](#11-contact-information)
12. [References](#12-references)

---

## 1. Introduction

**Static code analysis** in Go CI checks source code for bugs, style issues, and potential vulnerabilities without running the program. For a **Go** application (e.g. a REST service built with `go build`, `make build`), this typically includes **go fmt**, **go vet**, and linters such as **golangci-lint** or **staticcheck** run as part of the CI pipeline. This document describes what static code analysis is for Go, why to use it, workflow, tools, comparison, advantages, a POC (see [golang-static-code-ananlysis-poc.md](https://github.com/Snaatak-Saarthi/documentation/blob/SCRUM-180-mukesh/Applications/Understanding/Golang_CI_Checks/Static_Code_Analysis/POC/README.md)), and best practices.

---

## 2. What is static code analysis for Go

**What** — **Static code analysis** examines source code for defects, style violations, and security issues at build time. In the context of a **Go** application:

| Concept | Description |
|--------|-------------|
| **Static code analysis** | Automated analysis of source code (syntax, style, correctness, security) without executing the program. |
| **In Go** | Uses standard tools (`go fmt`, `go vet`) and/or linters (golangci-lint, staticcheck, errcheck) that understand Go code. |
| **Go context** | A Go project (e.g. modules under api, client, config, middleware, routes); analysis runs on `.go` files as part of CI (e.g. after checkout, before or with `go build`). |

---

## 3. Why use static code analysis for Go

**Why** — Teams use static code analysis for Go applications for the following reasons:

| Reason | Description |
|--------|-------------|
| **Quality** | Catch bugs, dead code, and common mistakes before they reach production. |
| **Consistency** | Enforce formatting and style (e.g. `go fmt`) so the codebase stays consistent. |
| **Security** | Some linters detect suspicious patterns or hardcoded secrets. |
| **CI gate** | Fail the pipeline when analysis finds issues; block merge until fixed. |

---

## 4. Workflow diagram

```
[Commit/PR] → [CI: checkout] → [go fmt / go vet] → [Linter (e.g. golangci-lint)] → [Report / Pass/Fail] → [go build, go test] → [Merge or block]
```

Static analysis runs as a CI step (often before or alongside `go build` and `go test`). The pipeline fails if formatting is wrong, `go vet` reports issues, or the linter finds violations above the configured severity.

---

## 5. Different tools

| Tool | Description |
|------|-------------|
| **go fmt** | Standard Go formatter; enforces canonical formatting. Often run via `make fmt` or `go fmt ./...`. |
| **go vet** | Standard Go static analyzer; catches suspicious constructs (e.g. unreachable code, wrong printf args). |
| **golangci-lint** | Aggregator of many Go linters (vet, staticcheck, errcheck, ineffassign, etc.); configurable via `.golangci.yml`. |
| **staticcheck** | Standalone linter with many checks; can be run directly or via golangci-lint. |
| **errcheck** | Ensures errors are checked; often included in golangci-lint. |
| **revive** | Fast, configurable linter alternative to golint. |

---

## 6. Comparison

| Criteria | go fmt / go vet | golangci-lint | staticcheck | revive |
|----------|-----------------|---------------|-------------|--------|
| **Cost** | Free (stdlib) | Free | Free | Free |
| **Setup** | None | Install binary, optional config | Install binary | Install binary |
| **CI integration** | Yes | Yes (single binary, many linters) | Yes | Yes |
| **Customization** | Limited | High (enable/disable linters, rules) | Medium | High |
| **Go fit** | Built-in | De facto standard for Go CI | Strong for correctness | Style/opinionated |

---

## 7. Advantages

| Advantage | Description |
|-----------|-------------|
| **Fast feedback** | Issues are reported in CI within minutes. |
| **No runtime** | Analysis does not require running the Go application. |
| **Wide adoption** | `go fmt` and `go vet` are standard; golangci-lint is widely used in Go projects. |
| **Configurable** | golangci-lint and others allow enabling/disabling linters and rules per project. |

---

## 8. POC

A dedicated **POC document** for Go static code analysis is available at **[golang-static-code-ananlysis-poc.md](https://github.com/Snaatak-Saarthi/documentation/blob/SCRUM-180-mukesh/Applications/Understanding/Golang_CI_Checks/Static_Code_Analysis/POC/README.md)**. It covers:

1. **Scope** — A Go project (e.g. REST service); one CI system (e.g. Jenkins or GitLab CI).  
2. **Add analysis** — Run `go fmt`, `go vet`, and optionally **golangci-lint** (or staticcheck) in CI.  
3. **Configure** — Use a `.golangci.yml` (or equivalent) to enable/disable linters and set severity.  
4. **Run in CI** — Add the step to the pipeline; fail the job when formatting or lint fails.  
5. **Iterate** — Fix reported issues; tune linter config to reduce false positives.

For the full step-by-step POC (prerequisites, commands, success criteria), see [golang-static-code-ananlysis-poc.md](https://github.com/Snaatak-Saarthi/documentation/blob/SCRUM-180-mukesh/Applications/Understanding/Golang_CI_Checks/Static_Code_Analysis/POC/README.md).

---

## 9. Best practices

| Practice | Description |
|----------|-------------|
| **Run on every commit/PR** | Include `go fmt`, `go vet`, and linter in the same pipeline that builds and tests the Go application. |
| **Format first** | Run `go fmt` (or `make fmt`) so the codebase is formatted before other checks. |
| **Use a config file** | For golangci-lint, use `.golangci.yml` so the same rules run locally and in CI. |
| **Fail on issues** | Configure the pipeline to fail when vet or linter reports errors (or high-severity findings). |
| **Combine with tests** | Run static analysis alongside `go test` for broader CI coverage. |

---

## 10. Recommendation / Conclusion

Use **static code analysis** as a standard step in **Go CI checks**. Run **go fmt** and **go vet** on every build; add **golangci-lint** (or staticcheck) for deeper analysis. Configure linters via `.golangci.yml` and fail the pipeline when issues are found. Document which tools and rules are used so the team can run the same checks locally. See the [golang-static-code-ananlysis-poc.md](https://github.com/Snaatak-Saarthi/documentation/blob/SCRUM-180-mukesh/Applications/Understanding/Golang_CI_Checks/Static_Code_Analysis/POC/README.md) for a step-by-step setup.

---

## 11. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 12. References

| Link | Description |
|------|-------------|
| [go fmt](https://pkg.go.dev/cmd/gofmt) | Standard Go formatter. |
| [go vet](https://pkg.go.dev/cmd/vet) | Standard Go static analyzer. |
| [golangci-lint](https://golangci-lint.run/) | Aggregated linters for Go. |
| [staticcheck](https://staticcheck.io/) | Static analysis for Go. |
| [golang-static-code-ananlysis-poc.md](https://github.com/Snaatak-Saarthi/documentation/blob/SCRUM-180-mukesh/Applications/Understanding/Golang_CI_Checks/Static_Code_Analysis/POC/README.md) | Step-by-step POC for Go static analysis. |

---