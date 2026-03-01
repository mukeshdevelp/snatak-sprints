# React CI Checks — DAST

This document describes **React CI checks** and **DAST (Dynamic Application Security Testing)** for the frontend application: the React (react-scripts) UI of the OT-Microservices stack that depends on Employee, Attendance, and Salary APIs. The frontend is located at **~/frontend**. It covers what React CI checks and DAST are, why to use them, workflow, tools, comparison, advantages, POC, best practices, and references.

---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 03-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  | aniruddh sir | faisal sir | ashwani sir |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [What is React CI checks and DAST](#2-what-is-react-ci-checks-and-dast)
3. [Why use React CI checks and DAST for the frontend](#3-why-use-react-ci-checks-and-dast-for-the-frontend)
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

The frontend application is located at **~/frontend** and is the main React (react-scripts) UI of the OT-Microservices stack. It depends on the Employee, Attendance, and Salary REST APIs and is built with `make build` (or `npm run build`), producing a `build/` directory served on port 3000 (e.g. `serve -s build` or via Docker). **React CI checks** are automated pipeline steps that build, test, and scan this frontend. **DAST (Dynamic Application Security Testing)** runs against a running instance of the app (after build or deploy) to find vulnerabilities such as XSS, injection, or misconfigurations. This document describes what React CI checks and DAST are for the frontend, why to use them, workflow, tools, comparison, advantages, a POC (see [poc/react-poc.md](poc/react-poc.md)), and best practices.

---

## 2. What is React CI checks and DAST

| Concept | Description |
|--------|-------------|
| **Frontend** | React application in **~/frontend**; uses npm, react-scripts; build output in `build/`; served on port 3000; calls Employee, Attendance, and Salary APIs via relative paths (e.g. `/employee/`, `/attendance/`, `/salary/`) when behind a reverse proxy. |
| **React CI checks** | Automated pipeline steps for the frontend: install (`npm install`), lint (if configured), test (`npm run test`), build (`make build` or `npm run build`), and optional security scans (SAST/DAST). |
| **DAST** | Dynamic testing against the running frontend (e.g. after `serve -s build` on port 3000 or a staging URL) to detect runtime security issues (XSS, CSRF, insecure headers, exposed endpoints). |
| **In this document** | All steps and tools are described in the context of the frontend repo: directory **~/frontend**, commands `make build`, `npm run build`, `serve -s build`, port 3000, and the [POC](poc/react-poc.md) for integrating CI and DAST. |

---

## 3. Why use React CI checks and DAST for the frontend

| Reason | Description |
|--------|-------------|
| **Early feedback** | Find security issues in CI before the frontend is deployed to production. |
| **Compliance** | Support security and compliance requirements (e.g. OWASP, audit) for the frontend and its integration with the backend APIs. |
| **Consistency** | Same checks on every pipeline run for the frontend; no reliance on manual scans. |
| **Risk reduction** | Catch common web vulnerabilities (XSS, insecure config, missing headers) in the frontend before release. |

---

## 4. Workflow diagram

For the frontend at **~/frontend**, the CI and DAST workflow is:

```
[Commit/PR to ~/frontend] → [CI: npm install, lint, test] → [make build / npm run build] → [Serve build (serve -s build :3000) or deploy to staging] → [DAST scan against URL] → [Report / Pass/Fail] → [Merge or block]
```

The build produces the `build/` directory in ~/frontend. CI serves it (e.g. `npx serve -s build -l 3000`) or deploys to a test URL. DAST runs against that URL; results are reported in CI (e.g. fail the job or create issues). In production, the frontend is typically behind a reverse proxy that routes `/employee/`, `/attendance/`, and `/salary/` to the respective backend APIs.

---

## 5. Different tools

| Tool / approach | Description (for ~/frontend) |
|-----------------|------------------------------|
| **OWASP ZAP** | Open-source DAST; run in CI (headless/Docker) against the served frontend URL (e.g. http://localhost:3000); good for OWASP Top 10. |
| **npm audit / Snyk** | Dependency checks for the frontend (package.json in ~/frontend); often used alongside DAST in the same pipeline. |
| **Lighthouse (security)** | Run in CI to check security-related audits (e.g. HTTPS, best practices) for the frontend. |
| **Commercial DAST** | Tools like Burp Suite, Checkmarx, Veracode; integrate via CLI or API in CI against the frontend URL. |
| **Custom scripts** | Curl or scripts to check headers, CSP, or critical routes (e.g. /, /employee-list) for the built frontend. |

---

## 6. Comparison

| Criteria | OWASP ZAP | npm audit / Snyk | Lighthouse | Commercial DAST |
|----------|-----------|------------------|------------|-----------------|
| **Cost** | Free | Free / paid tiers | Free | Paid |
| **CI integration** | Yes (CLI, Docker) | Yes (CLI in ~/frontend) | Yes (Node) | Varies (API/CLI) |
| **Scope** | Running frontend build | Frontend dependencies | Browser-style audits | Full DAST |
| **Setup effort** | Medium | Low | Low | Higher |
| **Depth** | Good for common vulns | Deps + some app | Best practices | Deep scans |

---

## 7. Advantages

| Advantage | Description |
|-----------|-------------|
| **Automation** | No manual security runs; every frontend pipeline execution is scanned. |
| **Speed** | Quick feedback on obvious issues (e.g. missing headers, known vulns) before merge. |
| **Traceability** | Results in CI logs and reports; easier to track and fix for the frontend team. |
| **Culture** | Encourages secure defaults and fixes as part of normal frontend development. |

---

## 8. POC

A dedicated **POC document** for React CI checks and DAST for the frontend is available at **[poc/react-poc.md](poc/react-poc.md)**. It covers:

1. **Scope** — Frontend application at **~/frontend** and one CI system (e.g. GitLab CI or Jenkins).  
2. **Build and serve** — In CI, run `make build` (or `npm install && npm run build`) in ~/frontend, then serve the `build/` output with `serve -s build` on port 3000 or deploy to a test URL.  
3. **Run DAST** — Run OWASP ZAP (or chosen tool) against the served URL; define pass/fail rules.  
4. **Integrate** — Add the step to the pipeline; store or publish reports.  
5. **Iterate** — Tune scan depth and exclusions; add more checks if needed.

For the full step-by-step POC (prerequisites, commands, success criteria), see [react-poc.md](poc/react-poc.md).

---

## 9. Best practices

| Practice | Description |
|----------|-------------|
| **Run after build/serve** | Run DAST against the built frontend (e.g. `serve -s build` from ~/frontend) or a staging deployment. |
| **Baseline and tune** | Use baselines or exclusions to avoid repeated false positives; review and update. |
| **Fail meaningfully** | Fail the pipeline only on high/critical findings; use severity thresholds. |
| **Keep scans fast** | Limit scope or depth so CI remains fast (e.g. baseline scan in CI, full scan nightly). |
| **Combine with SAST/deps** | Use DAST with `npm audit` (or Snyk) and static checks for broader coverage of the frontend. |

---

## 10. Recommendation / Conclusion

Use **React CI checks** for install, lint, test, and build of the frontend application at **~/frontend**; add **DAST** as a CI stage after the app is built and served (e.g. `serve -s build` on port 3000 or staging deployment). Start with **OWASP ZAP** or **npm audit/Snyk** for a low-cost POC (see [react-poc.md](poc/react-poc.md)); tune rules and scope to keep pipelines fast and actionable. Combine DAST with dependency and static analysis for a stronger security posture. Document which tools and thresholds are used for the frontend so the team can maintain and extend the checks.

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
| [React CI & DAST POC](poc/react-poc.md) | Step-by-step POC for the frontend (~/frontend). |

---
