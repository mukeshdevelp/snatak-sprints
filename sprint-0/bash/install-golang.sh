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
