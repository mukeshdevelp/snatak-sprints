# Declarative Jenkins Pipeline — Generic CI Checks and Notification POC


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
5. [Declarative Jenkinsfile location](#5-declarative-jenkinsfile-location)
6. [Step-by-step: configure the pipeline in Jenkins](#6-step-by-step-configure-the-pipeline-in-jenkins)
7. [Notification behavior](#7-notification-behavior)
8. [Extending generic CI checks](#8-extending-generic-ci-checks)
9. [Contact Information](#9-contact-information)

---

## 1. Introduction

This document describes a **Declarative Jenkins Pipeline** that implements **generic CI checks** for a Java (Maven) project and includes a **notification hook** on success/failure.

The pipeline:

- Checks out code from SCM.  
- Runs **build and unit tests**.  
- Runs a **static analysis / verification** step.  
- Runs **dependency scanning** using **Trivy filesystem scan**.  
- Runs **SonarQube analysis** and enforces **Quality Gates**.  
- Sends a **notification** in the `post` section (example for email/Slack; can be integrated into existing notification flows).

The pipeline definition is stored as a single `Jenkinsfile` under the `dec-pipeline` folder of this repository.

---

## 2. Scope and goals

| Item | Description |
|------|-------------|
| **Application** | Java / Maven microservice (e.g. salary-api) built in Jenkins. |
| **Generic CI checks** | Build, tests, static verification, dependency scan (Trivy), SonarQube analysis + Quality Gate enforcement. |
| **Notification** | Post-build notification (success/failure) that can be wired to email, Slack, or other channels. |
| **Out of scope** | Full deployment/CD, multi-branch setup, complex environment promotion. |

---

## 3. Prerequisites

| Requirement | Description |
|-------------|-------------|
| **Jenkins with agents** | Jenkins controller and at least one agent with Java, Maven, and (optionally) Trivy installed. |
| **SonarQube plugin and server** | Jenkins SonarQube plugin configured with a server name (e.g. `My-SonarQube-Server`) and a token credential ID (`sonar-token-id`). |
| **Trivy CLI (optional)** | Installed on the Jenkins agent if you want the Trivy filesystem dependency scan to run. |
| **SCM** | Jenkins job must be connected to a Git repository containing this project and the `dec-pipeline/Jenkinsfile`. |

---

## 4. Pipeline overview

High-level stages in the Declarative pipeline:

1. **Checkout** — fetch source from SCM.  
2. **Build & Unit Tests** — run `mvn clean test`.  
3. **Static Analysis / Lint (placeholder)** — run `mvn verify -DskipTests` or attach tools like Checkstyle/SpotBugs.  
4. **Dependency Scanning (Trivy fs)** — run `trivy fs --exit-code 1 --severity CRITICAL,HIGH .` if Trivy is installed.  
5. **SonarQube Analysis** — run `mvn sonar:sonar` with the configured SonarQube server and token.  
6. **Quality Gate** — wait for SonarQube Quality Gate result and **fail the pipeline** if it is not `OK`.  
7. **Notification (post block)** — send success/failure notification (examples provided as commented hooks).

This corresponds to a generic CI pattern:

```text
[SCM checkout] → [Build & Test] → [Static Analysis] → [Dependency Scan] → [Sonar + Quality Gate] → [Notify]
```

---

## 5. Declarative Jenkinsfile location

The pipeline definition is stored in:

```text
dec-pipeline/Jenkinsfile
```

### 5.1 Jenkinsfile contents (reference)

Below is the current version of the Declarative pipeline:

```groovy
pipeline {
  agent any

  options {
    timestamps()
    disableConcurrentBuilds()
  }

  environment {
    // Example envs; adapt to your project
    APP_NAME        = "salary-api"
    SONARQUBE_ENV   = "My-SonarQube-Server"   // Jenkins SonarQube server name
    SONARQUBE_TOKEN = credentials('sonar-token-id')
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build & Unit Tests') {
      steps {
        sh 'mvn clean test'
      }
    }

    stage('Static Analysis / Lint') {
      when {
        expression { fileExists('pom.xml') }
      }
      steps {
        // Placeholder for Java static analysis (e.g. Checkstyle, SpotBugs)
        sh 'mvn verify -DskipTests'
      }
    }

    stage('Dependency Scanning (Trivy fs)') {
      steps {
        sh '''
          if command -v trivy >/dev/null 2>&1; then
            trivy fs --exit-code 1 --severity CRITICAL,HIGH .
          else
            echo "Trivy not installed; skipping dependency scan."
          fi
        '''
      }
    }

    stage('SonarQube Analysis') {
      steps {
        withSonarQubeEnv(SONARQUBE_ENV) {
          sh '''
            mvn sonar:sonar \
              -Dsonar.login=$SONARQUBE_TOKEN
          '''
        }
      }
    }

    stage('Quality Gate') {
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
  }

  post {
    success {
      echo "Build succeeded for ${env.JOB_NAME} #${env.BUILD_NUMBER}"
      // Example notification hook (email, Slack, etc.)
      // emailext to: 'dev-team@example.com', subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Build passed."
    }
    failure {
      echo "Build failed for ${env.JOB_NAME} #${env.BUILD_NUMBER}"
      // Example failure notification hook
      // emailext to: 'devops-team@example.com', subject: "FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}", body: "Build failed. Check Jenkins logs."
    }
  }
}
```

You can adjust environment variables and stage commands according to your project (e.g. Gradle, Node.js).

---

## 6. Step-by-step: configure the pipeline in Jenkins

### 6.1 Create a Multibranch or Pipeline job

1. In Jenkins, click **New Item**.  
2. Choose:
   - **Multibranch Pipeline** (if you want branch-based pipelines), or  
   - **Pipeline** (single-branch).  
3. Name the job (e.g. `salary-generic-ci`).

### 6.2 Point Jenkins to this repository

For a **Multibranch Pipeline**:

1. Under **Branch Sources**, configure Git:
   - **Repository URL:** your Git repo for `snatak-sprints`.  
   - **Credentials:** Jenkins credential if private.  
2. Under **Build Configuration**, set:
   - **Script Path:** `dec-pipeline/Jenkinsfile`.

For a **Pipeline** job:

1. Under **Pipeline** section, set:
   - **Definition:** *Pipeline script from SCM*.  
   - **SCM:** Git, with the repo URL and credentials.  
   - **Script Path:** `dec-pipeline/Jenkinsfile`.

### 6.3 Configure SonarQube integration

1. Go to **Manage Jenkins → Configure System**.  
2. Under **SonarQube servers**, add or verify:
   - **Name:** `My-SonarQube-Server` (or whatever you use in the pipeline).  
   - **Server URL:** `https://<your-sonarqube-url>`.  
   - **Server authentication token**: a Jenkins credential (ID `sonar-token-id` in the example).
3. Ensure the Jenkins agent running the job has `mvn` and network access to SonarQube.

### 6.4 Configure Trivy (optional)

On the Jenkins agent:

1. Install Trivy per your OS (see [Trivy docs](https://aquasecurity.github.io/trivy/)).  
2. Ensure `trivy` is available on the `PATH`.  

If Trivy is not installed, the pipeline will **skip** the dependency scan gracefully (it prints a message and continues).

---

## 7. Notification behavior

The pipeline uses the `post` section for notifications:

- `post { success { ... } }` — executed when the pipeline succeeds.  
- `post { failure { ... } }` — executed when the pipeline fails.

By default, the Jenkinsfile only logs messages with `echo`. To enable real notifications:

- **Email**: Uncomment and configure `emailext`, e.g.:

```groovy
post {
  success {
    emailext to: 'dev-team@example.com',
             subject: "SUCCESS: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
             body: "Build passed. See ${env.BUILD_URL}"
  }
  failure {
    emailext to: 'devops-team@example.com',
             subject: "FAILURE: ${env.JOB_NAME} #${env.BUILD_NUMBER}",
             body: "Build failed. See ${env.BUILD_URL}"
  }
}
```

- **Slack**: Use `slackSend` if Slack plugin is configured.

You can adapt these examples to your organization’s notification channel.

---

## 8. Extending generic CI checks

Some ideas to extend this pipeline:

- **Add code style checks**: Integrate Checkstyle, SpotBugs, PMD, or ESLint (for JS/TS).  
- **Add integration tests**: Additional stage after unit tests.  
- **Add container image build and scan**: Build Docker images and scan with Trivy or another scanner.  
- **Branch-specific behavior**: Use `when { branch 'main' }` to run heavier checks only on main/release branches.  
- **Artifact archiving**: Archive test reports, coverage, or build artifacts for later inspection.

---

## 9. Contact Information

| Name | Email Address |
|------|----------------|
| Mukesh Kumar Sharma | msmukeshkumarsharma95@gmail.com |

---

