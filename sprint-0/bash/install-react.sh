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

info()  { echo -e "${BLUE}[INFO]${NC} $1"; }
ok()    { echo -e "${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()   { echo -e "${RED}[ERROR]${NC} $1"; }

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

command_exists() { command -v "$1" >/dev/null 2>&1; }

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
