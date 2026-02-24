#  Feature document of GitLab


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 03-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  | aniruddh sir | faisal sir | ashwani sir |



---

## Table of Contents

1. [Introduction](#1-introduction)
2. [What is GitLab (for CI)](#2-what-is-gitlab-for-ci)
3. [Why use GitLab for CI](#3-why-use-gitlab-for-ci)
4. [Workflow diagram](#4-workflow-diagram)
5. [Advantages](#5-advantages)
6. [Best practices](#6-best-practices)
7. [Conclusion](#7-conclusion)
8. [Contact Information](#8-contact-information)
9. [References](#9-references)

---

## 1. Introduction

**GitLab** is a single application that provides version control (Git), collaboration, and **CI/CD orchestration** in one platform. As a CI orchestration tool, GitLab CI/CD lets you define pipelines in code (`.gitlab-ci.yml`), run jobs on GitLab Runners (self-hosted or GitLab.com), and automate build, test, and deployment. This document describes what GitLab offers for CI, why teams choose it, how the workflow looks, its advantages, and best practices so you can align on its use in the Application CI design.

---

## 2. What is GitLab (for CI)

**GitLab** in the context of CI orchestration includes:

- **GitLab CI/CD** — Pipeline engine that runs jobs defined in `.gitlab-ci.yml` (or the UI) on events such as push, merge request, or tag.
- **Pipelines** — A set of stages and jobs (e.g. build, test, deploy) that run in sequence or in parallel; each job runs on a Runner.
- **GitLab Runners** — Agents that execute jobs; can be shared or project-specific, on-premises or in the cloud (e.g. EC2 from a Generic CI AMI).
- **`.gitlab-ci.yml`** — YAML file in the repo that defines stages, jobs, scripts, and rules (e.g. run only on main, or on MRs).
- **Integration** — Tight integration with Git (same repo, same permissions); merge requests can show pipeline status and block merge until checks pass.

GitLab can be self-managed (on your infra) or used as GitLab.com (SaaS). For Application CI design, we consider GitLab as the **orchestrator** that triggers and coordinates jobs; runners may be backed by a Generic CI AMI or other compute.

---

## 3. Why use GitLab for CI

| Reason | Description |
|--------|-------------|
| **Single platform** | Git (VCS), MRs, issues, and CI in one place; fewer tools to integrate and maintain. |
| **Pipeline as code** | `.gitlab-ci.yml` in the repo; pipelines are versioned, reviewable, and consistent across branches. |
| **Merge request integration** | Pipeline status and job logs in the MR; optional "merge when pipeline succeeds" for quality gates. |
| **Flexible runners** | Use shared or dedicated runners, Docker, Kubernetes, or EC2 (e.g. autoscale from a Generic CI AMI). |
| **Visibility and audit** | Pipeline history, artifacts, and logs in one UI; useful for compliance and debugging. |
| **Ecosystem** | Built-in container registry, dependency scanning, and optional GitLab Ultimate features for security and compliance. |

---

## 4. Workflow diagram

GitLab CI fits into the application CI workflow as follows:

1. **Developer** — Pushes code or opens a merge request; GitLab receives the event.
2. **Pipeline trigger** — GitLab CI reads `.gitlab-ci.yml` and creates a pipeline (stages and jobs).
3. **Job scheduling** — Each job is assigned to an available Runner (self-hosted or GitLab.com).
4. **Runner executes** — Runner picks up the job, runs in a container or on a VM (e.g. EC2 from Generic CI AMI), runs the job script (build, test, package).
5. **Results** — Logs and artifacts are sent back to GitLab; status is updated (passed/failed).
6. **Downstream** — On success, later stages (e.g. deploy) can run; MR can be merged when pipeline succeeds.

```
[Developer: push / MR] → [GitLab] → [Parse .gitlab-ci.yml] → [Schedule jobs] → [Runner: run build/test] → [Report status & artifacts] → [Optional: deploy / merge]
```

**High-level flow:**

<img width="1043" height="545" alt="image" src="https://github.com/user-attachments/assets/0904e692-c5f8-415f-9585-c9ffa7052171" />

---

## 5. Advantages

| Advantage | Description |
|-----------|-------------|
| **Unified VCS and CI** | No separate CI server to sync with Git; same permissions and repo context. |
| **Pipeline as code** | Pipelines live in the repo; easy to branch and test pipeline changes. |
| **Scalable runners** | Add more runners or use autoscaling (e.g. with Generic CI AMI) as load grows. |
| **Artifacts and caching** | Store build outputs and caches between jobs; faster subsequent runs. |
| **Visibility** | One place to see pipeline status, logs, and history for auditing and troubleshooting. |

---

## 6. Best practices

| Practice | Description |
|----------|-------------|
| **Keep `.gitlab-ci.yml` in the repo** | Version and review pipeline changes with the code; avoid defining pipelines only in the UI. |
| **Use stages** | Define clear stages (e.g. build → test → deploy) so order and dependencies are explicit. |
| **Reuse with templates** | Use `extends` or YAML anchors to avoid duplication across jobs. |
| **Limit scope of jobs** | One job, one concern; use artifacts to pass outputs between jobs. |
| **Use rules for when to run** | Run only on relevant branches or MRs (e.g. test on MRs, deploy only on main). |
| **Secure secrets** | Use CI/CD variables (masked) or a secrets manager; never commit credentials. |
| **Runner strategy** | Use dedicated or tagged runners for sensitive jobs; shared runners for general build/test. |
| **Cache wisely** | Cache dependencies (e.g. npm, Maven) to speed up jobs; invalidate when lockfiles change. |

---

## 7. Conclusion

**GitLab** as a CI orchestration tool provides a single platform for Git and CI/CD: pipelines as code (`.gitlab-ci.yml`), MR integration, and flexible runners. Use it when you want VCS and CI in one place, pipeline-as-code, and merge gating. Combine with a **Generic CI AMI** (or similar) for consistent runner environments. Follow best practices for stages, rules, secrets, and caching to keep pipelines maintainable and secure. For implementation details, refer to the **References** below and the rest of the Application CI design docs.

---

## 8. Contact Information


| Name|Email Address |
|----------------|----------------|
|Mukesh kumar Sharma|msmukeshkumarsharma95@gmail.com|


---

## 9. References

| Link | Description |
|------|-------------|
| [GitLab CI/CD documentation](https://docs.gitlab.com/ee/ci/) | Official GitLab CI/CD docs. |
| [GitLab `.gitlab-ci.yml` reference](https://docs.gitlab.com/ee/ci/yaml/) | Syntax and options for pipeline definition. |
| [GitLab Runner](https://docs.gitlab.com/runner/) | Install and configure Runners. |
| [GitLab Runner autoscaling](https://docs.gitlab.com/runner/configuration/autoscale.html) | Autoscale runners (e.g. with EC2/AMI). |
| [Generic CI AMI](generic_ci_ami.md) | Generic CI AMI in this repo (runner image context). |

---
