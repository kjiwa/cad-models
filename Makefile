# Root Makefile to coordinate builds across all model directories

# Discover all subdirectories containing a Makefile (stripped of trailing slash)
PROJECTS := $(patsubst %/,%,$(dir $(wildcard */Makefile)))

.PHONY: all clean setup $(PROJECTS)

all: $(PROJECTS)

$(PROJECTS):
	@echo "==> Building in $@"
	@$(MAKE) -C $@ all

clean:
	@for dir in $(PROJECTS); do \
		echo "==> Cleaning in $$dir"; \
		$(MAKE) -C $$dir clean; \
	done

setup:
	@mkdir -p "$$HOME/Documents/OpenSCAD/libraries"
	@for lib in $(CURDIR)/lib/*; do \
		if [ -d "$$lib" ]; then \
			name=$$(basename "$$lib"); \
			target="$$HOME/Documents/OpenSCAD/libraries/$$name"; \
			if [ ! -e "$$target" ]; then \
				ln -s "$$lib" "$$target"; \
				echo "Linked $$name into $$HOME/Documents/OpenSCAD/libraries"; \
			else \
				echo "$$name already exists in $$HOME/Documents/OpenSCAD/libraries"; \
			fi; \
		fi; \
	done


