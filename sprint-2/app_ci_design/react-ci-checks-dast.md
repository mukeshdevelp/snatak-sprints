# React CI Checks — DAST

This document describes **React CI checks** with focus on **DAST (Dynamic Application Security Testing)** in the context of the **API/frontend** application (OT-Microservices React frontend): introduction, what it is, why use it, workflow, tools, comparison, advantages, POC, best practices, and references.

---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 03-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  | aniruddh sir | faisal sir | ashwani sir |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [What](#2-what)
3. [Why](#3-why)
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

**React CI checks** are automated steps in a Continuous Integration pipeline that build, test, and scan React applications. **DAST (Dynamic Application Security Testing)** runs against a running instance of the app (e.g. after build or deploy) to find vulnerabilities such as XSS, injection, or misconfigurations. This document is written in the context of the **API/frontend** application—the React (react-scripts) frontend of the OT-Microservices stack that depends on Employee, Attendance, and Salary APIs. It describes what React CI checks and DAST are, why to use them, workflow, tools, comparison, advantages, a POC approach (see [POC document](poc/react-poc.md)), and best practices.

---

## 2. What

| Concept | Description |
|--------|-------------|
| **React CI checks** | Automated pipeline steps for a React app: lint, unit/test, build, and optional security scans (SAST/DAST). |
| **DAST** | Dynamic testing against a running application (e.g. dev server or deployed build) to detect runtime security issues (XSS, CSRF, insecure headers, exposed endpoints). |
| **In this context** | For **API/frontend**, CI runs `make build` (or `npm run build`), serves the `build/` output (e.g. `serve -s build` on port 3000), then runs DAST against the served URL so every commit or PR is checked before merge. |

---

## 3. Why

| Reason | Description |
|--------|-------------|
| **Early feedback** | Find security issues in CI instead of production. |
| **Compliance** | Support security and compliance requirements (e.g. OWASP, audit). |
| **Consistency** | Same checks on every pipeline run; no reliance on manual scans. |
| **Risk reduction** | Catch common web vulnerabilities (XSS, insecure config) before release. |

---

## 4. Workflow diagram

```
[Commit/PR] → [CI: install, lint, test] → [Build API/frontend (npm run build)] → [Serve build (serve -s build) or deploy to staging] → [DAST scan] → [Report / Pass/Fail] → [Merge or block]
```

For **API/frontend**, the build produces the `build/` directory; CI serves it (e.g. with `serve -s build` on port 3000) or deploys to a test URL. DAST runs against that URL; results are reported in CI (e.g. fail the job or create issues).

---

## 5. Different tools

| Tool / approach | Description |
|-----------------|-------------|
| **OWASP ZAP** | Open-source DAST; can run in CI (headless) against a URL; good for OWASP Top 10. |
| **npm audit / Snyk** | Dependency and (for Snyk) runtime-oriented checks; often used alongside DAST. |
| **Lighthouse (security)** | Can be run in CI to check security-related audits (e.g. HTTPS, best practices). |
| **Commercial DAST** | Tools like Burp Suite, Checkmarx, Veracode; often integrate via CLI or API in CI. |
| **Custom scripts** | Simple curl/scripts to check headers, CSP, or critical endpoints in CI. |

---

## 6. Comparison

| Criteria | OWASP ZAP | npm audit / Snyk | Lighthouse | Commercial DAST |
|----------|-----------|------------------|------------|-----------------|
| **Cost** | Free | Free / paid tiers | Free | Paid |
| **CI integration** | Yes (CLI, Docker) | Yes (CLI) | Yes (Node) | Varies (API/CLI) |
| **Scope** | Running app | Deps + optional app | Browser-style audits | Full DAST |
| **Setup effort** | Medium | Low | Low | Higher |
| **Depth** | Good for common vulns | Deps + some app | Best practices | Deep scans |

---

## 7. Advantages

| Advantage | Description |
|-----------|-------------|
| **Automation** | No manual security runs; every pipeline execution is scanned. |
| **Speed** | Quick feedback on obvious issues (e.g. missing headers, known vulns). |
| **Traceability** | Results in CI logs and reports; easier to track and fix. |
| **Culture** | Encourages secure defaults and fixes as part of normal development. |

---

## 8. POC

A dedicated **POC document** for React CI checks and DAST in the context of **API/frontend** is available at **[poc/react-poc.md](poc/react-poc.md)**. It covers:

1. **Scope** — API/frontend application and one CI system (e.g. GitLab CI or Jenkins).  
2. **Build and serve** — In CI, run `make build` (or `npm run build`) in the frontend directory, then serve the `build/` output (e.g. `serve -s build` on port 3000) or deploy to a test URL.  
3. **Run DAST** — Run OWASP ZAP (or chosen tool) against the served URL; define pass/fail rules.  
4. **Integrate** — Add the step to the pipeline; store or publish reports.  
5. **Iterate** — Tune scan depth and exclusions; add more checks if needed.

For the full step-by-step POC (prerequisites, commands, success criteria), see [react-poc.md](poc/react-poc.md).

---

## 9. Best practices

| Practice | Description |
|----------|-------------|
| **Run after deploy** | Run DAST against a real (or staging) deployment when possible. |
| **Baseline and tune** | Use baselines or exclusions to avoid repeated false positives; review and update. |
| **Fail meaningfully** | Fail the pipeline only on high/critical findings; use severity thresholds. |
| **Keep scans fast** | Limit scope or depth so CI remains fast (e.g. baseline scan in CI, full scan nightly). |
| **Combine with SAST/deps** | Use DAST with dependency and static checks for broader coverage. |

---

## 10. Recommendation / Conclusion

Use **React CI checks** for lint, test, and build of the **API/frontend** application; add **DAST** as a CI stage after the app is built and served (e.g. `serve -s build` or staging deployment). Start with **OWASP ZAP** or **npm audit/Snyk** for a low-cost POC (see [react-poc.md](poc/react-poc.md)); tune rules and scope to keep pipelines fast and actionable. Combine DAST with dependency and static analysis for a stronger security posture. Document which tools and thresholds are used so the team can maintain and extend the checks.

---

## 11. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 12. References

| Link | Description |
|------|-------------|
| [OWASP ZAP](https://www.zaproxy.org/) | OWASP ZAP — dynamic application security testing. |
| [OWASP Top 10](https://owasp.org/www-project-top-ten/) | OWASP Top Ten web risks. |
| [npm audit](https://docs.npmjs.com/cli/v8/commands/npm-audit) | npm audit for dependency vulnerabilities. |
| [Lighthouse](https://developer.chrome.com/docs/lighthouse/) | Lighthouse — performance and security audits. |
| [Snyk](https://snyk.io/) | Snyk — dependency and application security. |
| [React CI & DAST POC](poc/react-poc.md) | Step-by-step POC for API/frontend. |

---
