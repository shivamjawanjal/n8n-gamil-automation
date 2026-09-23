# Import all workflows from ./workflows/ into the n8n Docker container
Write-Host "Importing workflows from ./workflows/ into n8n container..." -ForegroundColor Cyan

if (-not (Test-Path -Path "./workflows")) {
    Write-Host "No ./workflows directory found to import." -ForegroundColor Red
    exit 1
}

docker compose exec n8n n8n import:workflow --input=/home/node/workflows/

if ($LASTEXITCODE -eq 0) {
    Write-Host "Workflows successfully imported into n8n!" -ForegroundColor Green
} else {
    Write-Host "Failed to import workflows. Ensure the n8n container is running." -ForegroundColor Red
}
