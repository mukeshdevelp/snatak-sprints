# SonarQube Quality Gates Setup — Manual Configuration


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 11-03-2026 | v1.0 | Mukesh Sharma | 11-03-2026 |  |  |  |  |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [What is a Quality Gate](#2-what-is-a-quality-gate)
3. [Prerequisites](#3-prerequisites)
4. [Step 1 — Access SonarQube and create a project (optional)](#4-step-1--access-sonarqube-and-create-a-project-optional)
5. [Step 2 — Create a custom Quality Gate](#5-step-2--create-a-custom-quality-gate)
6. [Step 3 — Configure Quality Gate conditions](#6-step-3--configure-quality-gate-conditions)
7. [Step 4 — Set the Quality Gate as default and/or assign to projects](#7-step-4--set-the-quality-gate-as-default-andor-assign-to-projects)
8. [Best practices](#8-best-practices)
9. [Troubleshooting](#9-troubleshooting)
10. [Contact Information](#10-contact-information)
11. [References](#11-references)

---

## 1. Introduction

This document provides a **step-by-step guide** to create and configure **SonarQube Quality Gates manually** in the SonarQube UI. No CI/CD pipeline or scanner integration is required, only access to the SonarQube server and admin (or Quality Gate admin) rights.

Quality Gates are a set of **conditions** that SonarQube evaluates on each project analysis. They define a pass/fail outcome based on metrics such as coverage, bugs, vulnerabilities, code smells, and duplication. This guide covers creating a custom gate, adding conditions, and assigning it to projects or setting it as the default.

---

## 2. What is a Quality Gate

A **Quality Gate** is a set of **conditions** (rules) that SonarQube evaluates on each project analysis. The gate returns:

- **Passed** — if all conditions are satisfied.
- **Failed** — if one or more conditions are violated.

Typical conditions include:

- Coverage on **new code** greater than or equal to X%.
- No **new blocker or critical bugs**.
- No **new vulnerabilities**.
- Code **duplication** below a given percentage.

After you create and assign a Quality Gate, SonarQube will evaluate it whenever a project is analyzed (e.g. from a scanner run locally or elsewhere). The result is visible in the project dashboard in SonarQube.

---

## 3. Prerequisites

| Item | Description |
|------|-------------|
| **SonarQube server** | A running SonarQube instance (Community, Developer, or Enterprise). |
| **Admin or Quality Gate admin rights** | A user account with permission to create and edit Quality Gates and assign them to projects. |


---

## 4. Step 1 — Access SonarQube and create a project (optional)

If you already have projects in SonarQube, you can skip this step and go to Step 2.

1. Log in to the **SonarQube UI** as an admin or project administrator.
2. Go to **Projects** and then **Create project** (or use an existing project).
3. Create the project:
   - **Manually:** Enter a project key and display name.
   - **From VCS:** Use the GitHub / GitLab / Bitbucket integration if it is configured.
4. Note the **Project Key**. You will use it later when assigning a Quality Gate to this project (Step 4).

Projects need at least one successful analysis before a Quality Gate result is shown. Analysis can be run later (e.g. from a local scanner or your own automation); this guide does not cover running the analysis.

---

## 5. Step 2 — Create a custom Quality Gate

1. Log in to SonarQube as a user with **Admin** (or Quality Gate admin) rights.
2. Open **Quality Gates** from the top menu (under **Administration** or **Quality Gates**).
3. Click **Create** (or **Create Quality Gate**, depending on your SonarQube version).
4. Enter a name for the gate, for example:
   - `Java-Strict-Gate`
   - `Microservice-Default-Gate`
5. Save the new Quality Gate. The gate is created with no conditions; you will add conditions in Step 3.

**Expected Output**
<img width="1920" height="980" alt="image" src="https://github.com/user-attachments/assets/1b98a88c-a48b-4b2d-b752-6501ce8397f3" />


---

## 6. Step 3 — Configure Quality Gate conditions

With your **custom Quality Gate** selected in the Quality Gates list:

1. Click **Add Condition**.
2. For each condition, configure:
   - **Metric** — e.g. *Coverage on New Code*, *Bugs on New Code*, *Vulnerabilities on New Code*, *Duplicated Lines on New Code*.
   - **Operator** — e.g. *is less than*, *is greater than*.
   - **Value** — numeric or percentage threshold.

Repeat for every condition you want. The gate fails if any condition is not met.

**Expected Output**
<img width="1920" height="980" alt="image" src="https://github.com/user-attachments/assets/bb5f90cd-8627-4be7-91e8-57a0a5f4fac9" />


### 6.1 Example conditions (recommended baseline)

Using **New Code** helps avoid failing on legacy code:

- **Coverage on New Code**
  - Condition: Coverage on New Code **is less than** `80` (%). Result: **FAIL** if new code coverage is below 80%.
- **Bugs on New Code**
  - Condition: Bugs on New Code **is greater than** `0` (optionally restrict to severity **Major** or higher). Result: **FAIL** if there are new bugs.
- **Vulnerabilities on New Code**
  - Condition: Vulnerabilities on New Code **is greater than** `0` (optionally restrict to **Major** or higher). Result: **FAIL** if there are new vulnerabilities.
- **Code Smells on New Code**
  - Condition: Code Smells on New Code **is greater than** `0` and severity **Critical**. Result: **FAIL** if there are new critical code smells.
- **Duplications on New Code**
  - Condition: Duplicated Lines (%) on New Code **is greater than** `3`. Result: **FAIL** if duplication on new code exceeds 3%.

You can add conditions on **overall code** as well; many teams start with New Code only and tighten later.

---

## 7. Step 4 — Set the Quality Gate as default and/or assign to projects

### 7.1 Set as default (optional)

1. In **Quality Gates**, select your custom Quality Gate.
2. Click **Set as Default**.

All projects that do not have another gate explicitly assigned will use this gate for future analyses.

**Expected Output**

<img width="1920" height="980" alt="image" src="https://github.com/user-attachments/assets/c43088e4-ba47-4635-8f06-e2eeac4fbaa7" />

<img width="1920" height="980" alt="image" src="https://github.com/user-attachments/assets/c4e34420-80f1-45ac-a8f7-b77ad3899830" />

<img width="1920" height="980" alt="image" src="https://github.com/user-attachments/assets/c686deff-bbea-4de8-98de-9a230e4fe1de" />


### 7.2 Assign the gate to specific projects

1. In **Quality Gates**, select your custom gate.
2. Use the **Projects** (or **Apply to Projects**) section.
3. Search for the project(s) by name and assign the gate to them.

After assignment, each new analysis of those projects will be evaluated against this Quality Gate. The pass/fail result appears on the project dashboard in SonarQube.


<img width="1920" height="980" alt="image" src="https://github.com/user-attachments/assets/52ea9f92-c9de-4f59-9ad9-4ee8d32b8afc" />


---

## 8. Best practices

| Practice | Description |
|----------|-------------|
| **Focus on New Code** | Use conditions on *new* or *changed* code to avoid blocking on legacy issues. |
| **Start lenient, then tighten** | Begin with moderate thresholds (e.g. 70–80% coverage) and increase strictness over time. |
| **Align with standards** | Define conditions to match your team’s standards for security, coverage, and maintainability. |
| **Monitor trends** | Use SonarQube project and portfolio dashboards to track coverage and issue trends. |
| **Document the gate** | Document which conditions you use and the thresholds so teams know what to fix when the gate fails. |

---

## 9. Troubleshooting

| Symptom | Possible cause / fix |
|---------|----------------------|
| Quality Gate never shows a result | The project must have at least one successful analysis. Run an analysis (e.g. with sonar-scanner or Maven) and refresh the project. |
| Wrong Quality Gate applied | In SonarQube go to **Project Settings → Quality Gate** and check which gate is assigned, or use the default gate. |
| Gate fails only on legacy code | Prefer conditions on **New Code** only, or relax thresholds for overall code. |
| Cannot create or edit Quality Gate | Your user needs **Admin** or **Quality Gate admin** permission. Ask an administrator to grant it. |

---

## 10. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh Kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 11. References

| Link | Description |
|------|-------------|
| [SonarQube Quality Gates](https://docs.sonarsource.com/sonarqube/latest/user-guide/quality-gates/) | Official documentation on Quality Gates. |
| [SonarQube New Code](https://docs.sonarsource.com/sonarqube/latest/user-guide/new-code/) | Definition and configuration of New Code. |
| [SonarQube Web API](https://docs.sonarqube.org/latest/extend/web-api/) | API reference; can be used to query Quality Gate status. |

---
