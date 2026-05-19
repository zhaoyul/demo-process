#!/usr/bin/env python3
"""
红创科技多物理场仿真平台
AAC 墙体拟静力试验 — 可视化渲染
输出: 滞回曲线PNG / 对比图表PNG / 墙体变形动画MP4
"""

import csv
import os
import json
import math
import subprocess
import xml.etree.ElementTree as ET
from pathlib import Path
from collections import defaultdict

ROOT = Path(__file__).parent
OUTPUTS_DIR = ROOT / "outputs"
RENDERS_DIR = ROOT / "renders"
RENDERS_DIR.mkdir(exist_ok=True)

# ─── 试件映射 ───
SPECIMENS_PS = {
    "W-03": "w03_pseudo_static.csv",
    "W-04": "w04_thin_pseudo_static.csv",
    "W-05": "w05_no_lattice_pseudo_static.csv",
    "W-06": "w06_large_plate_pseudo_static.csv",
    "W-07": "w07_thin_column_pseudo_static.csv",
    "W-08": "w08_window_opening_pseudo_static.csv",
    "W-09": "w09_hinged_pseudo_static.csv",
}

SPECIMENS_COLORS = {
    "W-03": "#1f77b4", "W-04": "#ff7f0e", "W-05": "#d62728",
    "W-06": "#2ca02c", "W-07": "#9467bd", "W-08": "#8c564b",
    "W-09": "#7f7f7f",
}

SPECIMENS_LABELS = {
    "W-03": "W-03 标准格构",
    "W-04": "W-04 薄墙(200mm)",
    "W-05": "W-05 无格构",
    "W-06": "W-06 大板(5000mm)",
    "W-07": "W-07 薄墙+构造柱",
    "W-08": "W-08 窗洞+构造柱",
    "W-09": "W-09 铰接",
}


# ═══════════════════════════════════════════════════════════
# SVG 图表生成 (零外部依赖)
# ═══════════════════════════════════════════════════════════

def svg_elem(tag, attrib=None, text=None, **extra):
    """创建 SVG XML 元素"""
    el = ET.Element(tag, attrib or {})
    for k, v in extra.items():
        el.set(k.replace("_", "-"), str(v))
    if text is not None:
        el.text = str(text)
    return el


def make_svg_chart(width=960, height=640, title="Chart"):
    """创建带坐标系的 SVG 画布"""
    margin = {"l": 90, "r": 40, "t": 60, "b": 60}
    svg = ET.Element("svg", {
        "xmlns": "http://www.w3.org/2000/svg",
        "width": str(width), "height": str(height),
        "viewBox": f"0 0 {width} {height}",
    })
    # Background
    svg.append(svg_elem("rect", x="0", y="0", width=str(width), height=str(height), fill="#FAFAFA"))

    plot = {
        "x0": margin["l"], "y0": margin["t"],
        "w": width - margin["l"] - margin["r"],
        "h": height - margin["t"] - margin["b"],
    }

    # Title
    svg.append(svg_elem("text", x=str(width // 2), y="32", text_anchor="middle",
                        font_size="16", font_weight="bold", fill="#222", font_family="sans-serif",
                        text=title))

    # Plot area background
    svg.append(svg_elem("rect", x=str(plot["x0"]), y=str(plot["y0"]),
                        width=str(plot["w"]), height=str(plot["h"]),
                        fill="white", stroke="#CCC", stroke_width="1"))

    return svg, plot


def add_axes(svg, plot, xlabel, ylabel, x_range, y_range):
    """添加坐标轴和标签"""
    x0, y0, w, h = plot["x0"], plot["y0"], plot["w"], plot["h"]

    def tx(x):
        return x0 + (x - x_range[0]) / (x_range[1] - x_range[0]) * w

    def ty(y):
        return y0 + h - (y - y_range[0]) / (y_range[1] - y_range[0]) * h

    # Grid lines
    for i in range(6):
        frac = i / 5.0
        xv = x_range[0] + frac * (x_range[1] - x_range[0])
        yv = y_range[0] + frac * (y_range[1] - y_range[0])
        svg.append(svg_elem("line", x1=str(tx(xv)), y1=str(y0), x2=str(tx(xv)),
                            y2=str(y0 + h), stroke="#E8E8E8", stroke_width="0.5"))
        svg.append(svg_elem("line", x1=str(x0), y1=str(ty(yv)), x2=str(x0 + w),
                            y2=str(ty(yv)), stroke="#E8E8E8", stroke_width="0.5"))
        # Tick labels
        svg.append(svg_elem("text", x=str(tx(xv)), y=str(y0 + h + 16), text_anchor="middle",
                            font_size="10", fill="#666", font_family="sans-serif",
                            text=f"{xv:.2f}"))
        svg.append(svg_elem("text", x=str(x0 - 8), y=str(ty(yv) + 4), text_anchor="end",
                            font_size="10", fill="#666", font_family="sans-serif",
                            text=f"{yv:.2f}"))

    # Axis lines
    svg.append(svg_elem("line", x1=str(x0), y1=str(y0 + h), x2=str(x0 + w),
                        y2=str(y0 + h), stroke="#444", stroke_width="1"))
    svg.append(svg_elem("line", x1=str(x0), y1=str(y0), x2=str(x0),
                        y2=str(y0 + h), stroke="#444", stroke_width="1"))

    # Zero lines
    if x_range[0] < 0 < x_range[1]:
        xz = tx(0)
        svg.append(svg_elem("line", x1=str(xz), y1=str(y0), x2=str(xz),
                            y2=str(y0 + h), stroke="#AAA", stroke_width="1", stroke_dasharray="4,4"))
    if y_range[0] < 0 < y_range[1]:
        yz = ty(0)
        svg.append(svg_elem("line", x1=str(x0), y1=str(yz), x2=str(x0 + w),
                            y2=str(yz), stroke="#AAA", stroke_width="1", stroke_dasharray="4,4"))

    # Labels
    svg.append(svg_elem("text", x=str(x0 + w // 2), y=str(y0 + h + 40), text_anchor="middle",
                        font_size="13", fill="#333", font_family="sans-serif", text=xlabel))
    svg.append(svg_elem("text", x="18", y=str(y0 + h // 2), text_anchor="middle",
                        font_size="13", fill="#333", font_family="sans-serif",
                        transform=f"rotate(-90,18,{y0 + h // 2})", text=ylabel))

    return tx, ty


def add_legend(svg, x, y, items):
    """添加图例"""
    g = ET.SubElement(svg, "g", {"transform": f"translate({x},{y})"})
    bg = svg_elem("rect", x="0", y="0", width="200", height=str(18 * len(items) + 12),
                   fill="white", stroke="#CCC", stroke_width="0.5", rx="4")
    g.append(bg)
    for i, (color, label) in enumerate(items):
        yy = 10 + i * 18
        g.append(svg_elem("line", x1="8", y1=str(yy + 4), x2="28", y2=str(yy + 4),
                          stroke=color, stroke_width="2.5"))
        g.append(svg_elem("text", x="34", y=str(yy + 8), font_size="11",
                          fill="#333", font_family="sans-serif", text=label))


# ═══════════════════════════════════════════════════════════
# 数据读取与分析
# ═══════════════════════════════════════════════════════════

def read_csv(csv_path):
    if not os.path.exists(csv_path):
        return None
    with open(csv_path) as f:
        return list(csv.DictReader(f))


def load_specimen_data(spec_id):
    """加载单个试件的位移-力数据"""
    csv_name = SPECIMENS_PS.get(spec_id)
    if not csv_name:
        return None
    csv_path = OUTPUTS_DIR / csv_name
    rows = read_csv(csv_path)
    if not rows:
        return None
    data = []
    for row in rows:
        try:
            d = float(row.get("top_disp_x", 0))
            f = float(row.get("base_shear_x", 0))
            data.append((d, f))
        except (ValueError, KeyError):
            continue
    return data if len(data) >= 2 else None


# ═══════════════════════════════════════════════════════════
# 1. 滞回曲线 (每试件一张)
# ═══════════════════════════════════════════════════════════

def render_hysteresis(spec_id):
    """生成单个试件的滞回曲线 PNG"""
    data = load_specimen_data(spec_id)
    if not data:
        print(f"  [跳过] {spec_id}: 无数据")
        return None

    fs = [abs(f) for _, f in data]
    ds = [abs(d) for d, _ in data]
    f_max = max(fs) * 1.1
    d_max = max(ds) * 1.1

    svg, plot = make_svg_chart(960, 640, f"{spec_id} — {SPECIMENS_LABELS.get(spec_id, spec_id)} 滞回曲线")
    tx, ty = add_axes(svg, plot,
                      "顶部位移 top_disp_x (m)", "基底剪力 base_shear_x (N)",
                      (-d_max, d_max), (-f_max, f_max))

    color = SPECIMENS_COLORS.get(spec_id, "#1f77b4")

    # Draw hysteresis loops as connected path
    path_parts = []
    for i, (d, f) in enumerate(data):
        x, y = tx(d), ty(f)
        if i == 0:
            path_parts.append(f"M{x:.2f},{y:.2f}")
        else:
            path_parts.append(f"L{x:.2f},{y:.2f}")

    svg.append(svg_elem("path", d=" ".join(path_parts),
                        fill="none", stroke=color, stroke_width="1.5"))

    # Mark start and end points
    x0, y0 = tx(data[0][0]), ty(data[0][1])
    svg.append(svg_elem("circle", cx=str(x0), cy=str(y0), r="4", fill=color, stroke="white", stroke_width="1"))

    # Peak annotations
    peak = max(data, key=lambda x: abs(x[1]))
    xp, yp = tx(peak[0]), ty(peak[1])
    svg.append(svg_elem("circle", cx=str(xp), cy=str(yp), r="5", fill="none", stroke=color, stroke_width="2"))
    svg.append(svg_elem("text", x=str(xp + 10), y=str(yp - 8), font_size="11",
                        fill="#333", font_family="sans-serif",
                        text=f"峰值: F={abs(peak[1]) / 1e3:.1f}kN"))

    # 计算关键指标
    peak_force_kN = max(abs(f) for _, f in data) / 1e3
    peak_disp_mm = max(abs(d) for d, _ in data) * 1e3

    g = ET.SubElement(svg, "g", {"transform": f"translate({plot['x0'] + plot['w'] - 210},{plot['y0'] + 10})"})
    g.append(svg_elem("rect", x="0", y="0", width="200", height="76",
                      fill="white", stroke="#CCC", stroke_width="0.5", rx="4"))
    stats = [
        f"峰值力: {peak_force_kN:.1f} kN",
        f"峰值位移: {peak_disp_mm:.2f} mm",
        f"数据点数: {len(data)}",
    ]
    for i, s in enumerate(stats):
        g.append(svg_elem("text", x="10", y=str(18 + i * 18), font_size="11",
                          fill="#555", font_family="monospace", text=s))

    return svg_to_png(svg, f"aac_hysteresis_{spec_id.replace('-', '').lower()}")


# ═══════════════════════════════════════════════════════════
# 2. 对比图表
# ═══════════════════════════════════════════════════════════

def render_skeleton_comparison(all_specimens):
    """骨架曲线对比图 (正方向包络)"""
    svg, plot = make_svg_chart(960, 640, "骨架曲线对比 (Skeleton Curves)")
    tx, ty = add_axes(svg, plot,
                      "顶部位移 (m)", "基底剪力 (N)",
                      (0, 0.016), (0, 1100000))

    # 提取骨架点
    all_pts = {}
    for spec_id in all_specimens:
        data = load_specimen_data(spec_id)
        if not data:
            continue
        # 骨架: 位移单调递增时的峰值点
        skeleton = []
        max_d_so_far = -1
        for d, f in sorted(data, key=lambda x: x[0]):
            if d >= 0 and d > max_d_so_far:
                skeleton.append((d, abs(f)))
                max_d_so_far = d
        if skeleton:
            all_pts[spec_id] = skeleton

    for spec_id, pts in all_pts.items():
        color = SPECIMENS_COLORS.get(spec_id, "#333")
        # Lines
        path_parts = []
        for i, (d, f) in enumerate(pts):
            x, y = tx(d), ty(f)
            path_parts.append(f"M{x:.2f},{y:.2f}" if i == 0 else f"L{x:.2f},{y:.2f}")
        svg.append(svg_elem("path", d=" ".join(path_parts),
                            fill="none", stroke=color, stroke_width="2"))
        # Markers
        for d, f in pts:
            svg.append(svg_elem("circle", cx=str(tx(d)), cy=str(ty(f)),
                                r="3", fill=color))

    items = [(SPECIMENS_COLORS.get(s, "#333"), SPECIMENS_LABELS.get(s, s))
             for s in all_pts.keys()]
    add_legend(svg, plot["x0"] + plot["w"] - 210, plot["y0"] + 10, items)

    return svg_to_png(svg, "aac_comparison_skeleton")


def render_stiffness_comparison(all_specimens):
    """刚度退化对比图"""
    svg, plot = make_svg_chart(960, 640, "刚度退化对比 (Stiffness Degradation)")

    all_curves = {}
    max_cycle = 0
    max_K = 0
    for spec_id in all_specimens:
        data = load_specimen_data(spec_id)
        if not data:
            continue
        # Compute secant stiffness per half-cycle
        cycles = []
        curr = []
        prev_sign = None
        for d, f in data:
            sign = 1 if d > 0 else (-1 if d < 0 else 0)
            if prev_sign and sign and prev_sign != sign:
                if curr:
                    cycles.append(curr)
                curr = [(d, f)]
            else:
                curr.append((d, f))
            if sign != 0:
                prev_sign = sign
        if curr:
            cycles.append(curr)

        stiffness = []
        for i, cyc in enumerate(cycles):
            if not cyc:
                continue
            max_pt = max(cyc, key=lambda x: abs(x[0]))
            if abs(max_pt[0]) > 1e-10:
                K = abs(max_pt[1] / max_pt[0])
                stiffness.append((i + 1, K))
                if i + 1 > max_cycle:
                    max_cycle = i + 1
                if K > max_K:
                    max_K = K

        if stiffness:
            all_curves[spec_id] = stiffness

    max_K *= 1.15
    max_cycle = max(max_cycle, 1)

    tx, ty = add_axes(svg, plot,
                      "半循环编号 (Half-cycle #)", "割线刚度 K (N/m)",
                      (0, max_cycle + 1), (0, max_K))

    for spec_id, curve in all_curves.items():
        color = SPECIMENS_COLORS.get(spec_id, "#333")
        path_parts = []
        for i, (cyc, K) in enumerate(curve):
            x, y = tx(cyc), ty(K)
            path_parts.append(f"M{x:.2f},{y:.2f}" if i == 0 else f"L{x:.2f},{y:.2f}")
        svg.append(svg_elem("path", d=" ".join(path_parts),
                            fill="none", stroke=color, stroke_width="2"))
        for cyc, K in curve:
            svg.append(svg_elem("circle", cx=str(tx(cyc)), cy=str(ty(K)),
                                r="3", fill=color))

    items = [(SPECIMENS_COLORS.get(s, "#333"), SPECIMENS_LABELS.get(s, s))
             for s in all_curves.keys()]
    add_legend(svg, plot["x0"] + plot["w"] - 210, plot["y0"] + 10, items)

    return svg_to_png(svg, "aac_comparison_stiffness")


def render_energy_comparison(all_specimens):
    """累积耗能对比图"""
    svg, plot = make_svg_chart(960, 640, "累积耗能对比 (Cumulative Energy Dissipation)")

    all_curves = {}
    max_cycle = 0
    max_E = 0
    for spec_id in all_specimens:
        data = load_specimen_data(spec_id)
        if not data:
            continue
        # Compute energy per half-cycle
        cycles = []
        curr = []
        prev_sign = None
        for d, f in data:
            sign = 1 if d > 0 else (-1 if d < 0 else 0)
            if prev_sign and sign and prev_sign != 0 and prev_sign != 0 and sign != prev_sign:
                if curr:
                    cycles.append(curr)
                curr = [(d, f)]
            else:
                curr.append((d, f))
            if sign != 0:
                prev_sign = sign
        if curr:
            cycles.append(curr)

        energy = []
        cum = 0
        for i, cyc in enumerate(cycles):
            if len(cyc) < 2:
                continue
            E = 0
            for j in range(len(cyc) - 1):
                dx = cyc[j + 1][0] - cyc[j][0]
                favg = (cyc[j + 1][1] + cyc[j][1]) / 2
                E += dx * favg
            cum += abs(E)
            energy.append((i + 1, cum / 1e3))  # kJ
            if i + 1 > max_cycle:
                max_cycle = i + 1
            if cum / 1e3 > max_E:
                max_E = cum / 1e3

        if energy:
            all_curves[spec_id] = energy

    max_E *= 1.15
    max_cycle = max(max_cycle, 1)

    tx, ty = add_axes(svg, plot,
                      "半循环编号", "累积耗能 (kJ)",
                      (0, max_cycle + 1), (0, max_E))

    for spec_id, curve in all_curves.items():
        color = SPECIMENS_COLORS.get(spec_id, "#333")
        path_parts = []
        for i, (cyc, E) in enumerate(curve):
            x, y = tx(cyc), ty(E)
            path_parts.append(f"M{x:.2f},{y:.2f}" if i == 0 else f"L{x:.2f},{y:.2f}")
        svg.append(svg_elem("path", d=" ".join(path_parts),
                            fill="none", stroke=color, stroke_width="2"))
        for cyc, E in curve:
            svg.append(svg_elem("circle", cx=str(tx(cyc)), cy=str(ty(E)),
                                r="3", fill=color))

    items = [(SPECIMENS_COLORS.get(s, "#333"), SPECIMENS_LABELS.get(s, s))
             for s in all_curves.keys()]
    add_legend(svg, plot["x0"] + plot["w"] - 210, plot["y0"] + 10, items)

    return svg_to_png(svg, "aac_comparison_energy")


def render_bar_comparison(all_specimens):
    """柱状图对比: 峰值力 + 累积耗能"""
    svg, plot = make_svg_chart(960, 640, "试件性能对比 (Peak Force & Cumulative Energy)")

    peak_data = {}
    energy_data = {}
    for spec_id in all_specimens:
        data = load_specimen_data(spec_id)
        if not data:
            continue
        peak = max(abs(f) for _, f in data) / 1e3  # kN
        peak_data[spec_id] = peak

        # Energy
        cycles = []
        curr = []
        prev_sign = None
        for d, f in data:
            sign = 1 if d > 0 else (-1 if d < 0 else 0)
            if prev_sign and sign and prev_sign != 0 and prev_sign != 0 and sign != prev_sign:
                if curr:
                    cycles.append(curr)
                curr = [(d, f)]
            else:
                curr.append((d, f))
            if sign != 0:
                prev_sign = sign
        if curr:
            cycles.append(curr)
        cum = 0
        for cyc in cycles:
            if len(cyc) < 2:
                continue
            E = 0
            for j in range(len(cyc) - 1):
                dx = cyc[j + 1][0] - cyc[j][0]
                favg = (cyc[j + 1][1] + cyc[j][1]) / 2
                E += dx * favg
            cum += abs(E)
        energy_data[spec_id] = cum / 1e3  # kJ

    ids = list(peak_data.keys())
    colors_list = [SPECIMENS_COLORS.get(s, "#333") for s in ids]
    labels_list = [SPECIMENS_LABELS.get(s, s) for s in ids]

    pe_max = max(peak_data.values()) * 1.2
    en_max = max(energy_data.values()) * 1.2

    # Two sub-charts side by side
    half_w = plot["w"] / 2 - 20
    nx = len(ids)

    # --- Peak force bars ---
    x0, y0, h = plot["x0"], plot["y0"], plot["h"]
    bar_w = min(half_w / nx - 8, 60)
    for i, sid in enumerate(ids):
        bx = x0 + 10 + i * (half_w / nx) + (half_w / nx - bar_w) / 2
        bh = (peak_data[sid] / pe_max) * h
        by = y0 + h - bh
        svg.append(svg_elem("rect", x=str(bx), y=str(by), width=str(bar_w), height=str(bh),
                            fill=colors_list[i], rx="2"))
        svg.append(svg_elem("text", x=str(bx + bar_w / 2), y=str(by - 6), text_anchor="middle",
                            font_size="9", fill="#333", font_family="sans-serif",
                            text=f"{peak_data[sid]:.0f}"))

    svg.append(svg_elem("text", x=str(x0 + half_w / 2), y=str(y0 + h + 35), text_anchor="middle",
                        font_size="13", fill="#333", font_family="sans-serif",
                        text="峰值承载力 (kN)"))

    # --- Energy bars ---
    x0_e = x0 + half_w + 40
    for i, sid in enumerate(ids):
        bx = x0_e + 10 + i * (half_w / nx) + (half_w / nx - bar_w) / 2
        bh = (energy_data[sid] / en_max) * h
        by = y0 + h - bh
        svg.append(svg_elem("rect", x=str(bx), y=str(by), width=str(bar_w), height=str(bh),
                            fill=colors_list[i], rx="2"))
        svg.append(svg_elem("text", x=str(bx + bar_w / 2), y=str(by - 6), text_anchor="middle",
                            font_size="9", fill="#333", font_family="sans-serif",
                            text=f"{energy_data[sid]:.1f}"))

    svg.append(svg_elem("text", x=str(x0_e + half_w / 2), y=str(y0 + h + 35), text_anchor="middle",
                        font_size="13", fill="#333", font_family="sans-serif",
                        text="累积耗能 (kJ)"))

    # Legend
    items = list(zip(colors_list, labels_list))
    add_legend(svg, x0 + 10, y0 + 10, items)

    return svg_to_png(svg, "aac_comparison_bars")


# ═══════════════════════════════════════════════════════════
# 3. 墙体变形动画 (基于CSV数据生成帧 → ffmpeg编码)
# ═══════════════════════════════════════════════════════════

def render_wall_animation(spec_id):
    """生成墙体变形动画 MP4"""
    data = load_specimen_data(spec_id)
    if not data:
        print(f"  [跳过] {spec_id} 动画: 无数据")
        return None

    label = SPECIMENS_LABELS.get(spec_id, spec_id)
    color = SPECIMENS_COLORS.get(spec_id, "#1f77b4")

    frame_dir = RENDERS_DIR / f"frames_{spec_id.replace('-', '').lower()}"
    frame_dir.mkdir(exist_ok=True)
    # Clean old frames
    for f in frame_dir.glob("*.png"):
        f.unlink()

    fs = [abs(f) for _, f in data]
    ds = [abs(d) for d, _ in data]
    f_max = max(fs)
    d_max = max(ds)
    f_range = f_max * 1.1
    d_range = d_max * 1.15

    n_frames = min(len(data), 240)
    step = max(1, len(data) // n_frames)
    frame_idx = 0

    for i in range(0, len(data), step):
        if frame_idx >= n_frames:
            break

        svg, plot = make_svg_chart(960, 640,
                                   f"{label} — 位移历程 (步 {i + 1}/{len(data)})")

        tx, ty = add_axes(svg, plot,
                          "顶部位移 (m)", "基底剪力 (N)",
                          (-d_range, d_range), (-f_range, f_range))

        # Draw the accumulated hysteresis path up to current point
        path_parts = []
        for j in range(i + 1):
            d, f = data[j]
            x, y = tx(d), ty(f)
            path_parts.append(f"M{x:.2f},{y:.2f}" if j == 0 else f"L{x:.2f},{y:.2f}")
        svg.append(svg_elem("path", d=" ".join(path_parts),
                            fill="none", stroke=color, stroke_width="1.5", opacity="0.6"))

        # Emphasize current point
        cd, cf = data[i]
        cx, cy = tx(cd), ty(cf)
        svg.append(svg_elem("circle", cx=str(cx), cy=str(cy), r="6",
                            fill=color, stroke="white", stroke_width="2"))

        # Wall deformation visualization (schematic side view)
        wall_x = plot["x0"] + plot["w"] + 50
        wall_y0 = plot["y0"] + plot["h"] * 0.75
        wall_h = plot["h"] * 0.6
        wall_w = 40
        wall_top_disp = (cd / d_range) * wall_h * 0.8 if d_range > 0 else 0

        # Original wall outline
        svg.append(svg_elem("rect", x=str(wall_x - wall_w // 2), y=str(wall_y0 - wall_h),
                            width=str(wall_w), height=str(wall_h),
                            fill="none", stroke="#CCC", stroke_width="1", stroke_dasharray="4,4"))

        # Deformed wall (parallelogram approximation)
        top_x = wall_x + wall_top_disp
        pts = f"{wall_x - wall_w // 2},{wall_y0} {top_x - wall_w // 2},{wall_y0 - wall_h} "
        pts += f"{top_x + wall_w // 2},{wall_y0 - wall_h} {wall_x + wall_w // 2},{wall_y0}"
        svg.append(svg_elem("polygon", points=pts, fill=color, opacity="0.3",
                            stroke=color, stroke_width="2"))

        # Base fixing indicator
        svg.append(svg_elem("line", x1=str(wall_x - wall_w), y1=str(wall_y0),
                            x2=str(wall_x + wall_w), y2=str(wall_y0),
                            stroke="#444", stroke_width="3"))
        # Hatching for base
        for kx in range(wall_x - wall_w, wall_x + wall_w, 8):
            svg.append(svg_elem("line", x1=str(kx), y1=str(wall_y0),
                                x2=str(kx + 6), y2=str(wall_y0 + 10),
                                stroke="#666", stroke_width="0.5"))

        # Current state info
        g = ET.SubElement(svg, "g", {"transform": f"translate({wall_x - 60},{wall_y0 - wall_h - 30})"})
        info_lines = [
            f"D = {cd * 1e3:.2f} mm",
            f"F = {cf / 1e3:.1f} kN",
            f"t = {i + 1}/{len(data)}",
        ]
        for ti, line in enumerate(info_lines):
            g.append(svg_elem("text", x="0", y=str(ti * 16), font_size="10",
                              fill="#333", font_family="monospace", text=line))

        # Save frame
        frame_path = frame_dir / f"f{frame_idx:04d}.png"
        svg_to_png_file(svg, frame_path)
        frame_idx += 1

    # Encode to MP4
    name = f"aac_wall_{spec_id.replace('-', '').lower()}"
    mp4_path = RENDERS_DIR / f"{name}.mp4"
    subprocess.run([
        "ffmpeg", "-y", "-framerate", "10",
        "-i", str(frame_dir / "f%04d.png"),
        "-c:v", "libx264", "-pix_fmt", "yuv420p",
        "-vf", "scale=1280:720",
        str(mp4_path)
    ], capture_output=True)

    # Cleanup frames
    for f in frame_dir.glob("*.png"):
        f.unlink()
    frame_dir.rmdir()

    if mp4_path.exists():
        sz = mp4_path.stat().st_size / 1e3
        print(f"  ✓ {name}.mp4 ({sz:.0f} KB)")
        return mp4_path
    return None


# ═══════════════════════════════════════════════════════════
# SVG → PNG 转换 (外部工具)
# ═══════════════════════════════════════════════════════════

def svg_to_png_file(svg_el, png_path):
    """将 SVG Element 写入临时文件并转为 PNG"""
    svg_str = ET.tostring(svg_el, encoding="unicode")
    tmp_svg = RENDERS_DIR / "_tmp.svg"
    with open(tmp_svg, "w") as f:
        f.write('<?xml version="1.0" encoding="UTF-8"?>\n')
        f.write(svg_str)
    subprocess.run(["rsvg-convert", "-o", str(png_path), str(tmp_svg)],
                   capture_output=True)
    tmp_svg.unlink(missing_ok=True)
    return png_path.exists()


def svg_to_png(svg_el, name):
    """保存 SVG 为 PNG"""
    png_path = RENDERS_DIR / f"{name}.png"
    ok = svg_to_png_file(svg_el, png_path)
    if ok:
        print(f"  ✓ {name}.png")
    return png_path if ok else None


# ═══════════════════════════════════════════════════════════
# 主流程
# ═══════════════════════════════════════════════════════════

def main():
    print("=" * 60)
    print("  红创科技 — AAC 后处理渲染")
    print("=" * 60)
    print()

    all_specimens = list(SPECIMENS_PS.keys())

    # 1. 滞回曲线
    print("[1/4] 滞回曲线 (Hysteresis Curves)")
    for spec_id in all_specimens:
        render_hysteresis(spec_id)
    print()

    # 2. 对比图表
    print("[2/4] 对比图表 (Comparison Charts)")
    render_skeleton_comparison(all_specimens)
    render_stiffness_comparison(all_specimens)
    render_energy_comparison(all_specimens)
    render_bar_comparison(all_specimens)
    print()

    # 3. 墙体变形动画
    print("[3/4] 墙体变形动画 (Wall Deformation Videos)")
    for spec_id in all_specimens:
        render_wall_animation(spec_id)
    print()

    # 4. 汇总
    print("[4/4] 输出汇总")
    print(f"  {RENDERS_DIR}/")
    for f in sorted(RENDERS_DIR.glob("*.png")):
        print(f"    {f.name}")
    for f in sorted(RENDERS_DIR.glob("*.mp4")):
        sz = f.stat().st_size / 1e3
        print(f"    {f.name} ({sz:.0f} KB)")
    print()
    print("=" * 60)
    print("  渲染完成 ✓")
    print("=" * 60)


if __name__ == "__main__":
    main()
