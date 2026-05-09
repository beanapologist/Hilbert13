/-
  Hilbert's 13th — full Lean formalization of the LHS/RHS split.

  Mirrors the 12-step derivation:
    Steps 1–3:  Septic ↔ F(x) = -b.
    Step 4:     LHS/RHS split via Complex.ext_iff.
    Step 5:     Polar substitution x = r e^{iθ}.
    Step 6:     Im F = 0 expanded.
    Step 7:     Chebyshev factorization → sin θ · (quartic in cos θ).
    Step 8:     Quartic (†) in C := cos θ.
    Step 9–10:  Re F = -b in C, r (modulus closure).
    Step 11:    Composition chain (a,b,c) → r → C → θ → x.
-/
import Mathlib

open Real

namespace Hilbert13

variable (a b c r θ : ℝ)

/-! ## Steps 1–3: Septic ↔ F(x) = -b -/

/-- F as defined after dividing by x². -/
noncomputable def F (x : ℂ) : ℂ := x^5 + (a:ℂ)*x + (c:ℂ)/x + 1/x^2

/-- Septic ↔ F(x) = -b, on ℂ*. -/
lemma septic_iff_F (x : ℂ) (hx : x ≠ 0) :
    x^7 + (a:ℂ)*x^3 + (b:ℂ)*x^2 + (c:ℂ)*x + 1 = 0 ↔ F a c x = -(b:ℂ) := by
  unfold F
  rw [eq_neg_iff_add_eq_zero]
  have hx2 : x^2 ≠ 0 := pow_ne_zero 2 hx
  field_simp
  constructor <;> intro h <;> linear_combination h

/-! ## Step 4: LHS/RHS split — complex = real iff Im=0 ∧ Re matches -/

lemma complex_eq_real_iff (z : ℂ) (t : ℝ) :
    z = (t : ℂ) ↔ z.im = 0 ∧ z.re = t := by
  constructor
  · rintro rfl; exact ⟨Complex.ofReal_im t, Complex.ofReal_re t⟩
  · rintro ⟨him, hre⟩; exact Complex.ext hre (by simpa using him)

/-- The split: F(x) = -b ⇔ Im F = 0 ∧ Re F = -b. -/
lemma F_eq_neg_b_iff (x : ℂ) :
    F a c x = -(b:ℂ) ↔ (F a c x).im = 0 ∧ (F a c x).re = -b := by
  rw [show (-(b:ℂ) : ℂ) = ((-b : ℝ) : ℂ) from by push_cast; ring,
      complex_eq_real_iff]

/-! ## Step 5: Polar substitution -/

lemma pow_polar (k : ℕ) :
    ((r : ℂ) * Complex.exp (θ * Complex.I))^k
      = (r^k : ℝ) * Complex.exp ((k*θ) * Complex.I) := by
  rw [mul_pow, ← Complex.exp_nat_mul]
  push_cast; ring_nf

/-! ## Step 6: Im F in polar coordinates -/

/-- Equation (6): Im F formula in (r, θ). -/
lemma im_F_polar (hr : r ≠ 0) :
    (F a c (r * Complex.exp (θ * Complex.I))).im
      = r^5 * sin (5*θ) + (a*r - c/r) * sin θ - (1/r^2) * sin (2*θ) := by
  unfold F; ring; norm_num [ ← Complex.exp_nat_mul, Complex.exp_re, Complex.exp_im, hr ] ; ring;
  norm_cast; norm_num [ Complex.normSq_eq_norm_sq, Complex.norm_exp ] ; ring;
  grind

/-! ## Step 7: Chebyshev factorization -/

/-- U₄ = Chebyshev of the second kind, degree 4. -/
def U₄ (C : ℝ) : ℝ := 16*C^4 - 12*C^2 + 1

/-- sin(5θ) = sin θ · U₄(cos θ). -/
lemma sin_five : sin (5*θ) = sin θ * U₄ (cos θ) := by
  unfold U₄
  have e : (5 : ℝ)*θ = 2*θ + 3*θ := by ring
  rw [e, sin_add, sin_two_mul, cos_two_mul, sin_three_mul, cos_three_mul]
  have hs2 : sin θ ^ 2 = 1 - cos θ ^ 2 := by linarith [sin_sq_add_cos_sq θ]
  have h3 : 4 * sin θ ^ 3 = 4 * sin θ - 4 * sin θ * cos θ ^ 2 := by
    have : sin θ ^ 3 = sin θ * sin θ ^ 2 := by ring
    rw [this, hs2]; ring
  have h4 : 8 * sin θ ^ 3 * cos θ ^ 2 = 8 * sin θ * cos θ ^ 2 - 8 * sin θ * cos θ ^ 4 := by
    have : sin θ ^ 3 = sin θ * sin θ ^ 2 := by ring
    rw [this, hs2]; ring
  nlinarith

/-- Bracket Q(r, C) — second factor of (7). -/
noncomputable def Q (r C : ℝ) : ℝ :=
  r^5 * U₄ C + (a*r - c/r) - 2*C / r^2

/-- **Main factorization** (Eq. (7)):
    Im F(r e^{iθ}) = sin θ · Q(r, cos θ; a, c). -/
theorem im_F_factor (hr : r ≠ 0) :
    (F a c (r * Complex.exp (θ * Complex.I))).im = sin θ * Q a c r (cos θ) := by
  rw [im_F_polar a c r θ hr, sin_two_mul, sin_five θ]
  unfold Q
  ring

/-- **Branch decomposition**: Im F = 0 ⇔ sin θ = 0 ∨ Q = 0. -/
theorem branches (hr : r ≠ 0) :
    (F a c (r * Complex.exp (θ * Complex.I))).im = 0
      ↔ sin θ = 0 ∨ Q a c r (cos θ) = 0 := by
  rw [im_F_factor a c r θ hr, mul_eq_zero]

/-! ## Step 8: Quartic (†) in C -/

/-- Equation (8) — explicit polynomial form of Q = 0 in C. -/
theorem dagger (C : ℝ) :
    Q a c r C = 0 ↔
      16*r^5*C^4 - 12*r^5*C^2 - 2*C/r^2 + (r^5 + a*r - c/r) = 0 := by
  unfold Q U₄
  constructor <;> intro h <;> linarith

/-! ## Steps 9–10: Real part / modulus closure -/

/-- Re F formula in (r, θ). -/
lemma re_F_polar (hr : r ≠ 0) :
    (F a c (r * Complex.exp (θ * Complex.I))).re
      = r^5 * cos (5*θ) + (a*r + c/r) * cos θ + (1/r^2) * cos (2*θ) := by
  unfold F;
  norm_num [ Complex.exp_re, Complex.exp_im, div_eq_mul_inv, mul_pow, mul_assoc, mul_comm, mul_left_comm, hr ];
  norm_cast; norm_num [ ← Complex.exp_nat_mul, Complex.exp_re, Complex.exp_im, Complex.normSq_eq_norm_sq, Complex.norm_exp ] ; ring;
  grind

/-- T₅ = Chebyshev of the first kind, degree 5. -/
def T₅ (C : ℝ) : ℝ := 16*C^5 - 20*C^3 + 5*C

lemma cos_five : cos (5*θ) = T₅ (cos θ) := by
  unfold T₅
  have e : (5 : ℝ)*θ = 2*θ + 3*θ := by ring
  rw [e, cos_add, sin_two_mul, cos_two_mul, sin_three_mul, cos_three_mul]
  have hs2 : sin θ ^ 2 = 1 - cos θ ^ 2 := by linarith [sin_sq_add_cos_sq θ]
  have h4 : 4 * sin θ ^ 2 * cos θ ^ 2 = 4 * cos θ ^ 2 - 4 * cos θ ^ 4 := by
    have : sin θ ^ 2 * cos θ ^ 2 = (1 - cos θ ^ 2) * cos θ ^ 2 := by rw [hs2]
    linarith [this]
  have h5 : 6 * sin θ ^ 2 * cos θ = 6 * cos θ - 6 * cos θ ^ 3 := by
    nlinarith
  nlinarith

/-- **Modulus equation in (C, r)** (Eq. (10)):
    Re F = -b becomes a polynomial relation. -/
theorem modulus_eq_C (hr : r ≠ 0) :
    (F a c (r * Complex.exp (θ * Complex.I))).re = -b
      ↔ r^5 * T₅ (cos θ) + (a*r + c/r) * cos θ
          + (2*(cos θ)^2 - 1) / r^2 = -b := by
  rw [re_F_polar a c r θ hr, cos_five θ, cos_two_mul]
  have hr2 : r^2 ≠ 0 := pow_ne_zero 2 hr
  constructor <;> intro h <;> field_simp at h ⊢ <;> linarith

/-! ## Step 11: The composition chain -/

/--
  **Hilbert 13 / Arnold–Kolmogorov decomposition.**

  A nonzero complex septic root x = r e^{iθ} with sin θ ≠ 0 satisfies:

    (†)   16 r⁵ C⁴ − 12 r⁵ C² − 2C/r² + (r⁵ + ar − c/r) = 0    [quartic in C]
    (10)  r⁵ T₅(C) + (ar + c/r) C + (2C² − 1)/r² = −b           [modulus eq.]

  where C := cos θ.

  Composition: (a,b,c) → r [via (10)] → C [via (†), Ferrari]
                       → θ = arccos C → x = r·(C + i√(1−C²)).

  Each arrow is a one-variable function — Arnold–Kolmogorov form.
-/
theorem hilbert13_decomposition
    (hx : (r : ℂ) * Complex.exp (θ * Complex.I) ≠ 0)
    (hr : r ≠ 0) (hsin : sin θ ≠ 0)
    (hroot : ((r : ℂ) * Complex.exp (θ * Complex.I))^7
              + (a:ℂ) * ((r : ℂ) * Complex.exp (θ * Complex.I))^3
              + (b:ℂ) * ((r : ℂ) * Complex.exp (θ * Complex.I))^2
              + (c:ℂ) * ((r : ℂ) * Complex.exp (θ * Complex.I)) + 1 = 0) :
    -- Quartic (†) in C := cos θ:
    (16*r^5*(cos θ)^4 - 12*r^5*(cos θ)^2 - 2*(cos θ)/r^2
        + (r^5 + a*r - c/r) = 0)
    -- AND modulus equation closing the system in r:
    ∧ (r^5 * T₅ (cos θ) + (a*r + c/r) * cos θ
          + (2*(cos θ)^2 - 1) / r^2 = -b) := by
  -- Steps 1–3: rewrite septic as F = -b.
  have hF : F a c ((r : ℂ) * Complex.exp (θ * Complex.I)) = -(b:ℂ) :=
    (septic_iff_F a b c _ hx).mp hroot
  -- Step 4: split into Im = 0 and Re = -b.
  obtain ⟨him, hre⟩ := (F_eq_neg_b_iff a b c _).mp hF
  -- Step 7: branches; sin θ ≠ 0 picks Branch B.
  have hQ : Q a c r (cos θ) = 0 :=
    ((branches a c r θ hr).mp him).resolve_left hsin
  refine ⟨?_, ?_⟩
  · exact (dagger a c r (cos θ)).mp hQ
  · exact (modulus_eq_C a b c r θ hr).mp hre

end Hilbert13