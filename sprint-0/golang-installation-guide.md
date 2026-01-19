# Golang Installation Guide

## Prerequisites

### Check if Go is Already Installed
```bash
go version
```

---

## Method 1: Official Binary (Recommended)

### Step 1: Download Go
```bash
# Get latest version from https://golang.org/dl/
# Or use wget (replace X.XX.X with latest version)
wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
```

### Step 2: Remove Old Installation (if exists)
```bash
sudo rm -rf /usr/local/go
```

### Step 3: Extract to /usr/local
```bash
sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
```

### Step 4: Add to PATH
```bash
# Add to ~/.bashrc or ~/.zshrc
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc
```

### Step 5: Verify Installation
```bash
go version
```

---

## Method 2: Package Manager (Ubuntu/Debian)

### Step 1: Update Package List
```bash
sudo apt update
```

### Step 2: Install Go
```bash
sudo apt install golang-go
```

### Step 3: Verify Installation
```bash
go version
```

**Note:** Package manager may install an older version. Use Method 1 for latest version.

---

## Method 3: Snap (Ubuntu)

### Step 1: Install via Snap
```bash
sudo snap install go --classic
```

### Step 2: Verify Installation
```bash
go version
```

---

## Setup Go Environment

### Configure GOPATH and GOROOT
```bash
# Add to ~/.bashrc or ~/.zshrc
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc
```

**Note:** Go 1.11+ uses modules by default, GOPATH is optional but recommended.

---

## Verify Installation

```bash
# Check Go version
go version

# Check Go environment
go env

# Test with a simple program
mkdir -p ~/hello-go
cd ~/hello-go
cat > main.go << EOF
package main
import "fmt"
func main() {
    fmt.Println("Hello, Go!")
}
EOF
go run main.go
```

**Expected Output:** `Hello, Go!`

---

## Quick Reference

```bash
# Installation (Official)
wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Verify
go version

# Create and run first program
mkdir hello-go && cd hello-go
echo 'package main; import "fmt"; func main() { fmt.Println("Hello!") }' > main.go
go run main.go
```

