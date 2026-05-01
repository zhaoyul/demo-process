#!/usr/bin/env bash
# 红创科技多物理场仿真平台 — 依赖安装脚本
# Hongchuang Multiphysics Simulation Platform — Dependency Installer
#
# 在 Arch Linux 上安装编译和运行所需的系统依赖。
# 需要 root 权限（通过 sudo）。

set -euo pipefail

RED='\033[0;31m'
NC='\033[0m'
BOLD='\033[1m'

echo -e "${RED}${BOLD}[红创科技] 依赖安装程序${NC}"
echo "目标平台: Arch Linux"
echo ""

# ---------------------------------------------------------------------
# 第0步：基础编译工具链
# ---------------------------------------------------------------------

echo -e "${RED}[红创科技]${NC} 安装基础编译工具链 (base-devel, cmake, git)..."
sudo pacman -S --needed --noconfirm \
    base-devel \
    cmake \
    git

# ---------------------------------------------------------------------
# 第1步：Gmsh 依赖 (FLTK, OpenCASCADE)
# ---------------------------------------------------------------------

echo -e "${RED}[红创科技]${NC} 安装 Gmsh 编译依赖 (MPI, HDF5, FLTK)..."
sudo pacman -S --needed --noconfirm \
    mpich \
    hdf5 \
    fltk \
    opencascade

# ---------------------------------------------------------------------
# 第2步：MOOSE 依赖 (Python, pip)
# ---------------------------------------------------------------------

echo -e "${RED}[红创科技]${NC} 安装 MOOSE 基础依赖 (Python)..."
sudo pacman -S --needed --noconfirm \
    python \
    python-pip

# ---------------------------------------------------------------------
# 第3步：ParaView 依赖 (Qt5, VTK)
# ---------------------------------------------------------------------

echo -e "${RED}[红创科技]${NC} 安装 ParaView 编译依赖 (Qt5, VTK)..."
sudo pacman -S --needed --noconfirm \
    qt5-base \
    qt5-tools \
    vtk

# ---------------------------------------------------------------------
# 验证安装
# ---------------------------------------------------------------------

echo ""
echo -e "${RED}${BOLD}[红创科技] 依赖安装完成${NC}"
echo ""
echo "已安装工具链:"
echo "  $(gcc --version | head -1)"
echo "  $(g++ --version | head -1)"
echo "  $(cmake --version | head -1)"
echo "  $(mpiexec --version 2>&1 | head -1 || echo 'mpich (需手动激活)')"
echo "  $(python --version 2>&1)"
echo ""
echo "后续步骤:"
echo "  1. 编译 Gmsh  → 复制到 bin/hongchuang_mesh"
echo "  2. 编译 MOOSE → 复制到 bin/hongchuang-opt"
echo "  3. 编译 ParaView → 复制到 bin/hongchuang_post"
echo "  4. 运行: make run CASE=<算例名称>"
