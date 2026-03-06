# Dependency Scanning | Java CI Checks — POC


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 26-02-2026 | v1.0 | Mukesh Sharma | 26-02-2026 |  |  |  |  |

---

## Table of Contents

1. [Scope and context](#1-scope-and-context)
2. [Prerequisites](#2-prerequisites)
3. [Step 1 — Build the Java application](#3-step-1--build-the-java-application)
4. [Step 2 — Add OWASP Dependency-Check](#4-step-2--add-owasp-dependency-check)
5. [Step 3 — Configure thresholds and run in CI](#5-step-3--configure-thresholds-and-run-in-ci)
6. [Step 4 — Remediate and document](#6-step-4--remediate-and-document)
7. [Benefits of dependency scanning for Java](#7-benefits-of-dependency-scanning-for-java)
8. [Contact Information](#8-contact-information)
9. [References](#9-references)

---

## 1. Scope and context

| Item | Description |
|------|-------------|
| **Application** | Java/Spring Boot microservice; Maven build; dependencies in `pom.xml`. |
| **Repo location** | Java project directory (e.g. **~/salary/salary-api** or your Maven project path). |
| **Build** | `mvn clean package` (or `make build`); produces the application JAR in `target/`. |
| **POC goal** | Add **OWASP Dependency-Check** to the CI pipeline for the Java (Maven) project; fail on high/critical CVEs. |

---

## 2. Prerequisites

| Requirement | Description |
|-------------|-------------|
| **Java and Maven** | Java 17+, Maven (per project `pom.xml`). |
| **Java project repo** | Clone or use the existing Java (Maven) project directory; ensure `pom.xml` is present. |
| **Scanner** | **OWASP Dependency-Check** (Maven plugin or CLI). Works on the project `pom.xml` and dependency tree. |

---

## 3. Step 1 — Build the Java application

1. Navigate to the Java project directory:
   ```bash
   cd ~/salary/salary-api
   ```
2. Build the project:
   ```bash
   
   mvn clean package
   ```
3. Ensure the build succeeds and produces the application JAR in `target/`. The dependency scanner will run against the same project (e.g. after `mvn compile` or `mvn verify`).

---

## 4. Step 2 — Add OWASP Dependency-Check

Add **OWASP Dependency-Check** (Maven plugin) to the Java project. Add the plugin to `pom.xml` (or a parent POM). Example:

```xml
<plugin>
  <groupId>org.owasp</groupId>
  <artifactId>dependency-check-maven</artifactId>
  <version>9.0.0</version>
  <executions>
    <execution>
      <goals><goal>check</goal></goals>
      <phase>verify</phase>
      <configuration>
        <failBuildOnCVSS>7</failBuildOnCVSS>
      </configuration>
    </execution>
  </executions>
</plugin>
```

Run: `mvn verify` (or `mvn dependency-check:check`). The build fails if CVEs at or above the threshold are found.

---

## 5. Step 3 — Configure thresholds and run manually

1. **Thresholds** — Decide what severity should block a build (e.g. CVSS ≥ 7 or severity high/critical). This is configured via `failBuildOnCVSS` in the plugin:
   ```xml
   <failBuildOnCVSS>7</failBuildOnCVSS>
   ```
2. **Run the scan locally** — From the project directory:
   ```bash
   mvn clean verify
   # or, if you prefer an explicit goal:
   mvn dependency-check:check
   ```
   The command fails if OWASP Dependency-Check finds vulnerabilities at or above the configured threshold.

---

## 6. Step 4 — Remediate and document

1. **Remediate** — Fix one or two reported issues (e.g. upgrade a vulnerable dependency in `pom.xml`); re-run the scan and confirm the pipeline passes.
2. **Document** — Record in this file or in the CI config: scanner (OWASP Dependency-Check), threshold (e.g. fail on high/critical), and how to run the scan locally (`mvn verify`).

---

## 7. Benefits of dependency scanning for Java

| Benefit | Description |
|---------|-------------|
| **Identifies vulnerable libraries early** | Highlights known CVEs in Maven dependencies before they are promoted to higher environments. |
| **Supports compliance and audits** | Provides evidence that third-party Java libraries are scanned regularly for vulnerabilities. |
| **Guides upgrade priorities** | Shows which dependencies should be upgraded first (e.g. critical/high CVEs) instead of guessing. |
| **Works with existing Maven builds** | Integrates as a Maven plugin so developers can run the same checks locally or in CI. |
| **Reduces production risk** | Shrinks the attack surface by catching outdated or vulnerable components before releases. |

---

## 8. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 9. References

| Link | Description |
|------|-------------|
| [Dependency Scanning — Java CI (main doc)](../dependency-scanning-java-ci.md) | Main design document for dependency scanning and Java CI checks. |
| [OWASP Dependency-Check](https://owasp.org/www-project-dependency-check/) | OWASP Dependency-Check — vulnerability detection for dependencies. |
| [OWASP Dependency-Check Maven Plugin](https://jeremylong.github.io/DependencyCheck/dependency-check-maven/) | Maven plugin for dependency-check. |

---
