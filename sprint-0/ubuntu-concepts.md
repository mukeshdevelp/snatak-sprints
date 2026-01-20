# Ubuntu Concepts

**Mukesh** edited this page on Dec 14, 2023 · 1 revision

| Author | Created on | Version | Last updated by | Last edited on |
|--------|------------|---------|-----------------|----------------|
| Mukesh | 10-08-23 | version 1 | Mukesh | 24-08-23 |

## What is Ubuntu?

Ubuntu is a free and open-source Linux distribution based on Debian, designed for desktop, server, and cloud environments. It is one of the most popular Linux distributions worldwide, known for its user-friendly interface, strong security features, and extensive community support. Ubuntu provides a stable, secure, and easy-to-use operating system that serves as the foundation for many enterprise applications, cloud services, and development environments.

### Definition

Ubuntu is an operating system built on the Linux kernel, providing a complete computing environment with system software, applications, and development tools. It combines the stability of Debian with a focus on ease of use and regular release cycles, making it accessible to both beginners and experienced users.

### Core Components

- **Linux Kernel**: The core operating system component that manages hardware resources
- **Systemd**: Init system and service manager for system initialization and service management
- **GNOME Desktop Environment**: Default graphical user interface (for Desktop edition)
- **APT Package Manager**: Tool for installing, updating, and managing software packages
- **Shell (Bash)**: Command-line interface for interacting with the system

## Why Ubuntu?

Ubuntu offers numerous advantages and is widely used across different sectors due to its reliability, security, and versatility.

### Benefits

- **Free and Open Source**: No licensing costs, complete source code access, and freedom to modify
- **Security**: Built-in security features including automatic security updates, AppArmor, and UFW firewall
- **Stability**: LTS (Long-Term Support) versions receive 5 years of security updates and support
- **Ease of Use**: User-friendly interface suitable for users transitioning from other operating systems
- **Large Software Repository**: Thousands of free applications available through package managers
- **Community Support**: Active community providing help, documentation, and troubleshooting
- **Enterprise Ready**: Used by major corporations and cloud providers worldwide
- **Regular Updates**: Consistent release cycle with new features every 6 months

### Use Cases

Ubuntu is used in various scenarios to solve specific problems and meet particular needs:

- **Desktop Computing**: Provides a user-friendly desktop environment for personal computers, offering an alternative to proprietary operating systems
- **Server Deployment**: Powers web servers, database servers, application servers, and enterprise infrastructure
- **Cloud Platforms**: Used as the base operating system for cloud instances on AWS, Azure, Google Cloud, and other cloud providers
- **Development Environment**: Offers a robust platform for software development with extensive programming language support and development tools
- **Container Hosting**: Serves as the host OS for Docker containers and Kubernetes clusters
- **IoT and Embedded Systems**: Provides lightweight versions for Internet of Things (IoT) devices and embedded systems
- **Security-Critical Applications**: Deployed in environments requiring high security and compliance standards
- **Educational Institutions**: Used as a cost-effective solution for schools and universities

## Key Features

- **User-Friendly Interface**: Intuitive graphical user interface (GNOME desktop environment) that makes Linux accessible to users of all skill levels
- **Security**: Built-in security features including AppArmor, UFW firewall, automatic security updates, and strong user permission management
- **Package Management**: Advanced package management system (APT) with thousands of pre-configured software packages
- **Long-Term Support (LTS)**: LTS releases provide 5 years of security updates and support, ensuring stability for enterprise deployments
- **Open Source**: Completely free and open-source software with active community contributions
- **Hardware Compatibility**: Extensive hardware support with drivers included for most modern hardware
- **Regular Updates**: Scheduled releases every 6 months, with LTS versions every 2 years
- **Cloud Integration**: Optimized for cloud platforms with official cloud images and tools
- **Container Support**: Native support for Docker, LXD, and other containerization technologies
- **Community Support**: Large, active community providing documentation, forums, and technical support

## Common Concepts

**Boot Process**: The sequence of events that occur when Ubuntu starts, including BIOS/UEFI initialization, GRUB bootloader, kernel loading, systemd initialization, and service startup.

**Systemd**: The init system and service manager (PID 1) that manages system services, handles boot process, and controls system initialization on Ubuntu.

**GRUB (GRand Unified Bootloader)**: The bootloader that loads the Linux kernel and initializes the boot process. Configuration file: `/boot/grub/grub.cfg`.

**Users and Groups**: User accounts have unique User IDs (UID) and belong to groups with Group IDs (GID). User information stored in `/etc/passwd` and `/etc/shadow`. Groups stored in `/etc/group`.

**File Permissions**: Linux uses three permission types - Read (r), Write (w), Execute (x) - for three user categories - Owner (u), Group (g), Others (o). Numeric notation: r=4, w=2, x=1 (e.g., 755).

**Soft Links (Symbolic Links)**: Special files that point to another file or directory by pathname. Created with `ln -s`. Can link to files and directories, cross filesystems, but break if target is deleted.

**Hard Links**: Additional directory entries pointing to the same inode (file data). Created with `ln` command. All hard links reference the same physical file data. File data is only deleted when all hard links are removed. Can only link to files (not directories) and cannot cross filesystem boundaries.

**Differences Between Hard Links and Soft Links**:
1. **Target Reference**: Hard links point to the inode (file data directly), while soft links point to the pathname of the target file
2. **Filesystem Boundaries**: Hard links cannot cross filesystem boundaries (must be on same partition), while soft links can link across different filesystems
3. **Target Deletion**: If the target file is deleted, hard links continue to work and access the data, while soft links become broken (dangling links)

**Root User**: The superuser account (UID 0) with full administrative privileges. Access via `sudo` or `su` commands.

**Sudo**: Command that allows authorized users to execute commands as root or another user. Configuration in `/etc/sudoers`.

**Repository**: A collection of software packages available for installation. Ubuntu repositories are configured in `/etc/apt/sources.list`.

**Package**: A compressed archive containing software, its files, and metadata. Ubuntu uses `.deb` packages managed by APT and DPKG.

**Daemon**: A background service that runs continuously, typically without user interaction (e.g., SSH daemon, web servers).

**Inode**: Index node - a data structure that stores metadata about a file (permissions, ownership, size, timestamps) and points to the file's data blocks on disk. Each file has a unique inode number.

**Shell**: Command-line interface that interprets user commands and executes them. Common shells: Bash (default), Zsh, Fish. Configuration files: `~/.bashrc`, `~/.bash_profile`.

**Environment Variables**: Named values that store configuration and system information. Accessed with `$VARIABLE_NAME`. Common ones: `PATH`, `HOME`, `USER`. Set with `export VARIABLE=value`.

**Process**: A running instance of a program. Each process has a Process ID (PID). Parent process creates child processes. View with `ps`, `top`, `htop`. Kill with `kill` or `killall`.

**Working Directory**: The current directory where commands are executed. Check with `pwd`, change with `cd`. `~` represents home directory, `.` is current directory, `..` is parent directory.

**Pipes and Redirection**: Pipes (`|`) send output of one command as input to another. Redirection (`>`, `>>`, `<`) redirects input/output. Example: `ls | grep file > output.txt`.

**Mount Point**: A directory where a filesystem is attached/accessible. File systems are mounted to mount points using `mount` command. Common mount points: `/`, `/home`, `/boot`. Mount information in `/etc/fstab`.

**Kernel**: The core of the operating system that manages hardware resources, process scheduling, memory management, and system calls. Linux kernel version shown with `uname -r`.

**File System**: The method and data structure used to organize files on storage devices. Common types: ext4 (default), XFS, Btrfs. File system hierarchy standard (FHS) defines directory structure (`/bin`, `/usr`, `/var`, etc.).

**UID and GID**: User ID (UID) uniquely identifies a user. Group ID (GID) uniquely identifies a group. Root has UID 0. Regular users typically have UID ≥ 1000.

**TCP/IP**: Network protocols used for internet communication. TCP ensures reliable data delivery. IP handles addressing and routing. Ubuntu uses TCP/IP for network communications.

**SSH (Secure Shell)**: Network protocol for secure remote access and file transfer. Uses port 22. Connect with `ssh user@hostname`. Key-based authentication for passwordless access.

**Cron**: Time-based job scheduler that executes commands at specified intervals. Cron jobs stored in crontab files. Edit with `crontab -e`. Format: minute hour day month weekday command.

## Getting Started

### Pre-requisites

| License Type | Description | Commercial Use | Open Source |
|--------------|-------------|----------------|-------------|
| GNU GPL v3 | Free and open-source operating system. Ubuntu is free to use, modify, and distribute. | Yes | Yes |

## Software Overview

| Software | Version |
|----------|---------|
| Ubuntu | 22.04 LTS (Jammy Jellyfish) |
| Linux Kernel | 5.15.x |
| Systemd | 249.11 |

## System Requirement

| Requirement | Minimum | Recommendation |
|-------------|---------|----------------|
| Processor/Instance Type | 2 GHz dual-core | 2 GHz quad-core or higher |
| RAM | 4 Gigabyte | 8 Gigabyte or Higher |
| ROM (Disk Space) | 25 Gigabyte | 50 Gigabyte or Higher |
| OS Required | Ubuntu 20.04 LTS or higher | Ubuntu 22.04 LTS |

## Important Ports

| Ports | Description |
|-------|-------------|
| 22 | Port 22 is used to establish an SSH connection to access the system remotely. |
| 80 | Standard HTTP port for web traffic. |
| 443 | Standard HTTPS port for secure web communication over SSL/TLS. |
| 53 | DNS service port for domain name resolution. |
| 3306 | Default MySQL/MariaDB database port. |
| 5432 | Default PostgreSQL database port. |

## Dependencies

### Run-time Dependency

| Run-time Dependency | Version | Description |
|---------------------|---------|-------------|
| systemd | 249.x | System and service manager for Linux, handles system initialization and service management |
| glibc | 2.35+ | GNU C Library, essential system library providing core functionality |
| OpenSSL | 3.0.x | Cryptographic library for secure communications |

### Other Dependency

| Other Dependency | Version | Description |
|------------------|---------|-------------|
| APT | 2.4.x | Advanced Package Tool for software package management |
| NetworkManager | 1.36+ | Network connection manager for managing network settings |
| UFW | 0.36 | Uncomplicated Firewall for managing firewall rules |

## How to Setup/Install Ubuntu

### Step-by-step Installation Instruction

1. **Download Ubuntu ISO**:
   - Visit https://ubuntu.com/download
   - Choose Desktop or Server version
   - Download the ISO file (preferably LTS version for stability)

2. **Create Bootable USB Drive using Balena Etcher**:
   - Download and install Balena Etcher from https://www.balena.io/etcher/
   - Launch Balena Etcher application
   - Click "Flash from file" and select the downloaded Ubuntu ISO file
   - Click "Select target" and choose your USB drive (minimum 4GB capacity)
   - Click "Flash" to create bootable USB drive
   - Wait for the flashing process to complete (5-15 minutes depending on USB speed)
   - Safely eject the USB drive once the process is finished

3. **Boot from USB**:
   - Insert bootable USB drive into target computer
   - Restart computer and enter BIOS/UEFI settings (usually F2, F12, Delete, or Esc key)
   - Change boot order to boot from USB first
   - Save settings and exit
   - Computer will boot from USB showing Ubuntu installation menu

4. **Installation Options**:
   - **Try Ubuntu**: Test Ubuntu without installing (live session)
   - **Install Ubuntu**: Start installation process

5. **Installation Process**:
   - **Language Selection**: Choose your preferred language
   - **Keyboard Layout**: Select keyboard layout (test in text box)
   - **Updates and Other Software**:
     - Choose "Normal installation" or "Minimal installation"
     - Optionally check "Install third-party software"
   - **Installation Type**:
     - **Erase disk and install Ubuntu**: Wipes entire disk (backup data first)
     - **Something else**: Manual partitioning for advanced users
   - **Create User Account**:
     - Enter your name
     - Choose username
     - Set password (or allow login without password)
     - Choose hostname (computer name)
   - **Wait for Installation**: Installation process will copy files and configure system (10-30 minutes)

6. **Complete Installation**:
   - Click "Restart Now" when installation completes
   - Remove USB drive when prompted
   - System will reboot into Ubuntu

7. **Post-Installation**:
   - Login with created user account
   - Complete first-time setup (if any)
   - Update system: `sudo apt update && sudo apt upgrade -y`

### Installation on Virtual Machine

1. **Download Ubuntu ISO** (same as above)

2. **Create Virtual Machine**:
   - **VirtualBox**:
     - Click "New" → Enter name and select "Linux" → "Ubuntu (64-bit)"
     - Allocate RAM (minimum 2GB, recommended 4GB+)
     - Create virtual hard disk (VDI, 25GB minimum)
     - Select virtual machine → Settings → Storage → Add Ubuntu ISO to optical drive
   
   - **VMware**:
     - Create New Virtual Machine → Typical → Installer disc image file (ISO)
     - Select Ubuntu ISO file
     - Enter user details and VM name
     - Set disk size (25GB minimum)

3. **Install Ubuntu**:
   - Start virtual machine
   - Follow same installation steps as physical installation

### Installation on Cloud Platforms

**AWS EC2**:
1. Launch EC2 instance
2. Select Ubuntu Server AMI (Amazon Machine Image)
3. Choose instance type (t2.micro for testing)
4. Configure security groups
5. Launch and connect via SSH

**Azure**:
1. Create Virtual Machine resource
2. Select Ubuntu Server image
3. Choose VM size
4. Configure networking and authentication
5. Deploy and connect via SSH

**Google Cloud**:
1. Create Compute Engine instance
2. Select Ubuntu image from boot disk options
3. Choose machine type
4. Configure firewall rules
5. Deploy and connect via SSH

### Verification

After installation, verify Ubuntu is working correctly:
```bash
# Check Ubuntu version
lsb_release -a

# Check kernel version
uname -r

# Check system uptime
uptime

# Check disk space
df -h

# Check network connectivity
ping -c 4 8.8.8.8
```

## Software Management

### APT (Advanced Package Tool)

APT is Ubuntu's primary package management system for installing, updating, and removing software.

**Basic Commands:**
```bash
# Update package list
sudo apt update

# Upgrade all packages
sudo apt upgrade

# Install a package
sudo apt install package-name

# Remove a package
sudo apt remove package-name

# Remove package and configuration files
sudo apt purge package-name

# Search for packages
apt search keyword

# Show package information
apt show package-name

# List installed packages
apt list --installed

# Update package list and upgrade all packages
sudo apt update && sudo apt upgrade -y
```

**Package Repository Management:**
- Repository configuration: `/etc/apt/sources.list` and `/etc/apt/sources.list.d/`
- Add repository: `sudo add-apt-repository "repository-url"`
- Remove repository: `sudo add-apt-repository --remove "repository-url"`

### DPKG (Debian Package Manager)

Low-level package management tool for installing `.deb` files directly.

**Commands:**
```bash
# Install a .deb file
sudo dpkg -i package.deb

# Remove a package
sudo dpkg -r package-name

# List installed packages
dpkg -l

# Show package information
dpkg -s package-name

# Fix broken dependencies
sudo apt --fix-broken install
```

### SNAP Package Manager

Modern, cross-distribution package manager for containerized applications.

**Commands:**
```bash
# Install snapd (if not installed)
sudo apt install snapd

# Install a snap package
sudo snap install package-name

# Remove a snap package
sudo snap remove package-name

# List installed snaps
snap list

# Update all snaps
sudo snap refresh

# Search for snaps
snap search keyword
```

### Other Package Managers

**Flatpak:**
```bash
# Install Flatpak
sudo apt install flatpak

# Add Flathub repository
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Install package
flatpak install package-name
```

**AppImage:**
- Download AppImage file
- Make it executable: `chmod +x application.AppImage`
- Run directly: `./application.AppImage`

## Services

### Systemd Service Management

Ubuntu uses systemd as its init system and service manager.

**Basic Service Commands:**
```bash
# Start a service
sudo systemctl start service-name

# Stop a service
sudo systemctl stop service-name

# Restart a service
sudo systemctl restart service-name

# Reload service configuration
sudo systemctl reload service-name

# Enable service to start on boot
sudo systemctl enable service-name

# Disable service from starting on boot
sudo systemctl disable service-name

# Check service status
sudo systemctl status service-name

# List all services
systemctl list-units --type=service

# List enabled services
systemctl list-unit-files --type=service --state=enabled

# List failed services
systemctl list-units --state=failed
```

**Common Services:**
- `ssh`: SSH daemon for remote access
- `apache2` / `nginx`: Web server services
- `mysql` / `postgresql`: Database services
- `ufw`: Firewall service
- `docker`: Docker daemon service

**Service File Location:**
- System services: `/etc/systemd/system/`
- User services: `~/.config/systemd/user/`
- Systemd unit files: `/lib/systemd/system/`

**Create Custom Service:**
1. Create service file: `sudo nano /etc/systemd/system/my-service.service`
2. Example service file:
   ```ini
   [Unit]
   Description=My Custom Service
   After=network.target

   [Service]
   Type=simple
   User=myuser
   ExecStart=/usr/bin/my-application
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```
3. Reload systemd: `sudo systemctl daemon-reload`
4. Enable and start: `sudo systemctl enable my-service && sudo systemctl start my-service`

**Service Logs:**
```bash
# View service logs
sudo journalctl -u service-name

# Follow logs in real-time
sudo journalctl -u service-name -f

# View logs since boot
sudo journalctl -u service-name -b

# View last 100 lines
sudo journalctl -u service-name -n 100
```

## Contact Information

| Name | Email address |
|------|---------------|
| mukesh | msmukeshkumarsharma@gmail.com |

## References

| Links | Descriptions |
|-------|--------------|
| https://ubuntu.com/ | Official Ubuntu website with documentation and downloads |
| https://help.ubuntu.com/ | Official Ubuntu help and documentation |
| https://wiki.ubuntu.com/ | Ubuntu Wiki with community documentation |
| https://askubuntu.com/ | Community Q&A forum for Ubuntu |
| https://ubuntu.com/server/docs | Ubuntu Server documentation |
| https://systemd.io/ | Systemd documentation for service management |
| https://wiki.debian.org/Apt | APT package manager documentation |
| https://snapcraft.io/docs | Snap package manager documentation |
