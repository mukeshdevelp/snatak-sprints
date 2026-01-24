# React.js Installation Script

**A generic bash script to install and upgrade React.js using npm and Vite.**

Works on **Linux**, **macOS**, and **Windows** (Git Bash or WSL). Requires **Node.js 20+** and **npm**.

---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 21-01-2026 | v1.0 | Mukesh Sharma | 21-01-2026 |  |  |  |  |


## Table of Contents

1. [Overview](#1-overview)
2. [Features](#2-features)
3. [Prerequisites](#3-prerequisites)
4. [Script](#4-script)
5. [Installation](#5-installation)
6. [Usage](#6-usage)
7. [Supported React Versions](#7-supported-react-versions)
8. [Examples](#8-examples)
9. [Troubleshooting](#9-troubleshooting)
10. [FAQs](#10-faqs)
11. [Contact & References](#11-contact--references)

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

## 4. Script
```bash
#!/bin/bash
# React.js Installation Script (Generic – Linux, macOS, Windows/Git Bash)
# Uses npm + Vite. Requires Node.js 20+. Supports multiple React versions and upgrades.
# Usage: ./install-react.sh [--version 16|17|18|19|latest] [--project-name NAME] [--upgrade] [--help]

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

REACT_VERSION="latest"
PROJECT_NAME="my-react-app"
UPGRADE_MODE=false

info() {
   echo -e "${BLUE}[INFO]${NC} $1"; 
}
ok() { 
   echo -e "${GREEN}[OK]${NC} $1"; }
warn() { 
   echo -e "${YELLOW}[WARN]${NC} $1"; 
}
err() { 
   echo -e "${RED}[ERROR]${NC} $1"; 
}

show_help() {
    echo "React.js Install (npm + Vite) — Node 20+ required"
    echo "Usage: ./install-react.sh [OPTIONS]"
    echo "  --version 16|17|18|19|latest   React version (default: latest)"
    echo "  --project-name NAME            Project folder name (default: my-react-app)"
    echo "  --upgrade                      Upgrade React in current project (run inside project dir)"
    echo "  --help                         Show this help"
    echo ""
    echo "Examples:"
    echo "  ./install-react.sh"
    echo "  ./install-react.sh --version 18 --project-name my-app"
    echo "  ./install-react.sh --upgrade --version latest"
}

while [[ $# -gt 0 ]]; do
    case $1 in
        --version)      REACT_VERSION="$2"; shift 2 ;;
        --project-name) PROJECT_NAME="$2";  shift 2 ;;
        --upgrade)      UPGRADE_MODE=true;  shift ;;
        --help)         show_help; exit 0 ;;
        *)              err "Unknown option: $1"; show_help; exit 1 ;;
    esac
done

command_exists() { 
   command -v "$1" >/dev/null 2>&1; 
}

check_node() {
    info "Checking Node.js..."
    if ! command_exists node; then
        err "Node.js not found. Install Node.js 20+ from https://nodejs.org/"
        exit 1
    fi
    NODE_VER=$(node -v)
    NODE_MAJOR=$(echo "$NODE_VER" | sed 's/v//' | cut -d. -f1)
    if [ "$NODE_MAJOR" -lt 20 ]; then
        err "Node.js 20+ required. Current: $NODE_VER. Install from https://nodejs.org/"
        exit 1
    fi
    ok "Node.js $NODE_VER"
}

check_npm() {
    info "Checking npm..."
    if ! command_exists npm; then
        err "npm not found. Install Node.js from https://nodejs.org/ (npm is included)."
        exit 1
    fi
    ok "npm $(npm -v)"
}

install_vite() {
    info "Creating React app with Vite + npm..."
    npm create vite@latest "$PROJECT_NAME" -- --template react
    cd "$PROJECT_NAME"
    npm install
    if [ "$REACT_VERSION" != "latest" ]; then
        npm install "react@^${REACT_VERSION}.0.0" "react-dom@^${REACT_VERSION}.0.0"
    fi
    cd ..
    ok "Project created: $PROJECT_NAME"
    info "Run: cd $PROJECT_NAME && npm run dev"
}

upgrade_react() {
    info "Upgrading React..."
    if [ ! -f "package.json" ]; then
        err "package.json not found. Run this script from your React project directory."
        exit 1
    fi
    if [ "$REACT_VERSION" = "latest" ]; then
        npm install react@latest react-dom@latest
    else
        npm install "react@^${REACT_VERSION}.0.0" "react-dom@^${REACT_VERSION}.0.0"
    fi
    ok "React upgraded."
}

main() {
    info "React.js installer (npm + Vite) — Version: $REACT_VERSION | Project: $PROJECT_NAME"
    check_node
    check_npm

    if [ "$UPGRADE_MODE" = true ]; then
        upgrade_react
    else
        install_vite
    fi
    ok "Done."
}

main
```

**Expected Output**

image place holder

---

## 5. Installation

1. **Download** or clone the repo and go to the `bash` folder:

   ```bash
   cd /path/to/snatak-sprints/sprint-0/bash
   ```

2. **Make the script executable:**

   ```bash
   chmod +x install-react.sh
   ```

3. **Run it** (see [Usage](#6-usage)).

---

## 6. Usage

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

## 7. Supported React Versions

| Version | Usage |
|---------|--------|
| `16` | Legacy |
| `17` | Transition |
| `18` | Stable |
| `19` | Newer |
| `latest` | Newest (default) |

---

## 8. Examples

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

## 9. Troubleshooting

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

## 10. FAQs

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

## 11. Contact & References

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
