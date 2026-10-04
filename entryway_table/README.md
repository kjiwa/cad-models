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

All dimensions are in millimeters.

### `[Tabletop]`
| Parameter | Default | Description |
|---|---|---|
| `Top_Length` | `1219.2` | Tabletop length along X (48") |
| `Top_Depth` | `279.4` | Tabletop depth along Y (11") |
| `Top_Overhang` | `38.1` | Tabletop overhang beyond the leg outer faces (1-1/2") |

### `[Legs]`
| Parameter | Default | Description |
|---|---|---|
| `Leg_Height` | `914.4` | Leg height from floor to underside of the top (36") |
| `Leg_Board_Width` | `50.8` | Width of each board in the L-shaped leg (2") |

### `[Apron]`
| Parameter | Default | Description |
|---|---|---|
| `Apron_Height` | `203.2` | Height of the apron boards (8") |
| `Apron_Length` | `0` | Length of the front and back apron boards (0 = auto: `Top_Length - 2 * Top_Overhang - 2 * Leg_Board_Width`, 1041.4 by default) |
| `Apron_Depth` | `0` | Depth of the side apron boards (0 = auto: `Top_Depth - 2 * Top_Overhang - 76.2`, 127 by default) |

### `[Plywood]`
| Parameter | Default | Description |
|---|---|---|
| `Board_Thickness` | `19.05` | Plywood sheet thickness (3/4") |
| `Ply_Count` | `5` | Number of plies for alternating veneer visualization |
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
