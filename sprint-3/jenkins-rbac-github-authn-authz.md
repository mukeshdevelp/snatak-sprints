# Jenkins Authorization — Role-Based Access Control (RBAC) POC


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 11-03-2026 | v1.0 | Mukesh Sharma | 11-03-2026 |  |  |  |  |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [What is Jenkins authorization (in this POC)](#2-what-is-jenkins-authorization-in-this-poc)
3. [Target RBAC model](#3-target-rbac-model)
   - 3.1 [Roles to implement](#31-roles-to-implement)
   - 3.2 [Permission mapping (high level)](#32-permission-mapping-high-level)
   - 3.3 [Fixed authorization values (this POC)](#33-fixed-authorization-values-this-poc)
4. [Prerequisites](#4-prerequisites)
5. [Step 1 — Install the Role-based Authorization Strategy plugin](#5-step-1--install-the-role-based-authorization-strategy-plugin)
6. [Step 2 — Select Role-Based Strategy under Authorization](#6-step-2--select-role-based-strategy-under-authorization)
7. [Step 3 — Define global roles (Dev, QA, DevOps)](#7-step-3--define-global-roles-dev-qa-devops)
8. [Step 4 — (Optional) Define item (project) roles](#8-step-4--optional-define-item-project-roles)
9. [Step 5 — Assign roles to users and groups](#9-step-5--assign-roles-to-users-and-groups)
10. [Step 6 — Validate authorization](#10-step-6--validate-authorization)
11. [Best practices](#11-best-practices)
12. [Troubleshooting (authorization)](#12-troubleshooting-authorization)
13. [Contact Information](#13-contact-information)
14. [References](#14-references)

---

## 1. Introduction

**Authorization** answers: *“What is this user allowed to do in Jenkins after they are logged in?”*  
It is separate from **authentication** (*“Who is this user?”* — login, LDAP, OAuth, SAML, etc.).

This POC documents **only authorization**: enabling the **Role-Based Authorization Strategy** plugin, defining **roles** and **permissions**, and **assigning** those roles to **users and groups** (principals) that Jenkins already knows from your existing Security Realm.

It does **not** cover:

- Installing or configuring login plugins (GitHub, LDAP, OIDC, etc.)
- OAuth apps, client IDs, or callback URLs
- Creating users or teams in GitHub or any external IdP

---

## 2. What is Jenkins authorization (in this POC)

| Concept | Meaning |
|--------|---------|
| **Authorization** | Which permissions each logged-in **principal** (user or group) has: overall Jenkins, jobs, credentials, views, agents, etc. |
| **Role-Based Strategy** | A plugin that lets you define **named roles** (e.g. `dev`, `qa`, `devops`) with permission sets, then map those roles to users/groups. |
| **Global roles** | Permissions that apply across Jenkins (or broadly), e.g. “can build jobs,” “can administer Jenkins.” |
| **Item roles** | Optional **regex-based** roles that apply only to jobs whose names match a pattern (e.g. `qa-.*`). |

---

## 3. Target RBAC model

### 3.1 Roles to implement

| Role | Intended behavior |
|------|-------------------|
| **dev** | View and **build** jobs; **no** job configuration, **no** Jenkins administration. |
| **qa** | Same as **dev** by default, or scoped via **item roles** to QA-related jobs only. |
| **devops** | Full administrative access (configure jobs, **Manage Jenkins**, credentials, etc.). |

### 3.2 Permission mapping (high level)

| Role | Overall | Job | View | Credentials / Admin |
|------|---------|-----|------|---------------------|
| **dev** | Read | Discover, Read, Build, Workspace (optional) | Read | — |
| **qa** | Read | Same as dev (or item-scoped) | Read | — |
| **devops** | Read + **Administer** | Full job permissions | Full | Full (as needed) |

The **exact** checkboxes to tick are defined in **Section 3.3** and applied in **Step 3**.

### 3.3 Fixed authorization values (this POC)

Use these values in **Manage Roles → Global roles** so all environments match. Labels follow the Jenkins UI (LTS); if your build adds plugins, extra rows may appear—leave them **unchecked** for `dev` / `qa` unless you explicitly need them.

#### Anonymous (not a named role — set under Configure Global Security)

| Category | Permission | Value |
|----------|------------|--------|
| **Overall** | Administer | **Off** |
| **Overall** | Read | **Off** |
| **Job** | *(all)* | **Off** |

Anonymous users must **not** run builds or read jobs.

#### Global role `dev` — tick **only** these

| Category | Permission | Value |
|----------|------------|--------|
| **Overall** | Read | **On** |
| **Overall** | Administer | **Off** |
| **Job** | Build | **On** |
| **Job** | Cancel | **On** |
| **Job** | Discover | **On** |
| **Job** | Read | **On** |
| **Job** | Workspace | **On** |
| **Job** | Configure | **Off** |
| **Job** | Create | **Off** |
| **Job** | Delete | **Off** |
| **Job** | Move | **Off** |
| **Run** | Replay | **On** |
| **Run** | Update | **On** |
| **Run** | Delete | **Off** |
| **View** | Read | **On** |
| **View** | Configure | **Off** |
| **View** | Create | **Off** |
| **View** | Delete | **Off** |
| **Credentials** | *(all)* | **Off** |
| **Agent** | *(all)* | **Off** |
| **SCM** | Tag | **Off** |

#### Global role `qa` — same as `dev` (identical checkboxes)

Apply the **same** table as **`dev`** above. If you use **item roles** (Section 8), you can later remove overlapping global Job permissions and rely only on item roles for `qa`.

#### Global role `devops` — tick these (full admin for this POC)

| Category | Permission | Value |
|----------|------------|--------|
| **Overall** | Administer | **On** |
| **Overall** | Read | **On** |
| **Job** | Build | **On** |
| **Job** | Cancel | **On** |
| **Job** | Configure | **On** |
| **Job** | Create | **On** |
| **Job** | Delete | **On** |
| **Job** | Discover | **On** |
| **Job** | Move | **On** |
| **Job** | Read | **On** |
| **Job** | Workspace | **On** |
| **Run** | Delete | **On** |
| **Run** | Replay | **On** |
| **Run** | Update | **On** |
| **View** | Configure | **On** |
| **View** | Create | **On** |
| **View** | Delete | **On** |
| **View** | Read | **On** |
| **Credentials** | Create | **On** |
| **Credentials** | Delete | **On** |
| **Credentials** | ManageDomains | **On** |
| **Credentials** | Update | **On** |
| **Credentials** | View | **On** |
| **Agent** | Build | **On** |
| **Agent** | Configure | **On** |
| **Agent** | Connect | **On** |
| **Agent** | Create | **On** |
| **Agent** | Delete | **On** |
| **Agent** | Disconnect | **On** |
| **Agent** | Provision | **On** |
| **SCM** | Tag | **On** |

If your Jenkins shows **Overall → RunScripts** or plugin-specific permissions, enable them **only** on `devops` if your admins need them; keep **Off** for `dev` / `qa`.

#### Item roles (optional — fixed values for this POC)

| Item role name | Pattern (regex) | Job permissions to enable |
|----------------|-----------------|----------------------------|
| `dev-jobs` | `dev-.*` | Discover, Read, Build, Workspace, Cancel |
| `qa-jobs` | `qa-.*` | Discover, Read, Build, Workspace, Cancel |

Do **not** enable Job **Configure**, **Delete**, or **Create** on these item roles unless you intentionally allow pipeline edits for those folders.

---

## 4. Prerequisites

| Item | Description |
|------|-------------|
| **Jenkins** | Controller running LTS; you can sign in as an administrator. |
| **Security Realm** | Already configured (any method). Users must be able to log in; this POC does not change **authentication**. |
| **Plugin** | **Role-based Authorization Strategy** plugin (installed in Step 1). |

---

## 5. Step 1 — Install the Role-based Authorization Strategy plugin

1. **Manage Jenkins → Plugins → Available plugins**.
2. Search for **Role-based Authorization Strategy**.
3. Install and **restart Jenkins** if prompted.

---

## 6. Step 2 — Select Role-Based Strategy under Authorization

1. **Manage Jenkins → Configure Global Security**.
2. Under **Authorization** (not Security Realm), select **Role-Based Strategy**.
3. Restrict **anonymous** access: do not grant **Administer** or job build rights to **Anonymous**.
4. **Save**.

This activates **authorization** via the plugin.

<img width="1918" height="448" alt="Role-Based Authorization Strategy selected under Configure Global Security" src="https://github.com/user-attachments/assets/a742b3b9-d861-4a15-82c4-da1b44393129" />

---

## 7. Step 3 — Define global roles (Dev, QA, DevOps)

**Manage Jenkins → Manage and Assign Roles → Manage Roles → Global roles**

1. Add three global roles: **`dev`**, **`qa`**, **`devops`**.
2. For **`dev`**, set checkboxes **exactly** as in **Section 3.3 — Global role `dev`** (Overall Read; Job Build/Cancel/Discover/Read/Workspace; Run Replay/Update; View Read; everything else listed as **Off**).
3. For **`qa`**, use the **same** checkboxes as **`dev`** (Section 3.3), unless you later switch to item-only access for QA.
4. For **`devops`**, set checkboxes **exactly** as in **Section 3.3 — Global role `devops`** (full admin set for this POC).
5. **Save**.

<img width="1918" height="448" alt="Manage Roles — global roles dev qa devops" src="https://github.com/user-attachments/assets/dd0b870b-1e51-40dd-9c70-990d7ed7c209" />

---

## 8. Step 4 — (Optional) Define item (project) roles

Use **Item roles** when Dev/QA should only see jobs matching a **name pattern**.

1. Same page: **Manage Roles → Item roles**.
2. Create roles with **fixed values** from **Section 3.3 — Item roles**:
   - **`dev-jobs`** — pattern **`dev-.*`** — enable Job: Discover, Read, Build, Workspace, Cancel (no Configure/Delete/Create).
   - **`qa-jobs`** — pattern **`qa-.*`** — same Job permissions as `dev-jobs`.
3. **Save**. Assign these item roles in Step 5 to specific users/groups if you use pattern-based access.

<img width="1918" height="448" alt="Manage Roles — item roles" src="https://github.com/user-attachments/assets/4460c8c7-2fe0-4dad-adc9-7c2cf3aa86c6" />

---

## 9. Step 5 — Assign roles to users and groups

**Manage Jenkins → Manage and Assign Roles → Assign Roles**

### 9.1 Global roles

1. In **User/group**, enter the **exact** principal name Jenkins uses (username or group from your identity source).  
2. Click **Add**.  
3. Tick **`dev`**, **`qa`**, or **`devops`** as appropriate.  
4. **Save**.

Repeat for each user or group.

#### 9.1.1 Principals used in this POC

Use these principals in **Assign Roles** (User/group column) and apply the permission sets defined in **Section 3.3**:

| GitHub ID | Assigned role | Overall permissions | Job permissions | Run permissions | View permissions | Credentials / Agent / SCM |
|------------|----------------|---------------------|-----------------|-----------------|------------------|----------------------------|
| `Aditya-1818` | `dev` | Read | Build, Cancel, Discover, Read, Workspace | Replay, Update | Read | All Off |
| `hardbro-7861` | `dev` | Read | Build, Cancel, Discover, Read, Workspace | Replay, Update | Read | All Off |
| `Abhinav-1901` | `qa` | Read | Build, Cancel, Discover, Read, Workspace | Replay, Update | Read | All Off |
| `Jangra-gunjani12` | `qa` | Read | Build, Cancel, Discover, Read, Workspace | Replay, Update | Read | All Off |
| `ShreyasAvsthi` | `qa` | Read | Build, Cancel, Discover, Read, Workspace | Replay, Update | Read | All Off |
| `admin` | `devops` | Read, Administer | Build, Cancel, Configure, Create, Delete, Discover, Move, Read, Workspace | Delete, Replay, Update | Configure, Create, Delete, Read | Credentials: Create/Delete/ManageDomains/Update/View; Agent: Build/Configure/Connect/Create/Delete/Disconnect/Provision; SCM Tag |
| `mukeshdevelp` | `devops` | Read, Administer | Build, Cancel, Configure, Create, Delete, Discover, Move, Read, Workspace | Delete, Replay, Update | Configure, Create, Delete, Read | Credentials: Create/Delete/ManageDomains/Update/View; Agent: Build/Configure/Connect/Create/Delete/Disconnect/Provision; SCM Tag |
| `suraj8957` | `devops` | Read, Administer | Build, Cancel, Configure, Create, Delete, Discover, Move, Read, Workspace | Delete, Replay, Update | Configure, Create, Delete, Read | Credentials: Create/Delete/ManageDomains/Update/View; Agent: Build/Configure/Connect/Create/Delete/Disconnect/Provision; SCM Tag |

<img width="1918" height="448" alt="Assign Roles — global roles matrix" src="https://github.com/user-attachments/assets/5ffb5f86-622d-4403-b0c9-d82d6c2a08dc" />

### 9.2 Item roles (if defined)

1. **Project roles** section: add the same **User/group** values.  
2. Tick **`dev-jobs`**, **`qa-jobs`**, etc.  
3. **Save**.

<img width="1916" height="1070" alt="image" src="https://github.com/user-attachments/assets/eaa659a8-317e-456a-85ea-198989fa3760" />

---

## 10. Step 6 — Validate authorization

1. Use accounts that **already** can log in (your Security Realm).  
2. Sign in as `Aditya-1818` (role `dev`) → expect **Build** on allowed jobs; **no** **Manage Jenkins**; **no** job **Configure** (if permissions were set correctly).  
3. Sign in as `Abhinav-1901` (role `qa`) → same as dev, or only jobs allowed by **item roles**.  
4. Sign in as `admin` (role `devops`) → full admin access.  

If behavior is wrong, adjust **Manage Roles** (permissions) and **Assign Roles** (who gets which role), not login settings.

---

## 11. Best practices

| Practice | Description |
|----------|-------------|
| **Least privilege** | Grant **Administer** only on **`devops`**; keep **dev** / **qa** minimal. |
| **Groups over users** | When your realm provides groups, assign roles to **groups** for easier maintenance. |
| **Name patterns** | Use **item roles** + regex to limit which jobs a role can touch. |
| **Audit assignments** | Review **Assign Roles** when org structure changes. |
| **Backup** | Backup **`JENKINS_HOME`** before large permission changes. |

---

## 12. Troubleshooting (authorization)

| Symptom | Check / fix |
|---------|-------------|
| User has no permissions | Wrong **User/group** string in **Assign Roles**; must match identity provider. |
| User can administer Jenkins | **`dev`** or **`qa`** has **Administer** or excessive Overall rights — edit **Manage Roles**. |
| User cannot see jobs | **Item role** patterns may not match job names; adjust regex or add global Job Read/Discover. |
| Anonymous can build | **Configure Global Security** → **Anonymous** must not have Job/Overall permissions under Role-Based Strategy. |

---

## 13. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh Kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 14. References

| Link | Description |
|------|-------------|
| [Jenkins – Authorization](https://www.jenkins.io/doc/book/security/authorization/) | Authorization strategies overview. |
| [Role-based Authorization Strategy plugin](https://plugins.jenkins.io/role-based-authorization-strategy/) | RBAC plugin for Jenkins. |
| [Securing Jenkins](https://www.jenkins.io/doc/book/security/) | Broader security context (auth + authz). |

---

