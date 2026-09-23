# n8n Automation Workspace

This project contains configurations for running **n8n** locally with Docker Compose as well as deploying to **Oracle Cloud Infrastructure (OCI)** with automatic HTTPS.

---

## 💻 Local Development

### 1. Start n8n locally
```powershell
docker compose up -d
```

### 2. Access local interface
Open [http://localhost:5678](http://localhost:5678) in your browser.

---

## ☁️ Oracle Cloud Deployment (Production)

For deploying n8n to Oracle Cloud's Always Free Tier with HTTPS/SSL:

1. Follow the step-by-step guide in [ORACLE_CLOUD_DEPLOYMENT.md](ORACLE_CLOUD_DEPLOYMENT.md).
2. Production compose configuration: [docker-compose.prod.yml](docker-compose.prod.yml).
3. Reverse proxy configuration: [Caddyfile](Caddyfile).
4. One-click setup script for your cloud instance: [deploy_oracle.sh](deploy_oracle.sh).
