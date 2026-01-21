# SOPs for npm

**Mukesh** edited this page on Jan 21, 2026 · 1 revision

| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 21-01-2026 | v1.0 | Mukesh Sharma | 21-01-2026 |  |  |  |  |

## Table of Contents

- [What is npm?](#what-is-npm)
  - [Definition](#definition)
  - [Core Components](#core-components)
- [Why npm?](#why-npm)
  - [Benefits](#benefits)
  - [Use Cases](#use-cases)
- [Getting Started](#getting-started)
  - [Pre-requisites](#pre-requisites)
  - [Step-by-Step Installation Guide](#step-by-step-installation-guide)
- [Basic Commands](#basic-commands)
- [Project Setup Example](#project-setup-example)
- [Configuration](#configuration)
- [Software Overview](#software-overview)
- [System Requirement](#system-requirement)
- [Dependencies](#dependencies)
  - [Run-time Dependency](#run-time-dependency)
  - [Other Dependency](#other-dependency)
- [Software Management](#software-management)
- [Services](#services)
- [Process Management](#process-management)
- [Troubleshooting](#troubleshooting)
- [FAQs](#faqs)
- [References](#references)

## What is npm?

npm (Node Package Manager) is the default package manager for Node.js. It installs, updates, and manages JavaScript dependencies for projects, and provides a registry of open-source packages.

### Definition

npm is a CLI tool that works with the npm registry to install and publish JavaScript packages. It ships by default with Node.js.

### Core Components

1. **npm CLI**: Command-line tool to install, update, and publish packages.
2. **npm Registry**: Hosted repository of public JavaScript packages.
3. **package.json**: Project manifest describing metadata, scripts, and dependencies.
4. **package-lock.json**: Locked dependency tree ensuring reproducible installs.
5. **node_modules/**: Downloaded dependencies installed locally per project.

## Why npm?

npm simplifies installing and sharing JavaScript packages, provides version control of dependencies, and automates common tasks via scripts.

### Benefits

1. **Bundled with Node.js**: No separate install needed once Node.js is installed.
2. **Massive Ecosystem**: Millions of packages available on the npm registry.
3. **Version Control**: Semantic versioning and lockfiles for reproducible builds.
4. **Scripts Automation**: Run tasks (build, test, lint) via `npm run`.
5. **Scoping & Security**: Scoped packages, audit, and provenance features.
6. **Cross-Platform**: Works on Windows, macOS, and Linux.

### Use Cases

1. Installing libraries/frameworks (React, Express, Vite).
2. Managing build tooling (Webpack, Babel, ESLint, TypeScript).
3. Running project scripts (dev server, tests, builds).
4. Publishing internal or public packages.
5. Managing monorepos with workspaces.

## Getting Started

### Pre-requisites (Ubuntu)

| Requirement | Description |
|-------------|-------------|
| sudo access | Needed to install packages |
| Internet access | Required to download installers and packages |
| Shell | Terminal on Ubuntu |
| curl | To fetch install scripts (install via `sudo apt install -y curl`) |

### Step-by-Step Installation Guide (Ubuntu)

#### Option A: Install via NodeSource (includes npm) — Recommended

```bash
sudo apt update
sudo apt install -y curl
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt install -y nodejs

# Verify
node --version
npm --version
```
<img width="1908" height="885" alt="Screenshot from 2026-01-21 12-19-21" src="https://github.com/user-attachments/assets/67340358-bb32-4d3b-8d39-0dff830e89ca" />

<img width="1908" height="885" alt="Screenshot from 2026-01-21 12-26-50" src="https://github.com/user-attachments/assets/93c8250b-4290-4b41-9f39-76d3a3575f08" />

<img width="1908" height="577" alt="image" src="https://github.com/user-attachments/assets/2bdee003-ec57-4ea6-a7b1-e7b08dbcfef5" />

<img width="1919" height="117" alt="Screenshot from 2026-01-21 12-28-59" src="https://github.com/user-attachments/assets/bbf2bc92-b37d-4310-a325-c2b6486a766f" />

#### Option B: Install via nvm (Node Version Manager) — Flexible

```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.nvm/nvm.sh

# Install Node.js 16.x (includes npm 8.x)
nvm install 16
nvm use 16

# Verify
node --version
npm --version
```
<img width="1919" height="963" alt="Screenshot from 2026-01-21 12-32-50" src="https://github.com/user-attachments/assets/ab30ca86-89d8-4148-9ad2-8cd9b915c3b3" />

<img width="1895" height="157" alt="image" src="https://github.com/user-attachments/assets/540dd265-e699-43f8-a9ba-4ec138f42b9a" />

## Basic Commands

```bash
npm --version                    # Check npm version
npm init -y                      # Create package.json with defaults
npm install <pkg>                # Install package locally
npm install <pkg>@<version>      # Install specific version
npm install --save-dev <pkg>     # Dev dependency
npm uninstall <pkg>              # Remove package
npm update <pkg>                 # Update package
npm audit                        # Security audit
npm cache clean --force          # Clear npm cache
```
<img width="1920" height="668" alt="Screenshot from 2026-01-21 12-35-23" src="https://github.com/user-attachments/assets/39256812-2700-4534-8ec2-69e148c03c57" />

<img width="1919" height="331" alt="Screenshot from 2026-01-21 12-38-08" src="https://github.com/user-attachments/assets/071916eb-083c-4745-bb5d-684f650acaf5" />

## Project Setup Example

```bash
mkdir my-app
cd my-app
npm init -y
npm install react react-dom

# Optional: add a simple script
npm set-script start "node index.js"
```

Minimal `index.js`:
```javascript
console.log("npm project ready");
```

Run:
```bash
npm start
```

## Configuration

```bash
npm config list                  # View current config
npm config set registry https://registry.npmjs.org/
npm set-script dev "node index.js"
```

## Software Overview

| Software | Version |
|----------|---------|
| npm | 8.x |
| Node.js | 16.x LTS |
| npx | Bundled with npm |

## System Requirement

| Requirement | Minimum | Recommendation |
|-------------|---------|----------------|
| OS | Ubuntu 20.04 LTS | Ubuntu 22.04 LTS |
| RAM | 1 GB | 2 GB+ |
| Disk Space | 500 MB free | 1 GB+ |
| Network | Internet access | Stable broadband |

## Dependencies

### Run-time Dependency

| Run-time Dependency | Version | Description |
|---------------------|---------|-------------|
| node | 16.x LTS | JavaScript runtime required for npm |
| npm | 8.x | Package manager CLI |

### Other Dependency

| Other Dependency | Version | Description |
|------------------|---------|-------------|
| curl | Latest | For fetching install scripts |
| build-essential (optional) | Latest | Compilers/tools for native addons |
| git (optional) | Latest | For cloning repositories |

## Software Management

```bash
npm --version               # Check npm version
npm install -g npm@latest   # Update npm
npm cache clean --force     # Clear cache
npm config list             # View config
```

```

## Troubleshooting

**npm: command not found**
- Ensure Node.js is installed and PATH updated; reopen terminal.

**Permission errors on Linux/macOS**
```bash
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

**SSL / network issues**
```bash
npm config set registry https://registry.npmjs.org/
npm cache clean --force
```

**Port in use (e.g., 3000)**
```bash
lsof -ti:3000 | xargs kill -9   # macOS/Linux
netstat -ano | findstr :3000    # Windows (then taskkill /PID <PID> /F)
```

## FAQs

**1. Does npm come with Node.js?**  
Yes. Installing Node.js installs npm.

**2. How do I update npm?**  
`npm install -g npm@latest`

**3. How do I install a specific Node.js version?**  
Use `nvm install <version>` then `nvm use <version>` (or nvm-windows).

**4. How do I clear npm cache?**  
`npm cache clean --force`

**5. How do I set a different registry?**  
`npm config set registry <url>`

## References

- https://nodejs.org/en/download
- https://docs.npmjs.com/
- https://github.com/nvm-sh/nvm
- https://github.com/coreybutler/nvm-windows

