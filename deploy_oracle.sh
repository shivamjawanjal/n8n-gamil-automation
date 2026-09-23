#!/usr/bin/env bash
set -e

# ==============================================================================
# n8n Automated Oracle Cloud Deployment Script
# Supports: Ubuntu 22.04/24.04 & Oracle Linux 8/9 (x86_64 & ARM64 Ampere)
# ==============================================================================

echo "=========================================================="
echo "  Starting n8n Setup on Oracle Cloud Infrastructure (OCI) "
echo "=========================================================="

# 1. Check Root Privileges
if [ "$EUID" -ne 0 ]; then
  echo "[-] Please run as root or with sudo: sudo bash deploy_oracle.sh"
  exit 1
fi

# Detect OS
if [ -f /etc/os-release ]; then
  . /etc/os-release
  OS=$ID
else
  OS="unknown"
fi

echo "[+] Detected OS: $OS"

# 2. Configure Host Firewall (OCI Specific Step)
echo "[+] Configuring host firewall for ports 80 and 443..."
if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
  # Insert rules before the default OCI DROP rule
  iptables -I INPUT 6 -p tcp -m state --state NEW -m tcp --dport 80 -j ACCEPT 2>/dev/null || iptables -A INPUT -p tcp --dport 80 -j ACCEPT
  iptables -I INPUT 6 -p tcp -m state --state NEW -m tcp --dport 443 -j ACCEPT 2>/dev/null || iptables -A INPUT -p tcp --dport 443 -j ACCEPT
  
  # Also allow in UFW if installed
  if command -v ufw >/dev/null 2>&1; then
    ufw allow 80/tcp || true
    ufw allow 443/tcp || true
    ufw allow 22/tcp || true
  fi

  # Persist iptables
  DEBIAN_FRONTEND=noninteractive apt-get update -y
  DEBIAN_FRONTEND=noninteractive apt-get install -y iptables-persistent netfilter-persistent
  netfilter-persistent save
elif [[ "$OS" == "ol" || "$OS" == "rhel" || "$OS" == "centos" || "$OS" == "fedora" ]]; then
  if command -v firewall-cmd >/dev/null 2>&1; then
    firewall-cmd --permanent --zone=public --add-service=http || true
    firewall-cmd --permanent --zone=public --add-service=https || true
    firewall-cmd --reload || true
  fi
fi

# 3. Install Docker & Docker Compose if not already present
if ! command -v docker >/dev/null 2>&1; then
  echo "[+] Installing Docker..."
  if [[ "$OS" == "ubuntu" || "$OS" == "debian" ]]; then
    apt-get update -y
    apt-get install -y ca-certificates curl gnupg lsb-release
    install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/$OS/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg --yes
    chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$OS $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
    apt-get update -y
    apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
  elif [[ "$OS" == "ol" || "$OS" == "rhel" || "$OS" == "centos" ]]; then
    dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo || true
    dnf install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
    systemctl enable --now docker
  fi
  systemctl enable docker
  systemctl start docker
  echo "[+] Docker installed successfully."
else
  echo "[+] Docker is already installed."
fi

# 4. Check .env Configuration
if [ ! -f .env ]; then
  if [ -f .env.prod.example ]; then
    echo "[!] .env not found. Copying from .env.prod.example..."
    cp .env.prod.example .env
    echo "[!] Please edit .env with your real domain name and email:"
    echo "    nano .env"
    echo "    Then rerun: docker compose -f docker-compose.prod.yml up -d"
    exit 0
  else
    echo "[-] Missing .env and .env.prod.example file. Please create .env first."
    exit 1
  fi
fi

# 5. Start Production Stack
echo "[+] Starting n8n + Caddy production stack..."
docker compose -f docker-compose.prod.yml up -d

echo ""
echo "=========================================================="
echo "  n8n Deployment Complete!"
echo "=========================================================="
echo "Containers running:"
docker compose -f docker-compose.prod.yml ps
echo ""
echo "Verify your instance at: https://$(grep DOMAIN_NAME .env | cut -d '=' -f2)"
