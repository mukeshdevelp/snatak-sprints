# Branching Strategy — Conclusion Doc

**Conclusion document on branching strategies: how to choose one and how common strategies compare.**


---

| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 03-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  |  |  |  |

## Table of Contents

1. [Intro](#1-intro)
2. [Branching strategies explained](#2-branching-strategies-explained)
3. [How to choose a branching strategy](#3-how-to-choose-a-branching-strategy)
4. [Comparison table](#4-comparison-table)
5. [Conclusion](#5-conclusion)
6. [Troubleshooting](#6-troubleshooting)
7. [FAQs](#7-faqs)
8. [Contact Information](#8-contact-information)
9. [References](#9-references)

---

## 1. Intro

- This document is a **conclusion doc**: it summarises how to choose a branching strategy and compares common approaches so you can pick or adapt one for your team.
- A **branching strategy** is a set of rules and conventions for how teams create, name, and merge branches in a version control system.
- It defines:
  - Where work happens (e.g. feature branches, release branches).
  - How changes flow (e.g. into `main` or into a release branch).
  - How often you integrate.
- Choosing a strategy affects release cadence, code review, and how much merge and conflict work you take on.

---

## 2. Branching strategies explained

This section briefly describes the common branching strategies referred to in this document.

- **1. Feature branching**
  - Work is done on branches (e.g. `feature/*`) created from `main` or `develop`.
  - Each feature is developed in isolation and merged when done.
  - Used within almost every strategy; keep branches short-lived to avoid merge debt.

- **2. Git Flow**
  - Two long-lived branches: `main` (production) and `develop` (integration).
  - Feature work in `feature/*` branches off `develop`.
  - For release: create `release/*` from `develop` for stabilisation and version bumps; merge into `main` and back into `develop` when stable.
  - Hotfixes from `main` via `hotfix/*`; merge back into both `main` and `develop`.
  - Suited to scheduled, versioned releases.

- **3. GitHub Flow**
  - Single production branch `main` plus short-lived `feature/*` branches.
  - All development branches from `main` and merges back via pull requests.
  - No separate release or develop branch; deployment typically from `main`.
  - Suited to continuous deployment and simple release models.

- **4. GitLab Flow**
  - Similar to GitHub Flow with `main` as primary branch.
  - Optional branches for environments or release lines: e.g. `production`, `release/*`, environment-specific.
  - Flexibility to add staging, pre-production, or versioned release branches without full Git Flow.

- **5. Trunk-based development**
  - Single long-lived branch (usually `main`, the “trunk”).
  - Integrate very frequently; feature branches very short-lived or work directly on trunk with feature flags.
  - Relies on strong CI/CD, automated tests, and small, frequent commits.
  - Suited to high-frequency releases and teams that can keep the main line stable.




---

## 3. How to choose a branching strategy

**Team size and structure** — Small or solo teams usually work best with fewer branches, such as GitHub Flow or trunk-based development. Large or distributed teams tend to need more structure (e.g. Git Flow or GitLab Flow) so release and feature work stay clearly separated.

**Release cadence** — If you ship often (continuous deployment or weekly releases), a single long-lived branch (trunk-based or GitHub Flow) usually fits. For scheduled releases (e.g. every few weeks or months), use a strategy with dedicated release branches, such as Git Flow, to stabilise and version before production.                                                            

**Stability vs speed** — Strategies with release branches and more gates (e.g. Git Flow) favour stability and controlled releases. Trunk-based and GitHub Flow favour speed and frequent integration; rely on feature flags and tests to keep the main line stable. Choose based on how much you need formal stabilisation versus fast delivery.

**Tooling and process** — Your CI/CD and code-review workflow should support the strategy. Trunk-based needs strong automation and short-lived branches; Git Flow needs pipelines that understand `develop`, `release/*`, and `main`. Misalignment leads to friction and workarounds.

**Existing habits** — Prefer a strategy close to what the team already does, then refine it over time (e.g. add release branches or simplify toward trunk-based) rather than a big-bang change.



---

## 4. Comparison table

| Strategy | Branches | Use case | Pros | Cons |
|----------|----------|----------|------|------|
| **Feature branching** | `feature/*` off `main`/`develop` | Per-feature isolation | Clear isolation | Long-lived branches drift from the target and cause merge debt and conflicts; keep branches short-lived (e.g. a few days). |
| **Git Flow** | `main`, `develop`, `feature/*`, `release/*`, `hotfix/*` | Scheduled, versioned releases | Clear roles; parallel releases | Many branches; heavy for small teams |
| **GitHub Flow** | `main` + short `feature/*` | CD, simple releases | Simple; one prod branch | No release branch |
| **GitLab Flow** | `main` + optional `production`, `release/*` | CD + release mix | Flexible | More branch options can lead to inconsistent use across repos or teams; document conventions so everyone follows the same rules. |
| **Trunk-based** | Single `main`; short/no feature branches | High-frequency, strong CI/CD | Fast feedback; minimal merge debt | Needs automation, feature flags |

---

## 5. Conclusion

- There is no single “best” branching strategy; the right one depends on team size, release cadence, and how much structure you need.

**Concrete choice by situation:**

| If you need… | Choose this strategy |
|---------------|----------------------|
| **Simple, fast releases (small team or CD)** | **GitHub Flow** or **trunk-based development**. Use short-lived feature branches; merge to `main` often. |
| **Scheduled releases with version numbers (e.g. quarterly)** | **Git Flow**. Use `develop` for integration, `release/*` for stabilisation, `main` for production. |
| **Mix of CD and occasional release branches** | **GitLab Flow**. Keep `main` as primary; add `release/*` or environment branches only when needed. |
| **Feature isolation without full Git Flow** | **Feature branching** on top of **GitHub Flow**: branch from `main`, keep branches short (days), merge via PR. |

**Decision rule:**

- Prefer **GitHub Flow** or **trunk-based** unless you have scheduled, versioned releases or multiple release lines—then use **Git Flow** or **GitLab Flow**.
- Use **feature branches** in all strategies; keep them **short-lived** (merge within days) to avoid merge debt.
- Align CI/CD and branch protection with your choice; revisit when team size or release cadence changes.

---

## 6. Troubleshooting

| Issue | Solution |
|-------|----------|
| **Merge conflicts on long-lived branch** | Rebase or merge from target (`main`/`develop`) often; resolve in small chunks. Prefer short-lived branches. |
| **Committed/pushed to wrong branch** | Not pushed: `git checkout correct-branch`, `git cherry-pick <commit>`, then reset wrong branch. Pushed: new branch from correct base, cherry-pick, then fix/remove wrong branch per policy. |
| **Too many stale branches** | Policy to delete merged branches; use `git branch -d`. Periodically clean remote merged branches. |
| **Unclear which branch to branch from** | Document strategy in README (e.g. features from `develop`, hotfixes from `main`). Use naming: `feature/`, `release/`, `hotfix/`. |
| **Release branch diverged from main** | Cherry-pick needed fixes into `main`. Keep release branches short-lived; merge back to `main` (and `develop`) when done. |
| **Team uses different strategies** | Agree on one; document in onboarding and review guidelines. Use branch protection and CI to enforce. |

---

## 7. FAQs

**1. Can we mix strategies (e.g. Git Flow for releases and GitHub Flow for features)?**  
Yes. Use a simplified model (e.g. GitHub Flow + optional release/hotfix). Document the hybrid so everyone follows the same rules.

**2. How long should a feature branch live?**  
Prefer a few days. Long-lived branches drift and cause merge conflicts. If work spans weeks: smaller branches or feature flags and integrate to main early.

**3. Do we need a `develop` branch?**  
Only if your strategy uses it (e.g. Git Flow). GitHub Flow and trunk-based use only `main`; skip `develop` if you don’t need a separate integration line.

**4. What if we have multiple products or versions from the same repo?**  
Use a strategy with release branches (Git Flow or GitLab Flow) so each version has a clear branch. Or: separate repos or monorepo with clear module/release mapping.

**5. How do we enforce the branching strategy?**  
Branch protection (GitHub/GitLab) so only allowed branches merge into `main` or `release/*`; CI checks for naming/base branch; document in onboarding and PR templates.

---

## 8. Contact Information

| Name | Email |
|------|--------|
| Mukesh | msmukeshkumarsharma@gmail.com |

---

## 9. References

| Link | Description |
|------|-------------|
| [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/) | Original Git Flow post (nvie) |
| [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow) | GitHub’s simple branching model |
| [GitLab Flow](https://docs.gitlab.com/ee/topics/gitlab_flow.html) | GitLab Flow and environment branches |
| [Trunk Based Development](https://trunkbaseddevelopment.com/) | Trunk-based development overview |
| [Git Book – Branching](https://git-scm.com/book/en/v2/Git-Branching-Branching-Workflows) | Git branching workflows (official book) |
