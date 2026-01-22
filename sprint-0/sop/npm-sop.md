# SOPs for npm

**Mukesh** edited this page on Jan 21, 2026 · 1 revision

| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 21-01-2026 | v1.0 | Mukesh Sharma | 21-01-2026 |  |  |  |  |

## Table of Contents

1. [What is npm?](#1-what-is-npm)
    
    1.1. [Core Components](#11-core-components)
2. [Why npm?](#2-why-npm)
    
    2.1. [Benefits](#21-benefits)
    
    2.2. [Use Cases](#22-use-cases)
3. [Getting Started](#3-getting-started)
    
    3.1. [Pre-requisites](#31-pre-requisites)
    
    3.2. [Step-by-Step Installation Guide](#32-step-by-step-installation-guide)
4. [Basic Commands](#4-basic-commands)
5. [Project Setup Example](#5-project-setup-example)
6. [Configuration](#6-configuration)
7. [Software Overview](#7-software-overview)
8. [System Requirement](#8-system-requirement)
9. [Dependencies](#9-dependencies)
    
    9.1. [Run-time Dependency](#91-run-time-dependency)
    
    9.2. [Other Dependency](#92-other-dependency)
10. [Software Management](#10-software-management)
11. [Troubleshooting](#11-troubleshooting)
12. [FAQs](#12-faqs)
13. [References](#13-references)

## 1. What is npm?

npm (Node Package Manager) is the default package manager for Node.js and the world's largest software registry. It serves as both a command-line tool and an online repository that hosts millions of open-source JavaScript packages. npm enables developers to discover, install, develop, and share code packages, making it an essential tool in modern JavaScript development. It manages project dependencies, handles versioning, and automates various development tasks through scripts, significantly streamlining the software development workflow. It uses `package.json` files to track project metadata and dependencies, and `package-lock.json` files to lock specific versions for reproducible builds across different environments.

### 1.1. Core Components

1. **npm CLI**: Command-line tool to install, update, and publish packages. Provides commands like `npm install`, `npm publish`, `npm run`, and many others for package management operations.

2. **npm Registry**: Hosted repository of public JavaScript packages accessible at registry.npmjs.org. Contains millions of packages that can be installed and used in projects.

3. **package.json**: Project manifest file that describes project metadata (name, version, description), dependencies, scripts, and configuration. Serves as the blueprint for npm operations.

4. **package-lock.json**: Automatically generated file that locks the exact versions of all dependencies and their sub-dependencies. Ensures consistent installs across different machines and environments.

5. **node_modules/**: Directory where npm installs all downloaded packages and their dependencies. Contains the actual package files used by your application.

## 2. Why npm?

npm was created to solve the problem of managing JavaScript dependencies and sharing code in a standardized way. Before npm, developers had to manually download and manage JavaScript libraries, leading to version conflicts, missing dependencies, and inconsistent project setups. npm provides a centralized, reliable system for package management that has become the foundation of modern JavaScript development. It enables teams to build upon existing code, share solutions, and maintain consistent development environments across different machines and team members.

### 2.1. Benefits

1. **Bundled with Node.js**: No separate install needed once Node.js is installed. This integration ensures that every Node.js installation comes with npm ready to use, reducing setup complexity and ensuring compatibility.

2. **Massive Ecosystem**: Millions of packages available on the npm registry covering virtually every need - from web frameworks to utility libraries, build tools, testing frameworks, and more. This vast ecosystem accelerates development by providing pre-built solutions.

3. **Version Control**: Semantic versioning (semver) and lockfiles ensure reproducible builds. Developers can specify version ranges or exact versions, and `package-lock.json` ensures everyone on a team gets the same dependency versions.

4. **Scripts Automation**: Run tasks (build, test, lint, start) via `npm run`. The scripts section in `package.json` allows defining custom commands that can be executed consistently across different environments.

5. **Scoping & Security**: Scoped packages (e.g., `@company/package-name`) provide namespace organization, while `npm audit` helps identify and fix security vulnerabilities in dependencies. Provenance features ensure package authenticity.

6. **Cross-Platform**: Works consistently on Windows, macOS, and Linux, ensuring that npm-based projects can be developed and deployed across different operating systems without modification.

7. **Dependency Resolution**: Automatically resolves and installs all required dependencies and sub-dependencies, handling complex dependency trees without manual intervention.

8. **Community Support**: Large, active community providing packages, documentation, and support. The npm registry is continuously growing with new packages and updates.

### 2.2. Use Cases

1. **Installing libraries/frameworks**: Quickly add popular libraries like React, Express, Vue, Angular, or Vite to projects with a single command, along with all their dependencies.

2. **Managing build tooling**: Install and configure build tools like Webpack, Babel, ESLint, TypeScript, and other development tools that enhance the development workflow.

3. **Running project scripts**: Execute predefined scripts for common tasks like starting development servers (`npm start`), running tests (`npm test`), building for production (`npm run build`), and custom project-specific commands.

4. **Publishing packages**: Share your own code packages with the community or within your organization. npm provides tools to publish, version, and maintain packages.

5. **Managing monorepos**: Use npm workspaces to manage multiple related packages in a single repository, allowing shared dependencies and coordinated versioning across multiple projects.

6. **Development workflow automation**: Automate repetitive tasks through npm scripts, reducing manual work and ensuring consistent execution of build, test, and deployment processes.

7. **Dependency management**: Track and update project dependencies, manage version conflicts, and ensure all required packages are available and compatible.

## 3. Getting Started

### 3.1. Pre-requisites

| Requirement | Description |
|-------------|-------------|
| sudo access | Needed to install packages |
| Internet access | Required to download installers and packages |
| Shell | Terminal on Ubuntu |
| curl | To fetch install scripts (install via `sudo apt install -y curl`) |

### 3.2. Step-by-Step Installation Guide

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

## 4. Basic Commands

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

## 5. Project Setup Example

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
<img width="1920" height="933" alt="Screenshot from 2026-01-21 13-01-51" src="https://github.com/user-attachments/assets/d4d95188-839e-49d9-a0d9-34958cd9dfcf" />

<img width="1920" height="623" alt="Screenshot from 2026-01-21 13-02-02" src="https://github.com/user-attachments/assets/2a9bce78-35b3-4fb7-b519-364726b484e3" />

## 6. Configuration

```bash
#/bin/bash
npm config list                  # View current config

```
<img width="1920" height="335" alt="Screenshot from 2026-01-21 13-12-51" src="https://github.com/user-attachments/assets/87a1b5a0-e0c4-4750-a7e9-e67eab16a627" />

## 7. Software Overview

| Software | Version |
|----------|---------|
| npm | 8.x |
| Node.js | 16.x LTS |
| npx | Bundled with npm |

## 8. System Requirement

| Requirement | Minimum | Recommendation |
|-------------|---------|----------------|
| OS | Ubuntu 20.04 LTS | Ubuntu 22.04 LTS |
| RAM | 1 GB | 2 GB+ |
| Disk Space | 500 MB free | 1 GB+ |
| Network | Internet access | Stable broadband |

## 9. Dependencies

### 9.1. Run-time Dependency

| Run-time Dependency | Version | Description |
|---------------------|---------|-------------|
| node | 16.x LTS | JavaScript runtime required for npm |
| npm | 8.x | Package manager CLI |

### 9.2. Other Dependency

| Other Dependency | Version | Description |
|------------------|---------|-------------|
| curl | Latest | For fetching install scripts |
| build-essential (optional) | Latest | Compilers/tools for native addons |
| git (optional) | Latest | For cloning repositories |

## 10. Software Management

```bash
npm --version               # Check npm version
npm install -g npm@latest   # Update npm
npm cache clean --force     # Clear cache
npm config list             # View config
```



## 11. Troubleshooting

**npm: command not found**
- Ensure Node.js is installed and PATH updated; reopen terminal.

**SSL / network issues**
```bash
npm config set registry https://registry.npmjs.org/
npm cache clean --force
```


**Port in use (e.g., 3000)**
```bash
lsof -ti:3000 | xargs kill -9   
netstat -ano | findstr :3000    
```

## 12. FAQs

**1. Does npm come with Node.js?**  
Yes. Installing Node.js installs npm.

**2. How do I update npm?**

First, update Node.js to a compatible version (npm 11+ requires Node.js 20.17.0+ or 22.9.0+):

**Using NodeSource (Ubuntu)**
```bash
#!/bin/bash
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
sudo apt install -y nodejs
npm install -g npm@9

node --version
```
<img width="1920" height="454" alt="image" src="https://github.com/user-attachments/assets/bd4630cf-7580-463f-b13a-9ee4e6e54044" />


**3. How do I install a specific Node.js version?**  
Use `nvm install <version>` then `nvm use <version>` (or nvm-windows).

**4. How do I clear npm cache?**  
`npm cache clean --force`


## 13. References
| Links | Descriptions |
|-------|--------------|
| https://nodejs.org/en/download | Official Node.js download page with installation instructions |
| https://docs.npmjs.com/ | Official npm documentation and CLI reference |
| https://github.com/nvm-sh/nvm | Node Version Manager (nvm) for managing multiple Node.js versions |


