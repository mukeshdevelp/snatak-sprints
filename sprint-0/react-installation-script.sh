#!/bin/bash

# React.js Installation Script
# This script helps you install React.js with support for multiple versions and upgrades
# Beginner-friendly with clear instructions

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check Node.js installation
check_nodejs() {
    print_info "Checking Node.js installation..."
    
    if command_exists node; then
        NODE_VERSION=$(node --version)
        print_success "Node.js is installed: $NODE_VERSION"
        
        # Check if version is 14.x or higher
        NODE_MAJOR=$(echo $NODE_VERSION | cut -d'v' -f2 | cut -d'.' -f1)
        if [ "$NODE_MAJOR" -lt 14 ]; then
            print_warning "Node.js version is below 14.x. React 19 requires Node.js 14.x or higher."
            read -p "Do you want to continue anyway? (y/n): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                print_error "Installation cancelled. Please update Node.js first."
                exit 1
            fi
        fi
        return 0
    else
        print_error "Node.js is not installed!"
        print_info "Please install Node.js first:"
        print_info "  - Visit: https://nodejs.org/"
        print_info "  - Or use: curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash - && sudo apt install -y nodejs"
        exit 1
    fi
}

# Function to check npm installation
check_npm() {
    print_info "Checking npm installation..."
    
    if command_exists npm; then
        NPM_VERSION=$(npm --version)
        print_success "npm is installed: $NPM_VERSION"
        return 0
    else
        print_error "npm is not installed!"
        exit 1
    fi
}

# Function to detect package manager
detect_package_manager() {
    if command_exists bun; then
        echo "bun"
    elif command_exists yarn; then
        echo "yarn"
    elif command_exists pnpm; then
        echo "pnpm"
    else
        echo "npm"
    fi
}

# Function to install React using Create React App
install_with_cra() {
    local REACT_VERSION=$1
    local PROJECT_NAME=$2
    local PACKAGE_MANAGER=$3
    
    print_info "Installing React using Create React App..."
    
    case $PACKAGE_MANAGER in
        bun)
            print_info "Creating React app with Bun..."
            bun create react-app "$PROJECT_NAME"
            ;;
        yarn)
            print_info "Creating React app with Yarn..."
            yarn create react-app "$PROJECT_NAME"
            ;;
        pnpm)
            print_info "Creating React app with pnpm..."
            pnpm create react-app "$PROJECT_NAME"
            ;;
        *)
            print_info "Creating React app with npm..."
            npx create-react-app "$PROJECT_NAME"
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        print_success "React app created successfully!"
        
        # Install specific React version if specified
        if [ -n "$REACT_VERSION" ] && [ "$REACT_VERSION" != "latest" ]; then
            print_info "Installing React version $REACT_VERSION..."
            cd "$PROJECT_NAME" || exit 1
            npm install "react@$REACT_VERSION" "react-dom@$REACT_VERSION"
            cd ..
        fi
        
        print_success "Project created in: $PROJECT_NAME"
        print_info "To start the development server, run:"
        print_info "  cd $PROJECT_NAME"
        print_info "  npm start"
    else
        print_error "Failed to create React app!"
        exit 1
    fi
}

# Function to install React using Vite
install_with_vite() {
    local REACT_VERSION=$1
    local PROJECT_NAME=$2
    local PACKAGE_MANAGER=$3
    local TEMPLATE=$4
    
    print_info "Installing React using Vite..."
    
    case $PACKAGE_MANAGER in
        bun)
            print_info "Creating Vite React app with Bun..."
            bun create vite "$PROJECT_NAME" --template "$TEMPLATE"
            ;;
        yarn)
            print_info "Creating Vite React app with Yarn..."
            yarn create vite "$PROJECT_NAME" --template "$TEMPLATE"
            ;;
        pnpm)
            print_info "Creating Vite React app with pnpm..."
            pnpm create vite "$PROJECT_NAME" --template "$TEMPLATE"
            ;;
        *)
            print_info "Creating Vite React app with npm..."
            npm create vite@latest "$PROJECT_NAME" -- --template "$TEMPLATE"
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        print_success "Vite React app created successfully!"
        
        cd "$PROJECT_NAME" || exit 1
        
        # Install dependencies
        print_info "Installing dependencies..."
        case $PACKAGE_MANAGER in
            bun) bun install ;;
            yarn) yarn install ;;
            pnpm) pnpm install ;;
            *) npm install ;;
        esac
        
        # Install specific React version if specified
        if [ -n "$REACT_VERSION" ] && [ "$REACT_VERSION" != "latest" ]; then
            print_info "Installing React version $REACT_VERSION..."
            case $PACKAGE_MANAGER in
                bun) bun add "react@$REACT_VERSION" "react-dom@$REACT_VERSION" ;;
                yarn) yarn add "react@$REACT_VERSION" "react-dom@$REACT_VERSION" ;;
                pnpm) pnpm add "react@$REACT_VERSION" "react-dom@$REACT_VERSION" ;;
                *) npm install "react@$REACT_VERSION" "react-dom@$REACT_VERSION" ;;
            esac
        fi
        
        cd ..
        
        print_success "Project created in: $PROJECT_NAME"
        print_info "To start the development server, run:"
        print_info "  cd $PROJECT_NAME"
        case $PACKAGE_MANAGER in
            bun) print_info "  bun dev" ;;
            yarn) print_info "  yarn dev" ;;
            pnpm) print_info "  pnpm dev" ;;
            *) print_info "  npm run dev" ;;
        esac
    else
        print_error "Failed to create Vite React app!"
        exit 1
    fi
}

# Function to upgrade React in existing project
upgrade_react() {
    local PROJECT_PATH=$1
    local NEW_VERSION=$2
    local PACKAGE_MANAGER=$3
    
    if [ ! -d "$PROJECT_PATH" ]; then
        print_error "Project directory not found: $PROJECT_PATH"
        exit 1
    fi
    
    print_info "Upgrading React in project: $PROJECT_PATH"
    
    cd "$PROJECT_PATH" || exit 1
    
    if [ ! -f "package.json" ]; then
        print_error "package.json not found. This doesn't appear to be a Node.js project."
        exit 1
    fi
    
    # Backup package.json
    print_info "Creating backup of package.json..."
    cp package.json package.json.backup
    
    # Upgrade React
    print_info "Upgrading React to version $NEW_VERSION..."
    case $PACKAGE_MANAGER in
        bun)
            bun remove react react-dom
            bun add "react@$NEW_VERSION" "react-dom@$NEW_VERSION"
            ;;
        yarn)
            yarn remove react react-dom
            yarn add "react@$NEW_VERSION" "react-dom@$NEW_VERSION"
            ;;
        pnpm)
            pnpm remove react react-dom
            pnpm add "react@$NEW_VERSION" "react-dom@$NEW_VERSION"
            ;;
        *)
            npm uninstall react react-dom
            npm install "react@$NEW_VERSION" "react-dom@$NEW_VERSION"
            ;;
    esac
    
    if [ $? -eq 0 ]; then
        print_success "React upgraded successfully to version $NEW_VERSION!"
        print_info "Backup saved as: package.json.backup"
    else
        print_error "Failed to upgrade React!"
        print_info "Restoring backup..."
        mv package.json.backup package.json
        exit 1
    fi
}

# Function to show React version in project
show_react_version() {
    local PROJECT_PATH=$1
    
    if [ ! -d "$PROJECT_PATH" ]; then
        print_error "Project directory not found: $PROJECT_PATH"
        exit 1
    fi
    
    cd "$PROJECT_PATH" || exit 1
    
    if [ ! -f "package.json" ]; then
        print_error "package.json not found."
        exit 1
    fi
    
    print_info "Current React versions in project:"
    
    if command_exists grep; then
        grep -E '"react"|"react-dom"' package.json | head -2
    else
        cat package.json | grep -E '"react"|"react-dom"'
    fi
}

# Main menu
show_menu() {
    echo ""
    echo "=========================================="
    echo "  React.js Installation Script"
    echo "=========================================="
    echo ""
    echo "1. Install React with Create React App"
    echo "2. Install React with Vite"
    echo "3. Upgrade React in existing project"
    echo "4. Show React version in project"
    echo "5. Exit"
    echo ""
}

# Main script
main() {
    clear
    print_info "React.js Installation Script"
    print_info "This script will help you install or upgrade React.js"
    echo ""
    
    # Check prerequisites
    check_nodejs
    check_npm
    
    # Detect package manager
    PACKAGE_MANAGER=$(detect_package_manager)
    print_info "Detected package manager: $PACKAGE_MANAGER"
    echo ""
    
    while true; do
        show_menu
        read -p "Select an option (1-5): " choice
        
        case $choice in
            1)
                echo ""
                read -p "Enter project name (default: my-react-app): " PROJECT_NAME
                PROJECT_NAME=${PROJECT_NAME:-my-react-app}
                
                echo ""
                echo "Available React versions:"
                echo "  - latest (default) - React 19.2.3"
                echo "  - 19.2.3 (latest stable)"
                echo "  - 19.1.0"
                echo "  - 19.0.0"
                echo "  - 18.2.0"
                echo "  - 18.1.0"
                echo "  - 18.0.0"
                echo "  - 17.0.2"
                echo "  - 16.14.0"
                read -p "Enter React version (default: latest): " REACT_VERSION
                REACT_VERSION=${REACT_VERSION:-latest}
                
                install_with_cra "$REACT_VERSION" "$PROJECT_NAME" "$PACKAGE_MANAGER"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            2)
                echo ""
                read -p "Enter project name (default: my-react-app): " PROJECT_NAME
                PROJECT_NAME=${PROJECT_NAME:-my-react-app}
                
                echo ""
                echo "Available templates:"
                echo "  1. react (JavaScript)"
                echo "  2. react-ts (TypeScript)"
                read -p "Select template (1-2, default: 1): " TEMPLATE_CHOICE
                
                case $TEMPLATE_CHOICE in
                    2) TEMPLATE="react-ts" ;;
                    *) TEMPLATE="react" ;;
                esac
                
                echo ""
                echo "Available React versions:"
                echo "  - latest (default) - React 19.2.3"
                echo "  - 19.2.3 (latest stable)"
                echo "  - 19.1.0"
                echo "  - 19.0.0"
                echo "  - 18.2.0"
                echo "  - 18.1.0"
                echo "  - 18.0.0"
                read -p "Enter React version (default: latest): " REACT_VERSION
                REACT_VERSION=${REACT_VERSION:-latest}
                
                install_with_vite "$REACT_VERSION" "$PROJECT_NAME" "$PACKAGE_MANAGER" "$TEMPLATE"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            3)
                echo ""
                read -p "Enter project path: " PROJECT_PATH
                
                echo ""
                echo "Available React versions:"
                echo "  - 19.2.3 (latest stable)"
                echo "  - 19.1.0"
                echo "  - 19.0.0"
                echo "  - 18.2.0"
                echo "  - 18.1.0"
                echo "  - 18.0.0"
                echo "  - 17.0.2"
                read -p "Enter React version to upgrade to (default: 19.2.3): " NEW_VERSION
                NEW_VERSION=${NEW_VERSION:-19.2.3}
                
                upgrade_react "$PROJECT_PATH" "$NEW_VERSION" "$PACKAGE_MANAGER"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            4)
                echo ""
                read -p "Enter project path: " PROJECT_PATH
                show_react_version "$PROJECT_PATH"
                echo ""
                read -p "Press Enter to continue..."
                ;;
            5)
                print_info "Exiting..."
                exit 0
                ;;
            *)
                print_error "Invalid option. Please select 1-5."
                sleep 2
                ;;
        esac
        clear
    done
}

# Run main function
main
