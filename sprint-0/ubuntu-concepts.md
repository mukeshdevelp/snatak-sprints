# Ubuntu Concepts

**Mukesh** edited this page on Dec 14, 2023 · 1 revision

| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 16-01-2026 | v1.0 | Mukesh Sharma| 16-01-2026 |  |  |  |  |


## Table of Contents

- [What is Ubuntu?](#what-is-ubuntu)
  - [Definition](#definition)
  - [Core Components](#core-components)
- [Why Ubuntu?](#why-ubuntu)
  - [Benefits](#benefits)
  - [Use Cases](#use-cases)
- [Key Features](#key-features)
- [Common Concepts](#common-concepts)
- [Getting Started](#getting-started)
  - [Pre-requisites](#pre-requisites)
- [Software Overview](#software-overview)
- [System Requirement](#system-requirement)
- [Dependencies](#dependencies)
  - [Run-time Dependency](#run-time-dependency)
  - [Other Dependency](#other-dependency)
- [Software Management](#software-management)
  - [APT (Advanced Package Tool)](#apt-advanced-package-tool)
  - [DPKG (Debian Package Manager)](#dpkg-debian-package-manager)
  - [SNAP Package Manager](#snap-package-manager)
- [Services](#services)
  - [Systemd Service Management](#systemd-service-management)
- [Process Management](#process-management)
- [Conclusion](#conclusion)
- [Troubleshooting](#troubleshooting)
- [FAQs](#faqs)
- [Contact Information](#contact-information)
- [References](#references)

## What is Ubuntu?

Ubuntu is a free and open-source Linux distribution based on Debian, designed for desktop, server, and cloud environments. It is one of the most popular Linux distributions worldwide, known for its user-friendly interface, strong security features, and extensive community support. Ubuntu provides a stable, secure, and easy-to-use operating system that serves as the foundation for many enterprise applications, cloud services, and development environments.

### Definition

Ubuntu is an operating system built on the Linux kernel, providing a complete computing environment with system software, applications, and development tools. It combines the stability of Debian with a focus on ease of use and regular release cycles, making it accessible to both beginners and experienced users.

### Core Components

1. **Linux Kernel**: The core operating system component that manages hardware resources
2. **Systemd**: Init system and service manager for system initialization and service management
3. **GNOME Desktop Environment**: Default graphical user interface (for Desktop edition)
4. **APT Package Manager**: Tool for installing, updating, and managing software packages
5. **Shell (Bash)**: Command-line interface for interacting with the system

## Why Ubuntu?

Ubuntu offers numerous advantages and is widely used across different sectors due to its reliability, security, and versatility.

### Benefits

1. **Free and Open Source**: No licensing costs, complete source code access, and freedom to modify
2. **Security**: Built-in security features including automatic security updates, AppArmor, and UFW firewall
3. **Stability**: LTS (Long-Term Support) versions receive 5 years of security updates and support
4. **Ease of Use**: User-friendly interface suitable for users transitioning from other operating systems
5. **Large Software Repository**: Thousands of free applications available through package managers
6. **Community Support**: Active community providing help, documentation, and troubleshooting
7. **Enterprise Ready**: Used by major corporations and cloud providers worldwide
8. **Regular Updates**: Consistent release cycle with new features every 6 months

### Use Cases

Ubuntu is used in various scenarios to solve specific problems and meet particular needs:

1. **Desktop Computing**: Provides a user-friendly desktop environment for personal computers, offering an alternative to proprietary operating systems
2. **Server Deployment**: Powers web servers, database servers, application servers, and enterprise infrastructure
3. **Cloud Platforms**: Used as the base operating system for cloud instances on AWS, Azure, Google Cloud, and other cloud providers
4. **Development Environment**: Offers a robust platform for software development with extensive programming language support and development tools
5. **Container Hosting**: Serves as the host OS for Docker containers and Kubernetes clusters
6. **IoT and Embedded Systems**: Provides lightweight versions for Internet of Things (IoT) devices and embedded systems


## Key Features

1. **User-Friendly Interface**: Intuitive graphical user interface (GNOME desktop environment) that makes Linux accessible to users of all skill levels
2. **Security**: Built-in security features including AppArmor, UFW firewall, automatic security updates, and strong user permission management
3. **Package Management**: Advanced package management system (APT) with thousands of pre-configured software packages
4. **Long-Term Support (LTS)**: LTS releases provide 5 years of security updates and support, ensuring stability for enterprise deployments
5. **Open Source**: Completely free and open-source software with active community contributions
6. **Hardware Compatibility**: Extensive hardware support with drivers included for most modern hardware
7. **Regular Updates**: Scheduled releases every 6 months, with LTS versions every 2 years
8. **Community Support**: Large, active community providing documentation, forums, and technical support

## Common Concepts

1. **Boot Process**: Sequence of events when Ubuntu starts - BIOS/UEFI initialization, GRUB bootloader, kernel loading, systemd initialization, and service startup.

2. **Systemd**: Init system and service manager (PID 1) that manages system services, handles boot process, and controls system initialization.

3. **GRUB (GRand Unified Bootloader)**: Bootloader that loads the Linux kernel and initializes the boot process. Configuration file: `/boot/grub/grub.cfg`.

4. **Users and Groups**: User accounts have unique User IDs (UID) and belong to groups with Group IDs (GID). User info in `/etc/passwd` and `/etc/shadow`. Groups in `/etc/group`.

5. **File Permissions**: Three permission types - Read (r), Write (w), Execute (x) - for three categories - Owner (u), Group (g), Others (o). Numeric: r=4, w=2, x=1 (e.g., 755).

6. **Soft Links (Symbolic Links)**: Special files pointing to another file/directory by pathname. Created with `ln -s`. Can link to files/directories, cross filesystems, but break if target deleted.

7. **Hard Links**: Additional directory entries pointing to same inode (file data). Created with `ln`. File data deleted only when all hard links removed. Only for files, cannot cross filesystems.

8. **Differences Between Hard Links and Soft Links**:
   - **Target Reference**: Hard links point to inode (file data directly), soft links point to pathname
   - **Filesystem Boundaries**: Hard links cannot cross filesystems, soft links can
   - **Target Deletion**: Hard links continue working if target deleted, soft links become broken

9. **Root User**: Superuser account (UID 0) with full administrative privileges. Access via `sudo` or `su` commands.

10. **Sudo**: Command allowing authorized users to execute commands as root or another user. Configuration in `/etc/sudoers`.

11. **Repository**: Collection of software packages available for installation. Ubuntu repositories configured in `/etc/apt/sources.list`.

12. **Package**: Compressed archive containing software, files, and metadata. Ubuntu uses `.deb` packages managed by APT and DPKG.

13. **Daemon**: Background service running continuously without user interaction (e.g., SSH daemon, web servers).

14. **Inode**: Index node - data structure storing file metadata (permissions, ownership, size, timestamps) and pointing to file's data blocks. Each file has unique inode number.

15. **Shell**: Command-line interface interpreting user commands. Common shells: Bash (default), Zsh, Fish. Config files: `~/.bashrc`, `~/.bash_profile`.

16. **Environment Variables**: Named values storing configuration and system information. Accessed with `$VARIABLE_NAME`. Common: `PATH`, `HOME`, `USER`. Set with `export VARIABLE=value`.

17. **Process**: Running instance of a program. Each has Process ID (PID). Parent creates child processes. View with `ps`, `top`, `htop`. Kill with `kill` or `killall`.

18. **Working Directory**: Current directory where commands execute. Check with `pwd`, change with `cd`. `~` is home, `.` is current, `..` is parent directory.

19. **Pipes and Redirection**: Pipes (`|`) send command output as input to another. Redirection (`>`, `>>`, `<`) redirects input/output. Example: `ls | grep file > output.txt`.

20. **Mount Point**: Directory where filesystem is attached/accessible. File systems mounted using `mount` command. Common: `/`, `/home`, `/boot`. Info in `/etc/fstab`.

21. **Kernel**: Core of operating system managing hardware resources, process scheduling, memory management, and system calls. Version shown with `uname -r`.

22. **File System**: Method and data structure organizing files on storage. Common types: ext4 (default), XFS, Btrfs. FHS defines directory structure (`/bin`, `/usr`, `/var`, etc.).

23. **UID and GID**: User ID (UID) uniquely identifies user. Group ID (GID) uniquely identifies group. Root has UID 0. Regular users typically UID ≥ 1000.

24. **TCP/IP**: Network protocols for internet communication. TCP ensures reliable delivery. IP handles addressing and routing.

25. **SSH (Secure Shell)**: Network protocol for secure remote access and file transfer. Uses port 22. Connect with `ssh user@hostname`. Key-based authentication for passwordless access.

26. **Cron**: Time-based job scheduler executing commands at specified intervals. Jobs stored in crontab files. Edit with `crontab -e`. Format: minute hour day month weekday command.

27. **Umask**: Default file permission mask applied when creating files/directories. Example: umask 022 sets permissions to 755 for directories, 644 for files.

28. **Tar (Tape Archive)**: Utility for creating and extracting archive files. Commands: `tar -czf` (create), `tar -xzf` (extract).

29. **Swap Space**: Virtual memory area on disk used when physical RAM is full. Improves system stability.

30. **Runlevel/Target**: System operational state determining which services run. Systemd uses targets (multi-user.target, graphical.target).

31. **Journalctl**: Systemd's log viewing utility for accessing system and service logs.

32. **APT Cache**: Local database storing package information from repositories. Speeds up package operations.

33. **FHS (Filesystem Hierarchy Standard)**: Standard defining directory structure and file locations in Linux systems.

34. **Man Pages**: Manual pages providing documentation for commands. Access with `man command-name`.

35. **Fstab**: File System Table (`/etc/fstab`) defining filesystems to mount at boot.

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
1. Repository configuration: `/etc/apt/sources.list` and `/etc/apt/sources.list.d/`
2. Add repository: `sudo add-apt-repository "repository-url"`
3. Remove repository: `sudo add-apt-repository --remove "repository-url"`

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

# Search for snaps
snap search keyword
```

## Services

### Systemd Service Management

Ubuntu uses systemd as its init system and service manager.

**Basic Service Commands:**
```bash
# Start a service
sudo systemctl start ot-service

# Stop a service
sudo systemctl stop ot-service

# Restart a service
sudo systemctl restart ot-service

# Reload service configuration
sudo systemctl reload ot-service

# Enable service to start on boot
sudo systemctl enable ot-service

# Disable service from starting on boot
sudo systemctl disable ot-service

# Check service status
sudo systemctl status ot-service

# List all services
systemctl list-units --type=service

```

**Service File Location:**
1. System services: `/etc/systemd/system/`
2. User services: `~/.config/systemd/user/`
3. Systemd unit files: `/lib/systemd/system/`

**Create Custom Service:**
1. Create service file: `sudo nano /etc/systemd/system/ot-service.service`
2. Example service file:
   ```ini
   [Unit]
   Description=OT-Microservice
   After=network.target

   [Service]
   Type=simple
   User=myuser
   ExecStart=/usr/bin/ot-service
   Restart=always

   [Install]
   WantedBy=multi-user.target
   ```
3. Reload systemd: `sudo systemctl daemon-reload`
4. Enable and start: `sudo systemctl enable ot-service && sudo systemctl start ot-service`

**Service Logs:**
```bash
# View service logs
sudo journalctl -u ot-service
```

## Process Management

Essential commands for managing processes on Ubuntu:

### Basic Commands

```bash
# List all running processes
ps aux

# Display real-time process information
top
# or htop (install: sudo apt install htop)

# Find process by name
pgrep nginx
pidof mysql

# Find processes using specific port
sudo lsof -i :80
```

### Process Control

```bash
# Start process in background
nginx &

# Terminate process gracefully
kill PID

# Force kill process
kill -9 PID

# Kill process by name
killall nginx
killall mysql

# Change process priority (nice value: -20 to 19)
nice -n 10 nginx
renice -n 10 -p PID
```

### Common Signals

1. **SIGTERM (15)**: Graceful termination
2. **SIGKILL (9)**: Force kill (cannot be ignored)
3. **SIGSTOP (19)**: Pause process
4. **SIGCONT (18)**: Resume stopped process

### Process States

1. **Running (R)**: Executing or ready to run
2. **Sleeping (S)**: Waiting for event (interruptible)
3. **Stopped (T)**: Stopped by signal
4. **Zombie (Z)**: Terminated but not reaped by parent

## Conclusion

Ubuntu stands as a powerful, versatile, and user-friendly Linux distribution that serves multiple purposes across desktop, server, and cloud environments. With its strong emphasis on security, stability, and ease of use, Ubuntu has become one of the most widely adopted operating systems globally.

## Troubleshooting

Common issues and solutions:

### Package Installation Issues

**Package Installation Fails:**
```bash
sudo apt update
sudo apt --fix-broken install
sudo dpkg --configure -a
sudo apt clean
```

**Locked Package Manager:**
```bash
sudo rm /var/lib/apt/lists/lock /var/cache/apt/archives/lock /var/lib/dpkg/lock*
sudo dpkg --configure -a
```

### Service Issues

**Service Won't Start:**
```bash
sudo systemctl status ot-service
sudo journalctl -u ot-service -n 50
sudo systemctl daemon-reload
sudo systemctl restart ot-service
```

### Network Issues

**Network Connectivity Problems:**
```bash
ip addr show
ping -c 4 8.8.8.8
sudo systemctl restart NetworkManager
nslookup google.com
```

**Firewall Blocking:**
```bash
sudo ufw status
sudo ufw allow port-number/tcp
```

### Disk Space Issues

**Disk Space Full:**
```bash
df -h
sudo du -h --max-depth=1 / | sort -hr
sudo apt clean
sudo apt autoremove --purge
sudo journalctl --vacuum-time=7d
```

## FAQs

**1. Is Ubuntu free to use?**
Yes, Ubuntu is completely free and open-source with no licensing fees for personal or commercial use.

**2. What is the difference between Ubuntu Desktop and Ubuntu Server?**
Ubuntu Desktop includes a graphical interface and desktop applications, while Ubuntu Server is optimized for server environments without GUI.

**3. How often is Ubuntu updated?**
Ubuntu releases new versions every 6 months. LTS versions are released every 2 years and receive 5 years of support.

**4. Can I upgrade Ubuntu without reinstalling?**
Yes, use `sudo do-release-upgrade` command which preserves your data and installed applications.

**5. Is Ubuntu suitable for enterprise use?**
Yes, Ubuntu LTS versions are widely used in enterprise environments with extended security support.

**6. How do I get support for Ubuntu?**
Ubuntu has extensive community support through forums, documentation, and Ask Ubuntu. Canonical offers commercial support for Ubuntu Pro.

**7. What package manager does Ubuntu use?**
Ubuntu uses APT (Advanced Package Tool) as primary package manager, also supports DPKG and SNAP.

**8. How do I install software on Ubuntu?**
Use `sudo apt install package-name` or `sudo snap install package-name` or `sudo dpkg -i package.deb`.

**9. What is the root password in Ubuntu?**
Ubuntu does not use a root password by default. Administrative tasks use `sudo` with the user's password.

**10. What is LTS in Ubuntu?**
LTS stands for Long-Term Support. LTS releases receive 5 years of security updates and support.

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
