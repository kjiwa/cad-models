# Peglock Magnet Mount

Parametric, 3D-printable magnet mount for Sy's Peglock modular pegboard system and standard 1/4" pegboards. A grid of round magnet pockets in a thin slab holds tools, bits, or sheet-metal fixtures on the pegboard.

## Features

- **Dual Mounting Modes**: Toggle between Sy's Peglock modular locking wedge sockets and monolithic integrated pegboard pegs.
- **Parametric Magnet Grid**: Configurable magnet diameter and depth, rows, columns, and spacing.
- **Epoxied Magnets**: Pockets are cut to the nominal magnet size and the magnets are glued in. JB Weld and UV-cure epoxy both held over about 10 prints.
- **Customizer Compatible**: Designed for use in the OpenSCAD Customizer with parameter controls.
- **Automated CLI Build**: `Makefile` support to render STL, 3MF, presets, and PNG preview images.

---

## Directory Structure

```text
peglock_magnet_mount/
├── Makefile                      # Build automation for STL, 3MF, presets, and PNG renders
├── README.md                     # Documentation and printing recommendations
├── peglock_magnet_mount.json     # Customizer preset configurations
├── peglock_magnet_mount.scad     # Parametric OpenSCAD source model
├── BOSL2                         # Relative symlink to ../lib/BOSL2
├── pegboard                      # Relative symlink to ../lib/pegboard
└── peglock                       # Relative symlink to ../lib/peglock
```

---

## Using the OpenSCAD Customizer (GUI)

1. Open `peglock_magnet_mount.scad` in OpenSCAD.
2. In the top menu, ensure **Window -> Customizer** is checked.
3. Select a preset (`Single_12mm`, `Pair_12mm`, `Grid_2x2_12mm`) or customize parameters.
4. Press `F5` to preview or `F6` to render, then `F7` to export to STL.

---

## Parameters Reference

All lengths are in millimeters unless noted.

### `[Layout]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Columns` | `1` | | Number of magnet columns |
| `Rows` | `1` | | Number of magnet rows |
| `Magnet_Spacing` | `2` | | Spacing between magnets and around the grid edge |

### `[Magnet]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Magnet_Diameter` | `12` | | Magnet pocket diameter (12 for a 12 mm disc) |
| `Magnet_Depth` | `3.5` | | Magnet pocket depth, which is also the slab thickness |

### `[Backplate]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Backplate_Thickness` | `1.5875` | | Thickness of the backplate behind the magnet slab |
| `Corner_Radius` | `1.5875` | | Radius of the rounded slab edges (0 for square edges) |

### `[Pegboard]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Mount_Type` | `peglock` | `peglock`, `monolithic` | Mounting interface: modular Peglock wedge socket or monolithic integrated pegboard pegs |
| `Hole_Spacing` | `25.4` | | Pegboard hole center spacing (25.4 for 1" standard, 15.875 for 5/8" metal) |
| `Pin_Diameter` | `5.7` | | Pin diameter (5.7 for standard 1/4" hole fit, 6.0 for original Sy fit) |
| `Pegboard_Thickness` | `6.35` | | Pegboard thickness (6.35 for 1/4" board, 1.5875 for 1/16" thin metal) |
| `Retention_Hook_Rise` | `3.5` | | Height of the retention hook tab behind the pegboard |

---

## 3D Printing Recommendations

- **Orientation**: Print with the magnet pockets facing up (+Z). No supports are required.
- **Magnets**: Epoxy the magnets into the pockets. JB Weld and UV-cure epoxy both worked over about 10 prints. Check polarity before the glue sets.
- **Perimeters / Walls**: 3-4 perimeters, so the spacing between pockets is solid plastic.
- **Material Selection**: PETG or PLA; both hold the magnets once glued.

---

## CLI Build & Automation

Run `make` commands from this directory or from the root repository directory:

```bash
# Build default STL, 3MF, preview PNG, and all JSON presets
make all

# Build only default STL
make stl

# Build only default 3MF
make 3mf

# Build all presets defined in JSON
make presets

# Generate a PNG preview image
make preview

# Clean build directory
make clean
```
