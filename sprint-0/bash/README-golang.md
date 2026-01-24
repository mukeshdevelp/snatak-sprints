# Go (Golang) Installation Script

**A concise, beginner-friendly bash script to install and upgrade Go using only official [go.dev](https://go.dev) downloads.**

Works on **Linux** and **macOS**. Uses **https://go.dev/dl/** only — no package managers or third-party URLs.

---

## Table of Contents

1. [Overview](#1-overview)
2. [Features](#2-features)
3. [Prerequisites](#3-prerequisites)
4. [Script](#4-script)
5. [Installation](#5-installation)
6. [Usage](#6-usage)
7. [Supported Go Versions](#7-supported-go-versions)
8. [Examples](#8-examples)
9. [Troubleshooting](#9-troubleshooting)
10. [FAQs](#10-faqs)
11. [Contact & References](#11-contact--references)

---

## 1. Overview

The script `install-golang.sh` lets you:

- **Install** Go from **official go.dev binaries** only
- **Choose** a version (1.21, 1.22, 1.23, latest, or X.Y.Z)
- **Upgrade** an existing Go installation (reinstall)
- Run on **Linux** and **macOS** (amd64, arm64)

---

## 2. Features

| Feature | Description |
|--------|-------------|
| **Official URLs only** | Downloads only from **https://go.dev/dl/** |
| **Multi-version** | 1.21, 1.22, 1.23, latest, or specific X.Y.Z |
| **Upgrade mode** | Reinstall Go with `--upgrade` |
| **Platform detection** | Linux/macOS, amd64/arm64 |
| **Beginner-friendly** | Clear messages, `--help`, minimal options |

---

## 3. Prerequisites

| Requirement | Notes |
|-------------|-------|
| **Bash** | Bash 4+ (Linux, macOS) |
| **curl or wget** | To download from go.dev |
| **tar** | To extract the archive |
| **sudo** | Install to `/usr/local/go` |
| **Internet** | Access to https://go.dev |

**Check:**

```bash
curl -sI https://go.dev/dl/ | head -1
# or
which tar
```

---
## 4. Script
```bash
#!/bin/bash
# Go (Golang) Installation Script (Linux, macOS)
# Downloads only from official https://go.dev/dl/. Supports multiple versions and upgrades.
# Usage: ./install-golang.sh [--version 1.21|1.22|1.23|latest|X.Y.Z] [--upgrade] [--help]

set -e
# red color
RED='\033[0;31m'
# green color
GREEN='\033[0;32m'
# yellow color
YELLOW='\033[1;33m'
# blue color
BLUE='\033[0;34m'
# no color
NC='\033[0m'
# default go version value
GO_VERSION="latest"
# install dir
INSTALL_DIR="/usr/local/go"
# default upgrade mode
UPGRADE_MODE=false
# base url - official website for go bin
BASE_URL="https://go.dev"
# info message show
info() { 
    echo -e "${BLUE}[INFO]${NC} $1"; 
}
# succcess message show
ok() { 
    echo -e "${GREEN}[OK]${NC} $1"; 
}
# Warning in yellow
warn() { 
    echo -e "${YELLOW}[WARN]${NC} $1"; 
}
# Error in red
err() { 
    echo -e "${RED}[ERROR]${NC} $1"; 
}

# show help message for script use for user
show_help() {
    # Available options -> --version, --upgrade, --help
    echo "Go (Golang) Install — official go.dev binaries only"
    echo "Usage: ./install-golang.sh [OPTIONS]"
    echo "  --version 1.21|1.22|1.23|latest|X.Y.Z   Go version (default: latest)"
    echo "  --upgrade                               Upgrade existing Go (reinstall)"
    echo "  --help                                  Show this help"
    echo ""
    echo "Examples:"
    echo "  ./install-golang.sh"
    echo "  ./install-golang.sh --version 1.22"
    echo "  ./install-golang.sh --upgrade --version latest"
}

# trigger when args are passed greater than 0
while [[ $# -gt 0 ]]; do
    case $1 in
        --version)  GO_VERSION="$2"; shift 2 ;;
        --upgrade)  UPGRADE_MODE=true; shift ;;
        --help)     show_help; exit 0 ;;
        *)          err "Unknown option: $1"; show_help; exit 1 ;;
    esac
done


command_exists() { 
    command -v "$1" >/dev/null 2>&1; 
}

# fetch url for url link download
fetch() {
    
    
    if command_exists wget; then
        wget -qO- "$1"
    else
        err "Need wget. Install one to download from $BASE_URL"
        exit 1
    fi
}

# platform detection for linux and mac os
detect_platform() {
    case "$(uname -s)" in
        Linux)   OS="linux" ;;
        Darwin)  OS="darwin" ;;
        *)       err "Unsupported OS. Use Linux or macOS."; exit 1 ;;
    esac
    # architecture detection
    case "$(uname -m)" in
        x86_64)  ARCH="amd64" ;;
        arm64|aarch64) ARCH="arm64" ;;
        *)       err "Unsupported arch. Use amd64 or arm64."; exit 1 ;;
    esac
    ok "Platform: $OS-$ARCH"
}
# checking dependencies for tar and network
check_deps() {
    info "Checking deps..."
    if ! command_exists tar; then
        err "tar required. Install it first."
        exit 1
    fi
    fetch "$BASE_URL/dl/?mode=json" >/dev/null 2>&1 || { err "Cannot reach $BASE_URL. Check network."; exit 1; }
    ok "Ready."
}
# get the latest go version
get_latest() {
    # fetcching the url using wget in fetch function
    fetch "$BASE_URL/VERSION?m=text" | sed 's/^go//'
}
# get the latest patch for a given minor version
get_latest_patch() {
    local minor="$1"
    local escaped="${minor//./\\.}"
    local out
    out=$(fetch "$BASE_URL/dl/?mode=json" | grep -oE "go${escaped}\\.[0-9]+" | sort -V | tail -1 | sed 's/go//')
    echo "${out:-${minor}.0}"
}
# resolving for version
resolve_version() {
    local v="$1"
    if [ "$v" = "latest" ]; then
        get_latest
    elif echo "$v" | grep -qE '^[0-9]+\.[0-9]+$'; then
        get_latest_patch "$v"
    else
        echo "$v"
    fi
}

# install go function
install_go() {
    local ver="$1"
    local tag="go$ver"
    local filename="${tag}.${OS}-${ARCH}.tar.gz"
    local url="$BASE_URL/dl/$filename"
    local tmpdir
    # create temp dir inside /tmp folder
    tmpdir=$(mktemp -d)

    info "Downloading $tag from $BASE_URL/dl/..."
    
    if command_exists wget; then
        wget -q -O "$tmpdir/$filename" "$url"
    fi

    if [ ! -s "$tmpdir/$filename" ]; then
        err "Download failed. Check $url"
        rm -rf "$tmpdir"
        exit 1
    fi
    ok "Downloaded."

    if [ -d "$INSTALL_DIR" ]; then
        warn "Removing existing $INSTALL_DIR"
        sudo rm -rf "$INSTALL_DIR"
    fi

    info "Extracting to $INSTALL_DIR..."
    sudo tar -C /usr/local -xzf "$tmpdir/$filename"
    rm -rf "$tmpdir"
    ok "Installed $tag."

    # PATH
    local rc=""
    [ -f "$HOME/.bashrc" ] && rc="$HOME/.bashrc"
    [ -f "$HOME/.zshrc" ] && rc="$HOME/.zshrc"
    [ -z "$rc" ] && rc="$HOME/.profile"
    [ ! -f "$rc" ] && touch "$rc"
    if ! grep -q '/usr/local/go/bin' "$rc" 2>/dev/null; then
        echo '' >> "$rc"
        echo 'export PATH=$PATH:/usr/local/go/bin' >> "$rc"
        ok "Added /usr/local/go/bin to PATH in $rc"
    fi
    export PATH="$PATH:/usr/local/go/bin"
    warn "Run: source $rc  (or restart terminal)"
}

main() {
    info "Go installer (official $BASE_URL only) — Version: $GO_VERSION"
    detect_platform
    check_deps

    if [ "$UPGRADE_MODE" = true ] && command_exists go; then
        info "Upgrading existing Go..."
    fi

    local resolved
    resolved=$(resolve_version "$GO_VERSION")
    [ -z "$resolved" ] && { err "Could not resolve version $GO_VERSION"; exit 1; }
    install_go "$resolved"

    ok "Done. Verify: go version"
}

main

```
## 5. Installation

1. **Go to the `bash` folder:**

   ```bash
   cd /path/to/install-golang.sh
   ```

2. **Make the script executable:**

   ```bash
   chmod +x install-golang.sh
   ```

3. **Run it** (see [Usage](#6-usage)).

---

## 6. Usage

### Install latest Go (default)

```bash
./install-golang.sh
```

### Options

| Option | Description | Default |
|--------|-------------|---------|
| `--version VERSION` | Go version: `1.21`, `1.22`, `1.23`, `latest`, or `X.Y.Z` | `latest` |
| `--upgrade` | Reinstall/upgrade existing Go | — |
| `--help` | Show help | — |

### Examples

```bash
# Latest Go
./install-golang.sh

# Go 1.22 (latest 1.22.x)
./install-golang.sh --version 1.22

# Specific version
./install-golang.sh --version 1.21.5

# Upgrade to latest
./install-golang.sh --upgrade --version latest
```

---

## 7. Supported Go Versions

| Version | Usage |
|---------|--------|
| `1.21` | Latest 1.21.x |
| `1.22` | Latest 1.22.x |
| `1.23` | Latest 1.23.x |
| `latest` | Newest stable (default) |
| `X.Y.Z` | Exact version (e.g. `1.21.5`) |

---

## 8. Examples

**Install and verify:**

```bash
./install-golang.sh --version 1.22
source ~/.bashrc   # or ~/.zshrc
go version
go env
```

**Upgrade existing Go:**

```bash
./install-golang.sh --upgrade --version latest
source ~/.bashrc
go version
```

---

## 9. Troubleshooting

| Issue | Solution |
|-------|----------|
| **Cannot reach go.dev** | Check network, firewall, proxy. Script uses only https://go.dev. |
| **tar not found** | Install `tar` (e.g. `apt install tar` or `brew install gnu-tar`). |
| **curl/wget missing** | Install `curl` or `wget`. |
| **Permission denied (script)** | Run `chmod +x install-golang.sh`. |
| **sudo fails** | Install writes to `/usr/local`. Use a user with sudo access. |
| **go not found after install** | Run `source ~/.bashrc` or `source ~/.zshrc`, or restart the terminal. |

---

## 10. FAQs

**1. Which URLs does the script use?**  
Only **https://go.dev** — e.g. `https://go.dev/VERSION?m=text`, `https://go.dev/dl/?mode=json`, and `https://go.dev/dl/goX.Y.Z.os-arch.tar.gz`.

**2. Does it work on Windows?**  
No. Use WSL (Linux) or install Go manually from [go.dev/doc/install](https://go.dev/doc/install).

**3. Where is Go installed?**  
`/usr/local/go`. The script adds `/usr/local/go/bin` to your shell config (`.bashrc`, `.zshrc`, or `.profile`).

**4. How do I uninstall?**  
Remove `/usr/local/go` and delete the `PATH` line the script added to your shell config.

**5. Can I use a package manager (apt, Homebrew)?**  
This script does not use them. It only downloads official binaries from go.dev.

---

## 11. Contact & References

| Name | Email |
|------|--------|
| Mukesh | msmukeshkumarsharma@gmail.com |

| Link | Description |
|------|-------------|
| [go.dev](https://go.dev/) | Official Go site |
| [go.dev/dl](https://go.dev/dl/) | Official downloads |
| [go.dev/doc/install](https://go.dev/doc/install) | Official install guide |

**Note:** Uses **official go.dev URLs only**. **Linux** and **macOS** (amd64, arm64).
