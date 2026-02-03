# VCS (Version Control System) Setup

**Design, POC, and step-by-step setup for a Version Control System (Git) on Linux.**

Works on **Linux** and **macOS**. Uses **Git** as the reference VCS.

---

| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 03-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  |  |  |  |

## Table of Contents

1. [VCS Design & POC](#1-vcs-design--poc)
   - 1.1 [Design](#design)
   - 1.2 [POC Scope](#poc-scope)
2. [Features of VCS](#2-features-of-vcs)
3. [Prerequisites](#3-prerequisites)
4. [VCS Setup (Detailed)](#4-vcs-setup-detailed)
   - 4.1 [Step 1: Install Git](#step-1-install-git)
   - 4.2 [Step 2: Set identity (name and email)](#step-2-set-identity-name-and-email)
   - 4.3 [Step 3: (Optional) Set default branch name](#step-3-optional-set-default-branch-name)
   - 4.4 [Step 4: Create or clone a repository](#step-4-create-or-clone-a-repository)
   - 4.5 [Step 5: Add and commit files](#step-5-add-and-commit-files)
   - 4.6 [Step 6: Add a remote (optional)](#step-6-add-a-remote-optional)
   - 4.7 [Step 7: Push to remote (optional)](#step-7-push-to-remote-optional)
5. [Verification](#5-verification)
6. [Troubleshooting](#6-troubleshooting)
7. [FAQs](#7-faqs)
8. [Contact](#8-contact)
9. [References](#9-references)

---

## 1. VCS Design & POC

### Design

A **Version Control System (VCS)** tracks changes to files over time so you can recall specific versions, compare changes, and collaborate without overwriting work. This document uses **Git** as the POC (Proof of Concept) VCS.

| Design aspect | Description |
|---------------|-------------|
| **Repository** | Single folder (local or remote) holding full history of the project. |
| **Commits** | Snapshots of the working tree at a point in time; each has a unique hash. |
| **Branches** | Parallel lines of development; default branch is usually `main` or `master`. |
| **Remote** | Hosted copy (e.g. GitHub, GitLab) for backup and collaboration. |

### POC Scope

- Install and configure Git on the machine.
- Create a local repo, make a commit, and (optionally) connect to a remote.
- Confirm basic workflow: clone / add / commit / push / pull.

---

## 2. Features of VCS

| Feature | Description |
|--------|-------------|
| **History** | Full history of file changes; revert or compare any revision. |
| **Branching** | Isolate work in branches; merge when ready. |
| **Collaboration** | Multiple people work on same repo via push/pull and merge. |
| **Staging** | Choose which changes go into the next commit (add → commit). |
| **Remote sync** | Push to and pull from a remote (e.g. GitHub) for backup and sharing. |
| **Tagging** | Mark releases (e.g. `v1.0`) for easy reference. |
| **Conflict handling** | Merge conflicts surfaced and resolved before completing merge. |

---

## 3. Prerequisites

| Requirement | Notes |
|-------------|-------|
| **OS** | Linux or macOS (WSL on Windows is supported). |
| **Network** | Required only for clone, pull, push (remote operations). |
| **Permissions** | Write access to the directory where the repo will live. |

---

## 4. VCS Setup (Detailed)

Follow these steps in order. Each step states **what** to do and **why**.

### Step 1: Install Git

**What:** Install the Git package.

**Why:** Git is the VCS binary; without it you cannot run `git` commands.

**How:**

```bash
# Debian/Ubuntu
sudo apt update
sudo apt install -y git

# Fedora/RHEL
sudo dnf install -y git

# macOS
brew install git
```

---

### Step 2: Set identity (name and email)

**What:** Configure `user.name` and `user.email` for this machine.

**Why:** Every commit records an author. Without identity, Git may refuse commits or use wrong metadata.

**How:**

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

Use the same email as on your remote (e.g. GitHub) so commits link to your account.

---

### Step 3: (Optional) Set default branch name

**What:** Set the default branch name to `main`.

**Why:** Keeps naming consistent with common hosting (GitHub, GitLab) and avoids `master` if you prefer `main`.

**How:**

```bash
git config --global init.defaultBranch main
```

---

### Step 4: Create or clone a repository

**What:** Either create a new repo or clone an existing one.

**Why:** All versioned work must live inside a Git repository.

**Option A – New repo:**

```bash
mkdir my-project
cd my-project
git init
```

**Option B – Clone existing repo:**

```bash
git clone https://github.com/username/repo-name.git
cd repo-name
```

---

### Step 5: Add and commit files

**What:** Stage changes and create the first (or next) commit.

**Why:** Git only stores history for changes you explicitly stage and commit.

**How:**

```bash
# Stage all changes (or use specific paths)
git add .

# Or stage a single file
git add path/to/file

# Create a commit with a message
git commit -m "Initial commit"
```

---

### Step 6: Add a remote (optional)

**What:** Add a remote URL (e.g. GitHub) so you can push and pull.

**Why:** Enables backup and collaboration; required for push/pull to that host.

**How:**

```bash
git remote add origin https://github.com/username/repo-name.git
```

---

### Step 7: Push to remote (optional)

**What:** Upload your branch to the remote.

**Why:** Backs up work and makes it visible to others (or to you on another machine).

**How:**

```bash
git push -u origin main
```

Use `-u origin main` once so future `git push` knows where to go.

---

## 5. Verification

| Check | Command | Expected |
|-------|---------|----------|
| Git installed | `git --version` | e.g. `git version 2.x.x` |
| Identity | `git config --global user.name` | Your name |
| Identity | `git config --global user.email` | Your email |
| In a repo | `git status` | Branch name and clean/modified state |
| Remote | `git remote -v` | `origin` and URL (if added) |

---

## 6. Troubleshooting

| Issue | Solution |
|-------|----------|
| **git: command not found** | Install Git (Step 1); ensure `PATH` includes Git. |
| **Permission denied (publickey)** | Use SSH key with remote, or use HTTPS and credentials. |
| **Updates were rejected** | Pull first: `git pull origin main`, resolve conflicts, then push. |
| **Please tell me who you are** | Run Step 2: set `user.name` and `user.email`. |
| **Wrong remote URL** | `git remote set-url origin <new-url>`. |
| **Merge conflict** | 1) `git status` to see conflicted files. 2) Open each file, edit to keep correct content, remove markers `<<<<<<<`, `=======`, `>>>>>>>`. 3) `git add <file>`, then `git commit`. To abort: `git merge --abort`. |

---

## 7. FAQs

**1. Why Git and not another VCS?**  
Git is the most widely used, has strong tooling and hosting (GitHub, GitLab), and is the standard for open source and many teams.

**2. What is the difference between Git and GitHub?**  
Git is the VCS software. GitHub is a hosted service that stores Git repositories and adds collaboration features.

**3. Do I need a remote?**  
No. Local repos work without a remote; use a remote for backup and collaboration.

**4. What is `origin`?**  
Default name for the primary remote URL (e.g. your repo on GitHub). You can add more remotes with other names.

**5. Why set identity globally?**  
So every repo on this machine uses the same author info unless you override it per repo.

---

## 8. Contact

| Name | Email |
|------|--------|
| Mukesh | msmukeshkumarsharma@gmail.com |

---

## 9. References

| Link | Description |
|------|-------------|
| [Git](https://git-scm.com/) | Official Git site |
| [Git Book](https://git-scm.com/book/en/v2) | Pro Git book (free) |
| [GitHub Docs](https://docs.github.com/) | GitHub usage and Git workflows |

**Note:** This document describes **Git** as the reference VCS. **Linux** and **macOS** (or WSL) are in scope.

