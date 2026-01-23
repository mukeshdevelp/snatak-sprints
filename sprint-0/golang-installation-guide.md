# Golang Installation Guide

**Mukesh** edited this page on Jan 21, 2026 · 1 revision

| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 21-01-2026 | v1.0 | Mukesh Sharma | 21-01-2026 |  |  |  |  |

## Table of Contents

1. [What is Golang?](#1-what-is-golang)
2. [Why Golang?](#2-why-golang)
3. [Prerequisites](#3-prerequisites)
    
    3.1. [Pre-requisites](#31-pre-requisites)
4. [Installation Methods](#4-installation-methods)
    
    4.1. [Method 1: Official Binary (Recommended)](#41-method-1-official-binary-recommended)
    
    4.2. [Method 2: Package Manager](#42-method-2-package-manager)
5. [Software Overview](#5-software-overview)
6. [System Requirements](#6-system-requirements)
7. [Dependencies](#7-dependencies)
    
    7.1. [Run-time Dependency](#71-run-time-dependency)
    
    7.2. [Other Dependency](#72-other-dependency)
8. [Verifying Your Installation](#8-verifying-your-installation)
9. [Troubleshooting](#9-troubleshooting)
10. [FAQs](#10-faqs)
11. [Contact Information](#11-contact-information)
12. [References](#12-references)

## 1. What is Golang?

Go (also known as Golang) is an open-source programming language developed by Google. It is designed for building simple, reliable, and efficient software. Go compiles directly to machine code, resulting in standalone binaries that don't require a runtime environment.

## 2. Why Golang?

Go was created to solve several critical problems in software development, making it an excellent choice for modern applications. It combines the ease of programming of interpreted languages with the efficiency and safety of statically typed, compiled languages.

## 3. Prerequisites

### 3.1. Pre-requisites

| Requirement | Description |
|-------------|-------------|
| sudo access | Needed to install Go system-wide |
| Internet access | Required to download Go binaries |
| Shell | Terminal access on Linux |
| wget or curl | For downloading Go binaries |

## 4. Installation Methods

### 4.1. Method 1: Official Binary (Recommended)

**Best for:** Latest version, all Linux distributions

**Step 1: Download Go**
```bash
# Download latest Go version (replace 1.21.5 with latest version)
wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz
```
<img width="1919" height="506" alt="Screenshot from 2026-01-23 11-53-39" src="https://github.com/user-attachments/assets/4886a242-0cfc-440d-a308-cd21ed582ffa" />

**Step 2: Remove Old Installation (if exists)**
```bash
sudo rm -rf /usr/local/go
```

**Step 3: Extract to /usr/local**
```bash
sudo tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz
```

**Step 4: Add to PATH**
```bash
# Add to ~/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc
```

**Step 5: Verify Installation**
```bash
go version
```
<img width="1919" height="335" alt="image" src="https://github.com/user-attachments/assets/69f8a677-3041-41bf-876a-9c00ef91f955" />

### 4.2. Method 2: Package Manager

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install -y golang-go
go version
```
<img width="1919" height="942" alt="Screenshot from 2026-01-23 11-58-22" src="https://github.com/user-attachments/assets/f4f4d9f0-e419-4422-a440-de68421c4fc6" />
<img width="1919" height="863" alt="Screenshot from 2026-01-23 11-58-47" src="https://github.com/user-attachments/assets/e509dafc-9bb1-410a-ad3f-a03cb9c6790d" />
<img width="1919" height="136" alt="image" src="https://github.com/user-attachments/assets/d2e1a5dd-f353-4b2d-b966-3fc2fe3aab72" />

**RedHat/CentOS/Fedora:**
```bash
sudo dnf install -y golang
go version
```

**Note:** Package manager may install an older version. Use Method 1 for latest version.

## 5. Software Overview

| Software | Version |
|----------|---------|
| Go | 1.21+ (recommended) |
| gofmt | Built-in |
| go test | Built-in |
| go mod | Built-in |

## 6. System Requirements

| Requirement | Minimum | Recommendation |
|-------------|---------|----------------|
| OS | Linux, macOS, Windows | Latest stable version |
| RAM | 512 MB | 2 GB or higher |
| Disk Space | 200 MB | 500 MB or higher |
| Processor | Any modern processor | Multi-core processor |

## 7. Dependencies

### 7.1. Run-time Dependency

| Run-time Dependency | Version | Description |
|---------------------|---------|-------------|
| Go Runtime | 1.21+ | Runtime environment for executing Go programs |
| Standard Library | Built-in | Core libraries included with Go installation |

### 7.2. Other Dependency

| Other Dependency | Version | Description |
|------------------|---------|-------------|
| Git | Latest | Required for downloading Go modules from version control |
| C Compiler | Latest | Required for building packages with CGO (optional) |

## 8. Verifying Your Installation

**Check Go Version:**
```bash
go version
```
<img width="1919" height="335" alt="image" src="https://github.com/user-attachments/assets/acaa476a-39b9-4209-9c5d-2c04c4bd23a0" />

**Check Go Environment:**
```bash
go env
```

**Test with Simple Program:**
```bash
mkdir hello-go && cd hello-go
go mod init hello-go
cat > main.go << 'EOF'
package main
import "fmt"
func main() {
    fmt.Println("Hello, Go!")
}
EOF
go run main.go
```

**Expected Output:** `Hello, Go!`

## 9. Troubleshooting

**Go command not found:**
- Ensure Go is installed and added to PATH
- Verify installation: `go version`
- Restart terminal after installation

**Import errors:**
- Ensure package is in `go.mod`
- Run `go mod tidy` to update dependencies
- Check import paths are correct

**Build errors:**
- Update dependencies: `go get -u ./...`
- Tidy module: `go mod tidy`
- Verify module: `go mod verify`

## 10. FAQs

**1. What is the difference between Go and Golang?**
Go is the official name. Golang is a common nickname used in search engines and domain names.

**2. Is Go object-oriented?**
Go is not a traditional object-oriented language. It has structs and methods but no classes or inheritance. It uses composition and interfaces instead.

**3. Do I need to learn other languages before Go?**
No, Go is beginner-friendly. However, basic programming knowledge helps.

**4. How do I handle errors in Go?**
Go uses explicit error returns. Functions return `(result, error)`. Check errors with `if err != nil { handle error }`.

**5. What is the difference between slice and array?**
Arrays have fixed size, slices are dynamic. Slices are more commonly used and built on top of arrays.

**6. Can I use Go for web development?**
Yes, Go has excellent HTTP support in the standard library and is widely used for building web services and APIs.

**7. Is Go fast?**
Yes, Go compiles to native machine code and provides performance comparable to C/C++ for many use cases.

**8. What is Go modules?**
Go modules is the dependency management system introduced in Go 1.11. It uses `go.mod` file to manage dependencies.

## 11. Contact Information

| Name | Email address |
|------|---------------|
| Mukesh | msmukeshkumarsharma@gmail.com |

## 12. References

| Links | Descriptions |
|-------|--------------|
| https://go.dev/ | Official Go website with documentation and downloads |
| https://go.dev/doc/ | Official Go documentation |
| https://go.dev/tour/ | Interactive Go tutorial (A Tour of Go) |
| https://go.dev/doc/effective_go | Effective Go - Go best practices guide |
| https://gobyexample.com/ | Go by Example - Code examples for learning |
| https://pkg.go.dev/std | Go Standard Library documentation |
