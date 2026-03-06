# Python CI Checks | Unit Testing — POC


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 26-02-2026 | v1.0 | Mukesh Sharma | 26-02-2026 |  |  |  |  |

---

## Table of Contents

1. [Scope and context](#1-scope-and-context)
2. [Prerequisites](#2-prerequisites)
3. [Step 1 — Python API: build, lint, and unit tests](#3-step-1--python-api-build-lint-and-unit-tests)
4. [Step 2 — Python worker: add tests and run locally](#4-step-2--python-worker-add-tests-and-run-locally)
5. [Step 3 — Run both projects locally](#5-step-3--run-both-projects-locally)
6. [Step 4 — Coverage and thresholds (local)](#6-step-4--coverage-and-thresholds-local)
7. [Benefits of Python CI unit testing](#7-benefits-of-python-ci-unit-testing)
8. [Contact Information](#8-contact-information)
9. [References](#9-references)

---

## 1. Scope and context

| Item | Description |
|------|-------------|
| **Python API** | Flask-based REST API; Poetry, pytest, pytest-cov, pytest-mock, pylint; tests in router, client, models, utils. |
| **Python worker** | Python service (e.g. SMTP, Elasticsearch); pip + requirements.txt; POC adds minimal unit tests if none exist. |
| **Repo locations** | Python API project directory (e.g. **~/python-api**); Python worker project directory (e.g. **~/python-worker**). |
| **Attendance API** | Flask-based REST API; Poetry, pytest, pytest-cov, pytest-mock, pylint; tests in `router/`, `client/`, `models/`, `utils/`. |
| **Notification Worker** | Python service (SMTP, Elasticsearch); pip + requirements.txt; currently no test suite in repo—POC adds minimal unit tests. |
| **Repo locations** | `API/attendance-api`, `API/notification-worker`. |
| **POC goal** | Run unit tests for both applications manually; optionally enforce coverage thresholds during local runs. |

---

## 2. Prerequisites

| Requirement | Description |
|-------------|-------------|
| **Python** | Python 3.11+ for the API (or per pyproject.toml); Python 3.6+ for the worker (or per Dockerfile/requirements). |
| **Poetry** | For the Python API dependency and test runs. |
| **pip** | For the Python worker (`pip install -r requirements.txt`). |

---

## 3. Step 1 — Python API: build, lint, and unit tests

1. Navigate to the Python API project directory:
   ```bash
   cd ~/python-api
   ```
2. Install dependencies:
   ```bash
   make build
   # or: poetry config virtualenvs.create false && poetry install --no-root --no-interaction --no-ansi
   ```
3. Run lint (e.g. pylint):
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
6. Tests are typically under `router/tests/`, `client/tests/`, `models/tests/`, `utils/tests/` (e.g. test_cache, test_postgres_conn, test_validator). Ensure all pass locally before sharing changes.

---

## 4. Step 2 — Python worker: add tests and run locally

1. Navigate to the Python worker project directory:
   ```bash
   cd ~/python-worker
   ```
2. Install dependencies:
   ```bash
   make build
   # or: pip3 install -r requirements.txt
   ```
3. Add a minimal test suite (POC):
   - Create a `tests/` directory and a `tests/test_*.py` (e.g. test config loading or a helper that builds the mail payload).
   - Mock SMTP and Elasticsearch (or other external services) in tests.
   - Use **pytest** (add `pytest` to `requirements.txt` or a dev-requirements file) or **unittest**.
4. Run tests locally:
   ```bash
   python3 -m pytest tests/ -v
   # or: python3 -m unittest discover -s tests
   ```
5. Optionally document the test command in the project README so others can run it.

---

## 5. Step 3 — Coverage and thresholds (manual)

1. For the **Python API**, you can measure coverage locally and enforce a threshold yourself:
   ```bash
   python3 -m pytest --cov=. --cov-fail-under=70
   ```
2. For the **Python worker**, start by ensuring tests pass; you can add `--cov` and thresholds later as the suite grows:
   ```bash
   python3 -m pytest --cov=.
   ```

---

## 7. Benefits of Python CI unit testing

| Benefit | Description |
|---------|-------------|
| **Early bug detection** | Fails the pipeline when unit tests break, catching regressions before they reach staging or production. |
| **Safer refactoring** | Gives confidence to refactor Python API and worker code because behaviour is locked in by tests. |
| **Better documentation** | Tests act as executable documentation for how functions, modules, and workers are expected to behave. |
| **Consistent quality across services** | Applies the same test standards to both the Python API and worker, reducing gaps between components. |
| **Measurable coverage** | Coverage thresholds highlight untested areas and provide an objective target for test quality over time. |

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
| [pytest](https://docs.pytest.org/) | pytest — Python testing framework. |
| [pytest-cov](https://pytest-cov.readthedocs.io/) | pytest-cov — coverage plugin for pytest. |
| [coverage.py](https://coverage.readthedocs.io/) | coverage.py — code coverage measurement. |

---
