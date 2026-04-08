# Declarative Jenkins Pipeline — AMI Build with Generic CI Checks POC


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 11-03-2026 | v1.0 | Mukesh Sharma | 11-03-2026 |  |  |  |  |

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Scope and goals](#2-scope-and-goals)
3. [Prerequisites](#3-prerequisites)
4. [Pipeline overview](#4-pipeline-overview)
5. [Declarative Jenkinsfile structure](#5-declarative-jenkinsfile-structure)
6. [Example Declarative pipeline for AMI build](#6-example-declarative-pipeline-for-ami-build)
7. [Step-by-step: configure the AMI pipeline in Jenkins](#7-step-by-step-configure-the-ami-pipeline-in-jenkins)
8. [Best practices](#8-best-practices)
9. [Contact Information](#9-contact-information)

---

## 1. Introduction

This document describes a **Declarative Jenkins Pipeline** to run **Generic CI checks** (build, tests, static analysis, dependency scanning, SonarQube Quality Gates) and then **build an AMI** (e.g. using Packer) when quality criteria are met.

The goal is to standardize AMI builds behind a pipeline that:

- Validates code and configuration via CI checks.  
- Runs AMI build tools (e.g. Packer) only when the code is in a good state.  
- Can be reused across multiple AMI definitions with minimal changes.

---

## 2. Scope and goals

| Item | Description |
|------|-------------|
| **Application / image** | Generic AMI or Golden Image build configuration (e.g. Packer template). |
| **Generic CI checks** | Lint, unit tests (if applicable), dependency scan, SonarQube analysis and Quality Gate enforcement. |
| **AMI build step** | Packer (or equivalent) command to build the AMI after CI checks pass. |
| **Out of scope** | Full promotion workflow (dev/stage/prod), image testing on real instances, rollback strategy. |

---

## 3. Prerequisites

| Requirement | Description |
|-------------|-------------|
| **Jenkins** | Jenkins controller with agents that have necessary tools. |
| **SCM repo** | Git repository containing the AMI build code (e.g. `packer` template, scripts) and `Jenkinsfile`. |
| **Packer (or AMI tool)** | Installed on Jenkins agent(s), with AWS credentials or IAM role to create AMIs. |
| **SonarQube (optional)** | SonarQube server and Jenkins integration if you want code quality analysis and Quality Gates. |
| **Trivy or other scanners (optional)** | For dependency or image scanning as part of generic CI checks. |

---

## 4. Pipeline overview

At a high level, the **Declarative AMI pipeline** performs:

1. **Checkout** — Fetch AMI build code from SCM.  
2. **Generic CI checks** (optional depending on project type):
   - Lint / static analysis for scripts (e.g. shellcheck, ansible-lint, Packer fmt/validate).  
   - Unit or integration tests (if applicable).  
   - Dependency / vulnerability scan (e.g. Trivy fs).  
   - SonarQube analysis + Quality Gate enforcement.  
3. **Build AMI** — Run Packer (or equivalent) to build the AMI only if all previous stages succeed.  
4. **Notification** — Post success/failure message (email/Slack).

Example flow:

```text
[SCM checkout] → [Lint / Tests / Scans / Sonar] → [Build AMI] → [Notify]
```

---

## 5. Declarative Jenkinsfile structure

A typical structure for an AMI Declarative pipeline:

```groovy
pipeline {
  agent any

  environment {
    APP_NAME        = "generic-ami"
    PACKER_TEMPLATE = "packer/template.json"
    SONARQUBE_ENV   = "My-SonarQube-Server"
    SONARQUBE_TOKEN = credentials('sonar-token-id')
  }

  stages {
    stage('Checkout') { ... }
    stage('Lint / Validate') { ... }
    stage('Tests / Scans') { ... }
    stage('SonarQube Analysis') { ... }
    stage('Quality Gate') { ... }
    stage('Build AMI') { ... }
  }

  post {
    success { ... }
    failure { ... }
  }
}
```

The following section provides a concrete example that you can place in a `Jenkinsfile` in your AMI repo.

---

## 6. Example Declarative pipeline for AMI build

Below is an example **Declarative Jenkins pipeline** that performs generic CI checks and then builds an AMI with Packer:

```groovy
pipeline {
  agent any

  options {
    timestamps()
    disableConcurrentBuilds()
  }

  environment {
    APP_NAME        = "generic-ami"
    PACKER_TEMPLATE = "packer/template.json"
    SONARQUBE_ENV   = "My-SonarQube-Server"
    SONARQUBE_TOKEN = credentials('sonar-token-id')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Lint / Validate') {
      steps {
        sh '''
          if command -v packer >/dev/null 2>&1; then
            echo "==> Running packer fmt and validate"
            packer fmt -check ${PACKER_TEMPLATE}
            packer validate ${PACKER_TEMPLATE}
          else
            echo "Packer not installed; skipping packer fmt/validate."
          fi
        '''
      }
    }

    stage('Tests / Generic Checks') {
      steps {
        sh '''
          # Example: run shellcheck/ansible-lint if you have scripts/playbooks
          echo "TODO: add real tests or linting for your AMI build scripts"
        '''
      }
    }

    stage('Dependency Scanning (Trivy fs, optional)') {
      steps {
        sh '''
          if command -v trivy >/dev/null 2>&1; then
            echo "==> Running Trivy filesystem scan"
            trivy fs --exit-code 1 --severity CRITICAL,HIGH .
          else
            echo "Trivy not installed; skipping dependency scan."
          fi
        '''
      }
    }

    stage('SonarQube Analysis (optional)') {
      when {
        expression { fileExists('pom.xml') || fileExists('sonar-project.properties') }
      }
      steps {
        withSonarQubeEnv(SONARQUBE_ENV) {
          sh '''
            if [ -f pom.xml ]; then
              mvn sonar:sonar -Dsonar.login=$SONARQUBE_TOKEN
            elif [ -f sonar-project.properties ]; then
              sonar-scanner -Dsonar.login=$SONARQUBE_TOKEN
            else
              echo "No recognizable SonarQube project configuration found."
            fi
          '''
        }
      }
    }

    stage('Quality Gate (optional)') {
      when {
        expression { fileExists('pom.xml') || fileExists('sonar-project.properties') }
      }
      steps {
        script {
          timeout(time: 5, unit: 'MINUTES') {
            def qg = waitForQualityGate()
            if (qg.status != 'OK') {
              error "Pipeline aborted due to Quality Gate failure: ${qg.status}"
            }
          }
        }
      }
    }

    stage('Build AMI') {
      steps {
        sh '''
          if command -v packer >/dev/null 2>&1; then
            echo "==> Building AMI with Packer"
            packer build ${PACKER_TEMPLATE}
          else
            echo "Packer not installed; cannot build AMI."
            exit 1
          fi
        '''
      }
    }
  }

  post {
    success {
      echo "AMI pipeline succeeded for ${env.JOB_NAME} #${env.BUILD_NUMBER}"
      // Example: notify success via email or Slack
      // emailext to: 'devops-team@example.com', subject: "SUCCESS: AMI ${APP_NAME}", body: "AMI build passed. See ${env.BUILD_URL}"
    }
    failure {
      echo "AMI pipeline failed for ${env.JOB_NAME} #${env.BUILD_NUMBER}"
      // Example: notify failure
      // emailext to: 'devops-team@example.com', subject: "FAILURE: AMI ${APP_NAME}", body: "AMI build failed. See ${env.BUILD_URL}"
    }
  }
}
```

You can adjust:

- `PACKER_TEMPLATE` path  
- CI checks (add/remove tools)  
- Notification hooks (email/Slack)  
according to your environment.

---

## 7. Step-by-step: configure the AMI pipeline in Jenkins

1. **Create a Pipeline job** (or Multibranch) named e.g. `generic-ami-pipeline`.  
2. Under **Pipeline → Definition**, choose **Pipeline script from SCM**.  
3. Configure **SCM**:
   - **Repository URL:** Git repo containing the AMI code and `Jenkinsfile` (you can place this example in `Jenkinsfile` at repo root or a subfolder and adjust Script Path).  
   - **Credentials:** Jenkins credentials if private repo.  
4. Set **Script Path** to the location of your Declarative Jenkinsfile (e.g. `Jenkinsfile` or `ami/Jenkinsfile`).  
5. Save and run the job.

Ensure that the Jenkins agent has:

- `packer` on PATH.  
- Any linters/scanners you reference (e.g. `trivy`, `sonar-scanner`, `mvn`).  

---

## 8. Best practices

| Practice | Description |
|----------|-------------|
| **Fail fast on CI checks** | Ensure lint/tests/scans fail the pipeline before the AMI build to avoid creating bad images. |
| **Parameterize AMI builds** | Use pipeline parameters (e.g. AWS region, base AMI, environment) instead of hardcoding values. |
| **Version images** | Tag AMIs with build numbers, Git commit hashes, or semantic versions for traceability. |
| **Test AMIs post-build** | Consider a follow-up job or stage that launches instances from the AMI and runs smoke tests. |
| **Secure credentials** | Use Jenkins Credentials for AWS keys and SonarQube tokens; avoid hardcoding secrets in Jenkinsfiles. |

---

## 9. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh Kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

