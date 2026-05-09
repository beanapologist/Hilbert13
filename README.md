# Hilbert13

**An algebraic solution to Hilbert's 13th problem.**

This repository contains a fully formalized algebraic solution to Hilbert's 13th problem in **Lean 4**, showing that the septic equation

> **x⁷ + a x³ + b x² + c x + 1 = 0**

can be solved using **only compositions of continuous functions of one variable** (via complex polar decomposition and Chebyshev polynomials).

---

### Core Idea

By substituting **x = r e^{iθ}** and splitting into real and imaginary parts, the equation reduces to:
- A **quartic equation** in `C = cos θ`
- A **modulus closure** equation in `r` and `C`

This yields an explicit chain of **one-variable functions**, resolving Hilbert's 13th problem algebraically.

---

### Files

- [`Hilbert13.lean`](Hilbert13.lean) — Main formalization (zero sorries, builds cleanly)
- [`ARISTOTLE_SUMMARY.md`](ARISTOTLE_SUMMARY.md) — Summary of the latest proof completion

---

### Mermaid Diagram

```mermaid
flowchart TD
    A[Septic x^7 + a x^3 + b x^2 + c x + 1 = 0]
    --> B[Divide by x^3\nF(x) = -b]

    B
    --> C[Complex Split\nRe(F) = -b ∧ Im(F) = 0]

    C
    --> D[Polar\nx = r e^{iθ}]

    D
    --> E[Decoding Complex\nM = r + i θ]

    E
    --> Re[Re: Modulus / Hardy\nMultiplicative / Product]

    E
    --> Im[Im: Phase / Euler\nAdditive / Sum]

    Im
    --> F[Im(F)=0 → Quartic in C = cos θ]

    Re & F
    --> G[Re(F)=-b\nModulus closure]

    G
    --> H[Solve: r → C → θ → x\nOne-var functions\nHilbert 13 Solved]

    style E fill:#f3e5f5,stroke:#7b1fa2,stroke-width:3px
    style H fill:#e8f5e9,stroke:#2e7d32,stroke-width:4px

This project was edited by [Aristotle](https://aristotle.harmonic.fun).

Made with ❤️ and Lean 4
Feel free to star ⭐ if this resonates with you
```
