# Jenkins Authentication and Authorization

This document describes **Jenkins authentication (Authn)** and **authorization (Authz)**: introduction, what they are, why they matter, workflow diagram, different types (security realms and authorization strategies), comparison table, best practices, recommendation/conclusion, contact information, and references.

---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 03-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  | aniruddh sir | faisal sir | ashwani sir |




---

## Table of Contents

1. [Introduction](#1-introduction)
2. [What](#2-what)
3. [Why](#3-why)
4. [Workflow diagram](#4-workflow-diagram)
5. [Different types](#5-different-types)
6. [Comparison table](#6-comparison-table)
7. [Best practices](#7-best-practices)
8. [Recommendation / Conclusion](#8-recommendation--conclusion)
9. [Contact Information](#9-contact-information)
10. [References](#10-references)

---

## 1. Introduction

**Authentication (Authn)** in Jenkins answers “Who are you?”—it determines how users (and optionally service accounts) prove their identity when accessing the Jenkins UI or API (e.g. username/password, LDAP, SAML, or OAuth). **Authorization (Authz)** answers “What are you allowed to do?”—it controls what an authenticated user can do (e.g. view jobs, run builds, configure jobs, or administer Jenkins).

Jenkins uses a **Security Realm** for authentication and an **Authorization Strategy** for authorization. Both are configured under **Manage Jenkins → Security**. This document describes what Authn and Authz are in Jenkins, why they matter, how the flow works, the different types (realms and strategies), a comparison table, best practices, and a recommendation for the Application CI design.

---

## 2. What

**Jenkins authentication and authorization** consist of:

- **Security Realm (Authn)** — The component that verifies identity. Jenkins supports:
  - **Jenkins’ own user database** — Users created and stored inside Jenkins (default).
  - **LDAP** — Bind to an LDAP/Active Directory server to validate usernames and passwords.
  - **SAML / OAuth / OIDC** — Integrate with an identity provider (IdP) for SSO via plugins (e.g. SAML, Google Login, GitHub Authentication).
  - **Unix user/group database** — Use the server’s Unix users (less common for web UI).

- **Authorization Strategy (Authz)** — The component that decides what an authenticated user can do. Examples:
  - **Logged-in users can do anything** — Any authenticated user has full access (simple but rarely appropriate for production).
  - **Matrix-based / Project-based Matrix** — Fine-grained permissions per user/group (Overall and optionally per job).
  - **Role-based (Role-Based Strategy plugin)** — Assign roles (e.g. Developer, Admin) and map them to permissions.

- **Flow** — User hits Jenkins → Security Realm verifies identity → Authorization Strategy checks permissions for each action (view, run, configure, admin).

---

## 3. Why

| Reason | Description |
|--------|-------------|
| **Security** | Restrict who can access Jenkins and who can run/change jobs or see secrets; reduce risk of misuse or compromise. |
| **Least privilege** | Grant only the permissions needed (e.g. developers run builds, only admins change system config); limit blast radius. |
| **Audit and accountability** | Tie actions to named users (from Authn); support compliance and incident response. |
| **Integration** | Use corporate LDAP or IdP so one identity is used across VCS, Jenkins, and other tools. |
| **Multi-tenant / shared Jenkins** | When multiple teams share one Jenkins, Authz (e.g. project-based matrix or roles) keeps projects isolated. |

---

## 4. Workflow diagram

High-level flow for **login** and **permission check** in Jenkins:

1. **User** — Opens Jenkins UI or calls API (e.g. with username/password or token).
2. **Security Realm (Authn)** — Validates credentials (e.g. against Jenkins DB, LDAP, or IdP); if valid, establishes the identity (username, groups).
3. **Authorization Strategy (Authz)** — For each action (view job, run build, configure job, manage Jenkins), the strategy checks whether the authenticated identity has the required permission.
4. **Result** — Request is allowed or denied; audit logs can record who did what.

```
[User] → [Jenkins] → [Security Realm: verify identity] → [Authz Strategy: check permission] → [Allow / Deny]
```

```
                    ┌─────────────┐
                    │    User     │
                    │ (browser/   │
                    │  API/token) │
                    └──────┬──────┘
                           │
                           ▼
                    ┌─────────────┐
                    │  Jenkins    │
                    │  (request)  │
                    └──────┬──────┘
                           │
                           ▼
                    ┌─────────────┐
                    │   Security  │  Authn: who are you?
                    │   Realm     │  (DB / LDAP / SAML / OAuth)
                    └──────┬──────┘
                           │ identity + groups
                           ▼
                    ┌─────────────┐
                    │ Authorization│  Authz: what can you do?
                    │  Strategy   │  (Matrix / Project Matrix / Role-based)
                    └──────┬──────┘
                           │
                           ▼
                    ┌─────────────┐
                    │ Allow or   │
                    │   Deny     │
                    └─────────────┘
```

---

## 5. Different types

### 5.1 Security Realm (Authentication)

| Type | Description |
|------|-------------|
| **Jenkins own user database** | Users and passwords stored in Jenkins; good for small setups or demos; no IdP integration. |
| **LDAP** | Connect to LDAP or Active Directory; users log in with LDAP credentials; groups can be used for Authz. |
| **SAML 2.0** | SSO via SAML IdP (e.g. Okta, Azure AD); plugin required; users do not enter Jenkins password. |
| **OAuth / OIDC** | SSO via Google, GitHub, or other OAuth/OIDC providers; plugin required. |
| **Delegation** | In some setups, Jenkins delegates to a reverse proxy or container identity; less common for general use. |

### 5.2 Authorization Strategy (Authorization)

| Type | Description |
|------|-------------|
| **Logged-in users can do anything** | Every authenticated user has full admin-level access; not recommended for production. |
| **Anyone can do anything** | No login required; only for isolated/test environments. |
| **Matrix-based security** | Grid of users/groups vs permissions (Overall); one matrix for the whole Jenkins. |
| **Project-based Matrix** | Matrix per job/project in addition to Overall; fine-grained control per pipeline. |
| **Role-based (Role Strategy plugin)** | Define roles (e.g. Viewer, Developer, Admin), assign roles to users/groups, map roles to permissions; easier to manage at scale. |

---

## 6. Comparison table

### Security realms (Authn)

| Realm | Ease of setup | IdP / corporate identity | Best for |
|-------|----------------|---------------------------|----------|
| **Jenkins user database** | Easy | No | Small teams, PoC, demos |
| **LDAP** | Medium | Yes (AD/LDAP) | Corporate directory already in use |
| **SAML 2.0** | Medium–Hard | Yes (SAML IdP) | Enterprise SSO |
| **OAuth / OIDC** | Medium (plugin) | Yes (Google, GitHub, etc.) | Cloud/developer IdP |

### Authorization strategies (Authz)

| Strategy | Granularity | Ease of management | Best for |
|----------|-------------|--------------------|----------|
| **Logged-in users can do anything** | None | Trivial | Not for production |
| **Matrix-based** | Overall only | Manual per user/group | Small user set |
| **Project-based Matrix** | Per job + Overall | More config, flexible | Per-project isolation |
| **Role-based (Role Strategy)** | Roles → permissions | Central roles, easier at scale | Multiple teams, shared Jenkins |

---

## 7. Best practices

| Practice | Description |
|----------|-------------|
| **Never use “Anyone can do anything”** | Always enable authentication in production. |
| **Prefer IdP integration** | Use LDAP or SAML/OAuth so one corporate identity is used; avoid local-only accounts where possible. |
| **Use least privilege** | Grant only the permissions needed (e.g. run builds, not “Administer”) for each role or group. |
| **Prefer Role-Based Strategy for multiple teams** | Define roles (Viewer, Developer, Release) and assign to groups; easier than maintaining a large matrix. |
| **Use project-based permissions when sharing Jenkins** | Restrict job access per project so teams only see/run their pipelines. |
| **Secure credentials** | Store secrets in Jenkins Credentials or external vault; limit who can create/use credentials. |
| **Service accounts** | Use dedicated service users or API tokens for CI/CD integration; avoid personal accounts for automation. |
| **Audit** | Enable audit logging (plugin or access logs) and review who changed jobs or system config. |
| **Regular review** | Periodically review user list and permissions; remove or downgrade unused accounts. |

---

## 8. Recommendation / Conclusion

**Authentication:** Prefer a **Security Realm** that integrates with your organisation’s identity (LDAP or SAML/OIDC) so Jenkins uses the same identities as VCS and other tools. Use Jenkins’ own user database only for small or isolated setups.

**Authorization:** Avoid “Logged-in users can do anything” in production. Use **Matrix-based** or **Project-based Matrix** for simple cases; use the **Role-Based Strategy** plugin when multiple teams share Jenkins and you need clear roles (Viewer, Developer, Admin). Apply least privilege and restrict job-level access where needed.

Together, Authn and Authz ensure only the right people can access Jenkins and perform only the actions they need. For implementation details and plugin setup, refer to the **References** below.

---

## 9. Contact Information


| Name|Email Address |
|----------------|----------------|
|Mukesh kumar Sharma|msmukeshkumarsharma95@gmail.com|


---

## 10. References

| Link | Description |
|------|-------------|
| [Jenkins – Securing Jenkins](https://www.jenkins.io/doc/book/security/) | Official guide to Jenkins security. |
| [Jenkins – Authentication](https://www.jenkins.io/doc/book/security/authentication/) | Security realms and authentication options. |
| [Jenkins – Authorization](https://www.jenkins.io/doc/book/security/authorization/) | Authorization strategies. |
| [Role-based Authorization Strategy plugin](https://plugins.jenkins.io/role-based-authorization-strategy/) | Role-based Authz plugin. |
| [SAML Plugin](https://plugins.jenkins.io/saml/) | SAML 2.0 SSO for Jenkins. |
| [LDAP Plugin](https://plugins.jenkins.io/ldap/) | LDAP/AD integration. |

---
