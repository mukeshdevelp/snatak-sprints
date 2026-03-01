# React CI Checks & DAST — POC (Proof of Concept)

This document is the **POC (Proof of Concept)** for **React CI checks and DAST** for the frontend application located at **~/frontend** (OT-Microservices React frontend): scope, prerequisites, step-by-step setup, and success criteria.

---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 26-02-2026 | v1.0 | Mukesh Sharma | 26-02-2026 |  |  |  |  |

---

## Table of Contents

1. [Scope and context](#1-scope-and-context)
2. [Prerequisites](#2-prerequisites)
3. [Step 1 — Build and run the frontend](#3-step-1--build-and-run-the-frontend)
4. [Step 2 — Add CI pipeline (lint, test, build)](#4-step-2--add-ci-pipeline-lint-test-build)
5. [Step 3 — Serve the build and run DAST](#5-step-3--serve-the-build-and-run-dast)
6. [Step 4 — Integrate and tune](#6-step-4--integrate-and-tune)
7. [Success criteria](#7-success-criteria)
8. [Contact Information](#8-contact-information)
9. [References](#9-references)

---

## 1. Scope and context

| Item | Description |
|------|-------------|
| **Application** | Frontend — React (react-scripts) frontend for OT-Microservices; depends on Employee, Attendance, and Salary APIs. |
| **Repo location** | **~/frontend** (frontend application directory). |
| **Build** | `npm install`, `npm run build` (or `make build`); output in `build/`. |
| **Run** | `serve -s build` on port 3000 (or `npm run start` for dev). |
| **POC goal** | Add React CI checks (lint, test, build) and DAST scan in CI, using the frontend as the target. |

---

## 2. Prerequisites

| Requirement | Description |
|-------------|-------------|
| **Node.js and npm** | Node 16+ (per frontend Dockerfile); npm for install and build. |
| **Frontend repo** | Clone or use the existing **~/frontend** directory; ensure `package.json` and `Makefile` are present. |
| **CI system** | GitLab CI, Jenkins, or similar (one pipeline for the POC). |
| **DAST tool** | OWASP ZAP (Docker or CLI) or npm audit/Snyk for dependency checks; ZAP for dynamic scan of the running app. |

---

## 3. Step 1 — Build and run the frontend

1. Navigate to the frontend directory:
   ```bash
   cd ~/frontend
   ```
2. Install dependencies and build:
   ```bash
   make build
   # or: npm install && npm run build
   ```
3. Serve the production build locally to verify:
   ```bash
   npx serve -s build -l 3000
   ```
   Or use the Docker image:
   ```bash
   make docker-build
   make docker-run
   ```
4. Confirm the app loads at `http://localhost:3000`. The frontend uses relative paths (`/employee/`, `/attendance/`, `/salary/`) that in production are routed via a reverse proxy to the backend APIs; for DAST you can scan the static UI first or run against a full stack (frontend + proxy + APIs).

---

## 4. Step 2 — Add CI pipeline (lint, test, build)

1. In your CI config (e.g. `.gitlab-ci.yml` or Jenkinsfile), add a job that:
   - Checks out the repo (or the frontend at **~/frontend**).
   - Runs `npm ci` or `npm install` in ~/frontend.
   - Runs lint (if configured, e.g. `npm run lint` or ESLint).
   - Runs tests: `npm run test -- --watchAll=false` (or equivalent for react-scripts).
   - Runs `npm run build` and stores the `build/` artifact.
2. Ensure the job passes so that the build artifact is available for the DAST step.

---

## 5. Step 3 — Serve the build and run DAST

1. In CI, after the build job, add a DAST job that:
   - Uses the `build/` artifact from the previous job.
   - Starts a static server serving `build/` (e.g. `npx serve -s build -l 3000` in background, or a small Docker image with `serve`).
   - Waits for the server to be ready (e.g. curl to `http://localhost:3000`).
   - Runs OWASP ZAP (e.g. Docker image `owasp/zap2docker-stable`) in baseline or quick scan mode against `http://host:3000`.
   - Parses the ZAP report and fails the job on high/critical findings (or uploads the report as an artifact).
2. Example (conceptual) for a GitLab CI DAST stage:
   - Start `serve -s build -l 3000`.
   - Run: `docker run --network host -i owasp/zap2docker-stable zap-baseline.py -t http://localhost:3000 -r zap_report.html`.
   - Publish `zap_report.html` as an artifact; optionally fail on exit code.
3. Alternatively, run `npm audit` (or Snyk) in the same pipeline for dependency vulnerabilities alongside DAST.

---

## 6. Step 4 — Integrate and tune

1. **Thresholds** — Configure the pipeline to fail only on high/critical DAST findings; document the threshold in the main design doc ([React CI checks — DAST](../react-ci-checks-dast.md)).
2. **Baseline** — If ZAP reports false positives (e.g. on static assets), use ZAP baseline or exclusions so the POC pipeline stays green for known-good state.
3. **Docs** — Document in this file or in the CI config: frontend path (**~/frontend**), build command (`make build` / `npm run build`), serve command (`serve -s build`), and DAST command/options.
4. **Optional** — If the frontend is deployed to a staging URL, run DAST against that URL instead of a CI-internal server for closer-to-production coverage.

---

## 7. Success criteria

| Criterion | Status |
|-----------|--------|
| Frontend at ~/frontend builds successfully in CI (`make build` or `npm run build`). | ☐ |
| Lint and test jobs run and pass (if configured). | ☐ |
| Build artifact is available to the DAST job. | ☐ |
| DAST (e.g. OWASP ZAP) runs against the served frontend and produces a report. | ☐ |
| Pipeline fails or warns on high/critical findings (per threshold). | ☐ |
| Process is documented (path, commands, thresholds). | ☐ |

---

## 8. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 9. References

| Link | Description |
|------|-------------|
| [React CI checks — DAST](../react-ci-checks-dast.md) | Main design document for React CI checks and DAST (frontend at ~/frontend). |
| [OWASP ZAP](https://www.zaproxy.org/) | OWASP ZAP — dynamic application security testing. |
| [npm audit](https://docs.npmjs.com/cli/v8/commands/npm-audit) | npm audit for dependency vulnerabilities. |

---
