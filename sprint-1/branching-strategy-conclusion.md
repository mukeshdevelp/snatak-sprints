# Branching Strategy — Conclusion Doc

**Conclusion document on branching strategies: how to choose one and how common strategies compare.**

Subtask: **Conclusion doc**. Applies to **Git** and similar VCS.

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

This document is a **conclusion doc**: it summarises how to choose a branching strategy and compares common approaches so you can pick or adapt one for your team.


A **branching strategy** is a set of rules and conventions for how teams create, name, and merge branches in a version control system. It defines where work happens (e.g. feature branches, release branches), how changes flow (e.g. into `main` or into a release branch), and how often you integrate. Choosing a strategy affects release cadence, code review, and how much merge and conflict work you take on.



---

## 2. How to choose a branching strategy

**Team size and structure** — Small teams or solo developers often prefer fewer branches (e.g. GitHub Flow or trunk-based). Large or distributed teams may need more structure (e.g. Git Flow or GitLab Flow) so release and feature work stay clear.

**Release cadence** — If you ship often (continuous deployment or multiple releases per week), a simple model with a single long-lived branch (e.g. trunk-based or GitHub Flow) usually fits. If you have scheduled releases (e.g. every few weeks or months), a strategy with dedicated release branches (e.g. Git Flow) can help stabilise and version code.

**Stability vs speed** — Strategies with release branches and more gates (e.g. Git Flow) favour stability and controlled releases. Trunk-based or GitHub Flow favour speed and frequent integration; they rely on feature flags, tests, and small changes to keep the main line stable.

**Tooling and process** — Your CI/CD, code review, and ticket workflow should support the strategy. For example, trunk-based needs strong automation and short-lived branches; Git Flow needs pipelines that understand `develop`, `release/*`, and `main`.

**Existing habits** — Ease of adoption matters. Prefer a strategy that is close to what the team already does, then refine (e.g. add release branches or simplify to trunk-based) rather than a big-bang change.

**Summary:** Match the strategy to team size, release cadence, and how much structure you need; then align tooling and process so the strategy is sustainable.

---

## 3. Comparison table

| Strategy | Main branches | Typical use | Pros | Cons |
|----------|----------------|-------------|------|------|
| **Git Flow** | `main`, `develop`, plus `feature/*`, `release/*`, `hotfix/*` | Scheduled releases, versioned products | Clear roles for each branch; supports multiple releases in parallel | More branches and steps; can be heavy for small teams or fast releases |
| **GitHub Flow** | `main` plus short-lived `feature/*` (or similar) | Continuous deployment, simple release model | Simple; one production branch; easy to reason about | No dedicated release branch; less structure for versioned or long stabilisation |
| **GitLab Flow** | `main` plus optional `production`, `release/*`, or environment branches | Mix of CD and release-based; staging/production promotion | Flexible; can add release or environment branches when needed | More options can mean more decisions and inconsistency |
| **Trunk-based development** | Single long-lived branch (e.g. `main`); very short-lived feature branches or none | High-frequency releases, strong CI/CD | Fast feedback; minimal merge debt; encourages small changes | Needs strong automation, feature flags, and discipline; can be hard for large or distributed teams |
| **One-flow (simplified)** | `main` plus short-lived branches; optional `release/*` for hotfixes | Teams wanting something between GitHub Flow and Git Flow | Fewer branches than Git Flow; still allows a release line when needed | Less standardised than “named” strategies; team must agree on rules |

---

## 4. Conclusion

- There is no single “best” branching strategy; the right one depends on team size, release cadence, and how much structure you need.
- **Small teams or continuous deployment** often fit **GitHub Flow** or **trunk-based development**.
- **Larger teams or scheduled, versioned releases** often benefit from **Git Flow** or **GitLab Flow** with release branches.
- Start from your current way of working, then adopt or adapt one of these models so that:
  - Integration is frequent and predictable.
  - Release and hotfix paths are clear.
  - Tooling (CI/CD, review, tickets) supports the strategy.
- Revisit the choice when team size, release frequency, or product needs change; the conclusion doc and comparison table can be used again to reassess.

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
