#!/usr/bin/env python3
"""红创科技 — 投标PPT: 嵌入仿真动画视频"""
from pptx import Presentation
from pptx.util import Inches, Pt, Emu
from pptx.dml.color import RGBColor
from pptx.enum.text import PP_ALIGN
from pathlib import Path

ROOT = Path(__file__).parent
RENDERS = ROOT / "renders"
OUT = ROOT / "红创科技仿真平台_投标讲稿.pptx"

prs = Presentation()
prs.slide_width = Inches(13.333)
prs.slide_height = Inches(7.5)

W = prs.slide_width
H = prs.slide_height

RED = RGBColor(0xC6, 0x28, 0x28)
GOLD = RGBColor(0xD4, 0xAF, 0x37)
WHITE = RGBColor(0xFF, 0xFF, 0xFF)
GRAY = RGBColor(0x88, 0x88, 0x88)
DARK = RGBColor(0x1A, 0x1A, 0x2E)

def dark_bg(slide):
    bg = slide.background
    fill = bg.fill
    fill.solid()
    fill.fore_color.rgb = DARK

def add_title(slide, text, y=Inches(0.2)):
    txBox = slide.shapes.add_textbox(Inches(0.5), y, Inches(12), Inches(0.7))
    tf = txBox.text_frame
    tf.word_wrap = True
    p = tf.paragraphs[0]
    p.text = text
    p.font.size = Pt(30)
    p.font.bold = True
    p.font.color.rgb = RED

def add_subtitle(slide, text, y=Inches(0.85)):
    txBox = slide.shapes.add_textbox(Inches(0.5), y, Inches(12), Inches(0.4))
    p = txBox.text_frame.paragraphs[0]
    p.text = text
    p.font.size = Pt(14)
    p.font.color.rgb = GRAY

def add_video(slide, path, left, top, width=None, height=None):
    """Embed video from file"""
    path = str(path)
    if width is None:
        width = Inches(12)
    if height is None:
        height = Inches(5.5)
    # python-pptx video support: add as movie
    try:
        slide.shapes.add_movie(path, left, top, width, height, 
                               poster_frame_image=None, mime_type='video/mp4')
    except Exception as e:
        # Fallback: add text note
        txBox = slide.shapes.add_textbox(left, top, width, height)
        p = txBox.text_frame.paragraphs[0]
        p.text = f"[视频: {Path(path).name}]\n请在PowerPoint中手动插入此视频"
        p.font.size = Pt(16)
        p.font.color.rgb = GOLD
        p.alignment = PP_ALIGN.CENTER

# ================================================================
# Slide 1: Title
# ================================================================
sl = prs.slides.add_slide(prs.slide_layouts[6])  # blank
dark_bg(sl)

txBox = sl.shapes.add_textbox(Inches(1), Inches(1.5), Inches(11), Inches(1.2))
p = txBox.text_frame.paragraphs[0]
p.text = "红创科技 多物理场仿真平台"
p.font.size = Pt(44); p.font.bold = True; p.font.color.rgb = RED; p.alignment = PP_ALIGN.CENTER

txBox = sl.shapes.add_textbox(Inches(1), Inches(2.8), Inches(11), Inches(0.8))
p = txBox.text_frame.paragraphs[0]
p.text = "仿真动画演示 — 投标技术讲稿"
p.font.size = Pt(24); p.font.color.rgb = WHITE; p.alignment = PP_ALIGN.CENTER

txBox = sl.shapes.add_textbox(Inches(1), Inches(4), Inches(11), Inches(0.5))
p = txBox.text_frame.paragraphs[0]
p.text = "2026年5月"
p.font.size = Pt(16); p.font.color.rgb = GRAY; p.alignment = PP_ALIGN.CENTER

# ================================================================
# Slides 2-5: Each with one video
# ================================================================
videos = [
    ("悬臂梁线弹性加载", "beam_loading.mp4",
     "真实 FEM 四面体网格 · 11 载荷步 · 3000× 变形放大 · 逐面着色"),
    ("接触力学演化", "contact.mp4",
     "Coulomb 摩擦 · 11 时间步 · 位移 0→0.17mm · 网格逐面着色"),
    ("静电双材料电位场", "electrostatic.mp4",
     "钢(σ=10⁷) + 混凝土(σ=10⁻²) · 电位 0→1V 渐进 · 3D 挤出网格"),
    ("多物理耦合 (热+力+损伤)", "multiphysics_coupling.mp4",
     "温度 · 位移 · 损伤 三场轮播 · 直接耦合求解 · 单求解器"),
]

for title, fname, desc in videos:
    sl = prs.slides.add_slide(prs.slide_layouts[6])
    dark_bg(sl)
    add_title(sl, title)
    add_subtitle(sl, desc)
    
    vpath = RENDERS / fname
    if vpath.exists():
        add_video(sl, vpath, Inches(0.6), Inches(1.3), Inches(12.1), Inches(5.8))
    else:
        txBox = sl.shapes.add_textbox(Inches(2), Inches(3), Inches(9), Inches(1))
        p = txBox.text_frame.paragraphs[0]
        p.text = f"[视频未找到: {fname}]"
        p.font.size = Pt(20); p.font.color.rgb = RED; p.alignment = PP_ALIGN.CENTER

# ================================================================
# Slide 6: Summary
# ================================================================
sl = prs.slides.add_slide(prs.slide_layouts[6])
dark_bg(sl)

txBox = sl.shapes.add_textbox(Inches(1), Inches(1), Inches(11), Inches(1))
p = txBox.text_frame.paragraphs[0]
p.text = "平台能力总结"
p.font.size = Pt(36); p.font.bold = True; p.font.color.rgb = RED; p.alignment = PP_ALIGN.CENTER

items = [
    "✓ 6 大验证算例全部通过",
    "✓ 网格收敛精度 0.11% (vs 理论解)",
    "✓ 端到端管线: Gmsh → MOOSE → ParaView",
    "✓ 3 物理场直接耦合 (热+力+损伤)",
    "✓ 11 个 ExodusII (.e) 输出文件",
    "✓ 完整文档: 三手册 + 架构 + 性能 + 回归基线",
]
for i, item in enumerate(items):
    txBox = sl.shapes.add_textbox(Inches(2), Inches(2.2 + i * 0.7), Inches(9), Inches(0.5))
    p = txBox.text_frame.paragraphs[0]
    p.text = item
    p.font.size = Pt(20); p.font.color.rgb = GOLD if i == 2 else WHITE

# Save
prs.save(str(OUT))
print(f"PPT saved: {OUT}")
print(f"Slides: {len(prs.slides)}")
