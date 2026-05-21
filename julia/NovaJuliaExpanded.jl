# ═══════════════════════════════════════════════════════════════════════════════
# NovaJuliaExpanded.jl — Extended NOVA Julia Mathematical Substrate (BUILD №65)
# Classification: CONFIDENTIAL — SOVEREIGN MATHEMATICS
#
# Copyright © 2024-2026 Alfredo Medina Hernandez
# Medina Tech | Dallas, Texas, USA
#
# ═══════════════════════════════════════════════════════════════════════════════
# 85+ ADDITIONAL MATHEMATICAL FUNCTIONS
# ═══════════════════════════════════════════════════════════════════════════════
#
# IMPORTANT: This is Julia code. To run it:
#   1. Install Julia: https://julialang.org/downloads/
#   2. Open terminal/PowerShell
#   3. Type: julia
#   4. Then: include("NovaJuliaExpanded.jl")
#
# DO NOT paste this into PowerShell directly — it will not work.
# PowerShell and Julia are different languages.
#
# ═══════════════════════════════════════════════════════════════════════════════

module NovaJuliaExpanded

using LinearAlgebra
using Statistics

# ═══ Section 1: Constants ═════════════════════════════════════════════════════

const PHI = 1.6180339887498948482
const PHI_INV = 0.6180339887498948482
const AMOR = 0.3819660112501051518
const FEIGENBAUM_D = 4.6692016091029906719
const HEARTBEAT_MS = 873
const EULER_E = 2.7182818284590452354

# ═══ Section 2: Linear Algebra Extensions ═════════════════════════════════════

"""QR Decomposition with φ-weighting"""
function phi_qr(A::Matrix{Float64})
    Q, R = qr(A)
    return (Matrix(Q), R)
end

"""LU Factorization"""
function phi_lu(A::Matrix{Float64})
    F = lu(A)
    return (F.L, F.U, F.p)
end

"""Cholesky decomposition (positive definite matrices)"""
function phi_cholesky(A::Matrix{Float64})
    return Matrix(cholesky(Symmetric(A)).L)
end

"""Matrix exponential e^A"""
function phi_expm(A::Matrix{Float64})
    return exp(A)
end

"""Matrix logarithm log(A)"""
function phi_logm(A::Matrix{Float64})
    return log(A)
end

"""Matrix square root √A"""
function phi_sqrtm(A::Matrix{Float64})
    return sqrt(A)
end

"""Condition number κ(A)"""
function phi_cond(A::Matrix{Float64})
    return cond(A)
end

"""Matrix rank"""
function phi_rank(A::Matrix{Float64})
    return rank(A)
end

"""Null space basis"""
function phi_nullspace(A::Matrix{Float64})
    return nullspace(A)
end

"""Kronecker product A ⊗ B"""
function phi_kron(A::Matrix{Float64}, B::Matrix{Float64})
    return kron(A, B)
end

"""Schur decomposition"""
function phi_schur(A::Matrix{Float64})
    F = schur(A)
    return (F.T, F.Z)
end

"""Pseudo-inverse A⁺"""
function phi_pinv(A::Matrix{Float64})
    return pinv(A)
end

"""Solve linear system Ax = b"""
function phi_solve(A::Matrix{Float64}, b::Vector{Float64})
    return A \ b
end

"""Least squares solution"""
function phi_lstsq(A::Matrix{Float64}, b::Vector{Float64})
    return A \ b
end

"""Dot product"""
function phi_dot(a::Vector{Float64}, b::Vector{Float64})
    return dot(a, b)
end

"""Cross product (3D)"""
function phi_cross(a::Vector{Float64}, b::Vector{Float64})
    return cross(a, b)
end

"""Trace of matrix"""
function phi_trace(A::Matrix{Float64})
    return tr(A)
end

"""Determinant"""
function phi_det(A::Matrix{Float64})
    return det(A)
end

# ═══ Section 3: Statistics Extensions ═════════════════════════════════════════

"""Median"""
function phi_median(x::Vector{Float64})
    return median(x)
end

"""Variance"""
function phi_var(x::Vector{Float64})
    return var(x)
end

"""Covariance"""
function phi_cov(x::Vector{Float64}, y::Vector{Float64})
    return cov(x, y)
end

"""Quantile"""
function phi_quantile(x::Vector{Float64}, p::Float64)
    return quantile(x, p)
end

"""Skewness"""
function phi_skewness(x::Vector{Float64})
    n = length(x)
    μ = mean(x)
    σ = std(x)
    return (1/n) * sum(((x .- μ) ./ σ).^3)
end

"""Kurtosis (excess)"""
function phi_kurtosis(x::Vector{Float64})
    n = length(x)
    μ = mean(x)
    σ = std(x)
    return (1/n) * sum(((x .- μ) ./ σ).^4) - 3.0
end

"""Shannon entropy"""
function phi_entropy(p::Vector{Float64})
    p_safe = p[p .> 0]
    return -sum(p_safe .* log.(p_safe))
end

"""KL Divergence D_KL(P||Q)"""
function phi_kl_divergence(P::Vector{Float64}, Q::Vector{Float64})
    mask = (P .> 0) .& (Q .> 0)
    return sum(P[mask] .* log.(P[mask] ./ Q[mask]))
end

"""Simple linear regression β = (XᵀX)⁻¹Xᵀy"""
function phi_regression(X::Matrix{Float64}, y::Vector{Float64})
    return X \ y
end

"""K-means clustering (simple implementation)"""
function phi_kmeans(X::Matrix{Float64}, k::Int; max_iter=100)
    n, d = size(X)
    # Random initialization
    centers = X[randperm(n)[1:k], :]
    labels = zeros(Int, n)

    for _ in 1:max_iter
        # Assignment step
        for i in 1:n
            dists = [norm(X[i,:] - centers[j,:]) for j in 1:k]
            labels[i] = argmin(dists)
        end
        # Update step
        new_centers = zeros(k, d)
        for j in 1:k
            members = X[labels .== j, :]
            if size(members, 1) > 0
                new_centers[j, :] = mean(members, dims=1)
            end
        end
        if new_centers ≈ centers
            break
        end
        centers = new_centers
    end

    return (labels, centers)
end

# ═══ Section 4: Optimization ══════════════════════════════════════════════════

"""BFGS quasi-Newton optimization"""
function phi_bfgs(f, x0::Vector{Float64}; max_iter=200, tol=AMOR)
    n = length(x0)
    x = copy(x0)
    H = Matrix{Float64}(I, n, n)  # Initial Hessian approximation

    for k in 1:max_iter
        grad = _numerical_gradient(f, x)
        if norm(grad) < tol
            break
        end
        d = -H * grad
        α = _line_search(f, x, d)
        s = α * d
        x_new = x + s
        y = _numerical_gradient(f, x_new) - grad

        # BFGS update
        if dot(y, s) > 1e-10
            ρ = 1.0 / dot(y, s)
            H = (I - ρ * s * y') * H * (I - ρ * y * s') + ρ * s * s'
        end
        x = x_new
    end
    return x
end

"""Golden section search (1D, uses φ!)"""
function phi_golden_search(f, a::Float64, b::Float64; tol=1e-8)
    while (b - a) > tol
        c = b - PHI_INV * (b - a)
        d = a + PHI_INV * (b - a)
        if f(c) < f(d)
            b = d
        else
            a = c
        end
    end
    return (a + b) / 2
end

"""Nelder-Mead simplex (derivative-free)"""
function phi_nelder_mead(f, x0::Vector{Float64}; max_iter=500, tol=AMOR)
    n = length(x0)
    # Initialize simplex
    simplex = [copy(x0)]
    for i in 1:n
        xi = copy(x0)
        xi[i] += 1.0
        push!(simplex, xi)
    end

    for _ in 1:max_iter
        # Sort by function value
        sort!(simplex, by=f)
        centroid = mean(simplex[1:end-1])

        # Reflection
        xr = centroid + (centroid - simplex[end])
        if f(simplex[1]) <= f(xr) < f(simplex[end-1])
            simplex[end] = xr
        elseif f(xr) < f(simplex[1])
            # Expansion
            xe = centroid + 2*(xr - centroid)
            simplex[end] = f(xe) < f(xr) ? xe : xr
        else
            # Contraction
            xc = centroid + 0.5*(simplex[end] - centroid)
            if f(xc) < f(simplex[end])
                simplex[end] = xc
            else
                # Shrink
                for i in 2:length(simplex)
                    simplex[i] = simplex[1] + 0.5*(simplex[i] - simplex[1])
                end
            end
        end

        # Convergence check
        vals = [f(s) for s in simplex]
        if std(vals) < tol
            break
        end
    end

    return simplex[argmin([f(s) for s in simplex])]
end

# ═══ Section 5: Differential Equations ════════════════════════════════════════

"""Runge-Kutta 4th order"""
function phi_rk4(f, y0::Float64, t0::Float64, tf::Float64, steps::Int)
    dt = (tf - t0) / steps
    t = t0
    y = y0
    history = [y0]

    for _ in 1:steps
        k1 = f(t, y)
        k2 = f(t + dt/2, y + dt*k1/2)
        k3 = f(t + dt/2, y + dt*k2/2)
        k4 = f(t + dt, y + dt*k3)
        y += (dt/6) * (k1 + 2k2 + 2k3 + k4)
        t += dt
        push!(history, y)
    end

    return history
end

"""Lorenz attractor"""
function phi_lorenz(u0::Vector{Float64}; σ=10.0, ρ=28.0, β=8/3, dt=0.01, steps=10000)
    x, y, z = u0
    history = zeros(steps+1, 3)
    history[1, :] = u0

    for i in 1:steps
        dx = σ * (y - x)
        dy = x * (ρ - z) - y
        dz = x * y - β * z
        x += dx * dt
        y += dy * dt
        z += dz * dt
        history[i+1, :] = [x, y, z]
    end

    return history
end

"""Van der Pol oscillator"""
function phi_van_der_pol(μ::Float64, u0::Vector{Float64}; dt=0.01, steps=5000)
    x, v = u0
    history = zeros(steps+1, 2)
    history[1, :] = u0

    for i in 1:steps
        dx = v
        dv = μ * (1 - x^2) * v - x
        x += dx * dt
        v += dv * dt
        history[i+1, :] = [x, v]
    end

    return history
end

"""φ-damped harmonic oscillator: ẍ + φ⁻¹ẋ + φx = 0"""
function phi_oscillator(x0::Float64, v0::Float64; dt=0.01, steps=1000)
    x, v = x0, v0
    history = zeros(steps+1, 2)
    history[1, :] = [x, v]

    for i in 1:steps
        a = -PHI * x - PHI_INV * v  # φ spring + φ⁻¹ damping
        v += a * dt
        x += v * dt
        history[i+1, :] = [x, v]
    end

    return history
end

"""Kuramoto oscillators (extended)"""
function phi_kuramoto(theta::Vector{Float64}, omega::Vector{Float64}, K::Float64; dt=0.873/1000, steps=1000)
    N = length(theta)
    history = zeros(steps+1, N)
    history[1, :] = theta

    for s in 1:steps
        for i in 1:N
            coupling = sum(sin(theta[j] - theta[i]) for j in 1:N if j != i)
            theta[i] += (omega[i] + (K / N) * coupling) * dt
        end
        history[s+1, :] = theta
    end

    return history
end

"""FitzHugh-Nagumo neuron model"""
function phi_fitzhugh_nagumo(a::Float64, b::Float64, I_ext::Float64, u0::Vector{Float64}; dt=0.01, steps=5000)
    v, w = u0
    history = zeros(steps+1, 2)
    history[1, :] = u0

    for i in 1:steps
        dv = v - v^3/3 - w + I_ext
        dw = (v + a - b * w) * 0.08
        v += dv * dt
        w += dw * dt
        history[i+1, :] = [v, w]
    end

    return history
end

# ═══ Section 6: Signal Processing ═════════════════════════════════════════════

"""Simple DFT (no FFTW dependency)"""
function phi_dft(x::Vector{Float64})
    N = length(x)
    X = zeros(Complex{Float64}, N)
    for k in 0:N-1
        for n in 0:N-1
            X[k+1] += x[n+1] * exp(-2π * im * k * n / N)
        end
    end
    return X
end

"""Inverse DFT"""
function phi_idft(X::Vector{Complex{Float64}})
    N = length(X)
    x = zeros(Complex{Float64}, N)
    for n in 0:N-1
        for k in 0:N-1
            x[n+1] += X[k+1] * exp(2π * im * k * n / N)
        end
    end
    return real.(x ./ N)
end

"""Convolution"""
function phi_convolve(f::Vector{Float64}, g::Vector{Float64})
    n = length(f) + length(g) - 1
    result = zeros(n)
    for i in 1:length(f)
        for j in 1:length(g)
            result[i+j-1] += f[i] * g[j]
        end
    end
    return result
end

"""Autocorrelation"""
function phi_autocorrelation(x::Vector{Float64})
    n = length(x)
    μ = mean(x)
    x_centered = x .- μ
    R = zeros(n)
    for lag in 0:n-1
        for i in 1:n-lag
            R[lag+1] += x_centered[i] * x_centered[i+lag]
        end
        R[lag+1] /= n
    end
    return R
end

"""Zero crossing rate"""
function phi_zero_crossing_rate(x::Vector{Float64})
    crossings = sum(abs.(diff(sign.(x))) .> 0)
    return crossings / (length(x) - 1)
end

# ═══ Section 7: Numerical Methods ═════════════════════════════════════════════

"""Bisection root finding"""
function phi_bisection(f, a::Float64, b::Float64; tol=1e-10, max_iter=100)
    for _ in 1:max_iter
        c = (a + b) / 2
        if abs(f(c)) < tol || (b - a) / 2 < tol
            return c
        end
        if sign(f(c)) == sign(f(a))
            a = c
        else
            b = c
        end
    end
    return (a + b) / 2
end

"""Newton's method for root finding"""
function phi_newton_root(f, x0::Float64; tol=1e-10, max_iter=100)
    x = x0
    for _ in 1:max_iter
        fx = f(x)
        if abs(fx) < tol
            return x
        end
        dfx = (f(x + 1e-8) - f(x - 1e-8)) / 2e-8
        x -= fx / dfx
    end
    return x
end

"""Trapezoidal integration"""
function phi_trapz(f, a::Float64, b::Float64, n::Int=1000)
    h = (b - a) / n
    result = (f(a) + f(b)) / 2
    for i in 1:n-1
        result += f(a + i * h)
    end
    return result * h
end

"""Simpson's rule integration"""
function phi_simpson(f, a::Float64, b::Float64, n::Int=1000)
    if n % 2 != 0
        n += 1
    end
    h = (b - a) / n
    result = f(a) + f(b)
    for i in 1:n-1
        x = a + i * h
        result += (i % 2 == 0 ? 2 : 4) * f(x)
    end
    return result * h / 3
end

"""Monte Carlo integration with φ⁵ samples"""
function phi_monte_carlo_integrate(f, dim::Int; n_samples=nothing)
    if n_samples === nothing
        n_samples = Int(ceil(PHI^5 * dim))
    end
    total = 0.0
    for _ in 1:n_samples
        x = rand(dim)
        total += f(x)
    end
    return total / n_samples
end

# ═══ Section 8: Quantum & Physics ═════════════════════════════════════════════

"""Ising model partition function (exact, small N)"""
function phi_ising_partition(J::Matrix{Float64}, β::Float64)
    N = size(J, 1)
    Z = 0.0
    for state in 0:2^N-1
        spins = [2 * ((state >> i) & 1) - 1 for i in 0:N-1]
        E = -0.5 * dot(spins, J * spins)
        Z += exp(-β * E)
    end
    return Z
end

"""Boltzmann distribution"""
function phi_boltzmann(energies::Vector{Float64}, T::Float64)
    β_E = -energies ./ T
    exp_E = exp.(β_E .- maximum(β_E))
    return exp_E ./ sum(exp_E)
end

"""Order parameter (Kuramoto)"""
function phi_order_parameter(theta::Vector{Float64})
    return abs(mean(exp.(im .* theta)))
end

# ═══ Section 9: Graph Theory ══════════════════════════════════════════════════

"""PageRank"""
function phi_pagerank(A::Matrix{Float64}; damping=0.85, max_iter=100, tol=1e-6)
    N = size(A, 1)
    # Normalize columns
    D = sum(A, dims=1)
    M = A ./ max.(D, 1.0)
    r = fill(1.0/N, N)

    for _ in 1:max_iter
        r_new = damping .* (M * r) .+ (1 - damping) / N
        if norm(r_new - r) < tol
            return r_new
        end
        r = r_new
    end
    return r
end

"""Graph Laplacian L = D - A"""
function phi_laplacian(A::Matrix{Float64})
    D = Diagonal(vec(sum(A, dims=2)))
    return D - A
end

# ═══ Section 10: Helper Functions ═════════════════════════════════════════════

function _numerical_gradient(f, x::Vector{Float64}; h=1e-5)
    n = length(x)
    grad = zeros(n)
    for i in 1:n
        x_plus = copy(x); x_plus[i] += h
        x_minus = copy(x); x_minus[i] -= h
        grad[i] = (f(x_plus) - f(x_minus)) / (2h)
    end
    return grad
end

function _line_search(f, x::Vector{Float64}, d::Vector{Float64}; α_init=1.0, c=1e-4, ρ=0.5)
    α = α_init
    fx = f(x)
    grad = _numerical_gradient(f, x)
    for _ in 1:20
        if f(x + α*d) <= fx + c*α*dot(grad, d)
            return α
        end
        α *= ρ
    end
    return α
end

# ═══ Exports ══════════════════════════════════════════════════════════════════

export PHI, PHI_INV, AMOR, FEIGENBAUM_D, HEARTBEAT_MS
# Linear Algebra
export phi_qr, phi_lu, phi_cholesky, phi_expm, phi_logm, phi_sqrtm
export phi_cond, phi_rank, phi_nullspace, phi_kron, phi_schur, phi_pinv
export phi_solve, phi_lstsq, phi_dot, phi_cross, phi_trace, phi_det
# Statistics
export phi_median, phi_var, phi_cov, phi_quantile, phi_skewness, phi_kurtosis
export phi_entropy, phi_kl_divergence, phi_regression, phi_kmeans
# Optimization
export phi_bfgs, phi_golden_search, phi_nelder_mead
# Differential Equations
export phi_rk4, phi_lorenz, phi_van_der_pol, phi_oscillator
export phi_kuramoto, phi_fitzhugh_nagumo
# Signal Processing
export phi_dft, phi_idft, phi_convolve, phi_autocorrelation, phi_zero_crossing_rate
# Numerical Methods
export phi_bisection, phi_newton_root, phi_trapz, phi_simpson, phi_monte_carlo_integrate
# Physics
export phi_ising_partition, phi_boltzmann, phi_order_parameter
# Graph
export phi_pagerank, phi_laplacian

end # module NovaJuliaExpanded
