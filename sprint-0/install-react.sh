#!/bin/bash

################################################################################
# React.js Installation Script
# 
# A generic bash script for installing React.js with support for:
# - Multiple React versions
# - Multiple installation methods (Create React App, Vite, Next.js, Direct)
# - Upgrading existing React projects
# - Cross-platform support (Linux, macOS, Windows with Git Bash/WSL)
#
# Usage:
#   ./install-react.sh [OPTIONS]
#
# Options:
#   --method METHOD      Installation method: cra, vite, nextjs, direct (default: cra)
#   --version VERSION    React version: 16, 17, 18, latest (default: latest)
#   --project-name NAME  Project name (default: my-react-app)
#   --package-manager PM Package manager: npm, yarn, pnpm (default: npm)
#   --upgrade            Upgrade React in existing project
#   --typescript         Use TypeScript template
#   --help               Show this help message
#
################################################################################

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
METHOD="cra"
REACT_VERSION="latest"
PROJECT_NAME="my-react-app"
PACKAGE_MANAGER="npm"
UPGRADE_MODE=false
USE_TYPESCRIPT=false
PROJECT_DIR=""

# Function to print colored messages
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show help
show_help() {
    cat << EOF
React.js Installation Script

Usage: $0 [OPTIONS]

Options:
    --method METHOD          Installation method:
                            - cra      : Create React App (default)
                            - vite     : Vite
                            - nextjs   : Next.js
                            - direct   : Direct npm/yarn/pnpm install
    
    --version VERSION        React version:
                            - 16       : React 16.x
                            - 17       : React 17.x
                            - 18       : React 18.x
                            - latest   : Latest version (default)
    
    --project-name NAME      Project name (default: my-react-app)
    
    --package-manager PM     Package manager:
                            - npm      : npm (default)
                            - yarn     : Yarn
                            - pnpm     : pnpm
    
    --upgrade                Upgrade React in existing project
                            (requires --project-dir or run from project directory)
    
    --project-dir DIR        Project directory for upgrade mode
    
    --typescript             Use TypeScript template (for cra, vite, nextjs)
    
    --help                   Show this help message

Examples:
    # Create React App with latest React
    $0 --method cra --project-name my-app
    
    # Install React 18 with Vite
    $0 --method vite --version 18 --project-name my-vite-app
    
    # Upgrade React in existing project
    $0 --upgrade --project-dir ./my-react-app --version 18
    
    # Install with TypeScript
    $0 --method vite --typescript --project-name my-ts-app

EOF
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check prerequisites
check_prerequisites() {
    print_info "Checking prerequisites..."
    
    # Check Node.js
    if ! command_exists node; then
        print_error "Node.js is not installed!"
        print_info "Please install Node.js from https://nodejs.org/"
        exit 1
    fi
    
    NODE_VERSION=$(node --version | sed 's/v//')
    print_success "Node.js version: $NODE_VERSION"
    
    # Check npm
    if ! command_exists npm; then
        print_error "npm is not installed!"
        exit 1
    fi
    
    NPM_VERSION=$(npm --version)
    print_success "npm version: $NPM_VERSION"
    
    # Check package manager
    case "$PACKAGE_MANAGER" in
        npm)
            if ! command_exists npm; then
                print_error "npm is not available!"
                exit 1
            fi
            ;;
        yarn)
            if ! command_exists yarn; then
                print_warning "Yarn is not installed. Installing yarn..."
                npm install -g yarn
            fi
            YARN_VERSION=$(yarn --version)
            print_success "Yarn version: $YARN_VERSION"
            ;;
        pnpm)
            if ! command_exists pnpm; then
                print_warning "pnpm is not installed. Installing pnpm..."
                npm install -g pnpm
            fi
            PNPM_VERSION=$(pnpm --version)
            print_success "pnpm version: $PNPM_VERSION"
            ;;
        *)
            print_error "Invalid package manager: $PACKAGE_MANAGER"
            exit 1
            ;;
    esac
}

# Function to get React version string
get_react_version() {
    case "$REACT_VERSION" in
        16)
            echo "^16.14.0"
            ;;
        17)
            echo "^17.0.2"
            ;;
        18)
            echo "^18.2.0"
            ;;
        latest)
            echo "latest"
            ;;
        *)
            echo "$REACT_VERSION"
            ;;
    esac
}

# Function to install React using Create React App
install_with_cra() {
    print_info "Installing React with Create React App..."
    
    local version_str=$(get_react_version)
    local template_flag=""
    
    if [ "$USE_TYPESCRIPT" = true ]; then
        template_flag="--template typescript"
    fi
    
    if [ "$PACKAGE_MANAGER" = "yarn" ]; then
        yarn create react-app "$PROJECT_NAME" $template_flag
    elif [ "$PACKAGE_MANAGER" = "pnpm" ]; then
        pnpm create react-app "$PROJECT_NAME" $template_flag
    else
        npx create-react-app "$PROJECT_NAME" $template_flag
    fi
    
    cd "$PROJECT_NAME"
    
    # Install specific React version if not latest
    if [ "$REACT_VERSION" != "latest" ]; then
        print_info "Installing React $version_str..."
        $PACKAGE_MANAGER install "react@$version_str" "react-dom@$version_str"
    fi
    
    print_success "React app created successfully!"
    print_info "Project location: $(pwd)"
    print_info "To start the development server, run: $PACKAGE_MANAGER start"
}

# Function to install React using Vite
install_with_vite() {
    print_info "Installing React with Vite..."
    
    local template="react"
    if [ "$USE_TYPESCRIPT" = true ]; then
        template="react-ts"
    fi
    
    if [ "$PACKAGE_MANAGER" = "yarn" ]; then
        yarn create vite "$PROJECT_NAME" --template "$template"
    elif [ "$PACKAGE_MANAGER" = "pnpm" ]; then
        pnpm create vite "$PROJECT_NAME" --template "$template"
    else
        npm create vite@latest "$PROJECT_NAME" -- --template "$template"
    fi
    
    cd "$PROJECT_NAME"
    
    print_info "Installing dependencies..."
    $PACKAGE_MANAGER install
    
    # Install specific React version if not latest
    if [ "$REACT_VERSION" != "latest" ]; then
        local version_str=$(get_react_version)
        print_info "Installing React $version_str..."
        $PACKAGE_MANAGER install "react@$version_str" "react-dom@$version_str"
    fi
    
    print_success "React app created successfully with Vite!"
    print_info "Project location: $(pwd)"
    print_info "To start the development server, run: $PACKAGE_MANAGER run dev"
}

# Function to install React using Next.js
install_with_nextjs() {
    print_info "Installing React with Next.js..."
    
    local flags=""
    if [ "$USE_TYPESCRIPT" = true ]; then
        flags="--typescript"
    fi
    
    if [ "$PACKAGE_MANAGER" = "yarn" ]; then
        yarn create next-app "$PROJECT_NAME" $flags
    elif [ "$PACKAGE_MANAGER" = "pnpm" ]; then
        pnpm create next-app "$PROJECT_NAME" $flags
    else
        npx create-next-app@latest "$PROJECT_NAME" $flags
    fi
    
    cd "$PROJECT_NAME"
    
    print_success "Next.js app created successfully!"
    print_info "Project location: $(pwd)"
    print_info "To start the development server, run: $PACKAGE_MANAGER run dev"
}

# Function to install React directly
install_direct() {
    print_info "Installing React directly..."
    
    if [ ! -f "package.json" ]; then
        print_info "Initializing npm project..."
        $PACKAGE_MANAGER init -y
    fi
    
    local version_str=$(get_react_version)
    
    if [ "$REACT_VERSION" = "latest" ]; then
        print_info "Installing latest React..."
        $PACKAGE_MANAGER install react react-dom
    else
        print_info "Installing React $version_str..."
        $PACKAGE_MANAGER install "react@$version_str" "react-dom@$version_str"
    fi
    
    # Install dev dependencies for JSX
    print_info "Installing development dependencies..."
    $PACKAGE_MANAGER install --save-dev @babel/core @babel/preset-env @babel/preset-react
    
    print_success "React installed successfully!"
    print_warning "Note: You'll need to configure Babel and a bundler (webpack/vite) separately."
}

# Function to upgrade React in existing project
upgrade_react() {
    print_info "Upgrading React in existing project..."
    
    local target_dir=""
    if [ -n "$PROJECT_DIR" ]; then
        target_dir="$PROJECT_DIR"
    else
        target_dir="."
    fi
    
    if [ ! -d "$target_dir" ]; then
        print_error "Project directory not found: $target_dir"
        exit 1
    fi
    
    if [ ! -f "$target_dir/package.json" ]; then
        print_error "package.json not found in $target_dir"
        print_error "This doesn't appear to be a valid Node.js project."
        exit 1
    fi
    
    cd "$target_dir"
    
    local version_str=$(get_react_version)
    
    print_info "Current React versions:"
    $PACKAGE_MANAGER list react react-dom 2>/dev/null || print_warning "Could not determine current versions"
    
    print_info "Upgrading to React $version_str..."
    
    if [ "$REACT_VERSION" = "latest" ]; then
        $PACKAGE_MANAGER install react@latest react-dom@latest
    else
        $PACKAGE_MANAGER install "react@$version_str" "react-dom@$version_str"
    fi
    
    print_success "React upgraded successfully!"
    print_info "New React versions:"
    $PACKAGE_MANAGER list react react-dom
    
    print_warning "Please test your application after upgrading!"
}

# Function to verify installation
verify_installation() {
    print_info "Verifying installation..."
    
    if [ "$UPGRADE_MODE" = false ]; then
        if [ ! -d "$PROJECT_NAME" ]; then
            print_error "Project directory not found!"
            return 1
        fi
        cd "$PROJECT_NAME"
    fi
    
    if [ -f "package.json" ]; then
        print_info "Checking package.json..."
        if grep -q "react" package.json; then
            print_success "React found in package.json"
            grep "react" package.json | head -2
        else
            print_warning "React not found in package.json"
        fi
    fi
    
    print_info "Checking node_modules..."
    if [ -d "node_modules/react" ]; then
        print_success "React is installed in node_modules"
    else
        print_warning "node_modules/react not found. Run '$PACKAGE_MANAGER install' if needed."
    fi
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --method)
                METHOD="$2"
                shift 2
                ;;
            --version)
                REACT_VERSION="$2"
                shift 2
                ;;
            --project-name)
                PROJECT_NAME="$2"
                shift 2
                ;;
            --package-manager)
                PACKAGE_MANAGER="$2"
                shift 2
                ;;
            --upgrade)
                UPGRADE_MODE=true
                shift
                ;;
            --project-dir)
                PROJECT_DIR="$2"
                shift 2
                ;;
            --typescript)
                USE_TYPESCRIPT=true
                shift
                ;;
            --help)
                show_help
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
}

# Main function
main() {
    print_info "React.js Installation Script"
    print_info "=============================="
    
    # Parse arguments
    parse_arguments "$@"
    
    # Check prerequisites
    check_prerequisites
    
    # Execute based on mode
    if [ "$UPGRADE_MODE" = true ]; then
        upgrade_react
        verify_installation
    else
        case "$METHOD" in
            cra)
                install_with_cra
                ;;
            vite)
                install_with_vite
                ;;
            nextjs)
                install_with_nextjs
                ;;
            direct)
                install_direct
                ;;
            *)
                print_error "Invalid installation method: $METHOD"
                print_info "Valid methods: cra, vite, nextjs, direct"
                exit 1
                ;;
        esac
        
        verify_installation
        
        print_success "Installation completed successfully!"
        print_info ""
        print_info "Next steps:"
        if [ "$METHOD" = "cra" ]; then
            print_info "  cd $PROJECT_NAME && $PACKAGE_MANAGER start"
        elif [ "$METHOD" = "vite" ]; then
            print_info "  cd $PROJECT_NAME && $PACKAGE_MANAGER run dev"
        elif [ "$METHOD" = "nextjs" ]; then
            print_info "  cd $PROJECT_NAME && $PACKAGE_MANAGER run dev"
        else
            print_info "  Configure your build tool and start developing!"
        fi
    fi
}

# Run main function
main "$@"

