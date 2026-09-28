# Root Makefile to coordinate builds across all model directories

# Discover all subdirectories containing a Makefile (stripped of trailing slash)
PROJECTS := $(patsubst %/,%,$(dir $(wildcard */Makefile)))

.PHONY: all clean setup dist help $(PROJECTS) stl 3mf preview presets

all: $(PROJECTS)

$(PROJECTS):
	@echo "==> Building in $@"
	@$(MAKE) -C $@ all

stl 3mf preview presets:
	@for dir in $(PROJECTS); do \
		echo "==> Building $@ in $$dir"; \
		$(MAKE) -C $$dir $@ || exit 1; \
	done

dist: all
	@mkdir -p dist
	@for dir in $(PROJECTS); do \
		if [ -d "$$dir/build" ]; then \
			find "$$dir/build" -maxdepth 1 -type f \( -name "*.stl" -o -name "*.3mf" -o -name "*.png" \) -exec cp -f {} dist/ \; ; \
		fi \
	done
	@echo "==> Packaged distribution artifacts in dist/:"
	@ls -la dist

clean:
	@rm -rf dist
	@for dir in $(PROJECTS); do \
		echo "==> Cleaning in $$dir"; \
		$(MAKE) -C $$dir clean || exit 1; \
	done

setup:
	@TARGET_DIR="$$HOME/Documents/OpenSCAD/libraries"; \
	if [ "$$(uname -s)" = "Linux" ]; then \
		TARGET_DIR="$$HOME/.local/share/OpenSCAD/libraries"; \
	fi; \
	mkdir -p "$$TARGET_DIR"; \
	for lib in $(CURDIR)/lib/*; do \
		if [ -d "$$lib" ]; then \
			name=$$(basename "$$lib"); \
			target="$$TARGET_DIR/$$name"; \
			if [ ! -e "$$target" ]; then \
				ln -s "$$lib" "$$target"; \
				echo "Linked $$name into $$TARGET_DIR"; \
			else \
				echo "$$name already exists in $$TARGET_DIR"; \
			fi; \
		fi; \
	done

help:
	@echo "Available targets:"
	@echo "  all      - Build all models (default STL, 3MF, preview, presets)"
	@echo "  stl      - Export default STL for all models"
	@echo "  3mf      - Export default 3MF for all models"
	@echo "  preview  - Export preview PNG images for all models"
	@echo "  presets  - Build all parameter presets across models"
	@echo "  dist     - Build all models and package artifacts into dist/"
	@echo "  setup    - Symlink lib/ into user OpenSCAD libraries directory"
	@echo "  clean    - Remove build and dist artifacts"
	@echo "  <model>  - Build a specific model (e.g. make ryobi_40v_battery_holder)"



