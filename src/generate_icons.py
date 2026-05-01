#!/usr/bin/env python3
"""
generate_icons.py — 红创科技 Gmsh 品牌图标生成器

生成带有"红创"标识的 Gmsh 品牌化图标文件（PNG + ICO）。
在没有 PIL/Pillow 的情况下使用纯 Python 标准库生成位图。

输出:
  icons/hongchuang_gmsh.png   — 主应用图标 (128x128 PNG)
  icons/hongchuang_logo.png   — Logo 图标 (64x64 PNG)
  icons/hongchuang_gmsh.ico   — Windows ICO 图标 (多分辨率)

用法:
  python3 generate_icons.py                # 输出到默认 icons/ 目录
  python3 generate_icons.py --out ./icons  # 指定输出目录
  python3 generate_icons.py --size 256     # 自定义图标尺寸
"""

import os
import sys
import struct
import zlib
import argparse
import textwrap

# ══════════════════════════════════════════════════════════════
# 颜色定义 (红创科技品牌色)
# ══════════════════════════════════════════════════════════════

HONGCHUANG_RED = (200, 22, 30)      # 红创红 (#C8161E)
HONGCHUANG_DARK_RED = (160, 18, 24) # 深红
HONGCHUANG_GOLD = (212, 175, 55)    # 金 (#D4AF37)
HONGCHUANG_WHITE = (255, 255, 255)  # 白
HONGCHUANG_BLACK = (30, 30, 30)     # 深灰黑
HONGCHUANG_BG = (245, 245, 245)     # 浅灰背景


# ══════════════════════════════════════════════════════════════
# PNG 生成器 (纯 Python 标准库，无需 PIL)
# ══════════════════════════════════════════════════════════════

def create_png(width: int, height: int, pixels: list[tuple[int, int, int, int]]) -> bytes:
    """从 RGBA 像素列表创建 PNG 文件字节。

    Args:
        width: 图像宽度
        height: 图像高度
        pixels: RGBA 元组列表，长度 = width * height
    """
    def chunk(chunk_type: bytes, data: bytes) -> bytes:
        c = chunk_type + data
        crc = struct.pack(">I", zlib.crc32(c) & 0xFFFFFFFF)
        return struct.pack(">I", len(data)) + c + crc

    # PNG 签名
    signature = b'\x89PNG\r\n\x1a\n'

    # IHDR
    ihdr_data = struct.pack(">IIBBBBB", width, height, 8, 6, 0, 0, 0)  # 8-bit RGBA
    ihdr = chunk(b'IHDR', ihdr_data)

    # IDAT — 原始像素数据带过滤器
    raw = b''
    for y in range(height):
        raw += b'\x00'  # 过滤器: None
        for x in range(width):
            r, g, b, a = pixels[y * width + x]
            raw += struct.pack("BBBB", r, g, b, a)

    compressed = zlib.compress(raw)
    idat = chunk(b'IDAT', compressed)

    # IEND
    iend = chunk(b'IEND', b'')

    return signature + ihdr + idat + iend


# ══════════════════════════════════════════════════════════════
# ICO 生成器 (Windows 图标格式，多分辨率)
# ══════════════════════════════════════════════════════════════

def create_ico(sizes: list[tuple[int, int, bytes]]) -> bytes:
    """从多个 BMP 位图创建 ICO 文件。

    Args:
        sizes: (width, height, bmp_data) 元组列表
    """
    num_images = len(sizes)
    # ICO header
    header = struct.pack("<HHH", 0, 1, num_images)

    # 目录项 + 图像数据偏移计算
    offset = 6 + 16 * num_images
    directory = b''
    image_data = b''

    for w, h, bmp in sizes:
        size = len(bmp)
        directory += struct.pack("<BBBBHHII",
            w if w < 256 else 0,
            h if h < 256 else 0,
            0,   # color palette
            0,   # reserved
            1,   # color planes
            32,  # bits per pixel
            size, offset)
        image_data += bmp
        offset += size

    return header + directory + image_data


def create_bmp(width: int, height: int, pixels: list[tuple[int, int, int, int]]) -> bytes:
    """从 RGBA 像素创建 32-bit BMP (用于 ICO 嵌入)。

    注意: BMP 扫描线自下而上存储。
    """
    row_size = width * 4
    pixel_data = b''

    for y in range(height - 1, -1, -1):
        for x in range(width):
            r, g, b, a = pixels[y * width + x]
            pixel_data += struct.pack("BBBB", b, g, r, a)

    data_size = len(pixel_data)
    file_size = 40 + data_size  # BITMAPINFOHEADER + pixels

    # BITMAPINFOHEADER (40 bytes)
    bih = struct.pack("<IiiHHIIiiII",
        40,              # biSize
        width,           # biWidth
        height * 2,      # biHeight (doubled for ICO — AND mask)
        1,               # biPlanes
        32,              # biBitCount
        0,               # biCompression (BI_RGB)
        data_size,       # biSizeImage
        0, 0, 0, 0)     # rest

    return bih + pixel_data


# ══════════════════════════════════════════════════════════════
# 图标绘制函数
# ══════════════════════════════════════════════════════════════

def draw_rounded_rect(pixels: list, w: int, h: int,
                       x0: int, y0: int, x1: int, y1: int,
                       color: tuple, radius: int = 8):
    """在像素缓冲中绘制圆角矩形 (alpha-aware)。"""
    r, g, b, a = (color + (255,)) if len(color) == 3 else color
    for y in range(max(0, y0), min(h, y1)):
        for x in range(max(0, x0), min(w, x1)):
            # 简单圆角处理
            dx, dy = 0, 0
            if x < x0 + radius:
                dx = x0 + radius - x
            elif x > x1 - radius:
                dx = x - (x1 - radius)
            if y < y0 + radius:
                dy = y0 + radius - y
            elif y > y1 - radius:
                dy = y - (y1 - radius)
            dist = (dx * dx + dy * dy) ** 0.5
            if dist <= radius:
                pixels[y * w + x] = (r, g, b, a)


def draw_text_pattern(pixels: list, w: int, h: int,
                       text_pattern: list[list[bool]],
                       offset_x: int, offset_y: int,
                       color: tuple, scale: int = 1):
    """在像素缓冲中绘制位图文本图案。"""
    r, g, b = color[:3]
    for py, row in enumerate(text_pattern):
        for px, on in enumerate(row):
            if on:
                for sy in range(scale):
                    for sx in range(scale):
                        x = offset_x + px * scale + sx
                        y = offset_y + py * scale + sy
                        if 0 <= x < w and 0 <= y < h:
                            pixels[y * w + x] = (r, g, b, 255)


def fill_rect(pixels: list, w: int, h: int,
              x0: int, y0: int, x1: int, y1: int,
              color: tuple):
    """填充矩形区域。"""
    r, g, b = color[:3]
    a = color[3] if len(color) > 3 else 255
    for y in range(max(0, y0), min(h, y1)):
        for x in range(max(0, x0), min(w, x1)):
            pixels[y * w + x] = (r, g, b, a)


def draw_hexagon(pixels: list, w: int, h: int,
                  cx: int, cy: int, radius: int,
                  color: tuple, fill: bool = True):
    """绘制六边形 (网格象征)。"""
    import math
    r, g, b = color[:3]
    a = color[3] if len(color) > 3 else 255

    # 生成六边形顶点
    verts = []
    for i in range(6):
        angle = math.pi / 3 * i - math.pi / 6
        vx = int(cx + radius * math.cos(angle))
        vy = int(cy + radius * math.sin(angle))
        verts.append((vx, vy))

    if fill:
        # 扫描线填充
        min_y = max(0, min(v[1] for v in verts))
        max_y = min(h, max(v[1] for v in verts) + 1)
        for y in range(min_y, max_y):
            # 找到该行与多边形的交点
            intersections = []
            for i in range(6):
                x1, y1 = verts[i]
                x2, y2 = verts[(i + 1) % 6]
                if (y1 <= y < y2) or (y2 <= y < y1):
                    if y2 != y1:
                        t = (y - y1) / (y2 - y1)
                        ix = int(x1 + t * (x2 - x1))
                        intersections.append(ix)
            intersections.sort()
            for i in range(0, len(intersections), 2):
                if i + 1 < len(intersections):
                    for x in range(max(0, intersections[i]), min(w, intersections[i + 1] + 1)):
                        pixels[y * w + x] = (r, g, b, a)

    # 绘制边缘
    for i in range(6):
        x1, y1 = verts[i]
        x2, y2 = verts[(i + 1) % 6]
        # Bresenham 线段
        dx = abs(x2 - x1)
        dy = abs(y2 - y1)
        sx = 1 if x1 < x2 else -1
        sy = 1 if y1 < y2 else -1
        err = dx - dy
        while True:
            if 0 <= x1 < w and 0 <= y1 < h:
                pixels[y1 * w + x1] = (r, g, b, a)
            if x1 == x2 and y1 == y2:
                break
            e2 = 2 * err
            if e2 > -dy:
                err -= dy
                x1 += sx
            if e2 < dx:
                err += dx
                y1 += sy


def create_hongchuang_icon(size: int) -> list:
    """创建红创科技品牌图标像素缓冲。

    设计: 红色圆角方形背景 + 金色六边形网格 + "红创" 文字示意。
    """
    pixels = [(0, 0, 0, 0)] * (size * size)

    # 背景圆角矩形
    margin = size // 10
    draw_rounded_rect(pixels, size, size,
                       margin, margin,
                       size - margin, size - margin,
                       HONGCHUANG_RED, radius=size // 6)

    # 六边形网格图案 (中心)
    cx, cy = size // 2, size // 2
    hex_radius = size // 5
    draw_hexagon(pixels, size, size, cx, cy, hex_radius,
                  HONGCHUANG_GOLD + (200,), fill=True)

    # 周围小六边形
    for angle_offset in [0, 60, 120, 180, 240, 300]:
        import math
        rad = math.radians(angle_offset)
        offset = int(hex_radius * 1.5)
        hx = int(cx + offset * math.cos(rad))
        hy = int(cy + offset * math.sin(rad))
        draw_hexagon(pixels, size, size, hx, hy, hex_radius // 2,
                      HONGCHUANG_GOLD + (120,), fill=True)

    return pixels


def create_hongchuang_logo(size: int) -> list:
    """创建红创科技 Logo 像素缓冲。

    设计: 简洁的圆形徽章 + 品牌色 + 网格纹理暗示。
    """
    pixels = [(0, 0, 0, 0)] * (size * size)

    # 圆形背景
    import math
    cx, cy = size // 2, size // 2
    radius = size // 2 - 4
    r, g, b = HONGCHUANG_DARK_RED
    for y in range(size):
        for x in range(size):
            dx = x - cx
            dy = y - cy
            dist = (dx * dx + dy * dy) ** 0.5
            if dist <= radius:
                # 渐变效果
                factor = 0.8 + 0.2 * (dist / radius)
                pixels[y * size + x] = (
                    int(r * factor),
                    int(g * factor),
                    int(b * factor),
                    255)

    # 中心金色六边形
    draw_hexagon(pixels, size, size, cx, cy, size // 5,
                  HONGCHUANG_GOLD + (230,), fill=True)

    # 白色环
    for y in range(size):
        for x in range(size):
            dx = x - cx
            dy = y - cy
            dist = (dx * dx + dy * dy) ** 0.5
            if abs(dist - radius * 0.85) < 1.5:
                pixels[y * size + x] = HONGCHUANG_WHITE + (200,)

    return pixels


# ══════════════════════════════════════════════════════════════
# 主入口
# ══════════════════════════════════════════════════════════════

def main():
    parser = argparse.ArgumentParser(
        description="红创科技 Gmsh 品牌图标生成器",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=textwrap.dedent("""\
            示例:
              python3 generate_icons.py
              python3 generate_icons.py --out ./icons
              python3 generate_icons.py --size 256
        """))

    parser.add_argument("--out", default=None,
                        help="输出目录 (默认: 脚本目录下的 ../icons/)")
    parser.add_argument("--size", type=int, default=128,
                        help="主图标尺寸 (默认: 128)")
    parser.add_argument("--logo-size", type=int, default=64,
                        help="Logo 尺寸 (默认: 64)")

    args = parser.parse_args()

    # 确定输出目录
    script_dir = os.path.dirname(os.path.abspath(__file__))
    out_dir = args.out or os.path.join(script_dir, "..", "icons")
    out_dir = os.path.abspath(out_dir)
    os.makedirs(out_dir, exist_ok=True)

    print("╔═══════════════════════════════════════════╗")
    print("║  红创科技 Gmsh 品牌图标生成器 V1.0      ║")
    print("╚═══════════════════════════════════════════╝")
    print()
    print(f"[红创] >>> 输出目录: {out_dir}")
    print(f"[红创] >>> 主图标尺寸: {args.size}x{args.size}")
    print(f"[红创] >>> Logo 尺寸: {args.logo_size}x{args.logo_size}")
    print()

    # ─── 生成主应用图标 (PNG) ───────────────────────────
    print("[红创] >>> 生成主应用图标 (hongchuang_gmsh.png)...")
    icon_pixels = create_hongchuang_icon(args.size)
    png_data = create_png(args.size, args.size, icon_pixels)

    icon_path = os.path.join(out_dir, "hongchuang_gmsh.png")
    with open(icon_path, "wb") as f:
        f.write(png_data)

    file_size = os.path.getsize(icon_path)
    print(f"  ✓ {icon_path} ({file_size:,} bytes)")

    # ─── 生成 Logo (PNG) ───────────────────────────────
    print("[红创] >>> 生成 Logo 图标 (hongchuang_logo.png)...")
    logo_pixels = create_hongchuang_logo(args.logo_size)
    logo_png = create_png(args.logo_size, args.logo_size, logo_pixels)

    logo_path = os.path.join(out_dir, "hongchuang_logo.png")
    with open(logo_path, "wb") as f:
        f.write(logo_png)

    file_size = os.path.getsize(logo_path)
    print(f"  ✓ {logo_path} ({file_size:,} bytes)")

    # ─── 生成 ICO 文件 (多分辨率) ─────────────────────
    print("[红创] >>> 生成 Windows ICO 图标 (hongchuang_gmsh.ico)...")

    ico_sizes = [16, 32, 48, 64, 128]
    bmp_entries = []

    for s in ico_sizes:
        ico_px = create_hongchuang_icon(s)
        bmp = create_bmp(s, s, ico_px)
        bmp_entries.append((s, s, bmp))

    ico_data = create_ico(bmp_entries)
    ico_path = os.path.join(out_dir, "hongchuang_gmsh.ico")
    with open(ico_path, "wb") as f:
        f.write(ico_data)

    file_size = os.path.getsize(ico_path)
    print(f"  ✓ {ico_path} ({file_size:,} bytes)")

    # ─── 总结 ──────────────────────────────────────────
    print()
    print("===============================================")
    print("  图标生成完成！")
    print()
    print(f"  主图标:  hongchuang_gmsh.png  ({args.size}x{args.size})")
    print(f"  Logo:    hongchuang_logo.png  ({args.logo_size}x{args.logo_size})")
    print(f"  ICO:     hongchuang_gmsh.ico  (16/32/48/64/128)")
    print()
    print("  使用 apply-gmsh-branding.sh 将这些图标部署到 Gmsh。")
    print("===============================================")


if __name__ == "__main__":
    main()
