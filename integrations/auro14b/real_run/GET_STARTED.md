# Use the trained Auro checkpoint

This bundle contains a real CPU-trained Auro micro checkpoint, tokenizer, training receipts, benchmark receipts, coding results, and launch scripts.

## Requirements

- Python 3.11+
- Git
- Windows PowerShell, macOS Terminal, or Linux shell

## First launch

### Windows

```powershell
Set-ExecutionPolicy -Scope Process Bypass
.\start-auro.ps1
```

### macOS or Linux

```bash
chmod +x start-auro.sh
./start-auro.sh
```

The script creates `.venv`, installs Auro14B, and starts the local server. Open:

```text
http://127.0.0.1:8090
```

## Command-line chat

After setup:

```bash
.venv/bin/auro-foundry generate --checkpoint model/final.pt --prompt "Explain NOVA and MESIE"
```

On Windows use `.venv\Scripts\auro-foundry.exe`.

## API

```bash
curl http://127.0.0.1:8090/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{"messages":[{"role":"user","content":"What are you trained on?"}],"max_tokens":128}'
```

## Evidence

- `release-manifest.json`: checkpoint and tokenizer hashes
- `evidence/training-receipt.json`: training run facts
- `benchmarks/lm-eval-results.json`: sampled official benchmark results
- `benchmarks/coding-results.json`: generated-code execution results

This artifact is a usable micro checkpoint produced by GitHub Actions. It is not represented as a completed 14B or 200B checkpoint.
