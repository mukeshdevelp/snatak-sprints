# Role CI/CD Implemetation


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 27-02-2026 | v1.0 | Mukesh Sharma | 27-02-2026 |  | aniruddh sir | faisal sir | ashwani sir |

---

## Table of Contents

1. [PostgreSQL role (Ubuntu) — overview](#1-postgresql-role-ubuntu--overview)
2. [Static inventory (Ubuntu hosts)](#2-static-inventory-ubuntu-hosts)
3. [Role structure and logic](#3-role-structure-and-logic)
4. [Playbook for role CD](#4-playbook-for-role-cd)
5. [CD steps for PostgreSQL role (using static inventory)](#5-cd-steps-for-postgresql-role-using-static-inventory)
   - 5.1 [Prepare control node](#51-prepare-control-node)
   - 5.2 [Configure static inventory](#52-configure-static-inventory)
   - 5.3 [Review or adjust role defaults](#53-review-or-adjust-role-defaults)
   - 5.4 [Run a dry run (check mode)](#54-run-a-dry-run-check-mode)
   - 5.5 [Apply the role (actual CD run)](#55-apply-the-role-actual-cd-run)
   - 5.6 [Post-deploy validation](#56-post-deploy-validation)
6. [FAQ](#6-faq)
7. [Contact Information](#7-contact-information)

---

## 1. PostgreSQL role (Ubuntu) — overview

This document describes a simple **Ansible role** that installs and configures **PostgreSQL** on **Ubuntu** servers using a **static inventory**, and how to run the role as part of role-level **CD**.

Role path (relative to this repo):

- `ansible/roles/postgresql/`
  - `defaults/main.yml`
  - `tasks/main.yml`
  - `handlers/main.yml`
  - `meta/main.yml`

Supporting files:

- Static inventory: `ansible/inventory/static.ini`
- Playbook for CD: `ansible/postgresql-role-cd.yml`

---

## 2. Static inventory (Ubuntu hosts)

File: `ansible/inventory/static.ini`

```ini
[postgresql_servers]
pg-host-1 ansible_ssh_private_key_file=~/secretKey.pem ansible_host=18.206.96.132 ansible_user=ubuntu

```

- **Group**: `postgresql_servers` — all hosts where PostgreSQL should be installed.
- **OS**: Ubuntu (remote user `ubuntu`).
- Replace `18.206.96.132` with your actual server IP/hostname.

---

## 3. Role structure and logic

**Role root**

- `ansible/roles/postgresql/`

**Defaults**

File: `ansible/roles/postgresql/defaults/main.yml`

```yaml
---
# Default PostgreSQL major version for Ubuntu
postgresql_version: "14"

# Whether this role should manage pg_hba.conf for local connections
postgresql_manage_pg_hba: true
```

**Tasks**

File: `ansible/roles/postgresql/tasks/main.yml`

```yaml
---
- name: Install PostgreSQL packages (Ubuntu)
  become: true
  ansible.builtin.apt:
    name:
      - postgresql
      - postgresql-contrib
    state: present
    update_cache: true

- name: Ensure PostgreSQL service is enabled and running
  become: true
  ansible.builtin.service:
    name: postgresql
    state: started
    enabled: true

- name: Allow local connections from all users (optional)
  become: true
  ansible.builtin.lineinfile:
    path: /etc/postgresql/{{ postgresql_version }}/main/pg_hba.conf
    regexp: '^host\\s+all\\s+all\\s+127\\.0\\.0\\.1/32\\s+'
    line: 'host    all             all             127.0.0.1/32            md5'
    state: present
  notify: Restart PostgreSQL
  when: postgresql_manage_pg_hba
```

**Handlers**

File: `ansible/roles/postgresql/handlers/main.yml`

```yaml
---
- name: Restart PostgreSQL
  become: true
  ansible.builtin.service:
    name: postgresql
    state: restarted
```

---

## 4. Playbook for role CD

File: `ansible/postgresql-role-cd.yml`

```yaml
---
- name: Apply PostgreSQL role on Ubuntu hosts
  hosts: postgresql_servers
  become: true
  vars:
    # Override defaults if needed
    # postgresql_version: "16"
    # postgresql_manage_pg_hba: true
  roles:
    - postgresql
```

---

## 5. CD steps for PostgreSQL role (using static inventory)

Follow these steps to deploy the **postgresql** role to Ubuntu servers:

### 5.1 Prepare control node

- Install Ansible on your control machine.
- Ensure SSH access from control node to the Ubuntu server(s) as user `ubuntu`.

### 5.2 Configure static inventory

- Edit `ansible/inventory/static.ini` and set the correct `ansible_host` IP/hostname for your PostgreSQL targets.

### 5.3 Review or adjust role defaults

- Open `ansible/roles/postgresql/defaults/main.yml`.
- Change `postgresql_version` if you want a different major version available in Ubuntu repos.
- Set `postgresql_manage_pg_hba` to `false` if you want to manage `pg_hba.conf` externally.

### 5.4 Run a dry run (check mode)

- From `ansible/` directory:
  ```bash
  cd sprint-2/ansible
  ansible-playbook -i inventory/static.ini postgresql-role-cd.yml --check
  ```
- Verify that the planned changes look correct.

### 5.5 Apply the role (actual CD run)

- From `ansible/` directory:
  ```bash
  cd sprint-2/ansible
  ansible-playbook -i inventory/static.ini postgresql-role-cd.yml
  ```
- Ansible will:
  - Install `postgresql` and `postgresql-contrib` via `apt`.
  - Enable and start the `postgresql` service.
  - Optionally update `pg_hba.conf` for local connections and restart PostgreSQL.

### 5.6 Post-deploy validation

- SSH to the Ubuntu host and verify:
  ```bash
  sudo systemctl status postgresql
  psql --version
  ```
- Optionally, connect as the `postgres` user to confirm DB is running:
  ```bash
  sudo -u postgres psql -c '\l'
  ```

These steps define the **CD flow** for the PostgreSQL role using a **static inventory** and **Ubuntu** as the OS.

---

## 6. FAQ

1. **"Unable to parse ... static.ini" or "Could not match host pattern: postgresql_servers"?**  
   Run the playbook from the **ansible** directory (the one that contains `roles/` and `inventory/`), not from inside `ansible/roles/`. Use:
   ```bash
   cd /path/to/snatak-sprints/sprint-2/ansible
   ansible-playbook postgresql-role-cd.yml
   ```
   An `ansible.cfg` in this directory sets `inventory = inventory/static.ini` and `deprecation_warnings = False`.

2. **Why use static inventory for this role?**  
  Static inventory is simple to manage for a fixed set of hosts (e.g. a few PostgreSQL servers). You list hosts in `inventory/static.ini`; no dynamic source or extra plugins are required. For many hosts or cloud-based discovery, consider dynamic inventory later.

3. **How do I add more PostgreSQL servers?**  
  Add more lines under `[postgresql_servers]` in `ansible/inventory/static.ini` with unique names and `ansible_host` (and `ansible_user=ubuntu` if needed). Re-run the playbook; the role applies to all hosts in the group.

4. **Can I use a different PostgreSQL version?**  
  Set the `postgresql_version` variable (e.g. in the playbook or in `roles/postgresql/defaults/main.yml`) to the major version number (e.g. `"16"`). Ensure that version is available in Ubuntu’s repositories for your release.

- **What if I don’t want the role to change pg_hba.conf?**  
  Set `postgresql_manage_pg_hba: false` in the playbook or in role defaults. The role will only install packages and manage the PostgreSQL service.

6. **Do I need to use Ubuntu?**  
  This role is written for Ubuntu (apt, `postgresql` package, paths like `/etc/postgresql/{{ postgresql_version }}/main/`). For other OS (e.g. RHEL), you would need a different role or conditional tasks (e.g. yum, different config paths).

---

## 7. Contact Information


| Name|Email Address |
|----------------|----------------|
|Mukesh kumar Sharma|msmukeshkumarsharma95@gmail.com|


---