// ═══════════════════════════════════════════════════════════════════════════════
// PROTOCOL-POWERSHELL-TRANSLATOR.js — Julia↔PowerShell Transpiler (BUILD №65)
// Classification: CONFIDENTIAL — SOVEREIGN PROTOCOL
//
// Copyright © 2024-2026 Alfredo Medina Hernandez
// Medina Tech | Dallas, Texas, USA
//
// ═══════════════════════════════════════════════════════════════════════════════
// SOVEREIGN TRANSLATOR — RUN JULIA/PYTHON MATH VIA POWERSHELL
// Solves: "PowerShell doesn't understand Julia syntax" error
// ═══════════════════════════════════════════════════════════════════════════════
//
// PROBLEM:
//   Users paste Julia code into PowerShell and get errors like:
//     "The term 'const' is not recognized..."
//     "Missing ')' in function parameter list..."
//
// SOLUTION:
//   This translator converts Julia math expressions into PowerShell commands
//   that invoke Julia subprocess OR execute equivalent PowerShell/.NET math.
//
// ARCHITECTURE:
//   Julia Source → Parse → Translate → PowerShell Command / .NET Math / Julia CLI
//
// ═══════════════════════════════════════════════════════════════════════════════

// ═══ Section 1: Constants ════════════════════════════════════════════════════

export const PHI = 1.6180339887498948482;
export const PHI_INV = 0.6180339887498948482;
export const AMOR = 0.3819660112501051518;
export const HEARTBEAT_MS = 873;

export const TRANSLATOR_VERSION = '1.0.0';
export const BUILD_NUMBER = 65;

// ═══ Section 2: Julia → PowerShell Token Mappings ════════════════════════════

export const JULIA_TO_PS_KEYWORDS = {
  'const': '$',                    // const X = val → $X = val
  'function': 'function',          // function name() → function name {
  'end': '}',                      // end → }
  'using': '# Import-Module',     // using Pkg → # Import equivalent
  'return': 'return',
  'if': 'if',
  'else': '} else {',
  'elseif': '} elseif',
  'for': 'for',
  'while': 'while',
  'true': '$true',
  'false': '$false',
  'nothing': '$null',
  'println': 'Write-Host',
  'print': 'Write-Host -NoNewline',
};

export const JULIA_TO_PS_OPERATORS = {
  '.*': '* ',                      // element-wise multiply
  '.+': '+ ',                      // element-wise add
  '.-': '- ',
  './': '/ ',
  '.^': '** ',                     // power (PS doesn't have .^ but we map)
  '|>': '|',                       // pipe
  '::': '',                        // type annotation removed
  '...': '',                       // splat removed
};

export const JULIA_MATH_TO_DOTNET = {
  'sqrt': '[Math]::Sqrt',
  'abs': '[Math]::Abs',
  'sin': '[Math]::Sin',
  'cos': '[Math]::Cos',
  'tan': '[Math]::Tan',
  'asin': '[Math]::Asin',
  'acos': '[Math]::Acos',
  'atan': '[Math]::Atan',
  'exp': '[Math]::Exp',
  'log': '[Math]::Log',
  'log2': '[Math]::Log2',
  'log10': '[Math]::Log10',
  'ceil': '[Math]::Ceiling',
  'floor': '[Math]::Floor',
  'round': '[Math]::Round',
  'max': '[Math]::Max',
  'min': '[Math]::Min',
  'pi': '[Math]::PI',
  'π': '[Math]::PI',
  'ℯ': '[Math]::E',
};

// ═══ Section 3: Julia Parser ═════════════════════════════════════════════════

export class JuliaParser {
  constructor() {
    this.tokens = [];
    this.position = 0;
  }

  // Tokenize Julia source code
  tokenize(source) {
    const tokens = [];
    const patterns = [
      { type: 'COMMENT', regex: /#[^\n]*/ },
      { type: 'STRING', regex: /"(?:[^"\\]|\\.)*"/ },
      { type: 'NUMBER', regex: /\d+\.?\d*([eE][+-]?\d+)?/ },
      { type: 'KEYWORD', regex: /\b(function|end|const|using|return|if|else|elseif|for|while|true|false|nothing|println|print|module|export|import|struct|mutable|abstract|type|begin|let|do|try|catch|finally|throw|break|continue)\b/ },
      { type: 'TYPE_ANNOTATION', regex: /::[\w{}\[\],\s]+/ },
      { type: 'OPERATOR', regex: /\.\*|\.\+|\.-|\.\^|\.\/|[+\-*/^%=<>!&|]=?|\.{3}|\|>/ },
      { type: 'IDENTIFIER', regex: /[a-zA-Zα-ωΑ-Ω_][a-zA-Zα-ωΑ-Ω_0-9]*[!?]?/ },
      { type: 'PAREN', regex: /[(){}[\]]/ },
      { type: 'COMMA', regex: /,/ },
      { type: 'SEMICOLON', regex: /;/ },
      { type: 'NEWLINE', regex: /\n/ },
      { type: 'WHITESPACE', regex: /[ \t]+/ },
    ];

    let remaining = source;
    while (remaining.length > 0) {
      let matched = false;
      for (const { type, regex } of patterns) {
        const match = remaining.match(new RegExp(`^(${regex.source})`));
        if (match) {
          if (type !== 'WHITESPACE') {
            tokens.push({ type, value: match[1] });
          }
          remaining = remaining.slice(match[1].length);
          matched = true;
          break;
        }
      }
      if (!matched) {
        remaining = remaining.slice(1); // Skip unknown char
      }
    }

    this.tokens = tokens;
    return tokens;
  }

  // Parse Julia into AST-like structure
  parse(source) {
    this.tokenize(source);
    const statements = [];
    this.position = 0;

    while (this.position < this.tokens.length) {
      const token = this.tokens[this.position];

      if (token.type === 'NEWLINE' || token.type === 'COMMENT') {
        if (token.type === 'COMMENT') {
          statements.push({ type: 'comment', value: token.value });
        }
        this.position++;
        continue;
      }

      if (token.type === 'KEYWORD') {
        switch (token.value) {
          case 'const':
            statements.push(this._parseConst());
            break;
          case 'function':
            statements.push(this._parseFunction());
            break;
          case 'using':
            statements.push(this._parseUsing());
            break;
          case 'module':
            statements.push(this._parseModule());
            break;
          default:
            statements.push(this._parseExpression());
        }
      } else {
        statements.push(this._parseExpression());
      }
    }

    return { type: 'program', statements };
  }

  _parseConst() {
    this.position++; // skip 'const'
    const name = this.tokens[this.position]?.value || 'unknown';
    this.position++; // skip name
    this.position++; // skip '='
    let value = '';
    while (this.position < this.tokens.length && this.tokens[this.position].type !== 'NEWLINE') {
      value += this.tokens[this.position].value + ' ';
      this.position++;
    }
    return { type: 'const', name, value: value.trim() };
  }

  _parseFunction() {
    this.position++; // skip 'function'
    let signature = '';
    while (this.position < this.tokens.length && this.tokens[this.position].type !== 'NEWLINE') {
      signature += this.tokens[this.position].value;
      this.position++;
    }
    // Collect body until 'end'
    let body = '';
    let depth = 1;
    while (this.position < this.tokens.length && depth > 0) {
      const t = this.tokens[this.position];
      if (t.value === 'function' || t.value === 'if' || t.value === 'for' || t.value === 'while') depth++;
      if (t.value === 'end') depth--;
      if (depth > 0) body += t.value + (t.type === 'NEWLINE' ? '\n' : ' ');
      this.position++;
    }
    // Extract function name and params
    const match = signature.match(/^(\w+)\((.*)\)$/);
    const name = match ? match[1] : signature;
    const params = match ? match[2] : '';
    return { type: 'function', name, params, body: body.trim() };
  }

  _parseUsing() {
    this.position++; // skip 'using'
    const modules = [];
    while (this.position < this.tokens.length && this.tokens[this.position].type !== 'NEWLINE') {
      if (this.tokens[this.position].type === 'IDENTIFIER') {
        modules.push(this.tokens[this.position].value);
      }
      this.position++;
    }
    return { type: 'using', modules };
  }

  _parseModule() {
    this.position++; // skip 'module'
    const name = this.tokens[this.position]?.value || 'Unknown';
    this.position++;
    return { type: 'module', name };
  }

  _parseExpression() {
    let expr = '';
    while (this.position < this.tokens.length && this.tokens[this.position].type !== 'NEWLINE') {
      expr += this.tokens[this.position].value + ' ';
      this.position++;
    }
    this.position++; // skip newline
    return { type: 'expression', value: expr.trim() };
  }
}

// ═══ Section 4: PowerShell Code Generator ════════════════════════════════════

export class PowerShellGenerator {
  constructor(options = {}) {
    this.useJuliaSubprocess = options.useJuliaSubprocess ?? true;
    this.juliaPath = options.juliaPath || 'julia';
    this.useNative = options.useNative ?? true; // Use .NET math when possible
  }

  // Generate PowerShell from parsed Julia AST
  generate(ast) {
    const lines = [
      '# ═══════════════════════════════════════════════════════════════════════',
      '# NOVA Mathematical Substrate — PowerShell Translation',
      '# Auto-generated by PROTOCOL-POWERSHELL-TRANSLATOR.js',
      `# Generated: ${new Date().toISOString()}`,
      '# ═══════════════════════════════════════════════════════════════════════',
      '',
    ];

    for (const stmt of ast.statements) {
      lines.push(this._generateStatement(stmt));
    }

    return lines.join('\n');
  }

  _generateStatement(stmt) {
    switch (stmt.type) {
      case 'comment':
        return stmt.value; // Comments pass through

      case 'const':
        return this._generateConst(stmt);

      case 'function':
        return this._generateFunction(stmt);

      case 'using':
        return this._generateUsing(stmt);

      case 'module':
        return `# Module: ${stmt.name}`;

      case 'expression':
        return this._translateExpression(stmt.value);

      default:
        return `# [untranslated] ${JSON.stringify(stmt)}`;
    }
  }

  _generateConst(stmt) {
    const value = this._translateValue(stmt.value);
    return `$${stmt.name} = ${value}`;
  }

  _generateFunction(stmt) {
    // Remove type annotations from params
    const cleanParams = stmt.params
      .replace(/::[^,)]+/g, '')  // Remove ::Type annotations
      .split(',')
      .map(p => '$' + p.trim())
      .filter(p => p !== '$')
      .join(', ');

    const body = this._translateFunctionBody(stmt.body);

    return [
      `function ${stmt.name} {`,
      `    param(${cleanParams})`,
      '',
      body.split('\n').map(l => '    ' + l).join('\n'),
      '}',
      '',
    ].join('\n');
  }

  _generateUsing(stmt) {
    const lines = stmt.modules.map(m => {
      switch (m) {
        case 'LinearAlgebra':
          return '# LinearAlgebra → .NET System.Numerics or julia subprocess';
        case 'Statistics':
          return '# Statistics → .NET or [System.Linq.Enumerable] methods';
        case 'FFTW':
          return '# FFTW → Requires julia subprocess for FFT operations';
        default:
          return `# using ${m} → julia subprocess required`;
      }
    });
    return lines.join('\n');
  }

  _translateExpression(expr) {
    // Replace Julia operators
    let ps = expr;
    for (const [juliaOp, psOp] of Object.entries(JULIA_TO_PS_OPERATORS)) {
      ps = ps.replaceAll(juliaOp, psOp);
    }

    // Replace math functions
    for (const [juliaFn, psFn] of Object.entries(JULIA_MATH_TO_DOTNET)) {
      const regex = new RegExp(`\\b${juliaFn}\\(`, 'g');
      ps = ps.replace(regex, `${psFn}(`);
    }

    // Replace Julia identifiers with PowerShell variables
    ps = ps.replace(/\b([a-zA-Zα-ωΑ-Ω_]\w*)\s*=/g, '$$1 =');

    return ps;
  }

  _translateValue(value) {
    let v = value;
    // Replace common constants
    v = v.replace(/\bpi\b/g, '[Math]::PI');
    v = v.replace(/\bπ\b/g, '[Math]::PI');
    return v;
  }

  _translateFunctionBody(body) {
    return body.split('\n').map(line => this._translateExpression(line)).join('\n');
  }

  // Generate PowerShell that invokes Julia subprocess
  generateJuliaInvocation(juliaCode) {
    const escaped = juliaCode.replace(/"/g, '\\"').replace(/\$/g, '`$');
    return [
      '# Run Julia code via subprocess (requires Julia installed)',
      `$juliaCode = @"`,
      juliaCode,
      `"@`,
      '',
      `$result = & ${this.juliaPath} -e $juliaCode`,
      'Write-Host $result',
    ].join('\n');
  }

  // Generate PowerShell .NET native equivalent (no Julia needed)
  generateNativeMath(expression) {
    const translations = {
      'eigen': this._nativeEigen,
      'svd': this._nativeSVD,
      'mean': this._nativeMean,
      'std': this._nativeStd,
      'norm': this._nativeNorm,
      'dot': this._nativeDot,
    };

    for (const [key, fn] of Object.entries(translations)) {
      if (expression.includes(key)) {
        return fn(expression);
      }
    }

    return `# No native equivalent: use julia subprocess\n` +
           this.generateJuliaInvocation(expression);
  }

  // Native .NET implementations
  _nativeMean(expr) {
    return [
      '# Mean (native .NET)',
      'function Phi-Mean {',
      '    param([double[]]$x)',
      '    return ($x | Measure-Object -Average).Average',
      '}',
    ].join('\n');
  }

  _nativeStd(expr) {
    return [
      '# Standard Deviation (native .NET)',
      'function Phi-Std {',
      '    param([double[]]$x)',
      '    $mean = ($x | Measure-Object -Average).Average',
      '    $variance = ($x | ForEach-Object { [Math]::Pow($_ - $mean, 2) } | Measure-Object -Average).Average',
      '    return [Math]::Sqrt($variance)',
      '}',
    ].join('\n');
  }

  _nativeNorm(expr) {
    return [
      '# Vector Norm (native .NET)',
      'function Phi-Norm {',
      '    param([double[]]$v, [int]$p = 2)',
      '    $sum = ($v | ForEach-Object { [Math]::Pow([Math]::Abs($_), $p) } | Measure-Object -Sum).Sum',
      '    return [Math]::Pow($sum, 1.0 / $p)',
      '}',
    ].join('\n');
  }

  _nativeDot(expr) {
    return [
      '# Dot Product (native .NET)',
      'function Phi-Dot {',
      '    param([double[]]$a, [double[]]$b)',
      '    $sum = 0',
      '    for ($i = 0; $i -lt $a.Length; $i++) { $sum += $a[$i] * $b[$i] }',
      '    return $sum',
      '}',
    ].join('\n');
  }

  _nativeEigen(expr) {
    return [
      '# Eigenvalue Decomposition — requires Julia subprocess',
      '# PowerShell/.NET does not have native eigenvalue support',
      '# Install Julia: https://julialang.org/downloads/',
      '# Then run:',
      '#   julia -e "using LinearAlgebra; vals, vecs = eigen(A); println(vals)"',
    ].join('\n');
  }

  _nativeSVD(expr) {
    return [
      '# SVD — requires Julia subprocess',
      '# PowerShell/.NET does not have native SVD support',
      '# Install Julia: https://julialang.org/downloads/',
      '# Then run:',
      '#   julia -e "using LinearAlgebra; U, S, V = svd(A); println(S)"',
    ].join('\n');
  }
}

// ═══ Section 5: Complete Translator Class ════════════════════════════════════

export class PowerShellTranslator {
  constructor(options = {}) {
    this.parser = new JuliaParser();
    this.generator = new PowerShellGenerator(options);
  }

  // Translate Julia source to PowerShell
  translate(juliaSource) {
    const ast = this.parser.parse(juliaSource);
    return this.generator.generate(ast);
  }

  // Generate PowerShell script that runs Julia via subprocess
  wrapForSubprocess(juliaSource) {
    return this.generator.generateJuliaInvocation(juliaSource);
  }

  // Generate helper script to install Julia and set up PATH
  generateInstallScript() {
    return [
      '# ═══════════════════════════════════════════════════════════════════════',
      '# NOVA Julia Installer for PowerShell',
      '# Run this script ONCE to set up Julia on your system',
      '# ═══════════════════════════════════════════════════════════════════════',
      '',
      '# Check if Julia is installed',
      '$juliaCheck = Get-Command julia -ErrorAction SilentlyContinue',
      'if ($juliaCheck) {',
      '    Write-Host "✓ Julia is already installed: $($juliaCheck.Source)" -ForegroundColor Green',
      '    julia --version',
      '} else {',
      '    Write-Host "Julia is not installed. Installing..." -ForegroundColor Yellow',
      '    Write-Host ""',
      '    Write-Host "Option 1: Install via winget (recommended):" -ForegroundColor Cyan',
      '    Write-Host "  winget install Julialang.Julia"',
      '    Write-Host ""',
      '    Write-Host "Option 2: Download manually:" -ForegroundColor Cyan',
      '    Write-Host "  https://julialang.org/downloads/"',
      '    Write-Host ""',
      '    Write-Host "After installing, restart PowerShell and run:" -ForegroundColor Yellow',
      '    Write-Host "  julia -e \\"println(1.6180339887498948482)\\"" -ForegroundColor White',
      '    Write-Host ""',
      '    ',
      '    # Attempt automated install via winget',
      '    $choice = Read-Host "Attempt automated install via winget? (y/n)"',
      '    if ($choice -eq "y") {',
      '        winget install Julialang.Julia',
      '    }',
      '}',
      '',
      '# Install NOVA Julia package',
      'Write-Host ""',
      'Write-Host "Setting up NOVA Julia Mathematical Substrate..." -ForegroundColor Gold',
      '$novaJuliaSetup = @"',
      '# Install NOVA dependencies',
      'import Pkg',
      'Pkg.add(["LinearAlgebra", "Statistics", "FFTW"])',
      'println("NOVA Julia dependencies installed successfully")',
      '"@',
      '',
      'if (Get-Command julia -ErrorAction SilentlyContinue) {',
      '    julia -e $novaJuliaSetup',
      '    Write-Host "✓ NOVA Julia substrate ready" -ForegroundColor Green',
      '}',
    ].join('\n');
  }

  // Generate PowerShell wrapper module for NOVA math functions
  generateNovaModule() {
    return [
      '# ═══════════════════════════════════════════════════════════════════════',
      '# Nova-Math.psm1 — NOVA Mathematical Functions for PowerShell',
      '# Provides φ-optimized mathematical functions via Julia subprocess',
      '# Usage: Import-Module ./Nova-Math.psm1',
      '# ═══════════════════════════════════════════════════════════════════════',
      '',
      '# ─── Constants ─────────────────────────────────────────────────────────',
      '$Script:PHI = 1.6180339887498948482',
      '$Script:PHI_INV = 0.6180339887498948482',
      '$Script:AMOR = 0.3819660112501051518',
      '$Script:HEARTBEAT_MS = 873',
      '',
      'function Get-Phi { return $Script:PHI }',
      'function Get-PhiInv { return $Script:PHI_INV }',
      'function Get-Amor { return $Script:AMOR }',
      '',
      '# ─── Julia Bridge ─────────────────────────────────────────────────────',
      '',
      'function Invoke-Julia {',
      '    param([string]$Code)',
      '    $juliaPath = (Get-Command julia -ErrorAction SilentlyContinue).Source',
      '    if (-not $juliaPath) {',
      '        Write-Error "Julia not found. Run: winget install Julialang.Julia"',
      '        return $null',
      '    }',
      '    return (& julia -e $Code 2>&1)',
      '}',
      '',
      '# ─── φ-Optimized Math Functions ────────────────────────────────────────',
      '',
      'function Invoke-PhiEigen {',
      '    param([double[,]]$Matrix)',
      '    $rows = $Matrix.GetLength(0)',
      '    $matStr = "["',
      '    for ($i = 0; $i -lt $rows; $i++) {',
      '        $row = @()',
      '        for ($j = 0; $j -lt $Matrix.GetLength(1); $j++) {',
      '            $row += $Matrix[$i,$j]',
      '        }',
      '        $matStr += "[" + ($row -join " ") + "];"',
      '    }',
      '    $matStr += "]"',
      '    $code = "using LinearAlgebra; A=$matStr; vals,vecs=eigen(A); println(vals)"',
      '    return Invoke-Julia -Code $code',
      '}',
      '',
      'function Invoke-PhiMean {',
      '    param([double[]]$X)',
      '    return ($X | Measure-Object -Average).Average',
      '}',
      '',
      'function Invoke-PhiStd {',
      '    param([double[]]$X)',
      '    $mean = ($X | Measure-Object -Average).Average',
      '    $var = ($X | ForEach-Object { [Math]::Pow($_ - $mean, 2) } | Measure-Object -Average).Average',
      '    return [Math]::Sqrt($var)',
      '}',
      '',
      'function Invoke-PhiNorm {',
      '    param([double[]]$V)',
      '    $sum = ($V | ForEach-Object { $_ * $_ } | Measure-Object -Sum).Sum',
      '    return [Math]::Sqrt($sum)',
      '}',
      '',
      'function Invoke-PhiDot {',
      '    param([double[]]$A, [double[]]$B)',
      '    $sum = 0.0',
      '    for ($i = 0; $i -lt $A.Length; $i++) { $sum += $A[$i] * $B[$i] }',
      '    return $sum',
      '}',
      '',
      'function Invoke-PhiGradientDescent {',
      '    param([scriptblock]$Objective, [double[]]$X0, [int]$MaxIter = 162)',
      '    $lr = $Script:PHI_INV',
      '    $x = $X0.Clone()',
      '    $h = 1e-5',
      '    for ($iter = 0; $iter -lt $MaxIter; $iter++) {',
      '        $grad = @()',
      '        for ($i = 0; $i -lt $x.Length; $i++) {',
      '            $xp = $x.Clone(); $xm = $x.Clone()',
      '            $xp[$i] += $h; $xm[$i] -= $h',
      '            $grad += (& $Objective $xp) - (& $Objective $xm)) / (2 * $h)',
      '        }',
      '        $normGrad = [Math]::Sqrt(($grad | ForEach-Object { $_ * $_ } | Measure-Object -Sum).Sum)',
      '        if ($normGrad -lt $Script:AMOR) { break }',
      '        for ($i = 0; $i -lt $x.Length; $i++) { $x[$i] -= $lr * $grad[$i] }',
      '    }',
      '    return $x',
      '}',
      '',
      'function Invoke-PhiFFT {',
      '    param([double[]]$Signal)',
      '    $arrStr = "[" + ($Signal -join ", ") + "]"',
      '    $code = "using FFTW; println(abs.(fft($arrStr)))"',
      '    return Invoke-Julia -Code $code',
      '}',
      '',
      'function Invoke-PhiMonteCarlo {',
      '    param([scriptblock]$F, [int]$Dim, [int]$Samples = 0)',
      '    if ($Samples -eq 0) { $Samples = [Math]::Ceiling([Math]::Pow($Script:PHI, 5) * $Dim) }',
      '    $results = @()',
      '    for ($i = 0; $i -lt $Samples; $i++) {',
      '        $point = @()',
      '        for ($d = 0; $d -lt $Dim; $d++) { $point += (Get-Random -Minimum 0.0 -Maximum 1.0) }',
      '        $results += (& $F $point)',
      '    }',
      '    return ($results | Measure-Object -Average).Average',
      '}',
      '',
      'function Invoke-KuramotoStep {',
      '    param([double[]]$Theta, [double[]]$Omega, [double]$K, [double]$Dt)',
      '    $N = $Theta.Length',
      '    $newTheta = @()',
      '    for ($i = 0; $i -lt $N; $i++) {',
      '        $coupling = 0.0',
      '        for ($j = 0; $j -lt $N; $j++) {',
      '            if ($j -ne $i) { $coupling += [Math]::Sin($Theta[$j] - $Theta[$i]) }',
      '        }',
      '        $dTheta = $Omega[$i] + ($K / $N) * $coupling',
      '        $newTheta += $Theta[$i] + $dTheta * $Dt',
      '    }',
      '    return $newTheta',
      '}',
      '',
      'function Get-OrderParameter {',
      '    param([double[]]$Theta)',
      '    $reSum = 0.0; $imSum = 0.0',
      '    foreach ($t in $Theta) {',
      '        $reSum += [Math]::Cos($t)',
      '        $imSum += [Math]::Sin($t)',
      '    }',
      '    return [Math]::Sqrt($reSum * $reSum + $imSum * $imSum) / $Theta.Length',
      '}',
      '',
      '# ─── Exports ──────────────────────────────────────────────────────────',
      'Export-ModuleMember -Function @(',
      '    "Get-Phi", "Get-PhiInv", "Get-Amor",',
      '    "Invoke-Julia",',
      '    "Invoke-PhiEigen", "Invoke-PhiMean", "Invoke-PhiStd",',
      '    "Invoke-PhiNorm", "Invoke-PhiDot",',
      '    "Invoke-PhiGradientDescent", "Invoke-PhiFFT",',
      '    "Invoke-PhiMonteCarlo",',
      '    "Invoke-KuramotoStep", "Get-OrderParameter"',
      ')',
    ].join('\n');
  }

  // Detect if input is Julia code
  detectJulia(input) {
    const juliaPatterns = [
      /\bfunction\s+\w+\(.*::\w+/,
      /\bconst\s+\w+\s*=/,
      /\busing\s+\w+/,
      /\bend\s*$/m,
      /::Vector\{/,
      /::Matrix\{/,
      /::Float64/,
      /\.\*/,
      /\|>/,
    ];
    let score = 0;
    for (const pattern of juliaPatterns) {
      if (pattern.test(input)) score++;
    }
    return score >= 2;
  }

  // Smart translate: detect language and provide helpful error message
  smartTranslate(input) {
    if (this.detectJulia(input)) {
      return {
        detected: 'julia',
        message: 'Julia code detected. This cannot run directly in PowerShell.',
        options: [
          'Option 1: Run in Julia REPL (type "julia" first)',
          'Option 2: Use translated PowerShell equivalent below',
          'Option 3: Install Julia and use subprocess wrapper',
        ],
        powershellEquivalent: this.translate(input),
        juliaSubprocess: this.wrapForSubprocess(input),
      };
    }

    return {
      detected: 'powershell',
      message: 'Input appears to be PowerShell-compatible.',
      options: [],
      powershellEquivalent: input,
      juliaSubprocess: null,
    };
  }
}

// ═══ Section 6: Singleton ════════════════════════════════════════════════════

let _translator = null;

export function getTranslator(options = {}) {
  if (!_translator) {
    _translator = new PowerShellTranslator(options);
  }
  return _translator;
}

// ═══════════════════════════════════════════════════════════════════════════════
// PROTOCOL-POWERSHELL-TRANSLATOR — JULIA↔POWERSHELL BRIDGE
// Solves: "const is not recognized" and similar PowerShell errors
// COPYRIGHT © 2024-2026 ALFREDO MEDINA HERNANDEZ
// ═══════════════════════════════════════════════════════════════════════════════

export default {
  PHI, PHI_INV, AMOR, HEARTBEAT_MS,
  TRANSLATOR_VERSION, BUILD_NUMBER,
  JULIA_TO_PS_KEYWORDS,
  JULIA_TO_PS_OPERATORS,
  JULIA_MATH_TO_DOTNET,
  JuliaParser,
  PowerShellGenerator,
  PowerShellTranslator,
  getTranslator,
};
