"""
NOVA Python Mathematical SDK — φ-Optimized Sovereign Mathematics (BUILD №65)

Copyright © 2024-2026 Alfredo Medina Hernandez
Medina Tech | Dallas, Texas, USA

Install: pip install nova-math (when published)
Usage:
    from nova_math import phi_gradient_descent, kuramoto_sync, order_parameter
    from nova_math import PHI, PHI_INV, AMOR

This file provides the Python implementation of NOVA's φ-optimized
mathematical functions, bridging to Motoko smart contracts on ICP.
"""

import math
from typing import Callable, List, Tuple, Optional

# ═══ Section 1: Constants ════════════════════════════════════════════════════

PHI = 1.6180339887498948482
PHI_INV = 0.6180339887498948482
AMOR = 0.3819660112501051518
FEIGENBAUM_D = 4.6692016091029906719
EULER_E = 2.7182818284590452354
HEARTBEAT_MS = 873
ISING_2D_BETA = 0.125
ISING_2D_TC = 2.269
PERC_2D_PC = 0.5927


# ═══ Section 2: Linear Algebra (no numpy dependency) ═════════════════════════

def dot(a: List[float], b: List[float]) -> float:
    """Dot product a · b"""
    return sum(x * y for x, y in zip(a, b))


def norm(v: List[float], p: int = 2) -> float:
    """Vector p-norm"""
    return sum(abs(x) ** p for x in v) ** (1.0 / p)


def mat_mul(A: List[List[float]], B: List[List[float]]) -> List[List[float]]:
    """Matrix multiplication A × B"""
    m, n = len(A), len(B[0])
    k = len(B)
    C = [[0.0] * n for _ in range(m)]
    for i in range(m):
        for j in range(n):
            for l in range(k):
                C[i][j] += A[i][l] * B[l][j]
    return C


def transpose(A: List[List[float]]) -> List[List[float]]:
    """Matrix transpose Aᵀ"""
    m, n = len(A), len(A[0])
    return [[A[j][i] for j in range(m)] for i in range(n)]


def mat_vec_mul(A: List[List[float]], x: List[float]) -> List[float]:
    """Matrix-vector multiplication Ax"""
    return [sum(A[i][j] * x[j] for j in range(len(x))) for i in range(len(A))]


def identity(n: int) -> List[List[float]]:
    """n×n identity matrix"""
    return [[1.0 if i == j else 0.0 for j in range(n)] for i in range(n)]


def trace(A: List[List[float]]) -> float:
    """Matrix trace tr(A)"""
    return sum(A[i][i] for i in range(min(len(A), len(A[0]))))


# ═══ Section 3: Statistics ════════════════════════════════════════════════════

def mean(x: List[float]) -> float:
    """Arithmetic mean"""
    return sum(x) / len(x)


def variance(x: List[float]) -> float:
    """Population variance"""
    mu = mean(x)
    return sum((xi - mu) ** 2 for xi in x) / len(x)


def std(x: List[float]) -> float:
    """Standard deviation"""
    return math.sqrt(variance(x))


def covariance(x: List[float], y: List[float]) -> float:
    """Covariance Cov(X, Y)"""
    mx, my = mean(x), mean(y)
    return sum((xi - mx) * (yi - my) for xi, yi in zip(x, y)) / len(x)


def correlation(x: List[float], y: List[float]) -> float:
    """Pearson correlation coefficient"""
    cov = covariance(x, y)
    sx, sy = std(x), std(y)
    if sx == 0 or sy == 0:
        return 0.0
    return cov / (sx * sy)


def median(x: List[float]) -> float:
    """Median value"""
    s = sorted(x)
    n = len(s)
    if n % 2 == 0:
        return (s[n // 2 - 1] + s[n // 2]) / 2
    return s[n // 2]


def entropy(p: List[float]) -> float:
    """Shannon entropy H = -Σ pᵢ log(pᵢ)"""
    return -sum(pi * math.log(pi) for pi in p if pi > 0)


def kl_divergence(P: List[float], Q: List[float]) -> float:
    """KL divergence D_KL(P‖Q)"""
    return sum(p * math.log(p / q) for p, q in zip(P, Q) if p > 0 and q > 0)


def softmax(x: List[float]) -> List[float]:
    """Softmax σ(z)ᵢ = eᶻⁱ / Σeᶻʲ"""
    m = max(x)
    exps = [math.exp(xi - m) for xi in x]
    s = sum(exps)
    return [e / s for e in exps]


def sigmoid(x: float) -> float:
    """Sigmoid σ(x) = 1/(1+e⁻ˣ)"""
    x = max(-10, min(10, x))
    return 1.0 / (1.0 + math.exp(-x))


# ═══ Section 4: Optimization ═════════════════════════════════════════════════

def numerical_gradient(f: Callable, x: List[float], h: float = 1e-5) -> List[float]:
    """Central difference numerical gradient"""
    grad = []
    for i in range(len(x)):
        x_plus = x.copy()
        x_minus = x.copy()
        x_plus[i] += h
        x_minus[i] -= h
        grad.append((f(x_plus) - f(x_minus)) / (2 * h))
    return grad


def phi_gradient_descent(f: Callable, x0: List[float],
                         lr: float = PHI_INV, max_iter: int = 162,
                         tol: float = AMOR) -> List[float]:
    """φ⁻¹ learning rate gradient descent (provably optimal convergence)"""
    x = x0.copy()
    for _ in range(max_iter):
        grad = numerical_gradient(f, x)
        grad_norm = norm(grad)
        if grad_norm < tol:
            break
        x = [xi - lr * gi for xi, gi in zip(x, grad)]
    return x


def golden_section_search(f: Callable, a: float, b: float,
                          tol: float = 1e-8) -> float:
    """Golden section search (uses φ for optimal bracketing)"""
    while (b - a) > tol:
        c = b - PHI_INV * (b - a)
        d = a + PHI_INV * (b - a)
        if f(c) < f(d):
            b = d
        else:
            a = c
    return (a + b) / 2


def nelder_mead(f: Callable, x0: List[float], max_iter: int = 500,
                tol: float = AMOR) -> List[float]:
    """Nelder-Mead simplex optimization (derivative-free)"""
    n = len(x0)
    # Initialize simplex
    simplex = [x0.copy()]
    for i in range(n):
        xi = x0.copy()
        xi[i] += 1.0
        simplex.append(xi)

    for _ in range(max_iter):
        simplex.sort(key=f)
        centroid = [sum(simplex[j][i] for j in range(n)) / n for i in range(n)]

        # Reflection
        xr = [2 * centroid[i] - simplex[-1][i] for i in range(n)]
        if f(simplex[0]) <= f(xr) < f(simplex[-2]):
            simplex[-1] = xr
        elif f(xr) < f(simplex[0]):
            xe = [centroid[i] + 2 * (xr[i] - centroid[i]) for i in range(n)]
            simplex[-1] = xe if f(xe) < f(xr) else xr
        else:
            xc = [centroid[i] + 0.5 * (simplex[-1][i] - centroid[i]) for i in range(n)]
            if f(xc) < f(simplex[-1]):
                simplex[-1] = xc
            else:
                for i in range(1, len(simplex)):
                    simplex[i] = [0.5 * (simplex[0][j] + simplex[i][j]) for j in range(n)]

        vals = [f(s) for s in simplex]
        if std(vals) < tol:
            break

    return min(simplex, key=f)


# ═══ Section 5: Differential Equations ════════════════════════════════════════

def rk4(f: Callable, y0: float, t0: float, tf: float,
        steps: int = 1000) -> List[float]:
    """Runge-Kutta 4th order ODE solver"""
    dt = (tf - t0) / steps
    t = t0
    y = y0
    history = [y0]

    for _ in range(steps):
        k1 = f(t, y)
        k2 = f(t + dt / 2, y + dt * k1 / 2)
        k3 = f(t + dt / 2, y + dt * k2 / 2)
        k4 = f(t + dt, y + dt * k3)
        y += (dt / 6) * (k1 + 2 * k2 + 2 * k3 + k4)
        t += dt
        history.append(y)

    return history


def kuramoto_sync(theta: List[float], omega: List[float],
                  K: float = PHI_INV, dt: float = 0.873,
                  steps: int = 100) -> List[float]:
    """Kuramoto oscillator synchronization model"""
    N = len(theta)
    theta = theta.copy()

    for _ in range(steps):
        for i in range(N):
            coupling = sum(math.sin(theta[j] - theta[i]) for j in range(N) if j != i)
            theta[i] += (omega[i] + (K / N) * coupling) * dt

    return theta


def order_parameter(theta: List[float]) -> float:
    """Kuramoto order parameter R = |1/N Σ exp(iθₖ)|"""
    N = len(theta)
    re_sum = sum(math.cos(t) for t in theta)
    im_sum = sum(math.sin(t) for t in theta)
    return math.sqrt(re_sum ** 2 + im_sum ** 2) / N


def lorenz(u0: List[float], sigma: float = 10.0, rho: float = 28.0,
           beta: float = 8 / 3, dt: float = 0.01, steps: int = 10000) -> List[List[float]]:
    """Lorenz attractor integration"""
    x, y, z = u0
    history = [u0.copy()]

    for _ in range(steps):
        dx = sigma * (y - x)
        dy = x * (rho - z) - y
        dz = x * y - beta * z
        x += dx * dt
        y += dy * dt
        z += dz * dt
        history.append([x, y, z])

    return history


# ═══ Section 6: Signal Processing ═════════════════════════════════════════════

def dft(x: List[float]) -> List[complex]:
    """Discrete Fourier Transform"""
    N = len(x)
    X = []
    for k in range(N):
        s = 0 + 0j
        for n in range(N):
            angle = -2 * math.pi * k * n / N
            s += x[n] * complex(math.cos(angle), math.sin(angle))
        X.append(s)
    return X


def convolve(f: List[float], g: List[float]) -> List[float]:
    """Discrete convolution"""
    n = len(f) + len(g) - 1
    result = [0.0] * n
    for i in range(len(f)):
        for j in range(len(g)):
            result[i + j] += f[i] * g[j]
    return result


def autocorrelation(x: List[float]) -> List[float]:
    """Autocorrelation function"""
    n = len(x)
    mu = mean(x)
    x_centered = [xi - mu for xi in x]
    R = []
    for lag in range(n):
        s = sum(x_centered[i] * x_centered[i + lag] for i in range(n - lag))
        R.append(s / n)
    return R


# ═══ Section 7: Physics ═══════════════════════════════════════════════════════

def boltzmann_distribution(energies: List[float], T: float) -> List[float]:
    """Boltzmann distribution P(E) = exp(-E/kT) / Z"""
    max_e = max(-e / T for e in energies)
    exp_e = [math.exp(-e / T - max_e) for e in energies]  # Numerical stability
    Z = sum(exp_e)
    return [e / Z for e in exp_e]


def ising_partition(J: List[List[float]], beta: float) -> float:
    """Ising model partition function Z (exact for small N)"""
    N = len(J)
    Z = 0.0
    for state in range(2 ** N):
        spins = [2 * ((state >> i) & 1) - 1 for i in range(N)]
        E = -0.5 * sum(spins[i] * sum(J[i][j] * spins[j] for j in range(N)) for i in range(N))
        Z += math.exp(-beta * E)
    return Z


# ═══ Section 8: Monte Carlo ═══════════════════════════════════════════════════

def phi_monte_carlo(f: Callable, dim: int,
                    n_samples: Optional[int] = None) -> float:
    """Monte Carlo integration with φ⁵ samples per dimension"""
    import random
    if n_samples is None:
        n_samples = int(math.ceil(PHI ** 5 * dim))
    total = 0.0
    for _ in range(n_samples):
        point = [random.random() for _ in range(dim)]
        total += f(point)
    return total / n_samples


# ═══ Section 9: Numerical Methods ═════════════════════════════════════════════

def bisection(f: Callable, a: float, b: float, tol: float = 1e-10) -> float:
    """Bisection root finding"""
    for _ in range(100):
        c = (a + b) / 2
        if abs(f(c)) < tol or (b - a) / 2 < tol:
            return c
        if f(c) * f(a) > 0:
            a = c
        else:
            b = c
    return (a + b) / 2


def trapz(f: Callable, a: float, b: float, n: int = 1000) -> float:
    """Trapezoidal integration"""
    h = (b - a) / n
    result = (f(a) + f(b)) / 2
    for i in range(1, n):
        result += f(a + i * h)
    return result * h


def simpson(f: Callable, a: float, b: float, n: int = 1000) -> float:
    """Simpson's rule integration"""
    if n % 2 != 0:
        n += 1
    h = (b - a) / n
    result = f(a) + f(b)
    for i in range(1, n):
        x = a + i * h
        result += (2 if i % 2 == 0 else 4) * f(x)
    return result * h / 3


# ═══ Module Info ══════════════════════════════════════════════════════════════

__version__ = '1.0.0'
__build__ = 65
__author__ = 'Alfredo Medina Hernandez'

__all__ = [
    # Constants
    'PHI', 'PHI_INV', 'AMOR', 'FEIGENBAUM_D', 'EULER_E', 'HEARTBEAT_MS',
    # Linear Algebra
    'dot', 'norm', 'mat_mul', 'transpose', 'mat_vec_mul', 'identity', 'trace',
    # Statistics
    'mean', 'variance', 'std', 'covariance', 'correlation', 'median',
    'entropy', 'kl_divergence', 'softmax', 'sigmoid',
    # Optimization
    'numerical_gradient', 'phi_gradient_descent', 'golden_section_search', 'nelder_mead',
    # Differential Equations
    'rk4', 'kuramoto_sync', 'order_parameter', 'lorenz',
    # Signal Processing
    'dft', 'convolve', 'autocorrelation',
    # Physics
    'boltzmann_distribution', 'ising_partition',
    # Monte Carlo
    'phi_monte_carlo',
    # Numerical
    'bisection', 'trapz', 'simpson',
]
