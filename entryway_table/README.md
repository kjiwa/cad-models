# Entryway Table

A parametric model of an entryway table designed for plywood construction with angled legs and decorative apron rings.

## Features

- **Plywood Layer Visualization**: Renders layered plywood construction with alternating veneer colors.
- **Parametric Joinery & Dimensions**: Configurable board thickness, table height, top dimensions, and overhangs.
- **Automated CLI Build**: `Makefile` support to render STL, 3MF, and PNG preview images.

---

## Directory Structure

```text
entryway_table/
├── Makefile            # Build automation for STL, 3MF, and PNG renders
├── README.md           # Project documentation
└── entryway_table.scad # Parametric OpenSCAD source model
```

---

## Parameters Reference

All dimensions are in inches.

| Parameter | Default | Description |
|---|---|---|
| `board_thickness` | `0.75` | Thickness of plywood stock |
| `board_layers` | `5` | Number of plies in plywood visualization |
| `leg_height` | `36` | Height of the table legs |
| `leg_width` | `2` | Width of the leg boards |
| `top_length` | `48` | Length of the table top |
| `top_width` | `11` | Width of the table top |
| `top_overhang` | `1.5` | Top overhang over the leg frame |
| `apron_length` | `41` | Length of front and back apron boards |
| `apron_width` | `8` | Width (vertical height) of apron boards |
| `apron_depth` | `5` | Length of side apron boards |

---

## CLI Build & Automation

Run `make` commands from this directory or from the root repository directory:

```bash
# Build default STL, 3MF, and preview PNG
make all

# Build only default STL
make stl

# Build only default 3MF
make 3mf

# Generate a PNG preview image
make preview

# Clean build directory
make clean
```

Outputs are generated in the `build/` subdirectory.
