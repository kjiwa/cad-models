# Peglock Holder

Parametric, 3D-printable open-front bin and organizer for Sy's Peglock modular pegboard system and standard 1/4" pegboards.

## Features

- **Dual Mounting Modes**: Toggle between Sy's Peglock modular locking wedge sockets and monolithic integrated pegboard pegs.
- **Parametric Capacity**: Configurable pocket dimensions (width, depth, height, rows, and columns) and a separate width and depth per column.
- **Multi-Row Organization**: Independent pockets with intact internal partitions or continuous open slots.
- **Customizer Compatible**: Designed for use in the OpenSCAD Customizer with parameter controls.
- **Automated CLI Build**: `Makefile` support to render STL, 3MF, presets, and PNG preview images.

---

## Directory Structure

```text
peglock_holder/
├── Makefile                # Build automation for STL, 3MF, presets, and PNG renders
├── README.md               # Documentation and printing recommendations
├── peglock_holder.json     # Customizer preset configurations
├── peglock_holder.scad     # Parametric OpenSCAD source model
├── BOSL2                   # Relative symlink to ../lib/BOSL2
├── pegboard                # Relative symlink to ../lib/pegboard
└── peglock                 # Relative symlink to ../lib/peglock
```

---

## Using the OpenSCAD Customizer (GUI)

1. Open `peglock_holder.scad` in OpenSCAD.
2. In the top menu, ensure **Window -> Customizer** is checked.
3. Select a preset (e.g. `Single_Slot`, `Dual_Slot`, `Organizer_4_Slot`, `Deep_Bin`, `Showpiece_Tilted`, `Knife_Holder`, `Olfa_Knife_Holder`, `Thin_Olfa_Knife_Holder`) or customize parameters.
4. Press `F5` to preview or `F6` to render, then `F7` to export to STL.

---

## Parameters Reference

All lengths are in millimeters unless noted.

### `[Layout]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Columns` | `1` | | Number of pocket columns |
| `Rows` | `1` | | Number of pocket rows |
| `Vertical_Alignment` | `bottom` | `bottom`, `center` | Where the pockets sit on the backplate; bottom is centered once the body nearly fills the plate |

### `[Pocket]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Pocket_Widths` | `12.7` | | Inner width of each pocket: one value for every column or one comma-separated value per column (12.7 for 1/2") |
| `Pocket_Depths` | `6.35` | | Inner depth of each pocket, same format as `Pocket_Widths` |
| `Pocket_Height` | `12.7` | | Inner height of each pocket |
| `Tilt_Angle` | `0` | | Forward tilt of the pockets in degrees, 0 to 45 (0 for vertical) |
| `Closed_Bottom` | `true` | | Close the pocket bottoms |
| `Wall_Thickness` | `1.5875` | | Thickness of the pocket walls |
| `Corner_Radius` | `3.175` | | Radius of the rounded pocket body corners (0 for square corners) |
| `Bottom_Edge_Radius` | `0` | | Rounds the pocket body's underside edges, except where it meets the plate; limited to `Wall_Thickness` (0 to disable) |

### `[Front]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Lip_Height` | `3.175` | | Height of the front lip (0 for no lip) |
| `Lip_Thickness` | `3.175` | | Thickness of the front lip |
| `Opening_Width` | `6.35` | | Width of the front access opening (0 for none) |
| `Opening_Chamfer` | `1.0` | | Front opening lead-in chamfer (0 to disable) |
| `Opening_Front_Row_Only` | `false` | | Only cut the front access opening on the front-most row when multi-row |

### `[Backplate]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Backplate_Thickness` | `1.5875` | | Thickness of the backplate behind the pockets; thicker resists flex under heavy loads (no load rating is claimed) |
| `Junction_Gusset` | `0` | | Size of the triangular web under the pockets where they meet the plate, clamped to the plate below them; open-bottom pockets cut through it (0 to disable) |

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

- **Orientation**: Print upright on its base with pockets opening facing upward (+Z). Zero supports required (the 45° lead-in chamfer of the female Peglock socket prints cleanly without sagging).
- **Perimeters / Walls**: 3–4 perimeters. This makes the 1.5875 mm pocket dividers and side walls 100% solid plastic, maximizing stiffness and preventing infill chatter.
- **Infill**: 20–25% Gyroid or Grid for the mounting block.
- **Bottom / Top Layers**: 4–5 solid bottom layers (at least 0.8–1.0 mm) for a rigid, durable floor when holding hardware or metal tools.
- **Material Selection**:
  - **PETG**: Recommended for chemical resistance, oil resistance, and drop toughness in workshop environments.
  - **PLA / PLA+**: Rigid and easy to print with clean vertical wall dimensional accuracy.

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
