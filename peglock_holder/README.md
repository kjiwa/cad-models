# Peglock Holder

Parametric, 3D-printable open-front bin and organizer for Sy's Peglock modular pegboard system and standard 1/4" pegboards.

## Features

- **Dual Mounting Modes**: Toggle between Sy's Peglock modular locking wedge sockets and monolithic integrated pegboard pegs.
- **Parametric Capacity**: Configurable pocket dimensions (width, depth, height, rows, and columns).
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
3. Select a preset (e.g. `Single_Slot`, `Dual_Slot`, `Organizer_4_Slot`, `Deep_Bin`, `Showpiece_Tilted`) or customize parameters.
4. Press `F5` to preview or `F6` to render, then `F7` to export to STL.

---

## Parameters Reference

All dimensions are in millimeters unless otherwise noted.

### `[Mounting]`
| Parameter | Default | Description |
|---|---|---|
| `Mount_Type` | `"peglock"` | Mounting interface: `"peglock"` for modular socket, `"monolithic"` for integrated pins |

### `[Pegboard]`
| Parameter | Default | Description |
|---|---|---|
| `Peg_Spacing` | `25.4` | Center-to-center pegboard hole spacing in mm (25.4 for 1" standard, 15.875 for 5/8" metal) |
| `Peg_Diameter` | `5.7` | Pegboard hole / pin diameter in mm (sized for 1/4" holes with print tolerance) |
| `Pegboard_Thickness` | `6.35` | Pegboard sheet thickness in mm (standard 1/4" board, 1.5875 for thin metal) |
| `Hook_Rise` | `3.5` | Retention hook tab rise height behind the pegboard |

### `[Holder]`
| Parameter | Default | Description |
|---|---|---|
| `Holder_Width` | `12.7` | Interior pocket width of each bin cell |
| `Holder_Depth` | `6.35` | Interior pocket depth (front-to-back) of each bin cell |
| `Holder_Height` | `12.7` | Interior pocket height of each bin cell |
| `Holder_Closed_Bottom` | `true` | Adds a solid floor to each pocket when true; leaves the pocket open-bottom when false |
| `Holder_Front_Opening` | `6.35` | Width of the front access opening cut into each pocket |
| `Holder_Front_Opening_Front_Only` | `false` | When true, only cuts front opening on the front-most row, keeping multi-row divider walls solid |
| `Holder_Opening_Bevel` | `1.0` | Front opening lead-in bevel/chamfer in mm (0 to disable) |
| `Holder_Front_Lip_Thickness` | `3.175` | Thickness of the retaining lip along the front opening |
| `Holder_Front_Lip_Height` | `3.175` | Height of the retaining lip along the front opening |
| `Holder_Wall_Thickness` | `1.5875` | Thickness of the walls separating pockets |
| `Holder_Backer_Thickness` | `1.5875` | Thickness of the backplate behind the pockets; thicker stiffens the joint where the pockets meet the plate under heavy loads (no load rating is claimed) |
| `Holder_Vertical_Align` | `"bottom"` | Where the pockets sit on the backplate: `"bottom"` or `"center"` |
| `Holder_Roundover` | `3.175` | Fillet radius applied to backer and pocket edges |
| `Holder_Bottom_Roundover` | `0` | Radius rounding the pocket body's underside edges, except where it meets the plate; limited to `Holder_Wall_Thickness` (0 to disable) |
| `Holder_Tilt_Angle` | `0` | Forward tilt of the pockets in degrees, 0 to 45 (0 for vertical) |
| `Holder_Junction_Gusset` | `0` | Size of a triangular web under the pockets where they meet the plate, limited to the plate below them; open-bottom pockets cut through it (0 to disable) |
| `Holder_Rows` | `1` | Number of pocket rows stacked vertically |
| `Holder_Columns` | `1` | Number of pocket columns arranged side by side |

### `[Peglock]`
| Parameter | Default | Description |
|---|---|---|
| `Peglock_Width` | `22` | Width of each Peglock wedge mounting socket |
| `Peglock_Height` | `35.4` | Height of each Peglock wedge mounting socket |
| `Peglock_Depth` | `6` | Depth (front-to-back) of each Peglock wedge mounting socket |
| `Peglock_Spacing` | `25.4` | Center-to-center spacing between adjacent Peglock sockets (backward-compatible alias for `Peg_Spacing`) |
| `Peglock_Roundover` | `3.175` | Fillet radius applied to Peglock socket edges |

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
