#!/usr/bin/env bash
set -e

echo "[+] Importing workflows from ./workflows/ into n8n container..."

if [ ! -d "./workflows" ]; then
  echo "[-] Directory ./workflows does not exist."
  exit 1
fi

docker compose exec -T n8n n8n import:workflow --input=/home/node/workflows/

echo "[+] Workflows successfully imported!"
