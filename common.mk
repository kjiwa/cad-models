# Root common Makefile for OpenSCAD models

REPO_ROOT ?= $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
export OPENSCADPATH ?= $(REPO_ROOT)/lib

OPENSCAD ?= openscad
MODEL    ?= $(notdir $(CURDIR))
SCAD_FILE ?= $(MODEL).scad
JSON_FILE ?= $(MODEL).json
COMPONENTS ?= $(wildcard components/*.scad)
BUILD_DIR ?= build

OPENSCAD_BACKEND := $(shell $(OPENSCAD) --help 2>&1 | grep -q -- '--backend' && echo '--backend=Manifold' || ($(OPENSCAD) --help 2>&1 | grep -q 'manifold' && echo '--enable=manifold'))

OPENSCAD_FLAGS ?= --render $(OPENSCAD_BACKEND)
RENDER_FLAGS   ?= --autocenter --viewall --imgsize=1024,768 --colorscheme=Tomorrow

PRESET_BUILDER := $(REPO_ROOT)/scripts/build_presets.py

.PHONY: all stl 3mf preview presets clean help

all: stl 3mf preview presets

stl: $(BUILD_DIR)/$(MODEL).stl

3mf: $(BUILD_DIR)/$(MODEL).3mf

preview: $(BUILD_DIR)/$(MODEL)_preview.png

$(BUILD_DIR)/$(MODEL).stl: $(SCAD_FILE) $(COMPONENTS)
	@mkdir -p $(@D)
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ $<

$(BUILD_DIR)/$(MODEL).3mf: $(SCAD_FILE) $(COMPONENTS)
	@mkdir -p $(@D)
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ $<

$(BUILD_DIR)/$(MODEL)_preview.png: $(SCAD_FILE) $(COMPONENTS)
	@mkdir -p $(@D)
	$(OPENSCAD) $(RENDER_FLAGS) --render -o $@ $<

presets: $(SCAD_FILE) $(COMPONENTS)
	@if [ -f "$(JSON_FILE)" ]; then \
		python3 $(PRESET_BUILDER) \
			--model "$(MODEL)" \
			--scad "$(SCAD_FILE)" \
			--json "$(JSON_FILE)" \
			--build-dir "$(BUILD_DIR)" \
			--openscad "$(OPENSCAD)" \
			--openscad-flags "$(OPENSCAD_FLAGS)" \
			--render-flags "$(RENDER_FLAGS)" \
			--target all; \
	fi

clean:
	rm -rf $(BUILD_DIR)

help:
	@echo "Available targets for $(MODEL):"
	@echo "  all      - Build default STL, 3MF, preview, and all presets (default)"
	@echo "  stl      - Export default STL"
	@echo "  3mf      - Export default 3MF"
	@echo "  preview  - Export rendered PNG preview image"
	@echo "  presets  - Build all parameter presets from $(JSON_FILE) (if present)"
	@echo "  clean    - Remove build artifacts"
