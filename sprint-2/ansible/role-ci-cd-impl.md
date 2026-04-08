# Role CI/CD Implemetation


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 27-02-2026 | v1.0 | Mukesh Sharma | 27-02-2026 |  | aniruddh sir | faisal sir | ashwani sir |

---

## Table of Contents

1. [PostgreSQL role (Ubuntu) — overview](#1-postgresql-role-ubuntu--overview)
2. [Create an Ansible role](#2-create-an-ansible-role)
3. [Static inventory (Ubuntu hosts)](#3-static-inventory-ubuntu-hosts)
4. [Role structure and logic](#4-role-structure-and-logic)
5. [Playbook for role CD](#5-playbook-for-role-cd)
6. [CD steps for PostgreSQL role (using static inventory)](#6-cd-steps-for-postgresql-role-using-static-inventory)
   - 6.1 [Prepare control node](#61-prepare-control-node)
   - 6.2 [Configure static inventory](#62-configure-static-inventory)
   - 6.3 [Review or adjust role defaults](#63-review-or-adjust-role-defaults)
   - 6.4 [Run a dry run (check mode)](#64-run-a-dry-run-check-mode)
   - 6.5 [Apply the role (actual CD run)](#65-apply-the-role-actual-cd-run)
   - 6.6 [Post-deploy validation](#66-post-deploy-validation)
7. [FAQ](#7-faq)
8. [Contact Information](#8-contact-information)
9. [References](#9-references)

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

## 2. Create an Ansible role

To create a new role from scratch (e.g. for another service), use `ansible-galaxy init` from the `ansible/roles` directory:

```bash
cd /path/to/snatak-sprints/sprint-2/ansible/roles
ansible-galaxy init postgresql
```

This creates the standard role layout:

```
roles/postgresql/
├── defaults/
│   └── main.yml
├── handlers/
│   └── main.yml
├── meta/
│   └── main.yml
├── tasks/
│   └── main.yml
├── templates/
├── files/
├── vars/
│   └── main.yml
└── README.md
```

Then add tasks in `tasks/main.yml`, defaults in `defaults/main.yml`, and reference the role from a playbook with `roles: - my_role_name`.

---

## 3. Static inventory (Ubuntu hosts)

File: `ansible/inventory/static.ini`

```ini
[postgresql_servers]
pg-host-1 ansible_ssh_private_key_file=~/secretKey.pem ansible_host=18.206.96.132 ansible_user=ubuntu

```
<img width="1920" height="234" alt="image" src="https://github.com/user-attachments/assets/3293a933-f7c4-4809-a6ff-f889a7530430" />


- **Group**: `postgresql_servers` — all hosts where PostgreSQL should be installed.
- **OS**: Ubuntu (remote user `ubuntu`).
- Replace `18.206.96.132` with your actual server IP/hostname.

---

## 4. Role structure and logic

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
<img width="1920" height="290" alt="image" src="https://github.com/user-attachments/assets/843db826-e301-4fa6-bc42-b271ba1d5024" />

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
<img width="1920" height="894" alt="image" src="https://github.com/user-attachments/assets/c3ba8cac-da3d-4e26-9a59-8b407050677d" />

<img width="1920" height="894" alt="image" src="https://github.com/user-attachments/assets/f9b4d37c-3f60-489f-a74e-976d9d0f5a15" />

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
<img width="1920" height="283" alt="image" src="https://github.com/user-attachments/assets/7fc9468d-c8e6-4403-980c-19149b51b53a" />

---

## 5. Playbook for role CD

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

<img width="1920" height="331" alt="image" src="https://github.com/user-attachments/assets/3d223604-64c4-477c-be8d-99a84787d823" />

---

## 6. CD steps for PostgreSQL role (using static inventory)

Follow these steps to deploy the **postgresql** role to Ubuntu servers:

### 6.1 Prepare control node

- Install Ansible on your control machine.
- Ensure SSH access from control node to the Ubuntu server(s) as user `ubuntu`.

### 6.2 Configure static inventory

- Edit `ansible/inventory/static.ini` and set the correct `ansible_host` IP/hostname for your PostgreSQL targets.

### 6.3 Review or adjust role defaults

- Open `ansible/roles/postgresql/defaults/main.yml`.
- Change `postgresql_version` if you want a different major version available in Ubuntu repos.
- Set `postgresql_manage_pg_hba` to `false` if you want to manage `pg_hba.conf` externally.

### 6.4 Run a dry run (check mode)

- From `ansible/` directory:
  ```bash
  cd sprint-2/ansible
  ansible-playbook -i inventory/static.ini postgresql-role-cd.yml --check
  ```
- Verify that the planned changes look correct.

<img width="1920" height="943" alt="image" src="https://github.com/user-attachments/assets/c1377f43-612d-4b83-94a8-74419b233b5e" />


### 6.5 Apply the role (actual CD run)

- From `ansible/` directory:
  ```bash
  cd sprint-2/ansible
  ansible-playbook -i inventory/static.ini postgresql-role-cd.yml
  ```
- Ansible will:
  - Install `postgresql` and `postgresql-contrib` via `apt`.
  - Enable and start the `postgresql` service.
  - Optionally update `pg_hba.conf` for local connections and restart PostgreSQL.
<img width="1920" height="943" alt="image" src="https://github.com/user-attachments/assets/602a5311-a5ea-46fd-93f1-63eb755ba544" />

### 6.6 Post-deploy validation

- SSH to the Ubuntu host and verify:
  ```bash
  sudo systemctl status postgresql
  psql --version
  ```
  <img width="1920" height="943" alt="image" src="https://github.com/user-attachments/assets/fac5abb1-df48-482e-affc-370636590c09" />

- Optionally, connect as the `postgres` user to confirm DB is running:
  ```bash
  sudo -u postgres psql -c '\l'
  ```
  <img width="1920" height="557" alt="image" src="https://github.com/user-attachments/assets/c0945dde-3f24-451c-9742-0dad81b01071" />


These steps define the **CD flow** for the PostgreSQL role using a **static inventory** and **Ubuntu** as the OS.

---

## 7. FAQ

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

5. **What if I don’t want the role to change pg_hba.conf?**  
  Set `postgresql_manage_pg_hba: false` in the playbook or in role defaults. The role will only install packages and manage the PostgreSQL service.

6. **Do I need to use Ubuntu?**  
  This role is written for Ubuntu (apt, `postgresql` package, paths like `/etc/postgresql/{{ postgresql_version }}/main/`). For other OS (e.g. RHEL), you would need a different role or conditional tasks (e.g. yum, different config paths).

---

## 8. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh Kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 9. References

| Link | Description |
|------|-------------|
| [Ansible User Guide](https://docs.ansible.com/ansible/latest/user_guide/index.html) | Ansible documentation and concepts. |
| [Ansible Roles](https://docs.ansible.com/ansible/latest/user_guide/playbooks_reuse_roles.html) | Reusing roles in playbooks. |
| [ansible-galaxy init](https://docs.ansible.com/ansible/latest/cli/ansible-galaxy.html#creating-roles) | Create a new role with the standard layout. |
| [Ansible Inventory](https://docs.ansible.com/ansible/latest/inventory_guide/intro_inventory.html) | Static and dynamic inventory. |

---
