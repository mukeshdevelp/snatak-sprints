# Application CI Design | Python CI Checks (Attendance & Notification) | Unit Testing — POC

This document is the **POC (Proof of Concept)** for **Python CI checks and unit testing** for the **Attendance API** and **Notification Worker**: scope, prerequisites, step-by-step setup, and success criteria.

---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 26-02-2026 | v1.0 | Mukesh Sharma | 26-02-2026 |  |  |  |  |

---

## Table of Contents

1. [Scope and context](#1-scope-and-context)
2. [Prerequisites](#2-prerequisites)
3. [Step 1 — Attendance API: build, lint, and unit tests](#3-step-1--attendance-api-build-lint-and-unit-tests)
4. [Step 2 — Notification Worker: add tests and run in CI](#4-step-2--notification-worker-add-tests-and-run-in-ci)
5. [Step 3 — Integrate both into CI](#5-step-3--integrate-both-into-ci)
6. [Step 4 — Coverage and thresholds](#6-step-4--coverage-and-thresholds)
7. [Success criteria](#7-success-criteria)
8. [Contact Information](#8-contact-information)
9. [References](#9-references)

---

## 1. Scope and context

| Item | Description |
|------|-------------|
| **Attendance API** | Flask-based REST API; Poetry, pytest, pytest-cov, pytest-mock, pylint; tests in `router/`, `client/`, `models/`, `utils/`. |
| **Notification Worker** | Python service (SMTP, Elasticsearch); pip + requirements.txt; currently no test suite in repo—POC adds minimal unit tests. |
| **Repo locations** | `API/attendance-api`, `API/notification-worker`. |
| **POC goal** | Run unit tests for both applications in CI; optionally enforce coverage thresholds. |

---

## 2. Prerequisites

| Requirement | Description |
|-------------|-------------|
| **Python** | Python 3.11 for Attendance API (per pyproject.toml); Python 3.6+ for Notification Worker (per Dockerfile). |
| **Poetry** | For Attendance API dependency and test runs. |
| **pip** | For Notification Worker (`pip install -r requirements.txt`). |
| **CI system** | GitLab CI, Jenkins, or similar (one pipeline or two jobs for the POC). |

---

## 3. Step 1 — Attendance API: build, lint, and unit tests

1. Navigate to the Attendance API directory:
   ```bash
   cd API/attendance-api
   ```
2. Install dependencies:
   ```bash
   make build
   # or: poetry config virtualenvs.create false && poetry install --no-root --no-interaction --no-ansi
   ```
3. Run lint (pylint):
   ```bash
   make fmt
   # or: pylint router/ client/ models/ utils/ app.py
   ```
4. Run unit tests:
   ```bash
   python3 -m pytest
   ```
5. Run tests with coverage:
   ```bash
   python3 -m pytest --cov=.
   ```
6. Tests are located under `router/tests/`, `client/tests/`, `models/tests/`, `utils/tests/` (e.g. test_cache, test_postgres_conn, test_validator, test_log_encoder). Ensure all pass locally before adding to CI.

---

## 4. Step 2 — Notification Worker: add tests and run in CI

1. Navigate to the Notification Worker directory:
   ```bash
   cd API/notification-worker
   ```
2. Install dependencies:
   ```bash
   make build
   # or: pip3 install -r requirements.txt
   ```
3. Add a minimal test suite (POC):
   - Create a `tests/` directory and a `tests/test_notification.py` (or similar).
   - Write one or two unit tests that mock SMTP and Elasticsearch (e.g. test config loading, or a helper that builds the mail payload).
   - Use **pytest** (add `pytest` to `requirements.txt` or a dev-requirements file) or **unittest**.
4. Run tests locally:
   ```bash
   python3 -m pytest tests/ -v
   # or: python3 -m unittest discover -s tests
   ```
5. Document the test command so CI can run the same.

---

## 5. Step 3 — Integrate both into CI

1. **Attendance API job** (example GitLab CI):
   - Checkout repo; change to `API/attendance-api`.
   - Install: `poetry install --no-root` (or `make build`).
   - Lint: `make fmt` or `pylint router/ client/ models/ utils/ app.py`.
   - Test: `python3 -m pytest --cov=. --cov-report=xml` (or `--junitxml=report.xml` for JUnit).
   - Publish coverage and/or JUnit report as artifacts; fail the job if pytest exits non-zero.
2. **Notification Worker job**:
   - Checkout repo; change to `API/notification-worker`.
   - Install: `pip install -r requirements.txt` (and pytest if not in requirements).
   - Test: `python3 -m pytest tests/ -v` (or equivalent).
   - Fail the job if tests fail.
3. Run both jobs on every push or MR to the relevant paths.

---

## 6. Step 4 — Coverage and thresholds

1. For **Attendance API**, set a coverage threshold in CI (e.g. fail if coverage &lt; 70%). Example with pytest-cov:
   ```bash
   python3 -m pytest --cov=. --cov-fail-under=70
   ```
2. Optionally publish coverage to a dashboard (e.g. GitLab coverage parsing, or a coverage server).
3. For **Notification Worker**, coverage is optional in the POC; focus on tests passing. Add `--cov` and thresholds later if the test suite grows.

---

## 7. Success criteria

| Criterion | Status |
|-----------|--------|
| Attendance API: `make build` and `make fmt` succeed in CI. | ☐ |
| Attendance API: `python3 -m pytest --cov=.` runs and all tests pass. | ☐ |
| Attendance API: Coverage report (and optionally threshold) is enforced in CI. | ☐ |
| Notification Worker: Dependencies install in CI. | ☐ |
| Notification Worker: At least one unit test exists and runs in CI. | ☐ |
| Both applications’ test jobs are part of the same pipeline or project. | ☐ |
| Process is documented (commands, paths, thresholds). | ☐ |

---

## 8. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 9. References

| Link | Description |
|------|-------------|
| [Python CI Checks — Unit Testing (main doc)](../python-ci-checks-unit-testing.md) | Main design document for Python CI checks and unit testing. |
| [Attendance API README](../../../API/attendance-api/README.md) | Attendance API build, test, and run instructions. |
| [Notification Worker README](../../../API/notification-worker/README.md) | Notification Worker build and run instructions. |
| [pytest](https://docs.pytest.org/) | pytest — Python testing framework. |
| [pytest-cov](https://pytest-cov.readthedocs.io/) | pytest-cov — coverage plugin for pytest. |

---
