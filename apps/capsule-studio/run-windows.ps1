$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot
if (-not (Test-Path ".env")) {
  Copy-Item ".env.example" ".env"
  Write-Host "Created .env from .env.example. Paste OPENAI_API_KEY into .env, then re-run this script."
  notepad .env
  exit 0
}
Write-Host "Starting NOVA Capsule Studio at http://127.0.0.1:8787"
npm start
