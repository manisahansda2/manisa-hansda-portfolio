# Run after: gh auth login
# Deploys this portfolio to GitHub, then opens Render to connect the repo.

$ErrorActionPreference = "Stop"
$repoName = "manisa-hansda-portfolio"

Write-Host "Checking GitHub login..." -ForegroundColor Cyan
gh auth status
if ($LASTEXITCODE -ne 0) {
    Write-Host "Run: gh auth login" -ForegroundColor Yellow
    exit 1
}

Set-Location $PSScriptRoot
git branch -M main 2>$null

Write-Host "Creating GitHub repo and pushing..." -ForegroundColor Cyan
gh repo create $repoName --public --source=. --remote=origin --push

$username = (gh api user --jq .login)
$repoUrl = "https://github.com/$username/$repoName"
$renderBlueprint = "https://dashboard.render.com/blueprint/new?repo=$repoUrl"

Write-Host ""
Write-Host "Repo: $repoUrl" -ForegroundColor Green
Write-Host "Next: open Render Blueprint deploy (log in to Render if prompted):" -ForegroundColor Cyan
Write-Host $renderBlueprint
Start-Process $renderBlueprint
