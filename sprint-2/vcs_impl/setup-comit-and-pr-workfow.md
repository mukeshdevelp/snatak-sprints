# Setup Commit & PR (Pull Request) Workflow
<<<<<<< HEAD

=======
>>>>>>> 4fbda50bf65e01ac8e7f9c6269829a53b0b04e96


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 20-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  | aniruddh sir | faisal sir | ashwani sir |




---



## Table of Contents

1. [Introduction](#1-introduction)
2. [Workflow diagram](#2-workflow-diagram)
3. [Setting up a PR](#3-setting-up-a-pr)
   - 3.1 [Step-by-step guide to create a commit](#31-step-by-step-guide-to-create-a-commit)
   - 3.2 [Steps to create a PR](#32-steps-to-create-a-pr)
   - 3.3 [Merge a PR](#33-merge-a-pr)
4. [Conclusion](#4-conclusion)
5. [FAQ](#5-faq)
6. [Contact Information](#6-contact-information)
7. [References](#7-references)

---

## 1. Introduction

A **Pull Request (PR)** is a request to merge changes from one branch (e.g. a feature branch) into another (e.g. `main`). It allows the team to review the code, run automated checks (e.g. CI), and discuss changes before the merge. Once approved, the target branch is updated with the proposed commits.

The VCS (Version Control System) setup uses a **feature-branch** model: work is done on branches named `feature-XXX` (where XXX is a ticket or feature identifier) and merged into `main` via **Pull Requests (PRs)**. This document gives:

- **Workflow diagram** — End-to-end flow from branch to merge.
- **Setting up a PR** — Step-by-step guide to create a commit (with all Git commands), steps to create a PR, and merge a PR.

---

## 2. Workflow diagram

End-to-end flow for the commit and Pull Request workflow:

```
[main] → [Checkout main & pull] → [Create feature-XXX] → [Make changes] → [Stage & commit] → [Push feature-XXX]
    → [Open PR (feature-XXX → main)] → [Review & CI] → [Merge PR] → [main updated] → [Delete feature branch (optional)]
```

| Stage | Description |
|-------|-------------|
| **Checkout main & pull** | Get latest `main` from remote. |
| **Create feature-XXX** | Create and switch to a feature branch from `main`. |
| **Make changes** | Edit files in the working directory. |
| **Stage & commit** | `git add` and `git commit` with a clear message. |
| **Push feature-XXX** | Push the branch to remote; set upstream if first push. |
| **Open PR** | In VCS UI, create a PR from `feature-XXX` to `main`. |
| **Review & CI** | Code review and automated checks (e.g. Jenkins) run. |
| **Merge PR** | Authorised person merges the PR into `main`. |
| **main updated** | Target branch now includes the changes. |
| **Delete feature branch** | Optionally remove the feature branch after merge. |

---

## 3. Setting up a PR

### 3.1 Step-by-step guide to create a commit

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



```

**Step 8 — Open a Pull Request** in the VCS UI (GitHub, GitLab, etc.): create a PR with **source branch** = `feature-XXX` and **target branch** = `main`.

### 3.2 Steps to create a PR

1. **Ensure your feature branch is ready** — All commits are pushed; branch is up to date with `main` (rebase or merge from `main` if needed).
2. **Open the PR** — In the VCS UI (e.g. GitHub, GitLab), create a new Pull Request. Set **source branch** to your `feature-XXX` branch and **target branch** to `main`.
3. **Fill in the PR description** — Summarise what changed, why, and how to verify (e.g. testing steps, screenshots). Link any related tickets or issues.


<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/8a6a130b-53c3-4185-a4be-d7a09c2c8e38" />

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/57c51841-851e-4a0a-b428-8bf476f8bac5" />
<<<<<<< HEAD

### 3.3 Merge a PR

1. **Ensure the PR is approved** — Required reviewers have approved the PR as per team policy.
2. **Ensure CI and checks pass** — All required status checks (e.g. Jenkins build, lint, tests) are green.
3. **Resolve any conflicts** — If `main` has moved ahead, update the feature branch (merge or rebase from `main`) and resolve conflicts; push the updated branch.
4. **Perform the merge** — In the VCS UI (GitHub, GitLab, etc.), use the **Merge** button. Choose merge type if prompted (e.g. **Create a merge commit**, **Squash and merge**, or **Rebase and merge**) as per team preference.
5. **Confirm target branch** — Ensure the target branch is `main` (or the intended branch). Complete the merge.
6. **Clean up (optional)** — Delete the feature branch after merge to keep the repo tidy; the PR page often offers a shortcut to delete the branch.


=======
>>>>>>> 4fbda50bf65e01ac8e7f9c6269829a53b0b04e96

---

## 4. Conclusion

Use a **feature branch** (`feature-XXX`) for all changes; commit and push with the Git commands in [Setting up a PR](#3-setting-up-a-pr). Open a **Pull Request** from the feature branch to `main`, get reviews and required checks (e.g. Jenkins), then have an authorised person (e.g. Lead) merge using [Merge a PR](#33-merge-a-pr) and clean up the branch. Following this workflow keeps `main` stable and makes every change traceable via PR history.

---

## 5. FAQ

**1. What if I committed to the wrong branch?**  
If not yet pushed: switch to the correct branch (`git checkout correct-branch`), cherry-pick the commit (`git cherry-pick <commit>`), then reset or remove the commit from the wrong branch. If already pushed: create a branch from the correct base, cherry-pick the commit there, and fix or remove the wrong branch as per team policy.

**2. What if I have merge conflicts when updating my feature branch with main?**  
Resolve conflicts in the files shown by Git after `git merge origin/main` or during `git rebase origin/main`. Edit the conflicting files, then `git add` them and run `git merge --continue` or `git rebase --continue`. If you rebased, use `git push --force-with-lease` (only on your own feature branch).

**3. Who can merge the PR?**  
Only the **Lead** or an authorised maintainer should perform the merge into `main`, as per the acceptance criteria. Branch protection can restrict merge to specific roles. See [Merge a PR](#33-merge-a-pr) for the merge steps.

**4. Do I have to use rebase or can I merge main into my branch?**  
Either is fine. Rebase keeps a linear history; merging main into your branch creates a merge commit. Follow your team's preference. Before opening a PR, ensure your branch is up to date with `main` using one of these methods.

---

## 6. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 7. References

| Link | Description |
|------|-------------|
| [GitHub – GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow) | GitHub's branch and PR workflow. |
| [GitHub – Creating a pull request](https://docs.github.com/en/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request) | How to create a PR on GitHub. |
| [GitLab – Merge requests](https://docs.gitlab.com/ee/user/project/merge_requests/) | GitLab merge request workflow. |
| [Git – Branching and merging](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging) | Git branching and merge basics. |

---
