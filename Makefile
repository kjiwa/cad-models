# Root Makefile to coordinate builds across all model directories

# Discover all subdirectories containing a Makefile (stripped of trailing slash)
PROJECTS := $(patsubst %/,%,$(dir $(wildcard */Makefile)))

.PHONY: all clean $(PROJECTS)

all: $(PROJECTS)

$(PROJECTS):
	@echo "==> Building in $@"
	@$(MAKE) -C $@ all

clean:
	@for dir in $(PROJECTS); do \
		echo "==> Cleaning in $$dir"; \
		$(MAKE) -C $$dir clean; \
	done

