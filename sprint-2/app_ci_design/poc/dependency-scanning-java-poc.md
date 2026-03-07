# Dependency Scanning | Java CI Checks — POC


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 26-02-2026 | v1.0 | Mukesh Sharma | 26-02-2026 |  |  |  |  |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Scope and context](#2-scope-and-context)
3. [Prerequisites](#3-prerequisites)
4. [Step 1 — Install Maven (if needed)](#4-step-1--install-maven-if-needed)
5. [Step 2 — Navigate to project and build](#5-step-2--navigate-to-project-and-build)
6. [Step 3 — Add OWASP Dependency-Check plugin](#6-step-3--add-owasp-dependency-check-plugin)
7. [Step 4 — Generate NVD API key](#7-step-4--generate-nvd-api-key)
8. [Step 5 — Run the dependency scan](#8-step-5--run-the-dependency-scan)
9. [Step 6 — Locate and open the report](#9-step-6--locate-and-open-the-report)
10. [Best practices](#10-best-practices)
11. [Contact Information](#11-contact-information)
12. [References](#12-references)

---

## 1. Introduction

This guide shows how to run **OWASP Dependency-Check manually** for a Maven project. You can use the Maven plugin (add to `pom.xml`) or the Docker/CLI approach for quick scans without modifying the project.

Dependency scanning is an automated process that identifies security vulnerabilities and license issues in third-party libraries and packages used by your applications.

Dependency scanning checks the **third-party libraries used in your project** for **known security vulnerabilities (CVEs)**.

OWASP Dependency-Check compares your dependencies against the **National Vulnerability Database (NVD)**.

---

## 2. Scope and context

| Item | Description |
|------|-------------|
| **Application** | Java/Spring Boot microservice; Maven build; dependencies in `pom.xml`. |
| **Repo location** | Java project directory (e.g. **~/salary/salary-api** or your Maven project path). |
| **Build** | `mvn clean package`; produces the application JAR in `target/`. |
| **POC goal** | Add **OWASP Dependency-Check** to the CI pipeline for the Java (Maven) project; fail on high/critical CVEs. |

---

## 3. Prerequisites

| Requirement | Description |
|-------------|-------------|
| **Java and Maven** | Java 17+, Maven (per project `pom.xml`). |
| **Java project repo** | Clone or use the existing Java (Maven) project directory; ensure `pom.xml` is present. |
| **Scanner** | **OWASP Dependency-Check** (Maven plugin or Docker/CLI). Works on the project `pom.xml` and dependency tree. |
| **NVD API key** | Required for Maven plugin scans; request at [NVD API key](https://nvd.nist.gov/developers/request-an-api-key). |

---




## 4. Step 1 — Install Maven (if needed)

If Maven is not installed (Ubuntu):

```bash
sudo apt update
sudo apt install maven -y
```

**Expected output**

<img width="1919" height="873" alt="image" src="https://github.com/user-attachments/assets/a72b82b6-fbe1-4900-9291-decf5ce3534b" />

<img width="1919" height="571" alt="image" src="https://github.com/user-attachments/assets/8b5b9b05-16d7-4218-904d-a634d4b25788" />

---

## 5. Step 2 — Navigate to project and build

Go to your project directory that contains `pom.xml` and build the project.

```bash
cd ~/salary/salary-api
mvn clean install
mvn clean package -DskipTests
```

**Expected output**


<img width="1919" height="898" alt="image" src="https://github.com/user-attachments/assets/177ea2f1-c08c-4ea5-a042-a4fd84fd87e1" />

<img width="1919" height="898" alt="image" src="https://github.com/user-attachments/assets/e3277c9a-48a5-4c29-a2f5-70f08d040606" />

<img width="1919" height="918" alt="image" src="https://github.com/user-attachments/assets/75e59046-41ac-4f1d-a25f-94439e459e02" />

<img width="1919" height="918" alt="image" src="https://github.com/user-attachments/assets/f59955a8-8ca3-4db3-a212-67954ce9527d" />



---

## 6. Step 3 — Add OWASP Dependency-Check plugin

Open the **pom.xml** file and add the plugin inside the `<plugins>` section.

```xml
<plugins>
  <plugin>
    <groupId>org.owasp</groupId>
    <artifactId>dependency-check-maven</artifactId>
    <version>9.0.0</version>
  </plugin>
</plugins>
```

Save the file.

<img width="1919" height="571" alt="image" src="https://github.com/user-attachments/assets/3fae80b0-f873-460c-97dc-d92a559c4122" />

---

## 7. Step 4 — Generate NVD API key

OWASP downloads vulnerability data from the **NVD database**, which requires an API key.

1. Visit [NVD — Request an API key](https://nvd.nist.gov/developers/request-an-api-key).
2. Enter your email address.
3. You will receive an **API key in your email**.

<img width="1919" height="963" alt="image" src="https://github.com/user-attachments/assets/a088a6e2-054f-460c-bc56-6ed93b3fc3b4" />

Example API key format:

```
abcd1234-xxxx-xxxx-xxxx-xxxxxxxx
```

<img width="1919" height="873" alt="image" src="https://github.com/user-attachments/assets/446b2028-c133-4c48-a64f-b3c8155676e1" />

---

## 8. Step 5 — Run the dependency scan

**Option A — Using Docker (no `pom.xml` change required):**

```bash
export NVD_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxx
docker run --rm \
  -v "$(pwd)":/src \
  owasp/dependency-check:latest \
  --scan /src \
  --project "salary" \
  --format HTML \
  --out /src/target
```

<img width="1919" height="159" alt="image" src="https://github.com/user-attachments/assets/ea8f83d4-10b8-40dc-b152-44d6b4d4ebee" />

![alt text](image-4.png)


<img width="897" height="914" alt="image" src="https://github.com/user-attachments/assets/dc443d32-a4e4-4ef3-a8fb-acdb3c94a085" />


<img width="911" height="762" alt="image" src="https://github.com/user-attachments/assets/dfc27a21-afad-4218-944b-c452996f0d78" />


<img width="905" height="951" alt="Screenshot from 2026-03-08 00-03-17" src="https://github.com/user-attachments/assets/f1097d86-4f56-4bd9-8a89-1ee7ac95b50c" />

**Option B — Using Maven plugin (after adding plugin to `pom.xml`):**

From the project directory, optionally clear caches and run the check with your NVD API key:

```bash
rm -rf ~/.m2/repository/org/owasp
rm -rf ~/.dependency-check
export NVD_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxx
mvn dependency-check:check -DnvdApiKey="$NVD_API_KEY"
```


<img width="1919" height="918" alt="image" src="https://github.com/user-attachments/assets/1066796a-ac6b-4a2d-91cc-f65cd6bcd071" />

<img width="1919" height="873" alt="image" src="https://github.com/user-attachments/assets/a7ad92f5-2045-405e-a8cc-92949d52ca54" />

<img width="1919" height="873" alt="image" src="https://github.com/user-attachments/assets/7e8453c6-099b-4fcf-b896-4e36ecb1927f" />

**What happens during the scan:**

1. Maven downloads project dependencies (if using Maven).
2. OWASP downloads vulnerability data from NVD (API key required for Maven).
3. Dependencies are matched with known CVEs.
4. A vulnerability report is generated.

---

## 9. Step 6 — Locate and open the report

After the scan finishes, the report is generated at:

```
target/dependency-check-report.html
```

**If you are running locally:**

```bash
xdg-open target/dependency-check-report.html
```

**If the scan was run on a server:**

<img width="1920" height="956" alt="Screenshot from 2026-03-08 00-13-08" src="https://github.com/user-attachments/assets/8923d6a3-ea72-4914-badc-e750bb929c33" />

<img width="1920" height="956" alt="Screenshot from 2026-03-08 00-13-13" src="https://github.com/user-attachments/assets/fac1ad4a-9674-4883-bce5-267ebb8724ea" />

<img width="1920" height="956" alt="Screenshot from 2026-03-08 00-13-19" src="https://github.com/user-attachments/assets/d9a7aaf2-4ff5-4ffe-9f11-22b20b7cd58d" />

<img width="1920" height="873" alt="Screenshot from 2026-03-08 00-13-27" src="https://github.com/user-attachments/assets/6557a20f-3d92-477a-a395-950f265eec28" />

<img width="1920" height="956" alt="Screenshot from 2026-03-08 00-13-33" src="https://github.com/user-attachments/assets/f5818a25-8c4f-4886-bf32-4d57743b94e2" />

```bash
scp user@server:/project/target/dependency-check-report.html .
```

Open the downloaded file in a browser.

---

## 10. Best practices

- Run dependency scanning regularly (e.g. in CI/CD or before releases).
- Regularly update dependencies and re-scan.
- Prioritise **Critical and High** vulnerabilities.
- Combine dependency scanning with:
  - Static code analysis
  - Container security scanning
  - Secret scanning

---

## 11. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 12. References

| Link | Description |
|------|-------------|
| [Dependency Scanning — Java CI Checks Documentation](https://github.com/Snaatak-Saarthi/documentation/blob/SCRUM-172-mukesh/Applications/Understanding/Java_CI_Checks/Dependency_Scanning/README.md) | Main design document for dependency scanning and Java CI checks. |
| [OWASP Dependency-Check](https://owasp.org/www-project-dependency-check/) | OWASP Dependency-Check — vulnerability detection for dependencies. |
| [OWASP Dependency-Check Maven Plugin](https://jeremylong.github.io/DependencyCheck/dependency-check-maven/) | Maven plugin for dependency-check. |

---
