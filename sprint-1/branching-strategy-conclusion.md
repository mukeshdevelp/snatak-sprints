# Branching Strategy — Conclusion Doc

**Conclusion document on branching strategies: how to choose one and how common strategies compare.**


---

| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 03-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  |  |  |  |

## Table of Contents

1. [Intro](#1-intro)
2. [How to choose a branching strategy](#2-how-to-choose-a-branching-strategy)
3. [Comparison table](#3-comparison-table)
4. [Conclusion](#4-conclusion)
5. [Troubleshooting](#5-troubleshooting)
6. [FAQs](#6-faqs)
7. [Contact Information](#7-contact-information)
8. [References](#8-references)

---

## 1. Intro

A **branching strategy** is a set of rules and conventions for how teams create, name, and merge branches in a version control system. It defines where work happens (e.g. feature branches, release branches), how changes flow (e.g. into `main` or into a release branch), and how often you integrate. Choosing a strategy affects release cadence, code review, and how much merge and conflict work you take on.

This document is a **conclusion doc**: it summarises how to choose a branching strategy and compares common approaches so you can pick or adapt one for your team.

---

## 2. How to choose a branching strategy

**1. Team size and structure** — Small teams or solo developers often prefer fewer branches (e.g. GitHub Flow or trunk-based). Large or distributed teams may need more structure (e.g. Git Flow or GitLab Flow) so release and feature work stay clear.

**2. Release cadence** — If you ship often (continuous deployment or multiple releases per week), a simple model with a single long-lived branch (e.g. trunk-based or GitHub Flow) usually fits. If you have scheduled releases (e.g. every few weeks or months), a strategy with dedicated release branches (e.g. Git Flow) can help stabilise and version code.

**3. Stability vs speed** — Strategies with release branches and more gates (e.g. Git Flow) favour stability and controlled releases. Trunk-based or GitHub Flow favour speed and frequent integration; they rely on feature flags, tests, and small changes to keep the main line stable.

**4. Tooling and process** — Your CI/CD, code review, and ticket workflow should support the strategy. For example, trunk-based needs strong automation and short-lived branches; Git Flow needs pipelines that understand `develop`, `release/*`, and `main`.

**5. Existing habits** — Ease of adoption matters. Prefer a strategy that is close to what the team already does, then refine (e.g. add release branches or simplify to trunk-based) rather than a big-bang change.

**Summary:** Match the strategy to team size, release cadence, and how much structure you need; then align tooling and process so the strategy is sustainable.

---

## 3. Comparison table

| Strategy | Branches | Use case | Pros | Cons |
|----------|----------|----------|------|------|
| **Feature branching** | Long-lived `feature/*` off `main` or `develop`; merge when done | Any workflow; isolate work per feature | Clear feature isolation; easy per-branch reasoning | Long-lived → merge debt and conflicts; keep short |
| **Git Flow** | `main`, `develop`, `feature/*`, `release/*`, `hotfix/*` | Scheduled, versioned releases | Clear roles; multiple releases in parallel | Many branches; heavy for small teams |
| **GitHub Flow** | `main` + short-lived `feature/*` | CD, simple releases | Simple; one production branch | No release branch; less for versioned stabilisation |
| **GitLab Flow** | `main` + optional `production`, `release/*`, env branches | CD + release mix; staging→production | Flexible; add branches as needed | More choices → possible inconsistency |
| **Trunk-based** | Single `main`; very short-lived or no feature branches | High-frequency releases, strong CI/CD | Fast feedback; minimal merge debt | Needs automation, feature flags, discipline |
| **One-flow** | `main` + short-lived branches; optional `release/*` | Between GitHub and Git Flow | Fewer branches than Git Flow; release line when needed | Less standardised than “named” strategies; team must agree on rules |

---

## 4. Conclusion

- There is no single “best” branching strategy; the right one depends on team size, release cadence, and how much structure you need.

**Concrete choice by situation:**

| If you need… | Choose this strategy |
|---------------|----------------------|
| **Simple, fast releases (small team or CD)** | **GitHub Flow** or **trunk-based development**. Use short-lived feature branches; merge to `main` often. |
| **Scheduled releases with version numbers (e.g. quarterly)** | **Git Flow**. Use `develop` for integration, `release/*` for stabilisation, `main` for production. |
| **Mix of CD and occasional release branches** | **GitLab Flow** or **One-flow**. Keep `main` as primary; add `release/*` or environment branches only when needed. |
| **Feature isolation without full Git Flow** | **Feature branching** on top of **GitHub Flow**: branch from `main`, keep branches short (days), merge via PR. |

**Decision rule:** Prefer **GitHub Flow** or **trunk-based** unless you have scheduled, versioned releases or multiple release lines—then use **Git Flow** or **GitLab Flow**. Use **feature branches** in all strategies, but keep them **short-lived** (merge within days) to avoid merge debt. Align CI/CD and branch protection with your choice, and revisit when team size or release cadence changes.

---

## 5. Troubleshooting

| Issue | Solution |
|-------|----------|
| **Merge conflicts when merging a long-lived branch** | Rebase or merge from the target branch (e.g. `main` or `develop`) into your branch often; resolve conflicts in small chunks. Prefer short-lived branches to reduce conflict scope. |
| **Committed or pushed to the wrong branch** | If not yet pushed: `git checkout correct-branch` then `git cherry-pick <commit>`, and reset or drop the commit on the wrong branch. If pushed: create a new branch from the correct base, cherry-pick the commit, then fix or remove the wrong branch as per team policy. |
| **Too many stale branches** | Define a policy for deleting merged branches; use `git branch -d` for merged branches. Periodically list remote branches and remove those that are merged and no longer needed. |
| **Unclear which branch to create work from** | Document the strategy (e.g. “features from `develop`”, “hotfixes from `main`”) in a README or wiki. Use branch naming conventions (e.g. `feature/`, `release/`, `hotfix/`) so purpose is clear. |
| **Release branch has diverged from main** | Merge or cherry-pick only the fixes you need from the release branch into `main`. For future releases, keep the release branch short-lived and merge back to `main` (and optionally `develop`) when done. |
| **Team members use different strategies** | Agree on one strategy and document it; add it to onboarding and code review guidelines. Use branch protection and CI checks to enforce merge targets and naming. |

---

## 6. FAQs

**1. Can we mix strategies (e.g. Git Flow for releases and GitHub Flow for features)?**  
Yes. Many teams use a simplified model: something like GitHub Flow for day-to-day work and an optional release or hotfix branch when they need to stabilise a version. Document the hybrid so everyone follows the same rules.

**2. How long should a feature branch live?**  
Prefer short-lived (e.g. a few days). Long-lived branches drift from the target branch and cause more merge conflicts. If work spans weeks, break it into smaller branches or use feature flags and integrate to the main branch early.

**3. Do we need a `develop` branch?**  
Only if your strategy uses it (e.g. Git Flow). GitHub Flow and trunk-based use only `main`. If you do not need a separate integration line before production, you can skip `develop`.

**4. What if we have multiple products or versions from the same repo?**  
Use a strategy that supports release branches (e.g. Git Flow or GitLab Flow) so each version has a clear branch. Alternatively, use separate repos or monorepo with clear module/release mapping.

**5. How do we enforce the branching strategy?**  
Use branch protection rules (e.g. on GitHub/GitLab) so only allowed branches can be merged into `main` or `release/*`. Add CI checks that block merges when branch naming or base branch is wrong. Document the strategy and include it in onboarding and PR templates.

---

## 7. Contact Information

| Name | Email |
|------|--------|
| Mukesh | msmukeshkumarsharma@gmail.com |

---

## 8. References

| Link | Description |
|------|-------------|
| [Git Flow](https://nvie.com/posts/a-successful-git-branching-model/) | Original Git Flow post (nvie) |
| [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow) | GitHub’s simple branching model |
| [GitLab Flow](https://docs.gitlab.com/ee/topics/gitlab_flow.html) | GitLab Flow and environment branches |
| [Trunk Based Development](https://trunkbaseddevelopment.com/) | Trunk-based development overview |
| [Git Book – Branching](https://git-scm.com/book/en/v2/Git-Branching-Branching-Workflows) | Git branching workflows (official book) |
