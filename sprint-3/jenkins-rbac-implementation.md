# Jenkins RBAC Authorization — Jenkins UI Step-by-Step Implementation


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 23-03-2026 | v1.0 | Mukesh Sharma | 23-03-2026 |  |  |  |  |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Scope](#2-scope)
3. [Prerequisites](#3-prerequisites)
4. [Target users and role mapping](#4-target-users-and-role-mapping)
5. [Step 1 — Open Jenkins security configuration](#5-step-1--open-jenkins-security-configuration)
6. [Step 2 — Enable Role-Based Strategy (Authorization)](#6-step-2--enable-role-based-strategy-authorization)
7. [Step 3 — Open Manage and Assign Roles](#7-step-3--open-manage-and-assign-roles)
8. [Step 4 — Create global roles in Jenkins UI](#8-step-4--create-global-roles-in-jenkins-ui)
9. [Step 5 — Set permission checkboxes for each role](#9-step-5--set-permission-checkboxes-for-each-role)
10. [Step 6 — Assign users to roles in Jenkins UI](#10-step-6--assign-users-to-roles-in-jenkins-ui)
11. [Step 7 — Validate access with test logins](#11-step-7--validate-access-with-test-logins)
12. [Troubleshooting](#12-troubleshooting)
13. [Contact Information](#13-contact-information)
14. [References](#14-references)

---

## 1. Introduction

This guide provides a practical **Jenkins UI implementation** of RBAC authorization. It explains exactly where to click and what to select in Jenkins to create roles and assign users.

This document is intentionally focused on **authorization only** (what users can do after login), not authentication setup.

---

## 2. Scope

| In scope | Out of scope |
|----------|--------------|
| Configure Role-Based Strategy in Jenkins UI | Configure login provider (LDAP/OIDC/GitHub OAuth/SAML) |
| Create `dev`, `qa`, `devops` roles in Jenkins UI | User creation in external IdP |
| Assign provided users to roles and validate access | Infrastructure setup for Jenkins server |

---

## 3. Prerequisites

| Item | Requirement |
|------|-------------|
| Jenkins access | Admin access to Jenkins dashboard |
| Plugin | `Role-based Authorization Strategy` plugin installed |
| Users available | These principals already visible in Jenkins: `Aditya-1818`, `Abhinav-1901`, `Jangra-gunjani12`, `ShreyasAvsthi`, `admin`, `hardbro-7861`, `mukeshdevelp`, `suraj8957` |

---

## 4. Target users and role mapping

Use this mapping in Jenkins **Assign Roles** page:

| User (GitHub ID / principal) | Role |
|------------------------------|------|
| `Aditya-1818` | `dev` |
| `hardbro-7861` | `dev` |
| `Abhinav-1901` | `qa` |
| `Jangra-gunjani12` | `qa` |
| `ShreyasAvsthi` | `qa` |
| `admin` | `devops` |
| `mukeshdevelp` | `devops` |
| `suraj8957` | `devops` |

---

## 5. Step 1 — Open Jenkins security configuration

1. Login to Jenkins as an admin user.
2. Click **Manage Jenkins**.
3. Click **Configure Global Security**.

---

## 6. Step 2 — Enable Role-Based Strategy (Authorization)

1. In **Configure Global Security**, go to **Authorization** section.
2. Select **Role-Based Strategy**.
3. Ensure **Anonymous** is not granted build/admin access.
4. Click **Save**.

Result: Jenkins starts using Role-Based Strategy for authorization decisions.

---

## 7. Step 3 — Open Manage and Assign Roles

1. Go to **Manage Jenkins**.
2. Open **Manage and Assign Roles**.
3. Click **Manage Roles** first.

---

## 8. Step 4 — Create global roles in Jenkins UI

In **Manage Roles** page:

1. In **Role to add**, type `dev` and click **Add**.
2. Type `qa` and click **Add**.
3. Type `devops` and click **Add**.

Now all three roles appear as rows in the matrix.

---

## 9. Step 5 — Set permission checkboxes for each role

Set permissions exactly as below in **Manage Roles**.

### 9.1 Role: `dev`

| Category | Permission | Value |
|----------|------------|-------|
| Overall | Read | On |
| Overall | Administer | Off |
| Job | Build, Cancel, Discover, Read, Workspace | On |
| Job | Configure, Create, Delete, Move | Off |
| Run | Replay, Update | On |
| Run | Delete | Off |
| View | Read | On |
| View | Configure, Create, Delete | Off |
| Credentials | All | Off |
| Agent | All | Off |
| SCM | Tag | Off |

### 9.2 Role: `qa`

Set the same permissions as `dev`.

### 9.3 Role: `devops`

| Category | Permission | Value |
|----------|------------|-------|
| Overall | Read, Administer | On |
| Job | Build, Cancel, Configure, Create, Delete, Discover, Move, Read, Workspace | On |
| Run | Delete, Replay, Update | On |
| View | Configure, Create, Delete, Read | On |
| Credentials | Create, Delete, ManageDomains, Update, View | On |
| Agent | Build, Configure, Connect, Create, Delete, Disconnect, Provision | On |
| SCM | Tag | On |

After selecting values, click **Save**.

---

## 10. Step 6 — Assign users to roles in Jenkins UI

1. Go to **Manage Jenkins → Manage and Assign Roles → Assign Roles**.
2. In **Global roles** section:
   - Add each user from the mapping table.
   - Tick the appropriate role checkbox (`dev`, `qa`, `devops`).
3. Click **Save**.

Expected assignment matrix:

| User | dev | qa | devops |
|------|-----|----|--------|
| `Aditya-1818` | Yes | No | No |
| `hardbro-7861` | Yes | No | No |
| `Abhinav-1901` | No | Yes | No |
| `Jangra-gunjani12` | No | Yes | No |
| `ShreyasAvsthi` | No | Yes | No |
| `admin` | No | No | Yes |
| `mukeshdevelp` | No | No | Yes |
| `suraj8957` | No | No | Yes |

---

## 11. Step 7 — Validate access with test logins

1. Login as `Aditya-1818`:
   - Can view and build jobs.
   - Cannot configure jobs.
   - Cannot access **Manage Jenkins**.
2. Login as `Abhinav-1901`:
   - Same restrictions as dev role.
3. Login as `admin`:
   - Full access including **Manage Jenkins** and job configuration.

If results differ, re-check role checkbox matrix under **Manage Roles** and user-role mapping under **Assign Roles**.

---

## 12. Troubleshooting

| Issue | Fix |
|------|-----|
| User has no access | Ensure username in **Assign Roles** matches exactly the principal shown by Jenkins |
| Dev/QA can administer Jenkins | Remove `Overall → Administer` from `dev` / `qa` |
| User cannot see jobs | Ensure `Job → Read` and `Job → Discover` are enabled for that role |
| Changes not effective | Re-open roles pages, verify saved state, re-login with target user |

---

## 13. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh Kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 14. References

| Link | Description |
|------|-------------|
| [Jenkins Authorization](https://www.jenkins.io/doc/book/security/authorization/) | Official Jenkins authorization guide |
| [Role-based Authorization Strategy Plugin](https://plugins.jenkins.io/role-based-authorization-strategy/) | Plugin documentation |

---

