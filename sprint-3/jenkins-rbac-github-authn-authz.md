# Jenkins RBAC with GitHub Authentication — POC


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 11-03-2026 | v1.0 | Mukesh Sharma | 11-03-2026 |  |  |  |  |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Target RBAC model](#2-target-rbac-model)
3. [Prerequisites](#3-prerequisites)
4. [Step 1 — Install required Jenkins plugins](#4-step-1--install-required-jenkins-plugins)
5. [Step 2 — Create GitHub org, teams, and users](#5-step-2--create-github-org-teams-and-users)
6. [Step 3 — Configure Jenkins authentication with GitHub](#6-step-3--configure-jenkins-authentication-with-github)
7. [Step 4 — Enable Role-Based Authorization Strategy](#7-step-4--enable-role-based-authorization-strategy)
8. [Step 5 — Create Dev, QA, and DevOps roles](#8-step-5--create-dev-qa-and-devops-roles)
9. [Step 6 — Assign roles to GitHub teams/users](#9-step-6--assign-roles-to-github-teamsusers)
10. [Step 7 — Validate RBAC with sample jobs](#10-step-7--validate-rbac-with-sample-jobs)
11. [Best practices](#11-best-practices)
12. [Troubleshooting](#12-troubleshooting)
13. [Contact Information](#13-contact-information)
14. [References](#14-references)

---

## 1. Introduction

This document is a **step-by-step guide** to configure **Jenkins authentication and authorization** using:

- **GitHub Authentication** (OAuth) for **user login**, and  
- **Role-Based Authorization Strategy** for **role-based access control (RBAC)**.

The goal is to implement three roles:

- **Dev** — Can view jobs and **build/execute** pipelines, but **cannot configure** jobs or Jenkins itself.  
- **QA** — Same as Dev (execute-only), optionally limited to QA-related jobs.  
- **DevOps** — Full administrative access (configure jobs, manage Jenkins, credentials, etc.).

Users authenticate with their **GitHub accounts**, and Jenkins uses **GitHub teams** or usernames to grant the appropriate Jenkins role.

---

## 2. Target RBAC model

### 2.1 Roles

| Role   | Jenkins permissions (high level) |
|--------|----------------------------------|
| **Dev** | Read jobs, Discover jobs, Build jobs, Workspace permissions; no job configuration, no system admin. |
| **QA**  | Same as Dev; can execute QA pipelines; no configuration or admin. |
| **DevOps** | All permissions (Administer Jenkins, Configure jobs, Manage credentials, etc.). |

### 2.2 Mapping to GitHub

Recommended pattern:

- Create a **GitHub organization** (e.g. `my-company-ci`).  
- Inside the org, create **teams**:
  - `dev-team`
  - `qa-team`
  - `devops-team`
- Add GitHub users to the appropriate teams.

<img width="1919" height="885" alt="image" src="https://github.com/user-attachments/assets/8cd94b3f-2fe0-43b9-88f0-6cfdb7f423a0" />


When using the GitHub Authentication plugin, Jenkins can treat GitHub teams as **groups**. Group names usually look like:

- `my-company-ci/dev-team`  
- `my-company-ci/qa-team`  
- `my-company-ci/devops-team`

You will later assign Jenkins **roles** (Dev, QA, DevOps) to these GitHub team group names.

---

## 3. Prerequisites

| Item | Description |
|------|-------------|
| **Jenkins** | A running Jenkins controller (LTS recommended), with an admin account to configure security. |
| **GitHub account** | Access to create / manage a GitHub **organization** and **OAuth app** for Jenkins. |
| **GitHub OAuth app** | Client ID and Client Secret for Jenkins GitHub Authentication (created under the GitHub org or user). |
| **Network** | Jenkins can reach `github.com` over HTTPS (port 443). |

---

## 4. Step 1 — Install required Jenkins plugins

From the Jenkins UI (as admin):

1. Go to **Manage Jenkins → Plugins → Available plugins**.
2. Install (or verify installed):
   - **GitHub Authentication plugin** (or an equivalent GitHub OAuth/OIDC plugin).
   - **Role-based Authorization Strategy** plugin.
3. After installation, **restart Jenkins** if prompted.

<img width="1919" height="126" alt="image" src="https://github.com/user-attachments/assets/b2cb4620-9675-4565-8f73-a607d32f3b16" />
<img width="1919" height="126" alt="image" src="https://github.com/user-attachments/assets/bd4165f8-e3b3-4455-9aea-d6d9f58d5e38" />


---

## 5. Step 2 — Create GitHub org, teams, and users

You can adapt these steps to an existing GitHub org; the example assumes a new org.

1. In GitHub, create (or use) an **organization**, e.g. `jenkins-batch-17`.
2. Under the org, create teams:
   - `dev-team`
   - `qa-team`
   - `devops-team`
3. Add members:
   - All **developers** → `dev-team`
   - All **QA engineers** → `qa-team`
   - **DevOps / platform engineers** → `devops-team`

Later, these team names will be used in Jenkins as **groups** to assign roles.

<img width="1919" height="885" alt="image" src="https://github.com/user-attachments/assets/07e7327a-7c4d-4572-83d6-59d914702270" />

<img width="1919" height="885" alt="image" src="https://github.com/user-attachments/assets/ac82e429-d890-4f55-bb93-4aacd3d68d33" />

<img width="1919" height="885" alt="image" src="https://github.com/user-attachments/assets/411ed819-c4d0-409b-b077-abb538250bfa" />

---

## 6. Step 3 — Configure Jenkins authentication with GitHub

### 6.1 Create a GitHub OAuth app

In GitHub (under your organization or user):

1. Go to **Settings → Developer settings → OAuth Apps**.
2. Click **New OAuth App**.
3. Set:
   - **Application name:** `Jenkins CI`
   - **Homepage URL:** `https://<your-jenkins-url>/`
   - **Authorization callback URL:** `https://<your-jenkins-url>/securityRealm/finishLogin`



4. After creating, note the:
   - **Client ID**
   - **Client Secret** (you will paste this into Jenkins).

<img width="1918" height="788" alt="image" src="https://github.com/user-attachments/assets/6a94a83b-2cd8-484f-b78b-942256f804eb" />

### 6.2 Configure Jenkins Security Realm

In Jenkins:

1. Go to **Manage Jenkins → Configure Global Security**.
2. Under **Security Realm**, select **GitHub Authentication Plugin**.
3. Set:
   - **GitHub Web URI:** `https://github.com`
   - **GitHub API URI:** `https://api.github.com`
   - **Client ID:** `<your GitHub OAuth client ID>`
   - **Client Secret:** `<your GitHub OAuth client secret>`
   - (Optional) **Scopes**: ensure at least `read:org` so Jenkins can read team membership.
4. Save the configuration.

From this point, users should be able to log in to Jenkins using the **“Sign in with GitHub”** button.



---

## 7. Step 4 — Enable Role-Based Authorization Strategy

Still on **Manage Jenkins → Configure Global Security**:

1. Under **Authorization**, choose **Role-Based Strategy**.
2. (Optional but recommended) under **Logged-in users** section, ensure:
   - Anonymous users have **no** administrative permissions.
3. Click **Save**.

This tells Jenkins to delegate authorization to the Role-Based Strategy plugin.

---

## 8. Step 5 — Create Dev, QA, and DevOps roles

Go to **Manage Jenkins → Manage and Assign Roles → Manage Roles**.

### 8.1 Global roles

Under **Global roles**, create:

- `dev`
- `qa`
- `devops`

Then assign permissions:

**Dev (global role `dev`)** — minimal rights to run jobs:

- Overall:
  - `Read`
- Job:
  - `Discover`
  - `Read`
  - `Build`
  - `Workspace` (if you want them to see workspace contents)
- View:
  - `Read`

**QA (global role `qa`)** — same as Dev, or optionally slightly different:

- Overall:
  - `Read`
- Job:
  - `Discover`
  - `Read`
  - `Build`
  - `Workspace` (optional)
- View:
  - `Read`

**DevOps (global role `devops`)** — admin role:

- Overall:
  - `Read`
  - `Administer`
- Job:
  - All Job permissions (Create, Configure, Delete, Build, etc.)
- Credentials:
  - All permissions (if you use Jenkins Credentials).
- View:
  - All view permissions.
- (Optionally) Nodes, Runs, SCM, etc. — typically **all**.

Click **Save** after setting the checkboxes.

### 8.2 (Optional) Project roles

If you want Dev/QA to have access only to certain jobs by name patterns:

1. In **Manage Roles**, under **Project roles**, create:
   - `dev-jobs` with a pattern like `dev-.*`
   - `qa-jobs` with a pattern like `qa-.*`
2. Assign Job permissions to these project roles (Read, Discover, Build).
3. Later you can assign these project roles to dev / qa groups instead of granting global Job permissions.

---

## 9. Step 6 — Assign roles to GitHub teams/users

Go to **Manage Jenkins → Manage and Assign Roles → Assign Roles**.

### 9.1 Assign global roles to GitHub teams

In the **Global roles** section:

1. In the **User/group** field, enter the GitHub team or user names as recognized by Jenkins, for example:
   - `my-company-ci/dev-team`
   - `my-company-ci/qa-team`
   - `my-company-ci/devops-team`
2. Click **Add** for each.
3. In the matrix:
   - For `my-company-ci/dev-team`, tick the **dev** role.
   - For `my-company-ci/qa-team`, tick the **qa** role.
   - For `my-company-ci/devops-team`, tick the **devops** role.
4. Click **Save**.

Now:

- Any user in the GitHub team `my-company-ci/dev-team` will get the **Dev** role when they log in.
- Any user in `my-company-ci/qa-team` will get **QA** role.
- Any user in `my-company-ci/devops-team` will get **DevOps** (admin) role.

### 9.2 (Optional) Assign project roles

If you defined project roles:

1. In the **Project roles** section of **Assign Roles**, add the same GitHub team names.
2. Tick `dev-jobs` for `my-company-ci/dev-team`, and `qa-jobs` for `my-company-ci/qa-team`.

This way Dev/QA can only see and run jobs matching the patterns you configured.

---

## 10. Step 7 — Validate RBAC with sample jobs

Create a couple of sample pipelines:

- `dev-app-build` (owned by Dev team).  
- `qa-app-regression` (owned by QA team).

Then:

1. Log out of Jenkins.
2. Log in as a **Dev user** (GitHub account in `dev-team`):
   - You should see **dev** jobs (and any others your policies allow).
   - You should be able to **Build** jobs.
   - You should **not** see “Manage Jenkins” or be able to configure jobs (if you followed the limited-permission setup).
3. Log in as a **QA user** (GitHub account in `qa-team`):
   - You should be able to see and run QA jobs, similar restrictions as Dev.
4. Log in as a **DevOps user** (GitHub account in `devops-team`):
   - You should have full access, including “Manage Jenkins” and job configuration.

If any user sees more/less than expected, revisit Role definitions and Assign Roles.

---

## 11. Best practices

| Practice | Description |
|----------|-------------|
| **Use GitHub teams for groups** | Manage membership in GitHub; Jenkins only needs to map teams to roles. |
| **Least privilege** | Keep Dev/QA roles limited to build/execute; only DevOps gets Administer. |
| **Separate admin accounts** | Use a dedicated DevOps team or admin user for Jenkins configuration; avoid granting `Administer` broadly. |
| **Audit login and role mappings** | Periodically verify that teams and roles still reflect the organization structure. |
| **Use HTTPS and reverse proxy** | Protect Jenkins with TLS; terminate HTTPS at a reverse proxy or use Jenkins HTTPS. |
| **Backup Jenkins configuration** | Before major security changes, back up `JENKINS_HOME`. |

---

## 12. Troubleshooting

| Symptom | Possible cause / fix |
|---------|----------------------|
| GitHub users cannot log in | Check GitHub OAuth app callback URL matches `https://<jenkins>/securityRealm/finishLogin`; verify Client ID/Secret; ensure plugin is configured as Security Realm. |
| GitHub team not recognized as group | Ensure the GitHub OAuth app has `read:org` scope; check the exact GitHub team name format (`org/team`); try adding a user directly by GitHub username in Assign Roles. |
| Dev users see “Manage Jenkins” | Dev role has too many permissions; remove `Administer` or other admin-level permissions from the `dev` role. |
| QA cannot see any jobs | Project role patterns might not match job names; check regex/pattern in project roles or grant global Job Read/Discover. |
| Anonymous users can run jobs | Ensure Anonymous is not granted Job Build/Read under Role-Based Strategy; review `Configure Global Security`. |

---

## 13. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh Kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 14. References

| Link | Description |
|------|-------------|
| [Jenkins – Securing Jenkins](https://www.jenkins.io/doc/book/security/) | Official guide to Jenkins security. |
| [GitHub Authentication Plugin](https://plugins.jenkins.io/github-oauth/) | Jenkins GitHub Authentication/OAuth plugin. |
| [Role-based Authorization Strategy plugin](https://plugins.jenkins.io/role-based-authorization-strategy/) | Role-based Authz plugin used for Dev/QA/DevOps roles. |
| [GitHub OAuth Apps](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/creating-an-oauth-app) | Creating and configuring GitHub OAuth applications. |
| [An Introduction to Jenkins Authorization](https://www.jenkins.io/doc/book/security/authorization/) | Authorization strategies overview. |

---

