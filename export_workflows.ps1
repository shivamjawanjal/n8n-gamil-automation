# Export all n8n workflows from Docker container to ./workflows/*.json
Write-Host "Exporting workflows from n8n container to ./workflows/..." -ForegroundColor Cyan

if (-not (Test-Path -Path "./workflows")) {
    New-Item -ItemType Directory -Path "./workflows" | Out-Null
}

docker compose exec n8n n8n export:workflow --all --output=/home/node/workflows/

if ($LASTEXITCODE -eq 0) {
    Write-Host "Workflows successfully exported to ./workflows/" -ForegroundColor Green
    Write-Host "You can now stage and commit changes to Git: git add workflows/ && git commit -m 'Update workflows'" -ForegroundColor Yellow
} else {
    Write-Host "Failed to export workflows. Ensure the n8n container is running (docker compose ps)." -ForegroundColor Red
}
