# Dependency Scanning | Java CI Checks

This document describes **dependency scanning** as part of **Java CI checks**, in the context of a **Java** application (Spring Boot, Maven): introduction, what it is, why use it, workflow, tools, comparison, advantages, POC, best practices, and references.

---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 26-02-2026 | v1.0 | Mukesh Sharma | 26-02-2026 |  |  |  |  |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [What is dependency scanning](#2-what-is-dependency-scanning)
3. [Why use dependency scanning for Java](#3-why-use-dependency-scanning-for-java)
4. [Workflow diagram](#4-workflow-diagram)
5. [Different tools](#5-different-tools)
6. [Comparison](#6-comparison)
7. [Advantages](#7-advantages)
8. [POC](#8-poc)
9. [Best practices](#9-best-practices)
10. [Recommendation / Conclusion](#10-recommendation--conclusion)
11. [Contact Information](#11-contact-information)
12. [References](#12-references)

---

## 1. Introduction

**Dependency scanning** in Java CI checks that third-party libraries (e.g. Maven dependencies in `pom.xml`) do not contain known vulnerabilities. For a **Java** (Spring Boot, Maven) application, this means scanning dependencies declared in `pom.xml` and the dependency tree (including transitive dependencies) as part of the CI pipeline. This document describes what dependency scanning is, why to use it for Java applications, workflow, tools, comparison, advantages, a POC approach, and best practices.

---

## 2. What is dependency scanning

**What** — **Dependency scanning** is an automated check of application dependencies (direct and transitive) against vulnerability databases (e.g. NVD, OSS Index) to find known CVEs. In the context of a **Java** application:

| Concept | Description |
|--------|-------------|
| **Dependency scanning** | Automated check of application dependencies (direct and transitive) against vulnerability databases (e.g. NVD, OSS Index) to find known CVEs. |
| **In Java / Maven** | Scans `pom.xml` and the resolved dependency tree; often run after `mvn dependency:tree` or during/after `mvn verify`. |
| **Java / Maven context** | A Java application using Maven and Spring Boot; scanning covers Spring, Cassandra, Redis, Lombok, Springdoc, Logstash, Micrometer, and other dependencies for known vulnerabilities. |

---

## 3. Why use dependency scanning for Java

**Why** — Teams use dependency scanning for Java applications for the following reasons:

| Reason | Description |
|--------|-------------|
| **Security** | Identify and fix vulnerable dependencies (e.g. log4j-style issues) before they reach production. |
| **Compliance** | Support security and audit requirements; evidence of scanning in CI. |
| **Early feedback** | Fail or warn in CI when high/critical CVEs are introduced, so fixes happen before merge. |
| **Risk reduction** | Reduce risk from supply-chain and known-vulnerability exposure in the Java application. |

---

## 4. Workflow diagram

```
[Commit/PR] → [CI: checkout] → [Maven build (compile, test)] → [Dependency scan (e.g. OWASP / Snyk / Dependabot)] → [Report / Pass/Fail] → [Merge or block]
```

Dependency scanning runs as a CI step after the project is built (or in parallel with tests). The scanner reads the dependency tree, checks against vulnerability databases, and reports or fails the pipeline based on configured severity thresholds.

---

## 5. Different tools

| Tool | Description |
|------|-------------|
| **OWASP Dependency-Check** | Maven plugin or CLI; uses NVD and other data sources; integrates with Maven and CI (e.g. Jenkins, GitLab). |
| **Snyk** | Commercial/freemium; Maven and CLI support; dependency and license scanning; integrates with Git and CI. |
| **GitHub Dependabot** | Alerts and PRs for vulnerable dependencies in GitHub repos; can be used alongside CI scans. |
| **Maven dependency:analyze / Versions** | Built-in Maven plugins for dependency tree and version updates; often combined with a CVE scanner. |
| **Trivy** | General-purpose scanner; supports Java/Maven; can run in CI against `pom.xml` or built artifacts. |

---

## 6. Comparison

| Criteria | OWASP Dependency-Check | Snyk | Dependabot | Trivy |
|----------|------------------------|------|------------|-------|
| **Cost** | Free | Free tier / paid | Free (GitHub) | Free |
| **Maven integration** | Plugin / CLI | CLI / IDE | Via GitHub | CLI / container |
| **CI integration** | Yes (Jenkins, GitLab, etc.) | Yes | GitHub-native | Yes |
| **Data source** | NVD, etc. | Proprietary + public | GitHub advisory | Multiple |
| **Fix suggestions** | Manual | Upgrade suggestions | Automated PRs | Report |
| **Java / Maven fit** | Good for on-prem CI | Good for cloud CI / SaaS | Good if repo on GitHub | Good for multi-artifact pipelines |

---

## 7. Advantages

| Advantage | Description |
|-----------|-------------|
| **Automation** | Every build or PR is scanned; no manual dependency audits. |
| **Transitive coverage** | Scans full dependency tree (e.g. Spring → transitive libs), not only direct deps in the Java project. |
| **Traceability** | CI logs and reports show which dependency has which CVE; easier to justify upgrades. |
| **Culture** | Encourages keeping dependencies up to date and responding to CVEs as part of normal development. |

---

## 8. POC

A dedicated **POC document** for dependency scanning (Java CI) is available at **[poc/dependency-scanning-java-poc.md](poc/dependency-scanning-java-poc.md)**. It covers:

1. **Scope** — Java (Maven) project repo; one CI system (e.g. Jenkins or GitLab CI).  
2. **Add scanner** — Integrate OWASP Dependency-Check Maven plugin (or Snyk CLI) into the build; run after `mvn compile` or `mvn verify`.  
3. **Configure thresholds** — Fail the job on high/critical CVEs; optionally warn on medium.  
4. **Run in CI** — Trigger on every PR or main build; publish report (e.g. artifact or security dashboard).  
5. **Remediate** — Fix one or two reported issues (e.g. upgrade a dependency); confirm pipeline passes. Document the process for the team.

For the full step-by-step POC (prerequisites, commands, success criteria), see [dependency-scanning-java-poc.md](poc/dependency-scanning-java-poc.md).

---

## 9. Best practices

| Practice | Description |
|----------|-------------|
| **Run on every build** | Include dependency scan in the same pipeline that builds the Java application (e.g. after `mvn verify`). |
| **Fail on high/critical** | Set severity thresholds so high and critical CVEs fail the job; avoid failing on low/informational only. |
| **Update scan DB** | Use fresh vulnerability data (e.g. OWASP NVD cache updated regularly) to avoid stale results. |
| **Pin and upgrade** | Pin dependency versions in `pom.xml` and upgrade in response to scan results; re-run scan after upgrades. |
| **Combine with SAST/DAST** | Use dependency scanning alongside other Java CI checks (e.g. SAST, tests) for broader coverage. |

---

## 10. Recommendation / Conclusion

Use **dependency scanning** as a standard step in **Java CI checks** for Java (Maven) applications. Integrate **OWASP Dependency-Check** (or **Snyk**) into the Maven build and CI pipeline; fail the build on high/critical vulnerabilities and treat scan reports as part of the definition of done. Combine with Dependabot (if on GitHub) for automated upgrade PRs. Document which tool and thresholds are used so the team can maintain and extend the checks.

---

## 11. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

## 12. References

| Link | Description |
|------|-------------|
| [OWASP Dependency-Check](https://owasp.org/www-project-dependency-check/) | OWASP Dependency-Check — vulnerability detection for dependencies. |
| [OWASP Dependency-Check Maven Plugin](https://jeremylong.github.io/DependencyCheck/dependency-check-maven/) | Maven plugin for dependency-check. |
| [Snyk for Java](https://docs.snyk.io/snyk-cli/cli-reference-for-snyk-cli/) | Snyk CLI and Java/Maven support. |
| [GitHub Dependabot](https://docs.github.com/en/code-security/dependabot) | Dependabot alerts and automated PRs. |
| [Trivy](https://github.com/aquasecurity/trivy) | Trivy — vulnerability scanner for artifacts and dependencies. |
| [Dependency Scanning — Java CI POC](poc/dependency-scanning-java-poc.md) | Step-by-step POC for Java (Maven) applications. |

---
