###############################################################################
# 红创科技多物理场仿真引擎 — Hongchuang Multi-Physics Engine
# MOOSE Application Makefile
#
# Build: make -j$(nproc)
# Run:   ./hongchuang-opt -i inputs/cantilever_multiphysics_cdp.i
###############################################################################

# ─── MOOSE directories ──────────────────────────────────────────
MOOSE_DIR          ?= /home/kevin/gt/demo/mayor/rig/build/moose
FRAMEWORK_DIR      ?= $(MOOSE_DIR)/framework

# Include MOOSE build system
include $(FRAMEWORK_DIR)/build.mk
include $(FRAMEWORK_DIR)/moose.mk

# ─── Application name ───────────────────────────────────────────
APPLICATION_NAME    := hongchuang
APPLICATION_DIR     := $(CURDIR)

# ─── Source directories ─────────────────────────────────────────
APPLICATION_SRC_DIRS := src
APPLICATION_INC_DIRS := src src/core src/materials

# ─── Module dependencies ────────────────────────────────────────
SOLID_MECHANICS_DIR := $(MOOSE_DIR)/modules/solid_mechanics
include $(SOLID_MECHANICS_DIR)/solid_mechanics.mk
APPLICATION_LIBS     += $(SOLID_MECHANICS_LIBS)

include $(FRAMEWORK_DIR)/app.mk
