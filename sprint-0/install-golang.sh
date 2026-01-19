#!/bin/bash

################################################################################
# Golang Installation Script
# 
# A generic bash script for installing Golang with support for:
# - Multiple Go versions
# - Multiple installation methods (Official Binary, Package Manager, Snap)
# - Upgrading existing Go installations
# - Cross-platform support (Linux, macOS)
#
# Usage:
#   ./install-golang.sh [OPTIONS]
#
# Options:
#   --version VERSION    Go version: 1.21, 1.22, 1.23, latest (default: latest)
#   --method METHOD      Installation method: official, apt, snap (default: official)
#   --install-dir DIR    Installation directory (default: /usr/local/go)
#   --upgrade            Upgrade existing Go installation
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
GO_VERSION="latest"
INSTALL_METHOD="official"
INSTALL_DIR="/usr/local/go"
UPGRADE_MODE=false
ARCH=""
OS=""

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
Golang Installation Script

Usage: $0 [OPTIONS]

Options:
    --version VERSION        Go version:
                            - 1.21      : Go 1.21.x
                            - 1.22      : Go 1.22.x
                            - 1.23      : Go 1.23.x
                            - latest    : Latest stable version (default)
                            - X.YY.Z    : Specific version (e.g., 1.21.5)
    
    --method METHOD          Installation method:
                            - official  : Official binary from go.dev (default)
                            - apt       : apt package manager (Ubuntu/Debian)
                            - snap      : Snap package (Ubuntu)
    
    --install-dir DIR        Installation directory (default: /usr/local/go)
                            Note: Only used with official method
    
    --upgrade                Upgrade existing Go installation
    
    --help                   Show this help message

Examples:
    # Install latest Go version
    $0 --method official
    
    # Install Go 1.22
    $0 --version 1.22 --method official
    
    # Install specific version
    $0 --version 1.21.5 --method official
    
    # Upgrade to latest version
    $0 --upgrade --version latest
    
    # Install via apt package manager
    $0 --method apt

EOF
}

# Function to detect OS and architecture
detect_system() {
    print_info "Detecting system information..."
    
    # Detect OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        OS="darwin"
    else
        print_error "Unsupported operating system: $OSTYPE"
        exit 1
    fi
    
    # Detect architecture
    ARCH=$(uname -m)
    case "$ARCH" in
        x86_64)
            ARCH="amd64"
            ;;
        arm64|aarch64)
            ARCH="arm64"
            ;;
        *)
            print_error "Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac
    
    print_success "Detected: $OS-$ARCH"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check prerequisites
check_prerequisites() {
    print_info "Checking prerequisites..."
    
    case "$INSTALL_METHOD" in
        official)
            if ! command_exists wget && ! command_exists curl; then
                print_error "Neither wget nor curl is installed!"
                print_info "Please install wget or curl to download Go"
                exit 1
            fi
            if ! command_exists tar; then
                print_error "tar is not installed!"
                exit 1
            fi
            ;;
        apt)
            if ! command_exists apt; then
                print_error "apt is not available! This method only works on Debian/Ubuntu"
                exit 1
            fi
            ;;
        snap)
            if ! command_exists snap; then
                print_error "snap is not installed!"
                print_info "Please install snapd first"
                exit 1
            fi
            ;;
        *)
            print_error "Invalid installation method: $INSTALL_METHOD"
            exit 1
            ;;
    esac
}

# Function to get latest Go version
get_latest_version() {
    print_info "Fetching latest Go version..."
    
    if command_exists curl; then
        local latest=$(curl -s https://go.dev/VERSION?m=text 2>/dev/null | head -1)
    elif command_exists wget; then
        local latest=$(wget -qO- https://go.dev/VERSION?m=text 2>/dev/null | head -1)
    else
        print_error "Cannot fetch latest version: curl or wget required"
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
    
    # If version doesn't start with "go", add it
    if [[ ! "$version" =~ ^go ]]; then
        version="go$version"
    fi
    
    echo "$version"
}

# Function to get download URL
get_download_url() {
    local version=$(get_version_string "$GO_VERSION")
    local filename="${version}.${OS}-${ARCH}.tar.gz"
    echo "https://go.dev/dl/${filename}"
}

# Function to check current Go installation
check_current_installation() {
    if command_exists go; then
        local current_version=$(go version | awk '{print $3}' | sed 's/go//')
        print_info "Current Go installation found: $current_version"
        return 0
    else
        print_info "No existing Go installation found"
        return 1
    fi
}

# Function to setup Go environment
setup_go_environment() {
    print_info "Setting up Go environment variables..."
    
    local shell_rc=""
    if [ -f "$HOME/.bashrc" ]; then
        shell_rc="$HOME/.bashrc"
    elif [ -f "$HOME/.zshrc" ]; then
        shell_rc="$HOME/.zshrc"
    elif [ -f "$HOME/.profile" ]; then
        shell_rc="$HOME/.profile"
    else
        shell_rc="$HOME/.bashrc"
        touch "$shell_rc"
    fi
    
    # Check if PATH already includes Go
    if grep -q "/usr/local/go/bin" "$shell_rc" 2>/dev/null; then
        print_info "Go PATH already configured in $shell_rc"
    else
        print_info "Adding Go to PATH in $shell_rc"
        echo '' >> "$shell_rc"
        echo '# Go environment variables' >> "$shell_rc"
        echo 'export PATH=$PATH:/usr/local/go/bin' >> "$shell_rc"
        echo 'export GOPATH=$HOME/go' >> "$shell_rc"
        echo 'export PATH=$PATH:$GOPATH/bin' >> "$shell_rc"
        print_success "Go environment variables added to $shell_rc"
    fi
    
    # Export for current session
    export PATH=$PATH:/usr/local/go/bin
    export GOPATH=$HOME/go
    export PATH=$PATH:$GOPATH/bin
    
    print_warning "Please run 'source $shell_rc' or restart your terminal to apply changes"
}

# Function to install Go using official binary
install_official() {
    print_info "Installing Go using official binary method..."
    
    local version=$(get_version_string "$GO_VERSION")
    local download_url=$(get_download_url)
    local filename=$(basename "$download_url")
    local temp_dir=$(mktemp -d)
    
    print_info "Downloading Go $version..."
    print_info "URL: $download_url"
    
    cd "$temp_dir"
    
    # Download Go
    if command_exists wget; then
        wget -q --show-progress "$download_url" || {
            print_error "Failed to download Go"
            rm -rf "$temp_dir"
            exit 1
        }
    elif command_exists curl; then
        curl -L --progress-bar -o "$filename" "$download_url" || {
            print_error "Failed to download Go"
            rm -rf "$temp_dir"
            exit 1
        }
    fi
    
    print_success "Download completed"
    
    # Remove old installation if exists
    if [ -d "$INSTALL_DIR" ]; then
        print_warning "Removing existing Go installation at $INSTALL_DIR"
        sudo rm -rf "$INSTALL_DIR"
    fi
    
    # Extract Go
    print_info "Extracting Go to $INSTALL_DIR..."
    sudo mkdir -p "$(dirname "$INSTALL_DIR")"
    sudo tar -C "$(dirname "$INSTALL_DIR")" -xzf "$filename" || {
        print_error "Failed to extract Go"
        rm -rf "$temp_dir"
        exit 1
    }
    
    # Cleanup
    rm -f "$filename"
    rm -rf "$temp_dir"
    
    print_success "Go extracted successfully"
    
    # Setup environment
    setup_go_environment
}

# Function to install Go using apt
install_apt() {
    print_info "Installing Go using apt package manager..."
    
    print_info "Updating package list..."
    sudo apt update || {
        print_error "Failed to update package list"
        exit 1
    }
    
    print_info "Installing golang-go..."
    sudo apt install -y golang-go || {
        print_error "Failed to install Go via apt"
        exit 1
    }
    
    print_success "Go installed via apt"
    print_warning "Note: apt may install an older version. Use --method official for latest version."
}

# Function to install Go using snap
install_snap() {
    print_info "Installing Go using snap..."
    
    if [ "$GO_VERSION" != "latest" ]; then
        print_warning "Snap method installs latest version. Version $GO_VERSION will be ignored."
    fi
    
    sudo snap install go --classic || {
        print_error "Failed to install Go via snap"
        exit 1
    }
    
    print_success "Go installed via snap"
}

# Function to upgrade Go
upgrade_go() {
    print_info "Upgrading Go installation..."
    
    if ! check_current_installation; then
        print_error "No existing Go installation found to upgrade"
        print_info "Use without --upgrade flag to perform a fresh installation"
        exit 1
    fi
    
    local current_version=$(go version | awk '{print $3}' | sed 's/go//')
    print_info "Current version: $current_version"
    
    if [ "$INSTALL_METHOD" != "official" ]; then
        print_warning "Upgrade mode works best with --method official"
        print_info "Switching to official method for upgrade..."
        INSTALL_METHOD="official"
    fi
    
    # Get target version
    local target_version="$GO_VERSION"
    if [ "$target_version" = "latest" ]; then
        target_version=$(get_latest_version)
    fi
    
    print_info "Target version: $target_version"
    
    # Compare versions (simple check)
    if [ "$current_version" = "$target_version" ] || [ "$current_version" = "go$target_version" ]; then
        print_warning "Go is already at version $current_version"
        print_info "No upgrade needed"
        return 0
    fi
    
    # Perform installation (which will replace existing)
    install_official
    
    print_success "Go upgraded successfully!"
}

# Function to verify installation
verify_installation() {
    print_info "Verifying Go installation..."
    
    # Reload PATH for current session
    export PATH=$PATH:/usr/local/go/bin
    
    if ! command_exists go; then
        print_error "Go command not found!"
        print_warning "You may need to run: source ~/.bashrc (or ~/.zshrc)"
        return 1
    fi
    
    local installed_version=$(go version)
    print_success "Go installation verified!"
    print_info "Installed version: $installed_version"
    
    # Check Go environment
    print_info "Go environment:"
    go env GOROOT
    go env GOPATH
    
    # Test Go installation
    print_info "Testing Go installation with a simple program..."
    local test_dir=$(mktemp -d)
    cd "$test_dir"
    
    cat > main.go << 'EOF'
package main
import "fmt"
func main() {
    fmt.Println("Hello, Go!")
}
EOF
    
    if go run main.go > /dev/null 2>&1; then
        print_success "Go test program executed successfully!"
        local output=$(go run main.go)
        print_info "Output: $output"
    else
        print_warning "Go test program failed (this might be normal if PATH not updated)"
    fi
    
    rm -rf "$test_dir"
}

# Parse command line arguments
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            --version)
                GO_VERSION="$2"
                shift 2
                ;;
            --method)
                INSTALL_METHOD="$2"
                shift 2
                ;;
            --install-dir)
                INSTALL_DIR="$2"
                shift 2
                ;;
            --upgrade)
                UPGRADE_MODE=true
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
    print_info "Golang Installation Script"
    print_info "==========================="
    
    # Parse arguments
    parse_arguments "$@"
    
    # Detect system
    detect_system
    
    # Check prerequisites
    check_prerequisites
    
    # Check current installation
    check_current_installation || true
    
    # Execute based on mode
    if [ "$UPGRADE_MODE" = true ]; then
        upgrade_go
    else
        case "$INSTALL_METHOD" in
            official)
                install_official
                ;;
            apt)
                install_apt
                ;;
            snap)
                install_snap
                ;;
            *)
                print_error "Invalid installation method: $INSTALL_METHOD"
                print_info "Valid methods: official, apt, snap"
                exit 1
                ;;
        esac
    fi
    
    # Verify installation
    verify_installation
    
    print_success "Installation completed successfully!"
    print_info ""
    print_info "Next steps:"
    print_info "  1. Run 'source ~/.bashrc' (or ~/.zshrc) to update PATH"
    print_info "  2. Verify with: go version"
    print_info "  3. Check environment: go env"
    print_info "  4. Create your first program: mkdir hello-go && cd hello-go"
    print_info "     echo 'package main; import \"fmt\"; func main() { fmt.Println(\"Hello!\") }' > main.go"
    print_info "     go run main.go"
}

# Run main function
main "$@"

