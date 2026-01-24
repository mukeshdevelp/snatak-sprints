# Complete React.js Installation Guide

**Mukesh** edited this page on Jan 21, 2026 · 1 revision

| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 21-01-2026 | v1.0 | Mukesh Sharma | 21-01-2026 |  |  |  |  |

## Table of Contents

1. [What is React?](#1-what-is-react)
2. [What is React Installation?](#2-what-is-react-installation)
    
    2.1. [Installation Methods Overview](#21-installation-methods-overview)
3. [Why Multiple Installation Methods?](#3-why-multiple-installation-methods)
    
    3.1. [Benefits](#31-benefits)
    
    3.2. [Use Cases](#32-use-cases)
4. [Prerequisites](#4-prerequisites)
    
    4.1. [Step 1: Install Node.js](#41-step-1-install-nodejs)
    
    4.2. [Step 2: Choose a Package Manager](#42-step-2-choose-a-package-manager)
5. [Installation Methods](#5-installation-methods)
    
    5.1. [Method 1: Create React App (Recommended for Beginners)](#51-method-1-create-react-app-recommended-for-beginners)
    
    5.2. [Method 2: Vite (Fast and Modern)](#52-method-2-vite-fast-and-modern)
    
    5.3. [Method 3: Installation via Yarn](#53-method-3-installation-via-yarn)
6. [Software Overview](#6-software-overview)
7. [System Requirements](#7-system-requirements)
8. [Dependencies](#8-dependencies)
    
    8.1. [Run-time Dependency](#81-run-time-dependency)
    
    8.2. [Development Dependency](#82-development-dependency)
9. [Verifying Your Installation](#9-verifying-your-installation)
10. [Troubleshooting](#10-troubleshooting)
11. [FAQs](#11-faqs)
12. [Contact Information](#12-contact-information)
13. [References](#13-references)

## 1. What is React?


## 2. What is React Installation?

React installation refers to the process of setting up React.js in your development environment to start building user interfaces. This guide covers the most common ways to install React.js on Linux distributions including Ubuntu, Debian, and RedHat.

### 2.1. Installation Methods Overview

1. **Create React App**: Official tool for beginners with zero configuration (currently deprecated)
2. **Vite**: Fast build tool with modern tooling
3. **Yarn**: Alternative package manager with faster installs

## 3. Why Multiple Installation Methods?

Different installation methods serve different purposes and skill levels, allowing developers to choose the best approach for their specific needs.

### 3.1. Benefits

1. **Flexibility**: Choose the method that fits your project requirements
2. **Performance**: Vite offers faster development experience
3. **Package Management**: Yarn provides faster dependency installation

### 3.2. Use Cases

- **Beginners**: Use Create React App for easy setup
- **Experienced Developers**: Use Vite for production apps
- **Fast Package Management**: Use Yarn for faster dependency installation

## 4. Prerequisites

Before installing React, you need to have Node.js and a package manager installed on your Linux server.

### 4.1. Step 1: Install Node.js

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install -y curl
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
```
<img width="1920" height="1080" alt="Screenshot from 2026-01-23 12-30-01" src="https://github.com/user-attachments/assets/3a9a0e84-82c2-4b50-ab25-d5691b756492" />

<img width="1920" height="1080" alt="Screenshot from 2026-01-23 12-30-33" src="https://github.com/user-attachments/assets/89ec7126-88df-4bc2-b999-4095d517eca1" />

<img width="1920" height="1080" alt="Screenshot from 2026-01-23 12-30-54" src="https://github.com/user-attachments/assets/e3939953-4884-40aa-bf02-90954b47cbd3" />

**RedHat/CentOS/Fedora:**
```bash
# Install curl if not already installed
sudo dnf install -y curl

# Add NodeSource repository
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -

# Install Node.js
sudo dnf install -y nodejs
```

**Verify installation (all distributions):**
```bash
node --version
npm --version
```
<img width="1919" height="152" alt="Screenshot from 2026-01-23 12-31-27" src="https://github.com/user-attachments/assets/901e7ae1-1c72-4879-8b83-29f0c614d120" />

### 4.2. Step 2: Choose a Package Manager

You can use npm (comes with Node.js), or install alternative package managers:

**Install Yarn:**
```bash
npm install -g yarn
yarn --version
```
<img width="1919" height="193" alt="Screenshot from 2026-01-23 12-32-35" src="https://github.com/user-attachments/assets/26c8681e-52d7-4ead-9593-cbc0c75ece19" />


## 5. Installation Methods

### 5.1. Method 1: Create React App (Recommended for Beginners)

**Best for:** Beginners, learning React, standard web applications

**Installation:**
```bash
npx create-react-app my-react-app
cd my-react-app
npm start
```
<img width="1919" height="771" alt="Screenshot from 2026-01-23 12-34-39" src="https://github.com/user-attachments/assets/5fbe716a-237f-4322-ab83-1e0e79eb942a" />

<img width="1919" height="333" alt="image" src="https://github.com/user-attachments/assets/6a54fc6a-4fc9-4da8-957c-b9b74c8bb70a" />

<img width="1919" height="903" alt="image" src="https://github.com/user-attachments/assets/62f5b4d8-cf46-4072-8592-6710cd30531b" />

**Available Scripts:**
```bash
npm start          # Start development server (http://localhost:3000)
npm run build      # Build for production
npm test           # Run tests
```
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/ca35310a-2571-4c19-9fa1-d01306e6c0e7" />

### 5.2. Method 2: Vite (Fast and Modern)

**Best for:** Developers who want faster builds and modern tooling. Require node 18+.

**Installation:**
```bash
npm create vite@latest my-react-app -- --template react
cd my-react-app
npm install
npm run dev
```

**Templates:**
```bash
npm create vite@latest my-app -- --template react      # JavaScript
npm create vite@latest my-app -- --template react-ts   # TypeScript
```

### 5.3. Method 3: Installation via Yarn

**Best for:** Faster dependency installation, better dependency resolution

**Install Yarn:**
```bash
npm install -g yarn
```

**Create React App with Yarn:**
```bash
yarn create react-app my-react-app
cd my-react-app
yarn start
```
<img width="1919" height="903" alt="image" src="https://github.com/user-attachments/assets/a9dbf46b-1f33-4021-85ed-e34b96cbfb49" />
<img width="1919" height="903" alt="image" src="https://github.com/user-attachments/assets/9f0999de-e32f-4407-adf4-fc29d421b98c" />




## 6. Software Overview

| Software | Version |
|----------|---------|
| React | 18.x (latest stable) |
| React DOM | 18.x |
| Node.js | 16.x or higher (recommended) |
| npm | 8.x or higher (recommended) |
| Yarn | Latest |
| Create React App | Latest |
| Vite | Latest |

## 7. System Requirements

| Requirement | Minimum | Recommendation |
|-------------|---------|----------------|
| Node.js | 14.x | 16.x or higher |
| npm | 6.x | 8.x or higher |
| RAM | 4 GB | 8 GB or higher |
| Disk Space | 500 MB | 1 GB or higher |
| OS | Ubuntu 20.04+, Debian 10+, RHEL 8+, CentOS 8+ | Ubuntu 22.04 LTS, Debian 12, RHEL 9 |

## 8. Dependencies

### 8.1. Run-time Dependency

| Run-time Dependency | Version | Description |
|---------------------|---------|-------------|
| react | ^18.0.0 | Core React library for building user interfaces |
| react-dom | ^18.0.0 | React library for DOM rendering and manipulation |

### 8.2. Development Dependency

| Development Dependency | Version | Description |
|----------------------|---------|-------------|
| react-scripts | ^5.0.0 | Scripts and configuration used by Create React App |
| vite | Latest | Fast build tool and development server |
| @babel/core | ^7.0.0 | JavaScript compiler for transforming JSX and ES6+ code |

## 9. Verifying Your Installation

**Check React Version:**
```bash
# In your project directory
npm list react react-dom

# Or check package.json
cat package.json | grep react
```

## 10. Troubleshooting

**npm install fails:** `npm cache clean --force`, delete `node_modules` and `package-lock.json`, then `npm install`.

**Port 3000 in use:** `lsof -ti:3000 | xargs kill -9` or use `PORT=3001 npm start`.

**Command not found:** Reinstall Node.js and restart terminal.

**Permission denied:** Fix npm permissions:
```bash
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

**Module not found:** Delete `node_modules` and `package-lock.json`, then `npm install`.

## 11. FAQs

**1. Which installation method should I use?**
For beginners, use Create React App. For faster builds, use Vite. For faster package installation, use Yarn.

**2. Do I need Node.js to use React?**
Yes, Node.js is required for development on Linux servers (Ubuntu, Debian, RedHat, etc.).

**3. What is the difference between Create React App and Vite?**
Create React App uses Webpack (easier for beginners). Vite uses esbuild (faster for development).

**4. What is the latest version of React?**
React 18.x is the latest stable version.

**5. How do I update React?**
Run: `npm install react@latest react-dom@latest`

## 12. Contact Information

| Name | Email address |
|------|---------------|
| Mukesh | msmukeshkumarsharma@gmail.com |

## 13. References

| Links | Descriptions |
|-------|--------------|
| https://react.dev/ | Official React documentation |
| https://react.dev/learn | React interactive tutorial |
| https://github.com/facebook/react | React GitHub repository |
| https://vitejs.dev/ | Vite build tool documentation |
| https://yarnpkg.com/ | Yarn package manager documentation |
| https://nodejs.org/ | Node.js official website |
