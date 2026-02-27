# VCS Implementation | Setup Workflow | Setup Commit & PR (Pull Request) Workflow

This document describes the **Commit and Pull Request (PR) workflow** for VCS implementation: steps to create a PR and get it ready for merge.

---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 20-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  | aniruddh sir | faisal sir | ashwani sir |




---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Setting up a PR](#2-setting-up-a-pr)
   - 2.1 [Step-by-step guide to create a commit](#21-step-by-step-guide-to-create-a-commit)
   - 2.2 [Steps to create a PR](#22-steps-to-create-a-pr)
3. [Conclusion](#3-conclusion)
4. [FAQ](#4-faq)
5. [Contact Information](#5-contact-information)
6. [References](#6-references)

---

## 1. Introduction

A **Pull Request (PR)** is a request to merge changes from one branch (e.g. a feature branch) into another (e.g. `main`). It allows the team to review the code, run automated checks (e.g. CI), and discuss changes before the merge. Once approved, the target branch is updated with the proposed commits.

The VCS (Version Control System) setup uses a **feature-branch** model: work is done on branches named `feature-XXX` (where XXX is a ticket or feature identifier) and merged into `main` via **Pull Requests (PRs)**. This document gives:

- **Setting up a PR** — Step-by-step guide to create a commit (with all Git commands) and steps to create a PR.

---

## 2. Setting up a PR

### 2.1 Step-by-step guide to create a commit

Follow these steps and commands to work on a feature branch and prepare it for a Pull Request.

**Step 1 — Get the latest `main` (if you already have the repo):**

```bash
git checkout main
git pull origin main
```
<img width="1917" height="792" alt="image" src="https://github.com/user-attachments/assets/cd51d69e-8cd4-4650-ac3f-f74a86e41bab" />


**Step 2 — Create and switch to a feature branch (or switch to an existing one):**

```bash
# Create new branch from main (use a name like feature-123-add-login or feature-456-fix-bug)
git checkout -b feature-XXX

# Or switch to an existing feature branch
# git checkout feature-XXX
```
<img width="1917" height="254" alt="image" src="https://github.com/user-attachments/assets/236119b9-eef3-4960-8820-54911b072733" />


**Step 3 — Make your changes** in the working directory.

**Step 4 — Stage the changes you want to commit:**

```bash
# Stage all modified and new files
git add .

# Or stage specific files only
# git add path/to/file1 path/to/file2
```
<img width="1917" height="254" alt="image" src="https://github.com/user-attachments/assets/9f26157c-355a-4e6e-88df-c4c5b84bb522" />


**Step 5 — Commit with a clear, descriptive message:**

```bash
git commit -m "Short description of the change (e.g. Add login form validation)"
```
<img width="1917" height="254" alt="image" src="https://github.com/user-attachments/assets/76f924b4-8414-4881-9b68-241798bdb3c7" />

**Step 6 — Push the feature branch to the remote:**

```bash
# First push: set upstream so future pushes can use just 'git push'
git push -u origin feature-XXX

```
<img width="1917" height="716" alt="image" src="https://github.com/user-attachments/assets/d018b479-c174-4d13-ae67-7175006f65b2" />

**Step 7 — Keep the branch in sync with `main` (optional but recommended before opening a PR):**

```bash
# Fetch latest from remote
git fetch origin



# Option A: Merge main into your branch (creates a merge commit)
# git merge origin/main

```

**Step 8 — Open a Pull Request** in the VCS UI (GitHub, GitLab, etc.): create a PR with **source branch** = `feature-XXX` and **target branch** = `main`.

### 2.2 Steps to create a PR

1. **Ensure your feature branch is ready** — All commits are pushed; branch is up to date with `main` (rebase or merge from `main` if needed).
2. **Open the PR** — In the VCS UI (e.g. GitHub, GitLab), create a new Pull Request. Set **source branch** to your `feature-XXX` branch and **target branch** to `main`.
3. **Fill in the PR description** — Summarise what changed, why, and how to verify (e.g. testing steps, screenshots). Link any related tickets or issues.
4. **Request reviewers** — Add at least two reviewers. CI (e.g. Jenkins) will run automatically when the PR is opened or updated.
5. **Address review feedback** — If reviewers request changes, update the branch (commit and push), then re-request review or notify in the PR.
6. **Wait for checks** — Ensure all required status checks (e.g. Jenkins) pass and reviews are complete. The PR is then ready for merge by an authorised person (e.g. Lead).

---

## 3. Conclusion

Use a **feature branch** (`feature-XXX`) for all changes; commit and push with the Git commands in [Setting up a PR](#2-setting-up-a-pr). Open a **Pull Request** from the feature branch to `main`, get reviews and required checks (e.g. Jenkins), then have an authorised person (e.g. Lead) merge and clean up the branch. Following this workflow keeps `main` stable and makes every change traceable via PR history.

---

## 4. FAQ

**What if I committed to the wrong branch?**  
If not yet pushed: switch to the correct branch (`git checkout correct-branch`), cherry-pick the commit (`git cherry-pick <commit>`), then reset or remove the commit from the wrong branch. If already pushed: create a branch from the correct base, cherry-pick the commit there, and fix or remove the wrong branch as per team policy.

**What if I have merge conflicts when updating my feature branch with main?**  
Resolve conflicts in the files shown by Git after `git merge origin/main` or during `git rebase origin/main`. Edit the conflicting files, then `git add` them and run `git merge --continue` or `git rebase --continue`. If you rebased, use `git push --force-with-lease` (only on your own feature branch).

**Who can merge the PR?**  
Only the **Lead** or an authorised maintainer should perform the merge into `main`, as per the acceptance criteria. Branch protection can restrict merge to specific roles.

**Do I have to use rebase or can I merge main into my branch?**  
Either is fine. Rebase keeps a linear history; merging main into your branch creates a merge commit. Follow your team's preference. Before opening a PR, ensure your branch is up to date with `main` using one of these methods.

---

## 5. Contact Information


| Name|Email Address |
|----------------|----------------|
|Mukesh kumar Sharma|msmukeshkumarsharma95@gmail.com|


---

## 6. References

| Link | Description |
|------|-------------|
| [GitHub – GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow) | GitHub's branch and PR workflow. |
| [GitHub – Creating a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) | How to create a PR on GitHub. |
| [GitLab – Merge requests](https://docs.gitlab.com/ee/user/project/merge_requests/) | GitLab merge request workflow. |
| [Git – Branching and merging](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging) | Git branching and merge basics. |

---
