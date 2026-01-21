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
- [Acceptance Criteria](#acceptance-criteria)
- [Getting Started](#getting-started)
  - [Pre-requisites](#pre-requisites)
  - [Step-by-Step Installation Guide](#step-by-step-installation-guide)
- [Basic Commands](#basic-commands)
- [Project Setup Example](#project-setup-example)
- [Configuration](#configuration)
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

## Acceptance Criteria

- Provides a **step-by-step installation guide** that works on a fresh machine (Windows, macOS, Linux).
- Includes commands that can be run as-is to install Node.js and npm.
- Verifies installation with version checks.

## Getting Started

### Pre-requisites

| Requirement | Description |
|-------------|-------------|
| Administrative rights | Needed to install Node.js/npm or use package managers |
| Internet access | Required to download installers and packages |
| Shell | PowerShell (Windows), Terminal (macOS/Linux) |
| curl or package manager | For scripted installs on macOS/Linux |

### Step-by-Step Installation Guide

#### Option A: Install via Node.js (includes npm) — Recommended

**Windows (Installer)**
```powershell
# Download LTS installer from https://nodejs.org/en/download
# Run the installer, keep "Install npm" and "Add to PATH" checked.
# After install, open a NEW PowerShell and verify:
node --version
npm --version
```

**macOS (Homebrew)**
```bash
# Install Homebrew if missing
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install Node.js (includes npm)
brew install node

# Verify
node --version
npm --version
```

**Linux (Debian/Ubuntu via NodeSource)**
```bash
sudo apt update
sudo apt install -y curl
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs

# Verify
node --version
npm --version
```

#### Option B: Install via nvm (Node Version Manager) — Flexible

**macOS/Linux**
```bash
# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.nvm/nvm.sh

# Install LTS Node.js (includes npm)
nvm install --lts
nvm use --lts

# Verify
node --version
npm --version
```

**Windows**
- Install nvm-windows from: https://github.com/coreybutler/nvm-windows/releases
- Then:
```powershell
nvm install 18
nvm use 18
node --version
npm --version
```

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

