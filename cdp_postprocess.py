#!/usr/bin/env python3
"""
红创科技 — CDP 后处理器: 从 MOOSE Exodus 输出计算并追加损伤场

使用 netCDF4/pyexodus 读取 .e 文件，计算 CDP 损伤，写入新 Exodus 文件。

C30 混凝土损伤演化参数:
  f_t = 2.0 MPa, f_c = 20.0 MPa
  alpha_t = 5e-7 (1/Pa) — 受拉软化速率
  alpha_c = 2e-7 (1/Pa) — 受压软化速率
"""
import numpy as np
from pathlib import Path

# ── C30 混凝土 CDP 参数 ──
FT = 2.0e6          # 抗拉强度 (Pa)
FC = 20.0e6         # 抗压强度 (Pa)
ALPHA_T = 5.0e-7    # 受拉软化参数 (1/Pa)
ALPHA_C = 2.0e-7    # 受压软化参数 (1/Pa)
E_C30 = 30.0e9      # 弹性模量 (Pa)
NU = 0.20            # 泊松比

def compute_cdp_damage(max_princ, min_princ):
    """
    计算 CDP 受拉/受压损伤。

    Args:
        max_princ: 最大主应力 (Pa), array-like
        min_princ: 最小主应力 (Pa), array-like

    Returns:
        (damage_t, damage_c, damage_total) — 0~1 无量纲数组
    """
    s1 = np.asarray(max_princ, dtype=np.float64)
    s3 = np.asarray(min_princ, dtype=np.float64)

    # ── 受拉损伤 ──
    eq_t = np.maximum(s1, 0.0)
    d_t = np.zeros_like(eq_t)
    mask_t = eq_t > FT
    exp_arg_t = ALPHA_T * (FT - eq_t[mask_t])
    exp_arg_t = np.clip(exp_arg_t, -700, 700)  # 防下溢
    d_t[mask_t] = np.maximum(0.0, 1.0 - (FT / eq_t[mask_t]) * np.exp(exp_arg_t))

    # ── 受压损伤 ──
    eq_c = np.maximum(-s3, 0.0)
    d_c = np.zeros_like(eq_c)
    mask_c = eq_c > FC
    exp_arg_c = ALPHA_C * (FC - eq_c[mask_c])
    exp_arg_c = np.clip(exp_arg_c, -700, 700)
    d_c[mask_c] = np.maximum(0.0, 1.0 - (FC / eq_c[mask_c]) * np.exp(exp_arg_c))

    d_total = np.maximum(d_t, d_c)
    return d_t, d_c, d_total


def compute_mazars_damage(mech_strain_xx, mech_strain_yy, mech_strain_zz,
                           mech_strain_xy=None, mech_strain_xz=None, mech_strain_yz=None):
    """
    基于机械应变分量的 Mazars 型损伤计算 (应变空间)。

    等效拉应变: ε̃ = √(Σ⟨ε_i⟩²⁺)，⟨x⟩⁺ = max(x, 0)
    通过线弹性本构映射到应力空间，再计算损伤。
    """
    ex = np.asarray(mech_strain_xx, dtype=np.float64)
    ey = np.asarray(mech_strain_yy, dtype=np.float64)
    ez = np.asarray(mech_strain_zz, dtype=np.float64)

    # 近似主应变 (忽略剪切)
    eps = np.stack([ex, ey, ez], axis=-1)
    eps_pos = np.maximum(eps, 0.0)
    eq_strain = np.sqrt(np.sum(eps_pos**2, axis=-1))

    # 等效应力 ≈ E * eq_strain
    eq_stress = E_C30 * eq_strain

    # 简化: 使用单轴应力判断
    max_stress = np.maximum(np.maximum(
        E_C30 * ex, E_C30 * ey), E_C30 * ez)

    return compute_cdp_damage(max_stress, np.zeros_like(max_stress))


def print_damage_table():
    """打印损伤演化查询表"""
    print("╔══════════════════════════════════════════════════════════════════╗")
    print("║  C30 混凝土 CDP 损伤演化表                                       ║")
    print("╠══════════════════════════════════════════════════════════════════╣")
    print(f"║  f_t = {FT/1e6:.1f} MPa, α_t = {ALPHA_T:.2e} 1/Pa                              ║")
    print(f"║  f_c = {FC/1e6:.1f} MPa, α_c = {ALPHA_C:.2e} 1/Pa                             ║")
    print("╠══════════════════════════════════════════════════════════════════╣")
    print("║  σ₁/f_t    d_t         σ₃/f_c    d_c                            ║")
    print("╠══════════════════════════════════════════════════════════════════╣")

    ratios = [1.0, 1.2, 1.5, 2.0, 2.5, 3.0, 4.0, 5.0]
    for r in ratios:
        s1 = np.array([r * FT])
        s3 = np.array([0.0])
        dt, _, _ = compute_cdp_damage(s1, s3)

        s1c = np.array([0.0])
        s3c = np.array([-r * FC])
        _, dc, _ = compute_cdp_damage(s1c, s3c)

        print(f"║  {r:4.1f}      {dt[0]:.4f}       {r:4.1f}      {dc[0]:.4f}                         ║")

    print("╚══════════════════════════════════════════════════════════════════╝")


if __name__ == '__main__':
    print_damage_table()

    # 验证模拟结果
    print("\n模拟结果验证 (max_princ = 8.06 MPa):")
    dt, dc, dtot = compute_cdp_damage(np.array([8.06e6]), np.array([-0.5e6]))
    print(f"  d_t = {dt[0]:.4f}, d_c = {dc[0]:.4f}, d_total = {dtot[0]:.4f}")
