param(
  [int]$Port = 8080,
  [string]$PairToken = ""
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

if (-not (Get-Command python -ErrorAction SilentlyContinue)) {
  throw "Python is required. Install Python 3 and make sure 'python' is available in PATH."
}

if ([string]::IsNullOrWhiteSpace($PairToken)) {
  $bytes = New-Object byte[] 24
  [System.Security.Cryptography.RandomNumberGenerator]::Fill($bytes)
  $PairToken = [Convert]::ToBase64String($bytes).TrimEnd('=').Replace('+','-').Replace('/','_')
}

$env:NOVA_IOT_HOST = "0.0.0.0"
$env:NOVA_IOT_PORT = "$Port"
$env:NOVA_IOT_PAIR_TOKEN = $PairToken

$ip = (Get-NetIPAddress -AddressFamily IPv4 |
  Where-Object { $_.IPAddress -notlike '127.*' -and $_.PrefixOrigin -ne 'WellKnown' } |
  Sort-Object InterfaceMetric |
  Select-Object -First 1 -ExpandProperty IPAddress)

Write-Host ""
Write-Host "NOVA PHONE IS STARTING" -ForegroundColor Cyan
Write-Host "Pair token: $PairToken" -ForegroundColor Yellow
if ($ip) {
  Write-Host "Open on your phone: http://${ip}:$Port/phone" -ForegroundColor Green
} else {
  Write-Host "Open on this computer: http://127.0.0.1:$Port/phone" -ForegroundColor Green
}
Write-Host "Keep this window open while using NOVA Phone." -ForegroundColor DarkGray
Write-Host ""

python server.py
