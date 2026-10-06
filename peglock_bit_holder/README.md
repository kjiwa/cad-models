# Peglock Bit Holder

Parametric, 3D-printable hex bit holder for Sy's Peglock modular pegboard system and standard 1/4" pegboards. Tilted tiers of hexagonal pockets hold 1/4" hex shank drill and driver bits, with a grip slot along each row for lifting bits out.

## Features

- **Dual Mounting Modes**: Toggle between Sy's Peglock modular locking wedge sockets and monolithic integrated pegboard pegs.
- **Tilted Tiers**: Rows of hexagon pockets lean forward so bits sit at an angle, stacked as a sawtooth with a solid wedge under each tier.
- **Grip Slot**: A relief slot runs along each row through the hex corners and dividers, so bits can be pinched out.
- **Entry Chamfer and Rounded Edges**: Each pocket mouth has a lead-in, and the outer edges of the body are rounded.
- **Customizer Compatible**: Designed for use in the OpenSCAD Customizer with parameter controls.
- **Automated CLI Build**: `Makefile` support to render STL, 3MF, presets, and PNG preview images.

---

## Directory Structure

```text
peglock_bit_holder/
├── Makefile                    # Build automation for STL, 3MF, presets, and PNG renders
├── README.md                   # Documentation and printing recommendations
├── peglock_bit_holder.json     # Customizer preset configurations
├── peglock_bit_holder.scad     # Parametric OpenSCAD source model
├── BOSL2                       # Relative symlink to ../lib/BOSL2
├── pegboard                    # Relative symlink to ../lib/pegboard
└── peglock                     # Relative symlink to ../lib/peglock
```

---

## Using the OpenSCAD Customizer (GUI)

1. Open `peglock_bit_holder.scad` in OpenSCAD.
2. In the top menu, ensure **Window -> Customizer** is checked.
3. Select a preset (`Hex_Bit_1_4in`) or customize parameters.
4. Press `F5` to preview or `F6` to render, then `F7` to export to STL.

---

## Parameters Reference

All lengths are in millimeters unless noted.

### `[Layout]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Columns` | `10` | `1` to `20`, step `1` | Number of bits per row |
| `Rows` | `2` | `1` to `6`, step `1` | Number of stacked tiers |

### `[Pocket]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Bit_Width` | `6.75` | | Hex shank width across flats, including clearance (6.75 for 1/4" bits) |
| `Pocket_Height` | `15` | | Depth of each pocket |
| `Wall_Thickness` | `2.68` | | Thickness of the thinnest wall, at the hex corners |
| `Relief_Width` | `1.5875` | | Width of the grip slot along each row (0 to disable) |
| `Tilt_Angle` | `15` | `5` to `45`, step `5` | Forward tilt of each tier in degrees |
| `Entry_Chamfer` | `0.5` | | Lead-in at each pocket mouth (0 to disable) |
| `Corner_Radius` | `1` | | Radius of the rounded outer edges of the body; the plate is narrowed by this radius on each side (0 to disable) |

### `[Backplate]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Backplate_Thickness` | `1.5875` | | Thickness of the backplate behind the pockets |

### `[Pegboard]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Mount_Type` | `peglock` | `peglock`, `monolithic` | Mounting interface: modular Peglock wedge socket or monolithic integrated pegboard pegs |
| `Hole_Columns` | `0` | `0`-`10` | Pegboard hole columns the mount engages, as Peglock sockets or peg columns (0 = auto: as many as fit within the body width) |
| `Hole_Spacing` | `25.4` | | Pegboard hole center spacing (25.4 for 1" standard, 15.875 for 5/8" metal) |
| `Pin_Diameter` | `5.7` | | Pin diameter (5.7 for standard 1/4" hole fit, 6.0 for original Sy fit) |
| `Pegboard_Thickness` | `6.35` | | Pegboard thickness (6.35 for 1/4" board, 1.5875 for 1/16" thin metal) |
| `Retention_Hook_Rise` | `3.5` | | Height of the retention hook tab behind the pegboard |
| `Stabilizing_Pin_Pattern` | `all` | `all`, `top_and_bottom`, `top`, `bottom`, `none` | Stabilizing pin rows below the retention hooks (`bottom` is the lowest hole; ignored by the Peglock socket mount) |

---

## 3D Printing Recommendations

- **Orientation**: Print upright as exported, with the pockets opening upward (+Z). The solid wedge under each tier carries the tilted pocket floor.
- **Perimeters / Walls**: 3-4 perimeters, so the walls between pockets are solid plastic.
- **Material Selection**: PETG or PLA.

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
