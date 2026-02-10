# Commit Hooks Recommendation

**Detailed recommendations on which commit hooks to implement: linting, formatting, tests, security, and commit message standards.**

---

| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 03-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  |  |  |  |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Why Use Commit Hooks](#2-why-use-commit-hooks)
3. [Git Hook Types](#3-git-hook-types)
4. [Recommended Hooks by Category](#4-recommended-hooks-by-category)
   - 4.1 [Linting](#41-linting)
   - 4.2 [Formatting](#42-formatting)
   - 4.3 [Tests](#43-tests)
   - 4.4 [Security and secrets](#44-security-and-secrets)
   - 4.5 [Commit message](#45-commit-message)
5. [Tools to Manage Hooks](#5-tools-to-manage-hooks)
6. [Advantages and Disadvantages](#6-advantages-and-disadvantages)
7. [Best Practices](#7-best-practices)
8. [Conclusion](#8-conclusion)
9. [Contact Information](#9-contact-information)
10. [References](#10-references)

---

## 1. Introduction

**Commit hooks** (often called **Git hooks**) are scripts that run automatically at certain points in the Git workflow—for example before a commit is created (*pre-commit*) or before a push (*pre-push*). They can block the action if a check fails (e.g. lint or tests) or simply warn. Hooks run locally on the developer’s machine and help catch issues before code is pushed or reviewed.

This document gives **detailed recommendations** on which hooks to implement: linting, formatting, tests, security (e.g. secret detection), and commit message rules. It covers common hook types, suggested checks per category, tools to manage hooks (e.g. pre-commit framework), trade-offs, and best practices so teams can adopt a consistent, maintainable hook setup.

---

## 2. Why Use Commit Hooks

| Reason | Description |
|--------|-------------|
| **Catch issues early** | Fail fast on lint, format, or tests before code is pushed or merged; reduces back-and-forth in review. |
| **Enforce standards** | Ensure code style and commit message format are consistent without relying only on reviewers. |
| **Prevent sensitive data** | Block commits that contain secrets, keys, or tokens so they do not enter the repo. |
| **Keep main branch green** | Run tests (or a subset) before push so broken code is less likely to reach the remote. |
| **Document and automate** | Hooks encode team rules in the repo (e.g. `.pre-commit-config.yaml`) so everyone gets the same checks. |

Hooks are a first line of defence; they complement (and do not replace) CI/CD and branch protection.

---

## 3. Git Hook Types

| Hook | When it runs | Typical use |
|------|----------------|-------------|
| **pre-commit** | Before the commit is created (after `git add`, before commit is recorded). | Linting, formatting, secret scanning, quick unit checks. |
| **commit-msg** | After the user writes the commit message; receives the path to the message file. | Enforce commit message format (e.g. conventional commits), length, or content. |
| **pre-push** | Before data is sent to the remote. | Run tests, integration checks, or heavier checks that are too slow for every commit. |
| **post-commit** | After the commit is created. | Notifications, logging; rarely used to block. |
| **post-merge** | After a merge completes. | Install dependencies, update generated files; optional. |

**Recommendation:** Start with **pre-commit** (lint, format, secrets) and **commit-msg** (message format). Add **pre-push** for tests or heavier checks if pre-commit stays fast.

---

## 4. Recommended Hooks by Category

### 4.1 Linting

Run linters on changed files to catch bugs and style violations before commit.

| Recommendation | Tool examples | Hook | Notes |
|----------------|---------------|------|-------|
| **Use a language-appropriate linter** | ESLint (JS/TS), Pylint / Ruff (Python), RuboCop (Ruby), golangci-lint (Go) | pre-commit | Lint only staged (or changed) files to keep runs fast. |
| **Fail on errors; optionally warn on style** | Configure linter to error on real issues; style can be format-only (see 4.2). | pre-commit | Avoid duplicate rules between linter and formatter. |
| **Share config in repo** | Commit `.eslintrc`, `pyproject.toml`, etc. so everyone and CI use the same rules. | — | Hooks and CI should use the same config. |

**Example (pre-commit, Python):** Run `ruff check` or `pylint` on staged `.py` files. For JS/TS, run `eslint` on staged files.

---

### 4.2 Formatting

Auto-format code so the repo stays consistent without manual style debates.

| Recommendation | Tool examples | Hook | Notes |
|----------------|---------------|------|-------|
| **Use a formatter** | Black (Python), Prettier (JS/TS/JSON/CSS), gofmt (Go), rustfmt (Rust) | pre-commit | Run formatter on staged files; auto-fix and re-stage so commit contains formatted code. |
| **Format and then commit** | Formatter runs, modifies files, hook re-stages; developer amends or commits again. | pre-commit | Reduces “format only” commits if formatter is fast and always applied. |
| **Match CI** | CI runs the same formatter (e.g. `black --check`) so unformatted code never passes. | — | Pre-commit fixes; CI checks. |

**Example (pre-commit):** Run `black .` or `prettier --write` on staged files and re-add them so the commit is formatted.

---

### 4.3 Tests

Run tests to avoid pushing obviously broken code.

| Recommendation | What to run | Hook | Notes |
|----------------|-------------|------|-------|
| **Fast tests on commit** | Unit tests for changed modules or a small smoke suite; keep under a few tens of seconds. | pre-commit (optional) | If slow, developers will bypass or disable; prefer fast subset. |
| **Full test suite on push** | Full unit + integration (or a larger subset) before push. | pre-push | Pre-push can take longer; still local feedback before CI. |
| **Only run affected tests if possible** | Use tools that run tests for changed files (e.g. Jest `--findRelatedTests`, pytest with selection). | pre-commit / pre-push | Speeds up feedback. |

**Recommendation:** Prefer **pre-push** for tests unless the suite is very fast; use **pre-commit** only for a minimal smoke check if at all.

---

### 4.4 Security and secrets

Prevent credentials, API keys, and tokens from being committed.

| Recommendation | Tool examples | Hook | Notes |
|----------------|---------------|------|-------|
| **Scan for secrets** | detect-secrets, gitleaks, truffleHog, git-secrets | pre-commit | Scan staged (or all) files; block commit if secrets detected. |
| **Block high-confidence matches** | Tune to reduce false positives but still block real secrets. | pre-commit | Whitelist known false positives (e.g. test fixtures) in config. |
| **Use allowlists** | Document and allow specific patterns (e.g. example keys in docs) so hooks stay usable. | — | Rotate any real secret that was ever committed. |

**Example (pre-commit):** Run `detect-secrets scan` or `gitleaks protect --staged`; fail if new secrets are found.

---

### 4.5 Commit message

Enforce structure and clarity of commit messages for history and tooling (changelogs, semantic versioning).

| Recommendation | Rule examples | Hook | Notes |
|----------------|---------------|------|-------|
| **Conventional Commits** | Format: `type(scope): description` (e.g. `feat(auth): add login`). Types: feat, fix, docs, style, refactor, test, chore. | commit-msg | Enables changelog generation and semantic versioning. |
| **Min/max length** | Require a subject line (e.g. 50–72 chars); optional body and footer. | commit-msg | Prevents empty or one-word messages; keeps subject scannable. |
| **No WIP / TODO as final message** | Optionally reject common placeholder text in main branch; allow in feature branches if desired. | commit-msg | Configurable by team. |

**Example (commit-msg):** Use `commitlint` or a small script that reads the message file and validates format (e.g. regex for conventional commits and length).

---

## 5. Tools to Manage Hooks

Using a framework keeps hooks consistent across the team and version-controlled.

| Tool | Description | Best for |
|------|-------------|----------|
| **pre-commit** (Python) | Framework for managing Git hooks; config in `.pre-commit-config.yaml`; many built-in hooks (lint, format, secrets). | Multi-language repos; teams wanting one config file for pre-commit and commit-msg. |
| **Husky** (Node) | Manages Git hooks in Node projects; often used with lint-staged. | JavaScript/TypeScript projects. |
| **lint-staged** | Runs commands only on staged files; pairs with Husky or others. | Keeping pre-commit fast by not linting the whole repo. |
| **Lefthook** | Fast hook manager (Go); config in `lefthook.yml`; supports pre-commit, commit-msg, pre-push. | Teams wanting a single, fast manager. |
| **Native Git hooks** | Scripts in `.git/hooks/`; not committed. | Simple setups; no framework. |

**Recommendation:** Use **pre-commit** or **Lefthook** so hook definitions live in the repo (YAML config) and everyone gets the same checks; use **lint-staged** (or equivalent) so only staged files are processed.

---

## 6. Advantages and Disadvantages

### Advantages

| Advantage | Description |
|-----------|-------------|
| **Consistent quality** | Same lint, format, and message rules for every developer; fewer “please fix style” reviews. |
| **Faster feedback** | Issues are caught locally before push or CI; saves CI time and review cycles. |
| **Security** | Secret scanning in hooks reduces the chance of credentials in the repo. |
| **Documented policy** | Hook config in the repo documents what the team expects; onboarding is clearer. |
| **Automation** | Formatters and fixers run automatically so developers do not have to remember every rule. |

### Disadvantages / trade-offs

| Disadvantage | Description |
|--------------|-------------|
| **Can be bypassed** | Hooks run locally; developers can skip with `--no-verify` or remove hooks. CI and branch protection are still needed. |
| **Slower commits** | Heavy checks (e.g. full test suite) on every commit can annoy; prefer fast pre-commit, heavier pre-push or CI. |
| **Setup and maintenance** | New contributors must install the hook manager and dependencies; config and versions need occasional updates. |
| **False positives** | Linters or secret scanners may block valid code; tune and allowlist to keep trust. |

---

## 7. Best Practices

| Practice | Description |
|----------|-------------|
| **Keep pre-commit fast** | Run only quick checks (lint, format, secret scan) in pre-commit; move slow tests to pre-push or CI. |
| **Version hook config** | Store hook configuration in the repo (e.g. `.pre-commit-config.yaml`) and pin hook versions for reproducibility. |
| **Match CI** | Use the same linters, formatters, and rules in hooks and CI so “passes locally” means “passes in CI”. |
| **Document how to skip** | Document when and how to use `--no-verify` (e.g. emergency hotfix) and prefer fixing the hook over habitual skip. |
| **Onboard clearly** | README or CONTRIBUTING should explain how to install and run hooks (e.g. `pre-commit install`). |
| **Review hook changes** | Treat hook config changes like code: review and test so a bad hook does not block the whole team. |
| **Allowlist carefully** | For secret scanners, allowlist only known safe patterns; rotate any secret that was ever committed. |

---

## 8. Conclusion

**Commit hooks** are a practical way to enforce linting, formatting, tests, secret detection, and commit message standards before code is pushed or merged. **Recommendations:** use **pre-commit** for lint, format, and secret scanning; use **commit-msg** for conventional commits and message length; use **pre-push** for tests or heavier checks. Manage hooks with a framework (**pre-commit**, **Lefthook**, or **Husky** + **lint-staged**) so configuration is version-controlled and shared. Keep pre-commit fast, align hooks with CI, and document setup and bypass policy. Used well, hooks improve consistency and catch issues early while still relying on CI and branch protection for enforcement that cannot be bypassed locally.

---

## 9. Contact Information

| Name | Email |
|------|-------|
| Mukesh Kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 10. References

| Link | Description |
|------|-------------|
| [Git Hooks](https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks) | Official Git documentation on hooks. |
| [pre-commit](https://pre-commit.com/) | Framework for managing and sharing pre-commit hooks. |
| [Conventional Commits](https://www.conventionalcommits.org/) | Specification for commit message format. |
| [Husky](https://typicode.github.io/husky/) | Git hooks for Node.js projects. |
| [Lefthook](https://github.com/evilmartians/lefthook) | Fast Git hooks manager. |
| [detect-secrets](https://github.com/Yelp/detect-secrets) | Tool to detect secrets in the codebase. |

---
