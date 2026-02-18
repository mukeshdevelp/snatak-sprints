# Authz Documentation

**Topic:** Authz documentation — Authentication and Authorization in Version Control Systems (VCS): access control, audit trails, and identity integration.

---

| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 03-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  |  |  |  |

---

## Detailed documentation

This document provides detailed **Authz documentation** for Version Control Systems (VCS). It covers the following:

| Section | Description |
|---------|-------------|
| **Introduction** | What authentication (Authn) and authorization (Authz) mean in VCS and why they matter. |
| **Why** | Reasons authn and authz are essential in VCS (security, policy, accountability, least privilege, compliance). |
| **Access Levels** | Repository and branch-level permissions (read, write, maintain, admin) and branch protection. |
| **Audit Trails** | What is logged (commits, pushes, merges, access) and how to use it for accountability and compliance. |
| **Integration with Identity Providers** | SSO, group mapping, JIT provisioning, and IdP integration with GitHub, GitLab, Bitbucket. |
| **Advantages** | Benefits of strong authz (security, traceability, controlled releases, scalability, IdP). |
| **Disadvantages** | Trade-offs (complexity, friction, IdP dependency, over-restriction). |
| **Best Practices** | One identity per person, least privilege, branch protection, MFA, service accounts, access reviews, audit retention. |
| **Conclusion** | Summary and recommendations. |
| **FAQ** | Frequently asked questions on authn, authz, access levels, audit, and IdP. |
| **Contact Information** | Author contact. |
| **References** | Links to official and standards documentation. |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Why Authorization (Authz) Matters in VCS](#2-why-authorization-authz-matters-in-vcs)
3. [Access Levels](#3-access-levels)
4. [Audit Trails](#4-audit-trails)
5. [Integration with Identity Providers](#5-integration-with-identity-providers)
6. [Advantages](#6-advantages)
7. [Disadvantages](#7-disadvantages)
8. [Best Practices](#8-best-practices)
9. [Conclusion](#9-conclusion)
10. [FAQ](#10-faq)
11. [Contact Information](#11-contact-information)
12. [References](#12-references)

---

## 1. Introduction

**Authentication (Authn)** answers “Who are you?”—it verifies the identity of a user or system (e.g. via username/password, SSH keys, or tokens). **Authorization (Authz)** answers “What are you allowed to do?”—it determines which actions an authenticated identity is permitted to perform (e.g. read a repo, push to a branch, or change settings).

In **Version Control Systems (VCS)** such as Git used with GitHub, GitLab, or Bitbucket, authn and authz control who can clone, push, create branches, open pull requests, merge, and manage the repository. This document describes access levels, audit trails, integration with identity providers (IdPs), advantages and disadvantages, and best practices so teams can design and operate secure, traceable VCS access.

---

## 2. Why Authorization (Authz) Matters in VCS

Authorization determines what each user or system is allowed to do in the repository—for example who can read, push, merge, or change settings. Clear, well-defined permissions are important for the following reasons:

| Reason | Description |
|--------|-------------|
| **Protect source code** | Repositories hold business logic and sometimes secrets. Limiting who can read or change code (via read-only, write, or admin roles) reduces the risk of unauthorized access or changes and helps avoid security and compliance issues. |
| **Enforce policy** | Branch protection, required reviews, and merge rules depend on permissions: only users with the right role can bypass or change them. Authorization ensures that only allowed people can merge to protected branches, approve PRs, or alter repo settings. |
| **Accountability** | When permissions are tied to individual identities (rather than shared accounts), every commit and merge can be attributed to someone with a known level of access. That supports traceability and review. |
| **Least privilege** | Grant only the access needed for each role—for example read-only for auditors or contractors, write for developers, admin for maintainers. Restricting permissions to what is necessary limits the impact of mistakes or compromised accounts. |


Without clear authorization, over‑broad or poorly defined permissions increase the risk of accidental or malicious misuse of the repository. Defining and enforcing roles (read, write, maintain, admin) and branch-level rules keeps access under control.

---

## 3. Access Levels

**What it is:** Each person or bot is assigned a **role** (access level) that defines what they can do in the repo. Higher roles include all abilities of lower ones. Typical levels in hosted VCS (e.g. GitHub, GitLab) are below; exact names vary by product.

| Level | Typical name | What they can do | Who typically gets it |
|-------|--------------|------------------|------------------------|
| **Read** | Read / Viewer | View and download code and history only; cannot push, change settings, or merge. | Contractors, auditors, read-only bots. |
| **Write / Push** | Write / Developer | Everything in Read, plus: push commits, create branches, open pull/merge requests. Cannot merge to protected branches or change repo settings. | Day-to-day developers, CI bots that push (e.g. version bumps). |
| **Maintain** | Maintain / Maintainer | Everything in Write, plus: merge to protected branches, manage issues and labels. Cannot change repo membership or delete the repo. | Senior devs, release managers. |
| **Admin / Owner** | Admin / Owner | Full control: change repo settings, add/remove people, configure branch protection, delete the repo. | Repo owners, platform admins. |

**Branch protection** adds another layer of authz: who can push or merge into a given branch (e.g. `main`). Common rules include:

- Require pull/merge requests and a minimum number of approvals.
- Require status checks (CI) to pass.
- Restrict who can push or merge (e.g. specific teams or roles).
- Prevent force-push and deletion of the branch.

Combining **repository-level roles** with **branch protection** gives fine-grained control (e.g. “developers can push to `develop` but only maintainers can merge into `main`”).

---

## 4. Audit Trails

An **audit trail** is a record of who did what and when. In VCS, this supports accountability, compliance, and incident response.

| What is logged | Examples |
|----------------|----------|
| **Commits** | Author, committer, timestamp, hash, branch; visible in `git log` and in the hosting UI. |
| **Push / pull** | Who pushed, when, which refs; often in server or platform logs. |
| **Merge / PR** | Who opened/merged the PR, reviewers, approvals, and comments. |
| **Access and settings** | Login events, permission changes, branch protection changes, repo creation/deletion (platform audit logs). |

**Best practices for audit:**

- Use **one identity per person** (no shared accounts) so that “who” is unambiguous.
- Rely on **platform audit logs** (e.g. GitHub/GitLab audit logs) for administrative actions and access.
- Retain logs according to policy; some products allow export or integration with SIEM for long-term retention and analysis.

---

## 5. Integration with Identity Providers

Integrating VCS with an **Identity Provider (IdP)**—such as SAML or OpenID Connect (OIDC)—centralises authentication and often authorization (e.g. group membership) so that one identity is used across tools.

| Aspect | Description |
|--------|-------------|
| **Single Sign-On (SSO)** | Users log in once at the IdP; the VCS platform trusts the IdP and does not store passwords. Reduces password sprawl and allows centralised MFA. |
| **Group / team mapping** | IdP groups (e.g. “backend-developers”) can be mapped to VCS teams or roles so that adding/removing someone in the IdP updates their VCS access. |
| **Just-in-time (JIT) provisioning** | On first login via IdP, a user can be created in the VCS with attributes (e.g. email, name) from the IdP; provisioning can be automated. |
| **Consistency** | Same identity across VCS, CI/CD, and other tools simplifies audit and access reviews. |

**Common integrations:**

- **GitHub:** SAML SSO (Enterprise), OIDC for actions; organisation and repo permissions can be tied to IdP groups.
- **GitLab:** SAML and OIDC; group sync from IdP groups; SCIM for user provisioning.
- **Bitbucket:** SAML and OIDC; group sync with Atlassian Access.

When using an IdP, define groups that match your intended VCS roles (e.g. “repo-readers”, “repo-writers”, “repo-admins”) and map them in the VCS to the appropriate access levels.

---

## 6. Advantages

Strong authorization (and authentication) in VCS brings the following benefits:

| Advantage | Description |
|-----------|-------------|
| **Security** | Only authorised users and systems can read or change code; reduced risk of insider misuse or compromised credentials. |
| **Traceability** | Every change is tied to an identity; easier to investigate issues and meet compliance. |
| **Controlled releases** | Branch protection and required reviews ensure that sensitive branches (e.g. `main`) are not changed without review. |
| **Scalability** | Role- and group-based access scales better than per-repo manual grants when many repos and people are involved. |
| **Centralised identity** | IdP integration means one place to onboard/offboard and enforce MFA; consistent identity across tools. |

---

## 7. Disadvantages

Trade-offs of strong authz (and related authn/IdP use):

| Disadvantage | Description |
|--------------|-------------|
| **Complexity** | Fine-grained roles, branch rules, and IdP sync add configuration and operational overhead. |
| **Friction** | Requiring MFA, approval workflows, or many checks can slow down development if not balanced with team needs. |
| **Dependency on IdP** | If the IdP is down or misconfigured, login or group sync can fail and block access. |
| **Over-restriction** | Too many gates or unclear ownership can lead to “who can merge?” confusion and bottlenecks. |

Balancing security and usability—e.g. strict rules on production branches but lighter ones on feature branches—helps avoid both under- and over-protection.

---

## 8. Best Practices

| Practice | Description |
|----------|-------------|
| **One identity per person** | Avoid shared accounts; use personal accounts or service accounts per system so audit trails are clear. |
| **Least privilege** | Grant the minimum role needed (read vs write vs admin); increase only when justified. |
| **Use branch protection** | Protect long-lived and release branches (e.g. `main`, `release/*`) with required reviews and CI; restrict who can merge. |
| **Enforce MFA** | Require multi-factor authentication for human users (and use tokens or deploy keys for automation). |
| **Service accounts and automation** | Use dedicated service accounts or deploy keys for CI/CD and bots; limit their scope (e.g. only needed repos). |
| **Map IdP groups to roles** | Define groups in the IdP that match VCS roles and sync them; offboard in the IdP to remove VCS access. |
| **Review access periodically** | Periodically review who has access to which repos and with what role; remove or downgrade when no longer needed. |
| **Audit log retention** | Retain platform audit logs (and export if needed) according to compliance and incident-response requirements. |
| **Document policies** | Document who gets which access level, how branch protection works, and how to request changes; include in onboarding. |

---

## 9. Conclusion

Authentication and authorization in VCS are essential for protecting source code, enforcing workflow (e.g. reviews and branch protection), and meeting compliance. Use **access levels** (read, write, maintain, admin) and **branch protection** to apply least privilege; maintain **audit trails** (commits, merges, platform logs) for accountability; and integrate with an **Identity Provider** where possible for SSO, group-based access, and consistent identity across tools. Weigh **advantages** (security, traceability, controlled releases) against **trade-offs** (complexity, friction, IdP dependency), and follow **best practices**—one identity per person, MFA, periodic access reviews—so that VCS authn and authz remain effective and maintainable as the team and repo count grow.

---

## 10. FAQ

**What is the difference between authentication and authorization?**

Authentication (authn) verifies who you are—for example via password, SSH key, or token. Authorization (authz) decides what you are allowed to do once authenticated—for example read a repo, push to a branch, or change settings. In short: authn identifies you; authz permits or denies actions.

**Why should we avoid shared accounts in VCS?**

Shared accounts make it impossible to know who made a given change. Audit trails and compliance require one identity per person (or per system for bots). Use personal accounts for humans and dedicated service accounts or deploy keys for automation.

**What access level should I give to a contractor or auditor?**

Grant the minimum needed: usually **read** (viewer) so they can clone and inspect code without being able to push or change settings. Restrict to specific repos if possible.

**How does branch protection relate to authorization?**

Branch protection is an authorization layer on top of repo roles. It defines who can push or merge into a branch (e.g. `main`), and can require pull requests, approvals, and passing CI. So even someone with write access can be blocked from merging directly to protected branches.

**What should we do if our Identity Provider (IdP) is down?**

Users may not be able to log in via SSO. Mitigate by having a documented incident process, optional fallback auth if your platform supports it, and ensuring the IdP is highly available. Plan for IdP outages in your runbooks.

**How often should we review VCS access?**

Review at least periodically (e.g. quarterly or when people change roles) and whenever someone leaves the team. Check who has admin vs write vs read on each repo and remove or downgrade access that is no longer needed.

**Do we need IdP integration for a small team?**

It is not strictly required, but IdP integration (SSO, group sync) improves security and scales better as the team grows. Small teams can start with strong MFA and clear roles; plan IdP integration when you add more people or need compliance.

---

## 11. Contact Information

| Name | Email |
|------|-------|
| Mukesh Kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 12. References

| Link | Description |
|------|-------------|
| [GitHub – Authentication](https://docs.github.com/en/authentication) | GitHub authentication (SSO, tokens, SSH). |
| [GitHub – Repository roles](https://docs.github.com/en/organizations/managing-peoples-access-to-your-organization-with-roles/repository-roles-for-an-organization) | Repository permission levels. |
| [GitLab – Authentication](https://docs.gitlab.com/ee/administration/auth/) | GitLab auth (SAML, OIDC, LDAP). |
| [GitLab – Permissions](https://docs.gitlab.com/ee/user/permissions.html) | GitLab roles and permissions. |
| [Atlassian – Bitbucket access](https://support.atlassian.com/bitbucket-cloud/docs/access-keys-and-repository-permissions/) | Bitbucket permissions and access. |
| [NIST – Access Control](https://csrc.nist.gov/projects/access-control) | NIST guidance on access control. |

---
