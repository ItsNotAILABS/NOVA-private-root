# ═══════════════════════════════════════════════════════════════════════════════
# run_all.jl — Master Runner for All 15 NOVA Julia API Functions
# Classification: CONFIDENTIAL — SOVEREIGN MATHEMATICS
#
# Copyright © 2024-2026 Alfredo Medina Hernandez
# Medina Tech | Dallas, Texas, USA
#
# NOVA Julia-Motoko Bridge — Complete Program Runner
# ═══════════════════════════════════════════════════════════════════════════════
#
# Runs all 15 API functions as complete programs with verification.
#
# USAGE:
#   julia run_all.jl           # Run all programs
#   julia run_all.jl eigen     # Run single program
#   julia run_all.jl --list    # List available programs
#
# MCP TOOL EQUIVALENTS:
#   julia.compute(phi_eigen)        → eigen_program.jl
#   julia.compute(phi_svd)          → svd_program.jl
#   julia.compute(phi_fft)          → fft_program.jl
#   julia.compute(phi_ifft)         → ifft_program.jl
#   julia.compute(phi_mean)         → mean_program.jl
#   julia.compute(phi_std)          → std_program.jl
#   julia.compute(phi_var)          → var_program.jl
#   julia.compute(phi_cov)          → cov_program.jl
#   julia.compute(phi_cor)          → cor_program.jl
#   julia.compute(phi_linsolve)     → linsolve_program.jl
#   julia.compute(kuramoto_sync)    → kuramoto_sync_program.jl
#   julia.compute(phi_learning_rate)→ phi_learning_rate_program.jl
#   julia.compute(phi_fibonacci)    → fibonacci_program.jl
#   julia.compute(golden_section)   → golden_section_program.jl
#   julia.compute(phi_decay)        → phi_decay_program.jl
#
# CROSS-SUBSTRATE MESH:
#   Cloudflare → Julia → ICP → Cloudflare → ICP → Julia
#   Everything talks to everything through MCP tools.
#
# ═══════════════════════════════════════════════════════════════════════════════

const PHI = 1.6180339887498948482
const BUILD = "BUILD №66"

# All 15 programs in order
const PROGRAMS = [
    ("eigen",           "eigen_program.jl",           "phi_eigen",        "Eigenvalues with φ-scaling"),
    ("svd",             "svd_program.jl",             "phi_svd",          "SVD with φ-truncation"),
    ("fft",             "fft_program.jl",             "phi_fft",          "FFT with φ-windowing"),
    ("ifft",            "ifft_program.jl",            "phi_ifft",         "Inverse FFT with φ-reconstruction"),
    ("mean",            "mean_program.jl",            "phi_mean",         "Mean with φ-outlier handling"),
    ("std",             "std_program.jl",             "phi_std",          "Std dev with φ-robust estimation"),
    ("var",             "var_program.jl",             "phi_var",          "Variance with φ-stabilization"),
    ("cov",             "cov_program.jl",             "phi_cov",          "Covariance with φ-normalization"),
    ("cor",             "cor_program.jl",             "phi_cor",          "Correlation with φ-bounds"),
    ("linsolve",        "linsolve_program.jl",        "phi_linsolve",     "Linear solver with φ-preconditioner"),
    ("kuramoto",        "kuramoto_sync_program.jl",   "kuramoto_sync",    "Kuramoto oscillator sync"),
    ("learning_rate",   "phi_learning_rate_program.jl","phi_learning_rate","φ⁻¹ scaled learning rate"),
    ("fibonacci",       "fibonacci_program.jl",       "phi_fibonacci",    "Fibonacci with φ closed-form"),
    ("golden_section",  "golden_section_program.jl",  "golden_section",   "Golden section optimization"),
    ("phi_decay",       "phi_decay_program.jl",       "phi_decay",        "φ-exponential decay"),
]

function print_header()
    println()
    println("╔══════════════════════════════════════════════════════════════════════════╗")
    println("║           NOVA JULIA-MOTOKO BRIDGE — API REFERENCE PROGRAMS            ║")
    println("║                                                                          ║")
    println("║  15 Mathematical Functions • 4 MCP Call Doors • 3 Type Layers           ║")
    println("║  $BUILD • Cross-Substrate Mesh (CF ↔ Julia ↔ ICP)                ║")
    println("╚══════════════════════════════════════════════════════════════════════════╝")
    println()
end

function print_mcp_tools()
    println("═══ MCP Tools (Brain Organ Exposure) ═══")
    println()
    println("  julia.compute(<function>)   Execute any of the 15 functions")
    println("  julia.classify_probe        Classify input → recommended function")
    println("  julia.optimize_policy       Run optimization with constraints")
    println("  julia.reward_curve          Compute reward/decay curves")
    println()
    println("═══ Cross-Substrate Routes ═══")
    println()
    println("  Cloudflare → Julia    Worker calls julia.compute via MCP")
    println("  Julia → ICP           Result stored on-chain via icp.persist")
    println("  ICP → Cloudflare      Canister triggers Worker via cf.trigger")
    println("  Cloudflare → ICP      Worker calls canister via icp.query")
    println("  ICP → Julia           Canister requests compute via julia.compute")
    println()
end

function list_programs()
    print_header()
    println("═══ Available Programs (15 functions) ═══")
    println()
    println("  $(lpad("#", 3))  $(lpad("Name", 16))  $(lpad("MCP Tool", 20))  Description")
    println("  $(repeat("─", 3))  $(repeat("─", 16))  $(repeat("─", 20))  $(repeat("─", 40))")
    for (i, (name, file, mcp, desc)) in enumerate(PROGRAMS)
        println("  $(lpad(i, 3))  $(lpad(name, 16))  $(lpad(mcp, 20))  $desc")
    end
    println()
    print_mcp_tools()
end

function run_program(name::String)
    # Find program
    idx = findfirst(p -> p[1] == name, PROGRAMS)
    if idx === nothing
        println("ERROR: Unknown program '$name'")
        println("Use --list to see available programs")
        return false
    end

    _, file, mcp_name, desc = PROGRAMS[idx]
    script_dir = @__DIR__
    filepath = joinpath(script_dir, file)

    println("┌─────────────────────────────────────────────────────────────────")
    println("│ Running: $file")
    println("│ MCP Tool: julia.compute($mcp_name)")
    println("│ Description: $desc")
    println("└─────────────────────────────────────────────────────────────────")
    println()

    if isfile(filepath)
        include(filepath)
        return true
    else
        println("  ERROR: File not found: $filepath")
        return false
    end
end

function run_all()
    print_header()
    print_mcp_tools()

    passed = 0
    failed = 0
    start_time = time()

    for (name, file, mcp, desc) in PROGRAMS
        println()
        println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
        try
            if run_program(name)
                passed += 1
            else
                failed += 1
            end
        catch e
            println("  ERROR in $name: $e")
            failed += 1
        end
    end

    elapsed = time() - start_time
    println()
    println("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
    println()
    println("═══ Summary ═══")
    println("  Total programs: $(passed + failed)")
    println("  Passed: $passed")
    println("  Failed: $failed")
    println("  Time: $(round(elapsed, digits=2))s")
    println("  Status: $(failed == 0 ? "✓ ALL PASS" : "✗ FAILURES DETECTED")")
    println()
    println("═══ Bridge Statistics ═══")
    println("  15 Math Functions")
    println("  4  MCP Call Doors (compute, classify_probe, optimize_policy, reward_curve)")
    println("  3  Type Layers (Julia → Motoko → JavaScript)")
    println("  5  Cross-Substrate Routes (CF↔Julia↔ICP full triangle)")
    println("  $BUILD")
end

# ═══ Main Entry Point ═════════════════════════════════════════════════════════

if abspath(PROGRAM_FILE) == @__FILE__
    if "--list" in ARGS || "-l" in ARGS
        list_programs()
    elseif "--help" in ARGS || "-h" in ARGS
        print_header()
        println("USAGE:")
        println("  julia run_all.jl           Run all 15 programs")
        println("  julia run_all.jl <name>    Run single program by name")
        println("  julia run_all.jl --list    List available programs")
        println("  julia run_all.jl --help    Show this help")
        println()
        println("EXAMPLES:")
        println("  julia run_all.jl eigen")
        println("  julia run_all.jl kuramoto")
        println("  julia run_all.jl fibonacci")
    elseif length(ARGS) > 0
        print_header()
        run_program(ARGS[1])
    else
        run_all()
    end
end
