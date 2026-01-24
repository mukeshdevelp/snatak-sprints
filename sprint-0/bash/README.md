# React.js Installation Script

**A generic, beginner-friendly bash script to install and upgrade React.js using npm and Vite.**

Works on **Linux**, **macOS**, and **Windows** (Git Bash or WSL). Requires **Node.js 20+** and **npm**.

---

## Table of Contents

1. [Overview](#1-overview)
2. [Features](#2-features)
3. [Prerequisites](#3-prerequisites)
4. [Script](#4-script)
4. [Installation](#4-installation)
5. [Usage](#5-usage)
6. [Supported React Versions](#6-supported-react-versions)
7. [Examples](#7-examples)
8. [Troubleshooting](#8-troubleshooting)
9. [FAQs](#9-faqs)
10. [Contact & References](#10-contact--references)

---

## 1. Overview

The script `install-react.sh` lets you:

- **Create** a new React app with **Vite** and **npm**
- **Choose** a React version (16, 17, 18, 19, or latest)
- **Upgrade** React in an existing project
- Run on **any OS** with a Bash-like shell (Linux, macOS, Git Bash, WSL)

---

## 2. Features

| Feature | Description |
|--------|-------------|
| **npm + Vite** | Uses npm as package manager and Vite as build tool |
| **Multi-version** | React 16, 17, 18, 19, or latest |
| **Upgrade mode** | Upgrade React in current project with `--upgrade` |
| **OS-agnostic** | No OS-specific install commands; only Node/npm checks |
| **Beginner-friendly** | Clear messages, `--help`, simple options |

---

## 3. Prerequisites

| Requirement | Version / notes |
|-------------|------------------|
| **Node.js** | **20 or higher** (minimum) |
| **npm** | Comes with Node.js |
| **Bash** | Bash 4+ (Linux, macOS, Git Bash, WSL) |
| **Internet** | Needed to download packages |

**Check versions:**

```bash
node --version   # e.g. v20.x.x or higher
npm --version
```

**Install Node.js 20+** (if missing):

- **All platforms:** [https://nodejs.org/](https://nodejs.org/) — download the LTS version (20+).
- **Linux (optional):** Use NodeSource, nvm, or your distro’s package manager to install Node 20+.

---

## 4. Installation

1. **Download** or clone the repo and go to the `bash` folder:

   ```bash
   cd /path/to/snatak-sprints/sprint-0/bash
   ```

2. **Make the script executable:**

   ```bash
   chmod +x install-react.sh
   ```

3. **Run it** (see [Usage](#5-usage)).

---

## 5. Usage

### Create a new React app (default: latest React, Vite, `my-react-app`)

```bash
./install-react.sh
```

### Options

| Option | Description | Default |
|--------|-------------|---------|
| `--version VERSION` | React version: `16`, `17`, `18`, `19`, `latest` | `latest` |
| `--project-name NAME` | Project folder name | `my-react-app` |
| `--upgrade` | Upgrade React in current project (run inside project dir) | — |
| `--help` | Show help | — |

### Examples

```bash
# Default: latest React, project name my-react-app
./install-react.sh

# React 18, custom project name
./install-react.sh --version 18 --project-name my-app

# Upgrade React in current project to latest
cd my-react-app
./install-react.sh --upgrade --version latest
```

---

## 6. Supported React Versions

| Version | Usage |
|---------|--------|
| `16` | Legacy |
| `17` | Transition |
| `18` | Stable |
| `19` | Newer |
| `latest` | Newest (default) |

---

## 7. Examples

**Create and run a new app:**

```bash
./install-react.sh --version 18 --project-name my-app
cd my-app
npm run dev
```

**Upgrade existing project:**

```bash
cd my-existing-react-app
/path/to/install-react.sh --upgrade --version 19
```

---

## 8. Troubleshooting

| Issue | Solution |
|-------|----------|
| **Node.js not found** | Install Node.js 20+ from [nodejs.org](https://nodejs.org/). |
| **Node version &lt; 20** | Upgrade Node to 20+ and re-run the script. |
| **npm not found** | Install Node.js (npm is included). |
| **Permission denied** | Run `chmod +x install-react.sh`. |
| **`package.json` not found (upgrade)** | Run `--upgrade` from inside your React project directory. |
| **Port in use** | Change Vite dev port, e.g. `npm run dev -- --port 3001`. |
| **Install fails** | `npm cache clean --force`, delete `node_modules` and `package-lock.json`, then `npm install`. |

---

## 9. FAQs

**1. Which OS are supported?**  
Linux, macOS, and Windows (via Git Bash or WSL). The script only checks Node/npm; it does not run OS-specific install commands.

**2. Why Node 20 minimum?**  
Vite and modern React tooling work best with Node 20+.

**3. Can I use yarn or pnpm?**  
The script uses **npm** only. You can switch to yarn/pnpm after the project is created.

**4. How do I uninstall?**  
Delete the project folder (e.g. `rm -rf my-react-app`).

**5. Where is the script?**  
`bash/install-react.sh` in this repo.

---

## 10. Contact & References

| Name | Email |
|------|--------|
| Mukesh | msmukeshkumarsharma@gmail.com |

| Link | Description |
|------|-------------|
| [React](https://react.dev/) | Official React docs |
| [Vite](https://vitejs.dev/) | Vite documentation |
| [Node.js](https://nodejs.org/) | Node.js downloads |
| [npm](https://www.npmjs.com/) | npm documentation |

**Note:** Generic script for all supported OS. Uses **npm** and **Vite** only. **Node.js 20+** required.
