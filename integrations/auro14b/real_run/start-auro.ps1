$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot
py -3.11 -m venv .venv
& .\.venv\Scripts\python.exe -m pip install --upgrade pip
& .\.venv\Scripts\python.exe -m pip install "git+https://github.com/ItsNotAILABS/Auro14B.git@main#egg=mesie[foundry]"
& .\.venv\Scripts\auro-foundry.exe serve --checkpoint model\final.pt --host 127.0.0.1 --port 8090 --open-browser
