# Python CI Checks | Unit Testing Documentation



---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 26-02-2026 | v1.0 | Mukesh Sharma | 26-02-2026 |  |  |  |  |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [What is unit testing for Python](#2-what-is-unit-testing-for-python)
3. [Why use unit testing for Python](#3-why-use-unit-testing-for-python)
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

**Python CI checks** for the microservices stack include build, lint, and **unit testing** for Python-based services. This document focuses on **unit testing** in the context of Python applications such as a **Flask-based REST API** (e.g. Poetry, pytest, PostgreSQL) and a **Python worker** (e.g. SMTP, Elasticsearch). Unit tests verify that individual functions, modules, and components behave correctly in isolation (often with mocks for DB and external services). Running them in CI ensures every commit or PR is validated before merge. This document describes what unit testing means for Python applications, why to run it in CI, workflow, tools, comparison, advantages, a POC (see [poc/python-ci-checks-unit-testing-poc.md](poc/python-ci-checks-unit-testing-poc.md)), and best practices.

---

## 2. What is unit testing for Python

**What** — **Unit testing** is automated testing of small units of code (functions, classes, modules) in isolation, typically with mocks for databases, APIs, and I/O. In the context of **Python** applications:

| Concept | Description |
|--------|-------------|
| **Unit testing** | Automated tests that exercise small units of code (functions, classes, modules) in isolation, typically with mocks for databases, APIs, and I/O. |
| **In Python** | Uses frameworks such as **pytest** or **unittest**; often with **pytest-cov** for coverage and **pytest-mock** (or **unittest.mock**) for patching. |
| **Python context** | A Python project (e.g. Flask API with router, client, models, utils; or a worker with config, mail, and ES logic). Tests run after install (Poetry or pip); CI fails if tests fail or coverage drops below a threshold. |

---

## 3. Why use unit testing for Python

**Why** — Teams use unit testing for Python applications for the following reasons:

| Reason | Description |
|--------|-------------|
| **Regression prevention** | Catch breakages as soon as code changes; avoid shipping bugs to production. |
| **Confidence** | Refactoring and new features are safer when a test suite exists. |
| **Documentation** | Tests describe expected behaviour of the Python service. |
| **CI gate** | Block merge when tests fail or coverage is too low; keep main branch stable. |

---

## 4. Workflow diagram

```
[Commit/PR] → [CI: checkout] → [Install deps (Poetry / pip)] → [Lint (e.g. pylint)] → [Run unit tests (pytest)] → [Coverage report] → [Pass/Fail] → [Merge or block]
```

For a **Python API** (e.g. Flask, Poetry): `make build` (or `poetry install`), then `make fmt` (pylint), then `python3 -m pytest --cov=.`. For a **Python worker**: `pip install -r requirements.txt`, then run pytest (once tests are added). CI publishes test and coverage results and fails the job if tests fail or coverage is below threshold.

---

## 5. Different tools

| Tool | Description |
|------|-------------|
| **pytest** | De facto standard for Python unit tests; supports fixtures, parametrization, and plugins (e.g. pytest-cov, pytest-mock). |
| **unittest** | Standard library; good for minimal-dependency setups; use with `unittest.mock` for patching. |
| **pytest-cov** | Coverage plugin for pytest; integrates with CI for coverage reports (`pytest --cov=.`). |
| **pytest-mock** | Thin wrapper around mock for pytest; convenient for patching and assertions. |
| **pylint** | Linter; improves code quality alongside tests (e.g. `make fmt`). |
| **coverage.py** | Standalone or via pytest-cov; measures line/branch coverage. |

---

## 6. Comparison

| Criteria | pytest | unittest | pylint |
|----------|---------|----------|--------|
| **Standard** | Third-party | Stdlib | Third-party |
| **Use case** | Primary for most Python projects | Alternative, minimal deps | Lint only |
| **Fixtures / plugins** | Rich (pytest-cov, pytest-mock) | Basic | N/A (lint only) |
| **CI integration** | Easy (exit code, XML/HTML reports) | Easy | Easy |

---

## 7. Advantages

| Advantage | Description |
|-----------|-------------|
| **Fast feedback** | Unit tests run quickly; developers get results in minutes in CI. |
| **Isolation** | Mocks for DB and external services (e.g. PostgreSQL, Redis, SMTP, Elasticsearch) keep tests stable and fast. |
| **Coverage visibility** | pytest-cov and coverage reports show which code is exercised; helps prioritise tests. |
| **Consistency** | Same test commands across Python services in CI. |

---

## 8. POC

A dedicated **POC document** for Python CI checks and unit testing is available at **[poc/python-ci-checks-unit-testing-poc.md](poc/python-ci-checks-unit-testing-poc.md)**. It covers:

1. **Scope** — Two Python applications (e.g. a Flask API and a Python worker); one CI system (e.g. GitLab CI or Jenkins).  
2. **Python API** — Run `make build`, `make fmt`, `python3 -m pytest --cov=.` in CI; collect coverage and fail on test failure or low coverage.  
3. **Python worker** — Add a minimal pytest (or unittest) suite for core logic; run in CI after `pip install -r requirements.txt`.  
4. **Integrate** — Add test jobs to the pipeline; publish JUnit/coverage artifacts.  
5. **Iterate** — Add tests for critical paths; set coverage thresholds.

For the full step-by-step POC (prerequisites, commands, success criteria), see [python-ci-checks-unit-testing-poc.md](poc/python-ci-checks-unit-testing-poc.md).

---

## 9. Best practices

| Practice | Description |
|----------|-------------|
| **Run tests on every commit/PR** | Include unit tests in the same pipeline that builds the Python application(s). |
| **Use mocks for I/O** | Mock databases, caches, and external services in unit tests so tests are fast and not environment-dependent. |
| **Set coverage thresholds** | Fail CI when coverage drops below a defined percentage (e.g. 70–80%); raise over time. |
| **Keep tests fast** | Avoid real DB or network calls in unit tests; use fixtures and mocks. |
| **Name and structure clearly** | Place tests in `tests/` or next to code; name test files `test_*.py`. |

---

## 10. Recommendation / Conclusion

Use **unit testing** as a standard part of **Python CI checks** for all Python services. Use **pytest**, **pytest-cov**, and optionally **pylint** in CI; enforce coverage thresholds. For services without tests, add a small **pytest** (or unittest) suite for core logic and run it in CI (see [python-ci-checks-unit-testing-poc.md](poc/python-ci-checks-unit-testing-poc.md)). Document test commands and coverage thresholds so the team can maintain and extend the checks.

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
| [coverage.py](https://coverage.readthedocs.io/) | coverage.py — code coverage measurement. |
| [Python CI & Unit Testing POC](poc/python-ci-checks-unit-testing-poc.md) | Step-by-step POC for Python CI checks and unit testing. |

---
