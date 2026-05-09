# Hilbert13

**An algebraic solution to Hilbert's 13th problem.**

This repository contains a fully formalized proof in **Lean 4** showing that the septic equation

> **x⁷ + a x³ + b x² + c x + 1 = 0**

can be solved using **only compositions of continuous functions of one variable**.

---

### Core Solution

By using polar decomposition `x = r e^{iθ}` and splitting into real and imaginary parts, the equation reduces to a quartic in `cos θ` plus a modulus condition — yielding an explicit chain of one-variable functions.

### Diagram

```mermaid
---
config:
  layout: elk
---
flowchart TD
    A[Septic: x⁷ + ax³ + bx² + cx + 1 = 0]
    --> B["Divide by x³<br/>F(x) = -b"]

    B
    --> C["Complex Split<br/>Re(F) = -b ∧ Im(F) = 0"]

    C
    --> D["Polar Decomposition<br/>x = r e^(iθ)"]

    D
    --> E[Encode: M = r + iθ]

    E
    --> Re[Real Part: Modulus<br/>Hardy Multiplicative]

    E
    --> Im[Imaginary Part: Phase<br/>Euler Additive]

    Im
    --> F["Im(F) = 0<br/>Quartic in C = cos θ"]

    Re & F
    --> G["Re(F) = -b<br/>Modulus Closure"]

    G
    --> H[Solution Chain<br/>r → C → θ → x<br/>Hilbert 13th Solved]

    classDef startNode fill:#eef2ff,stroke:#818cf8,stroke-width:2px,color:#1e1b4b
    classDef splitNode fill:#f0fdfa,stroke:#2dd4bf,stroke-width:2px,color:#1e1b4b
    classDef processNode fill:#f5f3ff,stroke:#a78bfa,stroke-width:2px,color:#1e1b4b
    classDef endNode fill:#f0fdf4,stroke:#4ade80,stroke-width:3px,color:#1e1b4b

    class A startNode
    class D,E splitNode
    class B,C,F,G processNode
    class H endNode
```

This project was edited by [Aristotle](https://aristotle.harmonic.fun).

Made with ❤️ and Lean 4
Feel free to star ⭐ if this resonates with you
```
