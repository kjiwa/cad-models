OPENSCAD ?= openscad
MODEL     := makita_hose_adapter
SCAD_FILE := $(MODEL).scad
BUILD_DIR := build

OPENSCAD_FLAGS := --render
RENDER_FLAGS   := --autocenter --viewall --imgsize=1024,768 --colorscheme=Tomorrow

.PHONY: all stl 3mf preview clean help

all: stl 3mf preview

# Default exports
stl: $(BUILD_DIR)/$(MODEL).stl

3mf: $(BUILD_DIR)/$(MODEL).3mf

preview: $(BUILD_DIR)/$(MODEL)_preview.png

$(BUILD_DIR)/$(MODEL).stl: $(SCAD_FILE)
	@mkdir -p $(@D)
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ $<

$(BUILD_DIR)/$(MODEL).3mf: $(SCAD_FILE)
	@mkdir -p $(@D)
	$(OPENSCAD) $(OPENSCAD_FLAGS) -o $@ $<

$(BUILD_DIR)/$(MODEL)_preview.png: $(SCAD_FILE)
	@mkdir -p $(@D)
	$(OPENSCAD) $(RENDER_FLAGS) -o $@ $<

clean:
	rm -rf $(BUILD_DIR)

help:
	@echo "Available targets:"
	@echo "  all      - Build default STL, 3MF, and preview image (default)"
	@echo "  stl      - Export default STL"
	@echo "  3mf      - Export default 3MF"
	@echo "  preview  - Export rendered PNG preview image"
	@echo "  clean    - Remove build artifacts"
