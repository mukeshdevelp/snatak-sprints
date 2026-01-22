# Complete React.js Installation Guide

**Mukesh** edited this page on Jan 21, 2026 · 1 revision

| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 21-01-2026 | v1.0 | Mukesh Sharma | 21-01-2026 |  |  |  |  |

## Table of Contents

- [What is React Installation?](#what-is-react-installation)
  - [Definition](#definition)
  - [Installation Methods Overview](#installation-methods-overview)
- [Why Multiple Installation Methods?](#why-multiple-installation-methods)
  - [Benefits](#benefits)
  - [Use Cases](#use-cases)
- [Prerequisites](#prerequisites)
  - [Step 1: Install Node.js](#step-1-install-nodejs)
  - [Step 2: Choose a Package Manager](#step-2-choose-a-package-manager)
- [Installation Methods](#installation-methods)
  - [Method 1: Create React App (Recommended for Beginners)](#method-1-create-react-app-recommended-for-beginners)
  - [Method 2: Vite (Fast and Modern)](#method-2-vite-fast-and-modern)
  - [Method 3: Installation via Yarn](#method-3-installation-via-yarn)
  - [Method 4: Installation via Bun](#method-4-installation-via-bun)
- [Software Overview](#software-overview)
- [System Requirements](#system-requirements)
- [Dependencies](#dependencies)
  - [Run-time Dependency](#run-time-dependency)
  - [Development Dependency](#development-dependency)
- [Verifying Your Installation](#verifying-your-installation)
- [Troubleshooting](#troubleshooting)
- [FAQs](#faqs)
- [Contact Information](#contact-information)
- [References](#references)

## What is React Installation?

React installation refers to the process of setting up React.js in your development environment to start building user interfaces. This guide covers the most common ways to install React.js with detailed instructions.

### Definition

React installation involves setting up the necessary tools, dependencies, and project structure to create React applications. The installation process varies depending on your needs, experience level, and project requirements.

### Installation Methods Overview

1. **Create React App**: Official tool for beginners with zero configuration currently deprecated
2. **Vite**: Fast build tool with modern tooling
3. **Yarn**: Alternative package manager with faster installs
4. **Bun**: Ultra-fast JavaScript runtime and package manager

## Why Multiple Installation Methods?

Different installation methods serve different purposes and skill levels, allowing developers to choose the best approach for their specific needs.

### Benefits

1. **Flexibility**: Choose the method that fits your project requirements
2. **Learning Path**: Start simple with Create React App, advance to Vite
3. **Performance**: Vite and Bun offer faster development experience
4. **Package Management**: Yarn and Bun provide faster dependency installation

### Use Cases

- **Beginners**: Use Create React App for easy setup
- **Experienced Developers**: Use Vite for production apps
- **Fast Package Management**: Use Yarn or Bun for faster dependency installation
- **Fast Development**: Vite and Bun for quick builds and hot reloading

## Prerequisites

Before installing React, you need to have Node.js and a package manager installed on your system.

### Step 1: Install Node.js

Node.js is required to run React applications. It includes npm (Node Package Manager).

#### For macOS:

**Using Homebrew (Recommended):**
```bash
brew install node
```

**Or download from:** [https://nodejs.org/](https://nodejs.org/)

Verify installation:
```bash
node --version
npm --version
```

#### For Linux:

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install -y curl
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
```

**Fedora/RHEL/CentOS:**
```bash
# Install curl if not already installed
sudo dnf install -y curl

# Add NodeSource repository
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -

# Install Node.js
sudo dnf install -y nodejs
```

**Arch Linux:**
```bash
# Using pacman
sudo pacman -S nodejs npm


```

**openSUSE:**
```bash
# Add NodeSource repository
curl -fsSL https://rpm.nodesource.com/setup_18.x | sudo bash -

# Install Node.js
sudo zypper install -y nodejs
```

**Verify installation (all distributions):**
```bash
node --version
npm --version
```

### Step 2: Choose a Package Manager

You can use npm (comes with Node.js), or install alternative package managers:

**Install Yarn:**
```bash
npm install -g yarn
yarn --version
```

**Install Bun (macOS/Linux):**
```bash
curl -fsSL https://bun.sh/install | bash
bun --version
```

**Install pnpm:**
```bash
npm install -g pnpm
pnpm --version
```

## Installation Methods

## Method 1: Create React App (Recommended for Beginners)

**Best for:** Beginners, learning React, standard web applications

Create React App is the official and easiest way to start a new React project. It sets up everything you need with zero configuration.

### Step-by-Step Installation:

1. **Create a New React App:**
   ```bash
   npx create-react-app my-react-app
   ```

2. **Navigate into Your Project:**
   ```bash
   cd my-react-app
   ```

3. **Start the Development Server:**
   ```bash
   npm start
   ```
   
   This will start the development server and automatically open your browser to `http://localhost:3000`

4. **Stop the Server:**
   - Press `Ctrl + C` in the terminal

### Project Structure:

```
my-react-app/
├── node_modules/          # Dependencies
├── public/                # Static files
│   ├── index.html
├── src/                   # Your React code
│   ├── App.js
│   ├── App.css
│   ├── index.js
├── package.json          # Project configuration
└── README.md
```

### Available Scripts:

```bash
npm start          # Start development server
npm run build      # Build for production
npm test           # Run tests
```

### Using Yarn or pnpm:

```bash
# With Yarn
yarn create react-app my-react-app
cd my-react-app
yarn start

# With pnpm
pnpm create react-app my-react-app
cd my-react-app
pnpm start
```

## Method 2: Vite (Fast and Modern)

**Best for:** Developers who want faster builds and modern tooling

Vite is a build tool that provides faster development experience and optimized production builds.

### Step-by-Step Installation:

1. **Create a New Project with Vite:**
   ```bash
   npm create vite@latest my-react-app -- --template react
   ```

2. **Navigate to Project Directory:**
   ```bash
   cd my-react-app
   ```

3. **Install Dependencies:**
   ```bash
   npm install
   ```

4. **Start Development Server:**
   ```bash
   npm run dev
   ```

5. **Open Browser:**
   - The terminal will show a local URL (usually `http://localhost:5173`)
   - Open this URL in your browser

### Vite Templates Available:

```bash
# React with JavaScript
npm create vite@latest my-app -- --template react

# React with TypeScript
npm create vite@latest my-app -- --template react-ts
```

## Method 3: Installation via Yarn

**Best for:** Faster dependency installation, better dependency resolution

Yarn is a fast, reliable, and secure package manager that provides better performance than npm for installing dependencies.

### Step 1: Install Yarn

```bash
# Install Yarn globally
npm install -g yarn

# Verify installation
yarn --version
```

### Step 2: Create React App with Yarn

```bash
# Create React App using Yarn
yarn create react-app my-react-app

# Navigate to project
cd my-react-app

# Start development server
yarn start
```

### Step 3: Using Yarn with Vite

```bash
# Create Vite project with Yarn
yarn create vite my-react-app --template react

# Navigate to project
cd my-react-app

# Install dependencies
yarn install

# Start development server
yarn dev
```

### Yarn Commands:

```bash
yarn install          # Install dependencies
yarn add <package>    # Add a dependency
yarn remove <package> # Remove a dependency
yarn start            # Start development server
yarn build            # Build for production
yarn test             # Run tests
```

## Method 4: Installation via Bun

**Best for:** Ultra-fast package installation and development, modern JavaScript runtime

Bun is an all-in-one JavaScript runtime, bundler, test runner, and package manager that is significantly faster than npm and yarn.

### Step 1: Install Bun

**For macOS/Linux:**
```bash
curl -fsSL https://bun.sh/install | bash
```

**Verify installation:**
```bash
bun --version
```

### Step 2: Create React App with Bun

```bash
# Create React App using Bun
bun create react-app my-react-app

# Navigate to project
cd my-react-app

# Install dependencies (much faster than npm)
bun install

# Start development server
bun start
```

### Step 3: Using Bun with Vite

```bash
# Create Vite project with Bun
bun create vite my-react-app --template react

# Navigate to project
cd my-react-app

# Install dependencies
bun install

# Start development server
bun run dev
```

### Bun Commands:

```bash
bun install          # Install dependencies (very fast)
bun add <package>    # Add a dependency
bun remove <package> # Remove a dependency
bun run <script>     # Run a script from package.json
bun dev              # Start development server
bun build            # Build for production
```

### Benefits of Bun:

- **Ultra-fast**: 10-100x faster than npm/yarn for package installation
- **Built-in bundler**: No need for separate bundlers
- **TypeScript support**: Native TypeScript support without configuration
- **All-in-one**: Runtime, bundler, test runner, and package manager

## Software Overview

| Software | Version |
|----------|---------|
| React | 18.x (latest stable) |
| React DOM | 18.x |
| Node.js | 16.x or higher (recommended) |
| npm | 8.x or higher (recommended) |
| Yarn | Latest |
| Bun | Latest |
| Create React App | Latest |
| Vite | Latest |

## System Requirements

| Requirement | Minimum | Recommendation |
|-------------|---------|----------------|
| Node.js | 14.x | 16.x or higher |
| npm | 6.x | 8.x or higher |
| RAM | 4 GB | 8 GB or higher |
| Disk Space | 500 MB | 1 GB or higher |
| Browser | Modern browser | Latest version |
| OS | macOS 10.15+, Linux (Ubuntu, Fedora, Arch, openSUSE) | Latest stable version |

## Dependencies

### Run-time Dependency

| Run-time Dependency | Version | Description |
|---------------------|---------|-------------|
| react | ^18.0.0 | Core React library for building user interfaces |
| react-dom | ^18.0.0 | React library for DOM rendering and manipulation |

### Development Dependency

| Development Dependency | Version | Description |
|----------------------|---------|-------------|
| react-scripts | ^5.0.0 | Scripts and configuration used by Create React App |
| @babel/core | ^7.0.0 | JavaScript compiler for transforming JSX and ES6+ code |
| webpack | ^5.0.0 | Module bundler for packaging React applications |
| vite | Latest | Fast build tool and development server |
| typescript | ^5.0.0 | TypeScript compiler (for TypeScript projects) |
| @types/react | ^18.0.0 | TypeScript type definitions for React |
| @types/react-dom | ^18.0.0 | TypeScript type definitions for React DOM |

## Verifying Your Installation

### Check React Version:

```bash
# In your project directory
npm list react react-dom

# Or check package.json
cat package.json | grep react
```


## Troubleshooting

**npm install fails:** `npm cache clean --force`, delete `node_modules` and `package-lock.json`, then `npm install`.

**Port 3000 in use:** Kill process using `lsof -ti:3000 | xargs kill -9` (Linux/macOS), or use `PORT=3001 npm start`.

**Command not found: npx or npm:** Node.js is not installed or not in PATH. Reinstall Node.js and restart your terminal after installation.

**ACCESS: permission denied (Linux/macOS):** Fix npm permissions:
```bash
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

**Module not found errors:** Delete `node_modules` and `package-lock.json`, then run `npm install`.

**React is not defined or JSX errors:** Make sure you have Babel configured for JSX. In Create React App, this is automatic.

**Outdated Node.js version:** Update Node.js to the latest LTS version. Use `nvm` (Node Version Manager) to manage multiple Node versions:
```bash
# Install nvm (Linux/macOS)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Install and use Node.js 18
nvm install 18
nvm use 18
```

## FAQs

**1. Which installation method should I use?**

For beginners, use Create React App. For faster builds, use Vite. For faster package installation, use Yarn or Bun.

**2. Do I need Node.js to use React?**

Yes, Node.js is required for development. However, you can use React via CDN for quick testing without Node.js.

**3. What is the difference between Create React App and Vite?**

Create React App uses Webpack and is easier for beginners. Vite uses esbuild and is faster for development.

**4. Can I use React without npm?**

You can use React via CDN for simple HTML pages, but npm (or yarn/pnpm) is recommended for real projects.

**5. What is the latest version of React?**

React 18.x is the latest stable version.

**6. Do I need to install React globally?**

No, React should be installed locally in each project. Use `npx` or `create` commands to avoid global installation.

**7. Can I use multiple React versions in different projects?**

Yes, each project can have its own React version installed locally.

**8. What is the difference between react and react-dom?**

`react` is the core library, while `react-dom` is the rendering library for web browsers.

**9. Do I need TypeScript to use React?**

No, TypeScript is optional. React works perfectly with JavaScript.

**10. How do I update React to the latest version?**

Update React in your project: `npm install react@latest react-dom@latest`

## Contact Information

| Name | Email address |
|------|---------------|
| Mukesh | msmukeshkumarsharma@gmail.com |

## References

| Links | Descriptions |
|-------|--------------|
| https://react.dev/ | Official React documentation |
| https://react.dev/learn | React interactive tutorial |
| https://github.com/facebook/react | React GitHub repository |
| https://create-react-app.dev/ | Create React App documentation |
| https://vitejs.dev/ | Vite build tool documentation |
| https://yarnpkg.com/ | Yarn package manager documentation |
| https://bun.sh/ | Bun runtime and package manager documentation |
| https://nodejs.org/ | Node.js official website |
