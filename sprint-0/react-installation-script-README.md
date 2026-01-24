# React.js Installation Script

**A Beginner-Friendly Bash Script for Installing and Managing React.js**

This script provides an easy way to install React.js with support for multiple versions, different installation methods, and project upgrades.

---

## Table of Contents

1. [Overview](#1-overview)
2. [Features](#2-features)
3. [Prerequisites](#3-prerequisites)
4. [Installation](#4-installation)
5. [Usage](#5-usage)
6. [Supported React Versions](#6-supported-react-versions)
7. [Installation Methods](#7-installation-methods)
8. [Examples](#8-examples)
9. [Troubleshooting](#9-troubleshooting)
10. [FAQs](#10-faqs)

---

## 1. Overview

This bash script simplifies the React.js installation process by providing:

- **Interactive menu** for easy navigation
- **Multiple installation methods** (Create React App, Vite)
- **Version selection** for different React versions
- **Automatic package manager detection** (npm, yarn, pnpm, bun)
- **Upgrade functionality** for existing projects
- **Beginner-friendly** with clear instructions and colored output

---

## 2. Features

**Multiple Installation Methods**
- Create React App (CRA)
- Vite (fast and modern)

**Version Support**
- React 19.x (latest - 19.2.3)
- React 18.x
- React 17.x
- React 16.x
- Custom version selection

**Package Manager Support**
- Automatic detection of npm, yarn, pnpm, or bun
- Uses the best available package manager

**Upgrade Functionality**
- Upgrade React in existing projects
- Automatic backup of package.json
- Safe upgrade process

**Project Management**
- Check React version in projects
- Create new projects with specified versions

---

## 3. Prerequisites

Before using this script, ensure you have:

1. **Node.js** (version 14.x or higher)
   - Check installation: `node --version`
   - Download from: [https://nodejs.org/](https://nodejs.org/)

2. **npm** (comes with Node.js)
   - Check installation: `npm --version`

3. **Bash shell** (available on macOS and Linux)

4. **Internet connection** (for downloading packages)

### Optional Package Managers

The script will automatically detect and use these if installed:
- **Yarn**: `npm install -g yarn`
- **pnpm**: `npm install -g pnpm`
- **Bun**: `curl -fsSL https://bun.sh/install | bash`

---

## 4. Installation

### Step 1: Download the Script

```bash
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
                echo "  - latest (default)"
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
                echo "  - latest (default)"
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

```

---

## 5. Usage

### Basic Usage

Run the script from the terminal:

```bash
./react-installation-script.sh
```

### Interactive Menu

The script will display a menu with the following options:

```
==========================================
  React.js Installation Script
==========================================

1. Install React with Create React App
2. Install React with Vite
3. Upgrade React in existing project
4. Show React version in project
5. Exit
```

### Option 1: Install with Create React App

1. Select option `1` from the menu
2. Enter your project name (or press Enter for default: `my-react-app`)
3. Choose React version (or press Enter for latest)
4. The script will create your React project

**Example:**
```bash
Select an option (1-5): 1
Enter project name (default: my-react-app): my-first-app
Enter React version (default: latest): 19.2.3
```

### Option 2: Install with Vite

1. Select option `2` from the menu
2. Enter your project name
3. Choose template (JavaScript or TypeScript)
4. Choose React version
5. The script will create your Vite React project

**Example:**
```bash
Select an option (1-5): 2
Enter project name (default: my-react-app): my-vite-app
Select template (1-2, default: 1): 1
Enter React version (default: latest): 19.2.3
```

### Option 3: Upgrade React

1. Select option `3` from the menu
2. Enter the path to your existing React project
3. Choose the React version to upgrade to
4. The script will upgrade React and create a backup

**Example:**
```bash
Select an option (1-5): 3
Enter project path: ./my-existing-app
Enter React version to upgrade to (default: 19.2.3): 19.2.3
```

### Option 4: Show React Version

1. Select option `4` from the menu
2. Enter the path to your React project
3. The script will display the current React version

**Example:**
```bash
Select an option (1-5): 4
Enter project path: ./my-react-app
```

---

## 6. Supported React Versions

The script supports the following React versions:

| Version | Status | Notes |
|---------|--------|-------|
| 19.2.3 | Latest | Current stable release (December 2025) |
| 19.1.0 | Stable | Previous 19.x release |
| 19.0.0 | Stable | First 19.x release |
| 18.2.0 | Stable | Previous major version |
| 18.1.0 | Stable | Previous 18.x release |
| 18.0.0 | Stable | First 18.x release |
| 17.0.2 | Legacy | Older projects |
| 16.14.0 | Legacy | Very old projects |

**Note:** You can also specify any valid React version number (e.g., `19.2.3`, `18.1.0`, `17.0.2`).

---

## 7. Installation Methods

### Method 1: Create React App

**Best for:** Beginners, standard web applications

- Zero configuration required
- Includes testing setup
- Production-ready build configuration
- Official React tooling

### Method 2: Vite

**Best for:** Fast development, modern tooling

- Lightning-fast development server
- Optimized production builds
- Modern ES modules
- Hot Module Replacement (HMR)

---

## 8. Examples

### Example 1: Create a New React App with Latest Version

```bash
./react-installation-script.sh
# Select option 1
# Project name: my-app
# React version: latest (press Enter)
```

### Example 2: Create a Vite Project with TypeScript

```bash
./react-installation-script.sh
# Select option 2
# Project name: my-ts-app
# Template: 2 (TypeScript)
# React version: latest
```

### Example 3: Upgrade Existing Project

```bash
./react-installation-script.sh
# Select option 3
# Project path: ./my-old-app
# New version: 19.2.3
```

### Example 4: Check React Version

```bash
./react-installation-script.sh
# Select option 4
# Project path: ./my-react-app
```

---

## 9. Troubleshooting

### Issue: "Permission denied"

**Solution:**
```bash
chmod +x react-installation-script.sh
```

### Issue: "Node.js is not installed"

**Solution:**
Install Node.js from [https://nodejs.org/](https://nodejs.org/) or use:
```bash
# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install -y nodejs
```

### Issue: "npm: command not found"

**Solution:**
npm comes with Node.js. Reinstall Node.js if npm is missing.

### Issue: "Failed to create React app"

**Possible causes:**
- Internet connection issues
- Insufficient disk space
- Node.js version too old

**Solution:**
- Check internet connection
- Ensure Node.js 14.x or higher
- Free up disk space

### Issue: "Project directory not found"

**Solution:**
- Use absolute path: `/home/user/my-project`
- Or relative path: `./my-project`
- Ensure the directory exists

---

## 10. FAQs

**Q1: Do I need to install React globally?**

No, React should be installed locally in each project. This script handles that automatically.

**Q2: Can I use this script on Windows?**

This script is designed for macOS and Linux. For Windows, use WSL (Windows Subsystem for Linux) or Git Bash.

**Q3: Which package manager should I use?**

The script automatically detects the best available package manager. npm works fine, but yarn, pnpm, or bun may be faster.

**Q4: Can I install multiple React versions?**

Yes, each project can have its own React version. The script allows you to specify versions per project.

**Q5: What happens if the upgrade fails?**

The script automatically creates a backup of `package.json` before upgrading. If upgrade fails, the backup is restored.

**Q6: Can I use this script for existing projects?**

Yes, use option 3 to upgrade React in existing projects, or option 4 to check the current version.

**Q7: Which installation method should I choose?**

- **Create React App**: Best for beginners
- **Vite**: Best for faster development and modern tooling

**Q8: How do I uninstall React?**

React is installed locally in each project. To remove it:
```bash
cd your-project
npm uninstall react react-dom
```

**Q9: Can I specify a custom React version?**

Yes, you can enter any valid React version number when prompted (e.g., `19.2.3`, `18.1.0`, `17.0.2`).

**Q10: Does this script work offline?**

No, the script requires an internet connection to download packages from npm registry.

---

## Script Output Colors

The script uses colored output for better readability:

- **Blue**: Information messages
- **Green**: Success messages
- **Yellow**: Warning messages
- **Red**: Error messages

---

## Next Steps After Installation

1. **Navigate to your project:**
   ```bash
   cd your-project-name
   ```

2. **Start the development server:**
   ```bash
   # For Create React App
   npm start
   
   # For Vite
   npm run dev
   ```

3. **Open your browser:**
   - Create React App: `http://localhost:3000`
   - Vite: `http://localhost:5173`

4. **Start coding!**
   - Edit `src/App.js` (or `src/App.tsx` for TypeScript)
   - Save and see changes automatically

---

## Support

If you encounter any issues:

1. Check the [Troubleshooting](#troubleshooting) section
2. Verify Node.js and npm are installed correctly
3. Ensure you have internet connection
4. Check that you have sufficient disk space

---

## License

This script is provided as-is for educational purposes.

---

**Last Updated:** January 2026  
**Script Version:** 1.0  
**Compatible with:** React 16.x, 17.x, 18.x, 19.x  
**Latest React Version:** 19.2.3 (as of December 2025)
