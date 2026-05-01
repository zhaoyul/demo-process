# 红创科技多物理场仿真平台 — 构建系统
# Hongchuang Multiphysics Simulation Platform Build System

SHELL := /bin/bash
ROOT_DIR := $(shell dirname $(realpath $(firstword $(MAKEFILE_LIST))))

# ---------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------

CONFIG := hongchuang.json
MPI_CORES ?= 8
BUILD_TYPE ?= Release

# ---------------------------------------------------------------------
# Default target
# ---------------------------------------------------------------------

.PHONY: help
help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

# ---------------------------------------------------------------------
# Dependencies
# ---------------------------------------------------------------------

.PHONY: install-deps
install-deps: ## Install system dependencies via pacman
	@echo "[红创科技] 正在安装系统依赖..."
	bash install-deps.sh

# ---------------------------------------------------------------------
# Build targets (stubs — actual builds happen in external repos)
# ---------------------------------------------------------------------

.PHONY: build-mesh
build-mesh: ## Build 红创网格工具 (Gmsh wrapper)
	@echo "[红创科技] 构建前处理引擎..."
	@test -f bin/hongchuang_mesh || echo "请先编译 Gmsh 并复制到 bin/hongchuang_mesh"

.PHONY: build-solver
build-solver: ## Build 红创求解器 (MOOSE App)
	@echo "[红创科技] 构建核心求解器..."
	@test -f bin/hongchuang-opt || echo "请先编译 MOOSE App 并复制到 bin/hongchuang-opt"

.PHONY: build-post
build-post: ## Build 红创后处理 (ParaView wrapper)
	@echo "[红创科技] 构建后处理渲染器..."
	@test -f bin/hongchuang_post || echo "请先编译 ParaView 并复制到 bin/hongchuang_post"

.PHONY: build-all
build-all: build-mesh build-solver build-post ## Build all components

# ---------------------------------------------------------------------
# Simulation targets
# ---------------------------------------------------------------------

.PHONY: run
run: ## Run a simulation (usage: make run CASE=hydro_dam)
	@if [ -z "$(CASE)" ]; then \
		echo "用法: make run CASE=<算例名称>"; \
		exit 1; \
	fi
	@echo "[红创科技] 运行仿真: $(CASE)"
	@test -f bin/hongchuang_mesh && test -f bin/hongchuang-opt || \
		{ echo "错误: 请先编译工具链 (make build-all)"; exit 1; }
	@./bin/hongchuang_mesh -3 -format msh22 inputs/$(CASE).geo -o outputs/$(CASE).msh
	@mpiexec -n $(MPI_CORES) ./bin/hongchuang-opt -i inputs/$(CASE).i
	@echo "[红创科技] 仿真完成: $(CASE)"

# ---------------------------------------------------------------------
# Pipeline
# ---------------------------------------------------------------------

.PHONY: pipeline
pipeline: ## Run full pipeline: mesh → solve → post
	@echo "[红创科技] 全流程仿真管线启动..."
	@$(MAKE) run

# ---------------------------------------------------------------------
# Cleanup
# ---------------------------------------------------------------------

.PHONY: clean
clean: ## Remove build artifacts
	@echo "[红创科技] 清理构建产物..."
	rm -rf build/

.PHONY: clean-outputs
clean-outputs: ## Remove simulation outputs
	@echo "[红创科技] 清理仿真输出..."
	rm -f outputs/*.msh outputs/*.vtk outputs/*.e outputs/*.xda outputs/*.xdr
	rm -f states/*.pvsm states/*.pvb

.PHONY: clean-all
clean-all: clean clean-outputs ## Clean everything except source

# ---------------------------------------------------------------------
# Info
# ---------------------------------------------------------------------

.PHONY: info
info: ## Display project configuration
	@echo "红创科技多物理场仿真平台"
	@echo "=========================="
	@echo "工作目录: $(ROOT_DIR)"
	@echo "配置: $(CONFIG)"
	@echo "并行核心: $(MPI_CORES)"
	@echo ""
	@echo "目录结构:"
	@echo "  bin/     — 编译后的可执行文件"
	@echo "  inputs/  — 输入文件 (.geo, .i)"
	@echo "  outputs/ — 仿真输出"
	@echo "  states/  — ParaView 状态文件"
	@echo "  src/     — 自定义源码"
