#!/bin/bash

set -e

GO_VERSION_CHECK="go version"
GO_VERSION="latest"
INSTALL_DIR="/usr/local/go"
UPGRADE_MODE=false
# official, apt, snap
INSTALL_METHOD="official"
ARCHITECTURE=""
OS=""

# function to check if go exist or not
check_go_installed() {
    if $GO_VERSION_CHECK >/dev/null 2>&1 ; then
        echo "go is already installed"
       
    else
        echo "go is not installed"
    fi
}


detect_system() {
    echo "Detecting system OS..."
    
    ARCHITECTURE=$(uname -m)
    
    
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        
        OS="linux";
        echo $OS;
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="darwin";
        echo $OS;
    else
        echo "Unsupported OS: coompatible with only linux and darwin";
        exit 1;
    fi
}

# architecture detection
detect_architecture() {
    echo "Detecting system architecture..."
    
    ARCHITECTURE=$(uname -m)
    case "$ARCHITECTURE" in
        x86_64)
            ARCHITECTURE="amd64"
            echo "[INFO] Architecture detected: $ARCHITECTURE"
            ;;
        arm64|aarch64)
            ARCHITECTURE="arm64"
            echo "[INFO] Architecture detected: $ARCHITECTURE"
            ;;
        *)
           
            echo "[ERROR] Unsupported architecture: $ARCHITECTURE" 
            exit 1
            ;;
    esac

}
# function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# curl, wget, tar, apt, snap function to check prerequisites
check_prerequisites() {
    echo "[INFO] Checking prerequisites..."
    
    case "$INSTALL_METHOD" in
        official)
            if ! command_exists wget && ! command_exists curl; then
                echo  "[EROOR] Neither wget nor curl is installed!"
                echo "[EROOR] install wget or curl first to download Go"
                exit 1
            fi
            if ! command_exists tar; then
                echo "[EROOR] tar is not installed!"
                exit 1
            fi
            ;;
        apt)
            if ! command_exists apt; then
                echo "apt is not available! This method only works on Debian/Ubuntu"
                exit 1
            fi
            ;;
        snap)
            if ! command_exists snap; then
                echo "[ERROR] snap is not installed!"
                echo "[ERROR] Please install snapd first"
                exit 1
            fi
            ;;
        *)
            echo "[WARNING] Invalid installation method: $INSTALL_METHOD"
            exit 1
            ;;
    esac
}


# Function to get latest Go version
get_latest_version() {
    print_info "Fetching latest Go version..."
    
    if command_exists curl; then
        # output go1.25.6
        local latest=$(curl -s https://go.dev/VERSION?m=text 2>/dev/null | head -1)

    elif command_exists wget; then
        local latest=$(wget -qO- https://go.dev/VERSION?m=text 2>/dev/null | head -1)
    else
        echo "[ERROR] Cannot fetch latest version: curl or wget required"
        exit 1
    fi
    
    if [ -z "$latest" ]; then
        print_warning "Could not fetch latest version, defaulting to 1.23"
        echo "1.23"
    else
        echo "$latest" | sed 's/go//'
    fi
}


# Function to get version string for download
get_version_string() {
    local version="$1"

    if [ "$version" = "latest" ]; then
        version=$(get_latest_version)
    fi

    # Prepend "go" if not present
    if [[ ! "$version" =~ ^go ]]; then
        version="go$version"
    fi

    echo "$version"
}

main() {
    # check if go is installed
    check_go_installed
    # detect the system
    detect_system

    # detect architecture
    detect_architecture

    # check prerequisites
    check_prerequisites
    # get version string
    get_version_string "1.25.6"
}

main