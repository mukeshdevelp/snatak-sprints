# SSL/TLS Implementation Guide


---


| Author | Created on | Version | Last updated by | Last edited on | Pre Reviewer | L0 Reviewer | L1 Reviewer | L2 Reviewer |
|--------|------------|---------|-----------------|----------------|--------------|-------------|-------------|-------------|
| Mukesh Sharma | 03-02-2026 | v1.0 | Mukesh Sharma | 03-02-2026 |  | aniruddh sir | faisal sir | ashwani sir |




---

## Table of Contents

1. [Introduction](#1-introduction)
2. [What](#2-what)
3. [Why](#3-why)
4. [Workflow diagram](#4-workflow-diagram)
5. [Implementation options](#5-implementation-options)
6. [Step-by-step implementation](#6-step-by-step-implementation)
7. [Best practices](#7-best-practices)
8. [Conclusion](#8-conclusion)
9. [Contact Information](#9-contact-information)
10. [References](#10-references)

---

## 1. Introduction

**SSL (Secure Sockets Layer)** and its successor **TLS (Transport Layer Security)** are protocols that provide **encryption**, **integrity**, and **server identity** for traffic between clients (browsers, apps) and servers. In practice, “SSL” is often used to mean TLS, since modern deployments use TLS (e.g. TLS 1.2, TLS 1.3).

This guide describes what SSL/TLS is, why to use it, how the handshake and data flow work, implementation options (public CA, private CA, self-signed), step-by-step examples for common scenarios (web server, reverse proxy, Jenkins HTTPS), and best practices. Use it when enabling HTTPS for web applications, APIs, or CI tools like Jenkins or GitLab.

---

## 2. What

| Term | Description |
|------|-------------|
| **TLS** | Protocol that encrypts and authenticates data between client and server; runs on top of TCP (e.g. HTTPS = HTTP over TLS). |
| **Certificate** | A digital document that binds a public key to a name (e.g. domain or hostname); signed by a Certificate Authority (CA). |
| **Private key** | Secret key used by the server to prove it owns the certificate; must be kept secure and never shared. |
| **Public key** | Distributed via the certificate; used by the client to encrypt data and verify the server’s signature. |
| **CA (Certificate Authority)** | Entity that signs certificates; can be public (e.g. Let’s Encrypt, DigiCert) or private (internal PKI). |
| **Chain / intermediate** | Certificates that link your server certificate to a root CA; clients use them to verify trust. |

**TLS versions:** Prefer **TLS 1.2** or **TLS 1.3**; disable SSL 3.0 and TLS 1.0/1.1 (deprecated and weak).

---

## 3. Why

| Reason | Description |
|--------|-------------|
| **Encryption** | Protects data in transit from eavesdropping; passwords, tokens, and sensitive payloads are unreadable to attackers on the path. |
| **Integrity** | Detects tampering; TLS ensures data is not modified in transit. |
| **Identity** | Certificates (from a trusted CA) help clients verify they are talking to the intended server, reducing MITM risk. |
| **Compliance** | Many standards (PCI-DSS, HIPAA, SOC2) require encryption in transit for sensitive data. |
| **Browser trust** | Browsers show “secure” only for HTTPS; HTTP is often flagged as not secure. |

---

## 4. Workflow diagram

### TLS handshake (simplified)

1. **Client Hello** — Client sends supported TLS version and cipher suites.
2. **Server Hello** — Server chooses version and cipher, sends its certificate (and chain).
3. **Verification** — Client verifies the certificate against trusted CAs.
4. **Key exchange** — Client and server agree on session keys (e.g. via Diffie–Hellman).
5. **Encrypted application data** — Subsequent traffic is encrypted with the session keys.


<img width="1151" height="652" alt="image" src="https://github.com/user-attachments/assets/c1e6b046-e898-4bc9-9a68-e463ba3ff47a" />


### End-to-end HTTPS flow

<img width="1151" height="652" alt="image" src="https://github.com/user-attachments/assets/27dc05c9-eb08-42ff-b436-b349900b25ae" />


TLS can **terminate** at the edge (load balancer or reverse proxy) or at the application server; internal traffic can stay HTTP or use TLS again depending on policy.

---

## 5. Implementation options

| Option | Description | When to use |
|--------|-------------|-------------|
| **Public CA (e.g. Let’s Encrypt, commercial)** | Certificate signed by a CA trusted by browsers and OS. | Public-facing sites and APIs; best UX and trust. |
| **Private CA (internal PKI)** | Your organisation runs a CA and signs certificates; clients must trust your CA. | Internal tools, Jenkins, GitLab, APIs used only inside the network. |
| **Self-signed certificate** | Server generates and signs its own cert; not trusted by default. | Dev/test or internal use; browsers show warnings unless the cert is trusted. |

**Where to terminate TLS:**

- **At the load balancer** — LB has the certificate; backend can use HTTP (ensure internal network is protected).
- **At the reverse proxy (e.g. Nginx)** — Proxy terminates TLS and forwards to backend over HTTP or TLS.
- **At the application** — Application (e.g. Jenkins, GitLab) holds the certificate and serves HTTPS directly.

---

## 6. Step-by-step implementation

### 6.1 Obtain a certificate

**Public CA (Let’s Encrypt example with certbot):**

```bash
# Install certbot (example: Ubuntu/Debian)
sudo apt update && sudo apt install -y certbot

# Obtain certificate (standalone or webroot; use -d for your domain)
sudo certbot certonly --standalone -d your-domain.example.com
# Cert and key are typically under /etc/letsencrypt/live/your-domain.example.com/
```
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/cb9fdbed-6167-41e9-82c4-951b787af29d" />
<img width="1920" height="362" alt="image" src="https://github.com/user-attachments/assets/caea4d71-6961-486c-be3e-1c396c89381b" />
<img width="1920" height="554" alt="image" src="https://github.com/user-attachments/assets/e6c76196-4b1d-4849-bec2-8ea9f165649b" />



### 6.2 Configure Nginx for HTTPS

```nginx
server {
    listen 443 ssl;
    server_name your-domain.example.com;

    ssl_certificate     /etc/ssl/certs/server.crt;   # or /etc/letsencrypt/live/.../fullchain.pem
    ssl_certificate_key /etc/ssl/private/server.key;

    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384;

    location /api/v1/employee/ {
        proxy_pass http://10.0.2.75:8080/api/v1/employee/;
        proxy_http_version 1.1;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;

        proxy_connect_timeout 10s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
    }

}
```
<img width="1920" height="554" alt="image" src="https://github.com/user-attachments/assets/ce756f2e-0c4a-4370-9737-f431da0f0ea5" />
<img width="1920" height="554" alt="image" src="https://github.com/user-attachments/assets/5fecbac4-df66-4c64-bed8-6e2fc39b7cf4" />

Reload Nginx: `sudo nginx -t && sudo systemctl reload nginx`.

### 6.3 Enable HTTPS for Jenkins

1. Obtain a certificate (public CA, private CA, or self-signed) and place cert and key where Jenkins can read them.
2. Set Java options to use the certificate (e.g. `https.port=443`, certificate and key paths). This can be done via:
   - **Reverse proxy (recommended)** — Nginx or Apache terminates TLS and proxies to Jenkins on HTTP (as in 6.2); Jenkins can be told the request was HTTPS via `X-Forwarded-Proto`.
   - **Jenkins directly** — Configure Jenkins with `--httpsPort=443`, `--httpsCertificate`, and `--httpsPrivateKey` (or your distro’s way of passing cert/key).
3. In **Manage Jenkins → System**, set **Jenkins URL** to `https://your-jenkins.example.com/`.
4. Restrict or disable HTTP if you use HTTPS only.

(Exact steps depend on how you run Jenkins—package, Docker, or Java command line; refer to [Jenkins HTTPS](https://www.jenkins.io/doc/book/installing/#enabling-https).)

### 6.4 AWS Application Load Balancer (ALB) HTTPS

1. Request or import a certificate in **AWS Certificate Manager (ACM)** for your domain (public or private).
2. Create or edit an ALB listener for **HTTPS:443**; attach the ACM certificate.
3. Set the security group to allow 443 from the right sources.
4. Backend targets can use HTTP on the target group; ALB terminates TLS.

---

## 7. Best practices

| Practice | Description |
|----------|-------------|
| **Use TLS 1.2 or 1.3 only** | Disable SSLv3 and TLS 1.0/1.1. |
| **Strong ciphers** | Prefer forward-secret ciphers (e.g. ECDHE, DHE) and AES-GCM; avoid NULL, export, or weak ciphers. |
| **Full chain** | Serve the full certificate chain (server cert + intermediates) so clients can validate to a trusted root. |
| **Protect private keys** | Restrict file permissions (e.g. 600); use a secrets manager or HSM in production where appropriate. |
| **Renew before expiry** | Automate renewal (e.g. certbot + cron for Let’s Encrypt); set reminders for non-auto certificates. |
| **HSTS** | Enable HTTP Strict Transport Security (HSTS) so browsers use HTTPS only (e.g. `Strict-Transport-Security: max-age=31536000`). |
| **Redirect HTTP → HTTPS** | Redirect port 80 to 443 so users do not stay on plain HTTP. |
| **Separate certs per environment** | Use appropriate certs (e.g. public CA for prod, self-signed or private CA for dev) and never reuse dev certs in production. |

---

## 8. Conclusion

Use **SSL/TLS** for all user-facing and sensitive traffic: encryption, integrity, and identity. Prefer **TLS 1.2 or 1.3** and **public or private CA** certificates; use self-signed only for dev/test or internal tools where trust is managed separately. Terminate TLS at the load balancer or reverse proxy when possible, and follow best practices for ciphers, key protection, renewal, and HSTS. For Jenkins and other CI tools, expose them over HTTPS (via reverse proxy or native HTTPS) and set the base URL to `https://` so links and callbacks are secure.

---

## 9. Contact Information


| Name|Email Address |
|----------------|----------------|
|Mukesh kumar Sharma|msmukeshkumarsharma95@gmail.com|


---

## 10. References

| Link | Description |
|------|-------------|
| [RFC 8446 – TLS 1.3](https://www.rfc-editor.org/rfc/rfc8446) | TLS 1.3 specification. |
| [Mozilla SSL Configuration Generator](https://ssl-config.mozilla.org/) | Recommended server configs for Nginx, Apache, and others. |
| [Let’s Encrypt](https://letsencrypt.org/) | Free public CA; certbot for automation. |
| [OpenSSL](https://www.openssl.org/docs/) | Command-line tools for keys and certificates. |
| [Jenkins – Enabling HTTPS](https://www.jenkins.io/doc/book/installing/#enabling-https) | Jenkins HTTPS configuration. |
| [Nginx – SSL termination](https://nginx.org/en/docs/http/configuring_https_servers.html) | Nginx HTTPS server configuration. |

---
