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

1. **Installing libraries/frameworks**: Quickly add popular libraries like React, Express, Vue, Angular, or Vite to projects with a single command, along with all their dependencies.

2. **Managing build tooling**: Install and configure build tools like Webpack, Babel, ESLint, TypeScript, and other development tools that enhance the development workflow.

3. **Running project scripts**: Execute predefined scripts for common tasks like starting development servers (`npm start`), running tests (`npm test`), building for production (`npm run build`), and custom project-specific commands.

4. **Publishing packages**: Share your own code packages with the community or within your organization. npm provides tools to publish, version, and maintain packages.

5. **Managing monorepos**: Use npm workspaces to manage multiple related packages in a single repository, allowing shared dependencies and coordinated versioning across multiple projects.

6. **Development workflow automation**: Automate repetitive tasks through npm scripts, reducing manual work and ensuring consistent execution of build, test, and deployment processes.

7. **Dependency management**: Track and update project dependencies, manage version conflicts, and ensure all required packages are available and compatible.

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
#!/bin/bash

# Create project directory
mkdir -p my-app
cd my-app
# Initialize npm project
npm init -y
# Install dependencies
npm install react react-dom
# Create index.js file
echo 'console.log("npm project ready");' > index.js
# Add start script to package.json
npm pkg set scripts.start="node index.js"
# Run the project
echo "Starting npm project..."
npm start

```

## Configuration

```bash
#/bin/bash
npm config list                  # View current config

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

First, update Node.js to a compatible version (npm 11+ requires Node.js 20.17.0+ or 22.9.0+):

**Using NodeSource (Ubuntu)**
# Update to Node.js 20.x LTS
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs

# Verify Node.js version
node --version
npm install -g npm@9


**3. How do I install a specific Node.js version?**  
Use `nvm install <version>` then `nvm use <version>` (or nvm-windows).

**4. How do I clear npm cache?**  
`npm cache clean --force`

**5. How do I set a different registry?**  
`npm config set registry <url>`

## References

| Links | Descriptions |
|-------|--------------|
| https://nodejs.org/en/download | Official Node.js download page with installation instructions |
| https://docs.npmjs.com/ | Official npm documentation and CLI reference |
| https://github.com/nvm-sh/nvm | Node Version Manager (nvm) for managing multiple Node.js versions |
| https://github.com/coreybutler/nvm-windows | nvm-windows for Windows users |

