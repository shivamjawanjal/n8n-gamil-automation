#!/usr/bin/env bash
set -e

echo "[+] Exporting workflows from n8n container to ./workflows/..."
mkdir -p ./workflows

if docker compose ps | grep -q "n8n"; then
  docker compose exec -T n8n n8n export:workflow --all --output=/home/node/workflows/
  echo "[+] Workflows successfully exported to ./workflows/"
  echo "[+] Ready for Git commit: git add workflows/ && git commit -m 'Update workflows'"
else
  echo "[-] Error: n8n container is not running."
  exit 1
fi
