# 📧 n8n Gmail Automation

A complete repository setup for running, developing, and deploying **n8n Gmail Automations** locally and on **Oracle Cloud Infrastructure (OCI)** with automatic HTTPS/SSL and Git-synced workflows.

---

## 📁 Repository Structure

```
n8n/
├── workflows/                     # Version-controlled n8n workflow JSON files
│   └── gmail_ai_autoresponder.json # Starter Gmail AI autoresponder template
├── docker-compose.yml             # Local Docker Compose setup
├── docker-compose.prod.yml        # Production Docker Compose (n8n + Caddy SSL)
├── Caddyfile                      # Caddy reverse proxy configuration
├── deploy_oracle.sh               # One-click deployment script for Oracle Cloud
├── export_workflows.ps1 / .sh     # Export all active workflows to ./workflows/
├── import_workflows.ps1 / .sh     # Import all ./workflows/ into n8n container
├── .env.example                   # Local environment variable template
├── .env.prod.example              # Oracle Cloud environment variable template
├── GMAIL_INTEGRATION_GUIDE.md     # Google Cloud OAuth 2.0 setup guide
└── ORACLE_CLOUD_DEPLOYMENT.md     # Step-by-step Oracle Cloud deployment guide
```

---

## 🚀 Quick Start (Local)

### 1. Start n8n
```powershell
docker compose up -d
```
Open [http://localhost:5678](http://localhost:5678) in your browser.

### 2. Connect Gmail Account
Follow the instructions in [GMAIL_INTEGRATION_GUIDE.md](GMAIL_INTEGRATION_GUIDE.md) to set up your Google Cloud OAuth2 credentials.

---

## 🔄 Syncing Workflows with Git

### Export Active Workflows to Git
To save all workflows you created or modified in the n8n UI into this repository:
- **Windows (PowerShell)**:
  ```powershell
  .\export_workflows.ps1
  ```
- **Linux / Cloud (Bash)**:
  ```bash
  bash export_workflows.sh
  ```
Then commit and push:
```bash
git add workflows/
git commit -m "Add new Gmail automation workflow"
git push origin main
```

### Import Workflows from Git into n8n
To load all workflows from `./workflows/` into n8n:
- **Windows (PowerShell)**:
  ```powershell
  .\import_workflows.ps1
  ```
- **Linux / Cloud (Bash)**:
  ```bash
  bash import_workflows.sh
  ```

---

## ☁️ Deploy to Oracle Cloud

Follow the comprehensive guide in [ORACLE_CLOUD_DEPLOYMENT.md](ORACLE_CLOUD_DEPLOYMENT.md) to launch this stack on Oracle Cloud's Always Free VM with automatic HTTPS.
