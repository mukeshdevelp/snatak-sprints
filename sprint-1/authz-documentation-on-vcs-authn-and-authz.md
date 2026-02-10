# Authz Documentation on VCS Authn and Authz

**Authentication (Authn) and Authorization (Authz) in Version Control Systems: access control, audit, and identity integration.**

---

| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 03-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  |  |  |  |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Why Authn and Authz Matter in VCS](#2-why-authn-and-authz-matter-in-vcs)
3. [Access Levels](#3-access-levels)
4. [Audit Trails](#4-audit-trails)
5. [Integration with Identity Providers](#5-integration-with-identity-providers)
6. [Advantages and Disadvantages](#6-advantages-and-disadvantages)
7. [Best Practices](#7-best-practices)
8. [Conclusion](#8-conclusion)
9. [Contact Information](#9-contact-information)
10. [References](#10-references)

---

## 1. Introduction

**Authentication (Authn)** answers “Who are you?”—it verifies the identity of a user or system (e.g. via username/password, SSH keys, or tokens). **Authorization (Authz)** answers “What are you allowed to do?”—it determines which actions an authenticated identity is permitted to perform (e.g. read a repo, push to a branch, or change settings).

In **Version Control Systems (VCS)** such as Git used with GitHub, GitLab, or Bitbucket, authn and authz control who can clone, push, create branches, open pull requests, merge, and manage the repository. This document describes access levels, audit trails, integration with identity providers (IdPs), trade-offs, and best practices so teams can design and operate secure, traceable VCS access.

---

## 2. Why Authn and Authz Matter in VCS

| Reason | Description |
|--------|-------------|
| **Protect source code** | Repos hold business logic and sometimes secrets; unauthorized access or changes can cause security or compliance issues. |
| **Enforce policy** | Branch protection, required reviews, and merge rules only work when identities are known and permissions are enforced. |
| **Accountability** | Every commit and merge should be attributable to an identity so that changes can be traced and reviewed. |
| **Least privilege** | Grant only the access needed for a role (e.g. read-only for external auditors, write for developers, admin for maintainers). |
| **Compliance** | Many standards (e.g. SOC 2, ISO 27001) require access control and audit logs; VCS authn/authz and audit trails support this. |

Without clear authn and authz, shared accounts, weak or missing auth, or over‑broad permissions increase the risk of accidental or malicious misuse of the repository.

---

## 3. Access Levels

Typical permission levels in hosted VCS (e.g. GitHub, GitLab) are summarised below. Exact names and options vary by product.

| Level | Typical name | Description | Common use |
|-------|--------------|-------------|------------|
| **Read** | Read / Viewer | Clone, pull, view code and history; no push or settings. | Contractors, auditors, read-only automation. |
| **Write / Push** | Write / Developer | Read plus push commits, create branches, open MRs/PRs. | Developers, CI bots that push (e.g. version bumps). |
| **Maintain** | Maintain / Maintainer | Write plus merge to protected branches, manage issues/labels. | Senior devs, release managers. |
| **Admin / Owner** | Admin / Owner | Full control: repo settings, membership, branch protection, delete repo. | Repo owners, platform admins. |

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

## 6. Advantages and Disadvantages

### Advantages of strong Authn and Authz in VCS

| Advantage | Description |
|-----------|-------------|
| **Security** | Only authorised users and systems can read or change code; reduced risk of insider misuse or compromised credentials. |
| **Traceability** | Every change is tied to an identity; easier to investigate issues and meet compliance. |
| **Controlled releases** | Branch protection and required reviews ensure that sensitive branches (e.g. `main`) are not changed without review. |
| **Scalability** | Role- and group-based access scales better than per-repo manual grants when many repos and people are involved. |
| **Centralised identity** | IdP integration means one place to onboard/offboard and enforce MFA; consistent identity across tools. |

### Disadvantages / trade-offs

| Disadvantage | Description |
|--------------|-------------|
| **Complexity** | Fine-grained roles, branch rules, and IdP sync add configuration and operational overhead. |
| **Friction** | Requiring MFA, approval workflows, or many checks can slow down development if not balanced with team needs. |
| **Dependency on IdP** | If the IdP is down or misconfigured, login or group sync can fail and block access. |
| **Over-restriction** | Too many gates or unclear ownership can lead to “who can merge?” confusion and bottlenecks. |

Balancing security and usability—e.g. strict rules on production branches but lighter ones on feature branches—helps avoid both under- and over-protection.

---

## 7. Best Practices

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

## 8. Conclusion

Authentication and authorization in VCS are essential for protecting source code, enforcing workflow (e.g. reviews and branch protection), and meeting compliance. Use **access levels** (read, write, maintain, admin) and **branch protection** to apply least privilege; maintain **audit trails** (commits, merges, platform logs) for accountability; and integrate with an **Identity Provider** where possible for SSO, group-based access, and consistent identity across tools. Weigh **advantages** (security, traceability, controlled releases) against **trade-offs** (complexity, friction, IdP dependency), and follow **best practices**—one identity per person, MFA, periodic access reviews—so that VCS authn and authz remain effective and maintainable as the team and repo count grow.

---

## 9. Contact Information

| Name | Email |
|------|-------|
| Mukesh Kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 10. References

| Link | Description |
|------|-------------|
| [GitHub – Authentication](https://docs.github.com/en/authentication) | GitHub authentication (SSO, tokens, SSH). |
| [GitHub – Repository roles](https://docs.github.com/en/organizations/managing-peoples-access-to-your-organization-with-roles/repository-roles-for-an-organization) | Repository permission levels. |
| [GitLab – Authentication](https://docs.gitlab.com/ee/administration/auth/) | GitLab auth (SAML, OIDC, LDAP). |
| [GitLab – Permissions](https://docs.gitlab.com/ee/user/permissions.html) | GitLab roles and permissions. |
| [Atlassian – Bitbucket access](https://support.atlassian.com/bitbucket-cloud/docs/access-keys-and-repository-permissions/) | Bitbucket permissions and access. |
| [NIST – Access Control](https://csrc.nist.gov/projects/access-control) | NIST guidance on access control. |

---
