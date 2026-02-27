# Application CI Design | Python CI Checks (Attendance & Notification) | Unit Testing

This document describes **unit testing** as part of **Python CI checks** for the **Attendance API** and **Notification Worker** (OT-Microservices): introduction, what it is, why use it, workflow, tools, comparison, advantages, POC, best practices, and references.

---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 26-02-2026 | v1.0 | Mukesh Sharma | 26-02-2026 |  |  |  |  |

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

**Python CI checks** for the OT-Microservices stack include build, lint, and **unit testing** for Python-based services. This document focuses on **unit testing** in the context of the **Attendance API** (Flask, Poetry, PostgreSQL) and the **Notification Worker** (Python, SMTP, Elasticsearch). Unit tests verify that individual functions, modules, and components behave correctly in isolation (often with mocks for DB and external services). Running them in CI ensures every commit or PR is validated before merge. This document describes what unit testing means for these APIs, why to run it in CI, workflow, tools, comparison, advantages, a POC (see [python-ci-checks-unit-testing-poc.md](poc/python-ci-checks-unit-testing-poc.md)), and best practices.

---

## 2. What

| Concept | Description |
|--------|-------------|
| **Unit testing** | Automated tests that exercise small units of code (functions, classes, modules) in isolation, typically with mocks for databases, APIs, and I/O. |
| **Attendance API** | Flask-based REST API; uses **Poetry**, **pytest**, **pytest-cov**, **pytest-mock**; tests in `router/`, `client/`, `models/`, `utils/` (e.g. validators, cache, encoders, DB client). Run with `python3 -m pytest` or `pytest --cov=.`. |
| **Notification Worker** | Python script (SMTP, Elasticsearch); uses **pip** and **requirements.txt**. Unit tests can be added with **pytest** or **unittest** for logic (e.g. config parsing, mail payload, ES query building) with mocks for SMTP and ES. |
| **In CI** | Unit tests run in the pipeline after install (e.g. `poetry install` or `pip install -r requirements.txt`) and before or after build; CI fails if tests fail or coverage drops below a threshold. |

---

## 3. Why

| Reason | Description |
|--------|-------------|
| **Regression prevention** | Catch breakages as soon as code changes; avoid shipping bugs to production. |
| **Confidence** | Refactoring and new features are safer when a test suite exists. |
| **Documentation** | Tests describe expected behaviour of the Attendance API and Notification Worker. |
| **CI gate** | Block merge when tests fail or coverage is too low; keep main branch stable. |

---

## 4. Workflow diagram

```
[Commit/PR] → [CI: checkout] → [Install deps (Poetry / pip)] → [Lint (e.g. pylint)] → [Run unit tests (pytest)] → [Coverage report] → [Pass/Fail] → [Merge or block]
```

For **Attendance API**: `make build` (or `poetry install`), then `make fmt` (pylint), then `python3 -m pytest --cov=.`. For **Notification Worker**: `pip install -r requirements.txt`, then run pytest (once tests are added). CI publishes test and coverage results.

---

## 5. Different tools

| Tool | Description |
|------|-------------|
| **pytest** | De facto standard for Python unit tests; used by Attendance API; supports fixtures, parametrization, and plugins (e.g. pytest-cov, pytest-mock). |
| **unittest** | Standard library; used in some Attendance API tests (e.g. client tests with `unittest.mock`); good for minimal-dependency setups. |
| **pytest-cov** | Coverage plugin for pytest; used in Attendance API (`pytest --cov=.`); integrates with CI for coverage reports. |
| **pytest-mock** | Thin wrapper around mock for pytest; used in Attendance API for patching and assertions. |
| **pylint** | Linter; used in Attendance API (`make fmt`); improves code quality alongside tests. |
| **coverage.py** | Standalone or via pytest-cov; measures line/branch coverage; useful for Notification Worker if tests are added. |

---

## 6. Comparison

| Criteria | pytest | unittest | pylint |
|----------|---------|----------|--------|
| **Standard** | Third-party | Stdlib | Third-party |
| **Attendance API** | Yes (primary) | Used in some client tests | Yes (make fmt) |
| **Notification Worker** | Recommended if adding tests | Alternative | Optional |
| **Fixtures / plugins** | Rich (pytest-cov, pytest-mock) | Basic | N/A (lint only) |
| **CI integration** | Easy (exit code, XML/HTML reports) | Easy | Easy |

---

## 7. Advantages

| Advantage | Description |
|-----------|-------------|
| **Fast feedback** | Unit tests run quickly; developers get results in minutes in CI. |
| **Isolation** | Mocks for DB and external services (PostgreSQL, Redis, SMTP, Elasticsearch) keep tests stable and fast. |
| **Coverage visibility** | pytest-cov and coverage reports show which code is exercised; helps prioritise tests. |
| **Consistency** | Same test commands for Attendance API and (once added) Notification Worker in CI. |

---

## 8. POC

A dedicated **POC document** for Python CI checks and unit testing (Attendance API and Notification Worker) is available at **[poc/python-ci-checks-unit-testing-poc.md](poc/python-ci-checks-unit-testing-poc.md)**. It covers:

1. **Scope** — Attendance API and Notification Worker; one CI system (e.g. GitLab CI or Jenkins).  
2. **Attendance API** — Run `make build`, `make fmt`, `python3 -m pytest --cov=.` in CI; collect coverage and fail on test failure or low coverage.  
3. **Notification Worker** — Add a minimal pytest (or unittest) suite for core logic; run in CI after `pip install -r requirements.txt`.  
4. **Integrate** — Add test jobs to the pipeline; publish JUnit/coverage artifacts.  
5. **Iterate** — Add tests for critical paths; set coverage thresholds.

For the full step-by-step POC, see [python-ci-checks-unit-testing-poc.md](poc/python-ci-checks-unit-testing-poc.md).

---

## 9. Best practices

| Practice | Description |
|----------|-------------|
| **Run tests on every commit/PR** | Include unit tests in the same pipeline that builds the Attendance API and Notification Worker. |
| **Use mocks for I/O** | Mock PostgreSQL, Redis, SMTP, Elasticsearch in unit tests so tests are fast and not environment-dependent. |
| **Set coverage thresholds** | Fail CI when coverage drops below a defined percentage (e.g. 70–80%); raise over time. |
| **Keep tests fast** | Avoid real DB or network calls in unit tests; use fixtures and mocks. |
| **Name and structure clearly** | Place tests next to code (e.g. `tests/` under each package) or in a top-level `tests/`; name test files `test_*.py`. |

---

## 10. Recommendation / Conclusion

Use **unit testing** as a standard part of **Python CI checks** for both the **Attendance API** and **Notification Worker**. The Attendance API already uses **pytest**, **pytest-cov**, and **pylint**; run these in CI and enforce coverage thresholds. For the Notification Worker, add a small **pytest** (or unittest) suite for core logic and run it in CI (see [python-ci-checks-unit-testing-poc.md](poc/python-ci-checks-unit-testing-poc.md)). Document test commands and coverage thresholds so the team can maintain and extend the checks.

---

## 11. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 12. References

| Link | Description |
|------|-------------|
| [pytest](https://docs.pytest.org/) | pytest — Python testing framework. |
| [pytest-cov](https://pytest-cov.readthedocs.io/) | pytest-cov — coverage plugin for pytest. |
| [Attendance API README](../../../API/attendance-api/README.md) | Attendance API build, test, and run instructions. |
| [Notification Worker README](../../../API/notification-worker/README.md) | Notification Worker build and run instructions. |
| [Python CI & Unit Testing POC](poc/python-ci-checks-unit-testing-poc.md) | Step-by-step POC for Attendance API and Notification Worker. |

---
