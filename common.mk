# Root common Makefile for OpenSCAD models

REPO_ROOT ?= $(abspath $(dir $(lastword $(MAKEFILE_LIST))))

OPENSCAD ?= openscad
MODEL    ?= $(notdir $(CURDIR))
SCAD_FILE ?= $(MODEL).scad
JSON_FILE ?= $(MODEL).json
COMPONENTS ?= $(wildcard components/*.scad)
BUILD_DIR ?= build

OPENSCAD_BACKEND := $(shell $(OPENSCAD) --help 2>&1 | grep -q -- '--backend' && echo '--backend=Manifold' || ($(OPENSCAD) --help 2>&1 | grep -q 'manifold' && echo '--enable=manifold'))

OPENSCAD_FLAGS ?= --render $(OPENSCAD_BACKEND)
RENDER_FLAGS   ?= --autocenter --viewall --imgsize=1024,768 --colorscheme=Tomorrow

ONESCAD ?= uvx onescad==0.1.0
DIST_DIR ?= $(REPO_ROOT)/dist

PRESET_BUILDER := $(REPO_ROOT)/scripts/build_presets.py

.PHONY: all stl 3mf preview presets bundle clean help

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
	$(OPENSCAD) $(OPENSCAD_BACKEND) $(RENDER_FLAGS) --render -o $@ $<

presets: $(SCAD_FILE) $(COMPONENTS)
	@if [ -f "$(JSON_FILE)" ]; then \
		python3 $(PRESET_BUILDER) \
			--model "$(MODEL)" \
			--scad "$(SCAD_FILE)" \
			--json "$(JSON_FILE)" \
			--build-dir "$(BUILD_DIR)" \
			--openscad "$(OPENSCAD)" \
			--openscad-flags "$(OPENSCAD_FLAGS)" \
			--render-flags "$(OPENSCAD_BACKEND) $(RENDER_FLAGS)" \
			--target all; \
	fi

bundle: $(SCAD_FILE) $(COMPONENTS)
	@mkdir -p $(DIST_DIR)
	OPENSCADPATH=$(REPO_ROOT)/lib $(ONESCAD) $(SCAD_FILE) -o $(DIST_DIR)/$(SCAD_FILE) --verify

clean:
	rm -rf $(BUILD_DIR)

help:
	@echo "Available targets for $(MODEL):"
	@echo "  all      - Build default STL, 3MF, preview, and all presets (default)"
	@echo "  stl      - Export default STL"
	@echo "  3mf      - Export default 3MF"
	@echo "  preview  - Export rendered PNG preview image"
	@echo "  presets  - Build all parameter presets from $(JSON_FILE) (if present)"
	@echo "  bundle   - Inline includes into a single verified $(SCAD_FILE) in dist/ (needs uv)"
	@echo "  clean    - Remove build artifacts"
