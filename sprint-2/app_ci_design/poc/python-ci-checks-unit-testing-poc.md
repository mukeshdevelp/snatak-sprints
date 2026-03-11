# Python CI Checks | Unit Testing — POC


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 26-02-2026 | v1.0 | Mukesh Sharma | 26-02-2026 |  |  |  |  |

---

## Table of Contents

1. [Scope and context](#1-scope-and-context)
2. [Prerequisites](#2-prerequisites)
3. [Unit testing on Attendance](#3-unit-testing-on-attendance)
   - 3.1 [Attendance API (API/attendance-api)](#31-attendance-api-apiattendance-api)
4. [Unit testing on Notification](#4-unit-testing-on-notification)
   - 4.1 [Notification worker (API/notification-worker)](#41-notification-worker-apinotification-worker)
5. [Integrate both into CI](#5-step-3--integrate-both-into-ci)
6. [Coverage and thresholds](#6-step-4--coverage-and-thresholds)
7. [Advantages of using pytest (and related tools)](#7-advantages-of-using-pytest-and-related-tools)
8. [Contact Information](#8-contact-information)
9. [References](#9-references)

---

## 1. Scope and context

| Item | Description |
|------|-------------|
| **Attendance API** | Python Flask REST API in **API/attendance-api**; Poetry, pytest, pytest-cov, pylint; PostgreSQL, Redis. |
| **Notification worker** | Python worker in **API/notification-worker**; pip + requirements.txt or Poetry; POC adds or runs unit tests. |
| **POC goal** | Run unit tests for both applications (attendance API and notification worker), optionally enforce coverage thresholds. |

---

## 2. Prerequisites

| Requirement | Description |
|-------------|-------------|
| **Python** | Python 3.11+ for the API (or per pyproject.toml); Python 3.6+ for the worker (or per Dockerfile/requirements). |
| **Poetry** | For the Python API dependency and test runs. |
| **pip** | For the Python worker (`pip install -r requirements.txt`). |
| **CI system** | GitLab CI, Jenkins, or similar (one pipeline or two jobs for the POC). |

---

## 3. Unit testing on Attendance

This section covers unit testing for the **Attendance API** in **API/attendance-api** (Python, Flask, Poetry, PostgreSQL, Redis).

### 3.1 Attendance API (API/attendance-api)

**Step 3.1.1 — Navigate to the Attendance API project**

```bash
cd attendance/attendance-api
```

**Step 3.1.2 — Install dependencies**

```bash
make build
# or: poetry config virtualenvs.create false && poetry install --no-root --no-interaction --no-ansi
```

**Step 3.1.3 — Run lint (e.g. pylint)**

```bash
export TMPDIR=/data/tmp
mkdir -p /data/tmp
poetry run pylint router/ client/ models/ utils/ app.py

```
<img width="1917" height="873" alt="image" src="https://github.com/user-attachments/assets/5fa33418-bfc2-42d8-b242-368532b97b52" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/1c1702cb-3aab-4351-8356-634952ad01cf" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/0cd4fc07-914e-408d-86d2-d01c8a52cec6" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/51884d9f-99b5-4795-b97d-73f328904afd" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/afec3f4c-26d9-472e-93f0-6ca35f012a0f" />


**Step 3.1.4 — Run unit tests**

```bash
python3 -m pytest
```

**Step 3.1.5 — Run tests with coverage and save report in HTML**

```bash
# to use data fodler
sudo systemctl stop attendance-api.service
sudo cp -r ~/attendance/ /data/attendance
cd /data/attendance
cat pytest.ini
mkdir -p /data/systemd
nano /data/systemd/attendance.service
sudo cp /data/systemd/attendance.service /etc/systemd/system/attendance.service
export COVERAGE_FILE=/data/attendance/.coverage

scp -i secretkey.pem -r ubuntu@10.0.2.75:/data/attendance/htmlcov/ ~/bastion
scp -i secretkey.pem -r ubuntu@54.226.94.183:~/bastion/ /home/mukesh/htmlcov/


```
<img width="1917" height="411" alt="image" src="https://github.com/user-attachments/assets/f386035c-5a6a-44b1-8d01-8dce69a17f00" />
**Expected Output**

<img width="1917" height="697" alt="image" src="https://github.com/user-attachments/assets/5eaee422-fc88-4d73-93e3-7e45d79bf208" />
<img width="1917" height="697" alt="image" src="https://github.com/user-attachments/assets/a4683bc9-2bf7-4d4c-9a34-17178397582d" />
<img width="1917" height="747" alt="image" src="https://github.com/user-attachments/assets/8f9d4537-4f70-4469-8452-75cf0c9aadf1" />

<img width="1917" height="524" alt="image" src="https://github.com/user-attachments/assets/b3f64759-d928-45e1-83ba-6e662ef05249" />

<img width="1917" height="815" alt="image" src="https://github.com/user-attachments/assets/8d0e1559-ea12-4f8a-b63c-332cde993946" />


<img width="1917" height="821" alt="image" src="https://github.com/user-attachments/assets/ef292fa1-2ffa-4706-a5b3-c1c45d42e2ac" />


- The **coverage report** is saved in the **`htmlcov/`** directory in the project root (`API/attendance-api/htmlcov/`).
- Open **`htmlcov/index.html`** in a browser to view the report (line-by-line coverage, summary by file).

**Step 3.1.6 — Confirm test layout and pass**

Tests are typically under `router/tests/`, `client/tests/`, `models/tests/`, `utils/tests/` (e.g. test_cache, test_postgres_conn, test_validator). Mock PostgreSQL and Redis in tests where needed. Ensure all tests pass locally before adding to CI.

**Final Report**

<img width="1917" height="982" alt="image" src="https://github.com/user-attachments/assets/7e722c2f-5548-478e-aa82-82910eebeee4" />

<img width="1917" height="982" alt="image" src="https://github.com/user-attachments/assets/0d5a9a88-d58a-43ca-b734-544d75e1f1ce" />

---

## 4. Unit testing on Notification

This section covers unit testing for the **Notification worker** in **API/notification-worker**.

### 4.1 Notification worker (API/notification-worker)

**Step 4.1.1 — Navigate to the Notification worker project**

```bash
cd API/notification-worker
```

**Step 4.1.2 — Install dependencies**

```bash
make build
# or: pip3 install -r requirements.txt
```

**Step 4.1.3 — Add or locate the test suite (POC)**

- If no tests exist: create a `tests/` directory and add `tests/test_*.py` (e.g. test config loading or a helper that builds the notification payload).
- Mock external services (e.g. SMTP, email gateway, message queue) in tests.
- Use **pytest** (add `pytest` to `requirements.txt` or a dev-requirements file) or **unittest**.

**Step 4.1.4 — Run tests locally and save report in HTML**

```bash
python3 -m pytest tests/ -v --cov=. --cov-report=html
# or, without coverage: python3 -m pytest tests/ -v
# or: python3 -m unittest discover -s tests
```

- The **coverage report** is saved in the **`htmlcov/`** directory in the project root (`API/notification-worker/htmlcov/`).
- Open **`htmlcov/index.html`** in a browser to view the report.

**Step 4.1.5 — Document the test command**

Record the test command (e.g. `python3 -m pytest tests/ -v --cov-report=html`) so CI or other developers can run the same. Add `htmlcov/` to `.gitignore` if you do not want to commit the generated report.

---

## 5. Step 3 — Integrate both into CI

1. **Python API job** (example GitLab CI):
   - Checkout repo; change to the Python API project directory.
   - Install: `poetry install --no-root` (or `make build`).
   - Lint: `make fmt` or `pylint router/ client/ models/ utils/ app.py`.
   - Test: `python3 -m pytest --cov=. --cov-report=xml --cov-report=html` (or `--junitxml=report.xml` for JUnit). The HTML report is in `htmlcov/`; publish `htmlcov/` or `coverage.xml` as artifacts if needed.
   - Publish coverage and/or JUnit report as artifacts; fail the job if pytest exits non-zero.
2. **Notification worker job**:
   - Checkout repo; change to **API/notification-worker**.
   - Install: `pip install -r requirements.txt` (and pytest if not in requirements).
   - Test: `python3 -m pytest tests/ -v --cov=. --cov-report=html` (or equivalent). HTML report is in `htmlcov/`.
   - Fail the job if tests fail.
3. Run both jobs on every push or MR to the relevant paths.

---

## 6. Step 4 — Coverage and thresholds

1. For the **Attendance API** (**API/attendance-api**), set a coverage threshold and save the report in HTML:
   ```bash
   python3 -m pytest --cov=. --cov-report=html --cov-fail-under=70
   ```
   The report is saved in **`htmlcov/index.html`**; open it in a browser to view. Optionally publish `htmlcov/` or `coverage.xml` to a dashboard or CI artifacts.
2. For the **Notification worker** (**API/notification-worker**), coverage is optional in the POC; to save an HTML report:
   ```bash
   python3 -m pytest tests/ -v --cov=. --cov-report=html
   ```
   Report location: **`htmlcov/index.html`**. Add `--cov-fail-under` later if you enforce a threshold.

---

## 7. Advantages of using pytest (and related tools)

This POC uses **pytest** for unit tests, with **pytest-cov** for coverage and **pytest-mock** (or **unittest.mock**) for mocking. Advantages over the built-in **unittest** or other test runners:

| Advantage | Description |
|-----------|-------------|
| **Less boilerplate** | No need to subclass TestCase; plain functions and `assert` statements. Tests are shorter and easier to read. |
| **Discovery and naming** | Automatically finds tests in `test_*.py` and `*_test.py`; flexible naming without a fixed class structure. |
| **Fixtures** | Built-in fixture system for setup/teardown and shared resources (e.g. DB, API client); cleaner than unittest setUp/tearDown. |
| **Parametrization** | `@pytest.mark.parametrize` runs the same test with different inputs; reduces duplication compared to unittest. |
| **Plugins and ecosystem** | **pytest-cov** for coverage, **pytest-mock** for patching; many plugins for async, ordering, and reporting. |
| **Clear failure output** | Assertion introspection shows values on failure (e.g. expected vs actual); unittest often requires more manual debugging. |
| **Coverage integration** | `pytest --cov` produces coverage reports and supports thresholds (`--cov-fail-under`); fits CI quality gates. |
| **Widely adopted** | De facto standard for Python testing; easy to find examples, CI templates, and team familiarity. |

| Both applications’ 
---

## 8. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 9. References

| Link | Description |
|------|-------------|
| [Python CI Checks — Unit Testing (main doc)](https://github.com/Snaatak-Saarthi/documentation/blob/SCRUM-176-mukesh/Applications/Understanding/Python_CI_Checks/Unit_Testing/README.md) | Main design document for Python CI checks and unit testing. |
| [pytest](https://docs.pytest.org/) | pytest — Python testing framework. |
| [pytest-cov](https://pytest-cov.readthedocs.io/) | pytest-cov — coverage plugin for pytest. |
| [coverage.py](https://coverage.readthedocs.io/) | coverage.py — code coverage measurement. |

---
