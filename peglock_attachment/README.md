# Peglock Attachment

Parametric, 3D-printable board attachment clip for Sy's Peglock modular pegboard system.

Prints flat with an integrated 0.2 mm living hinge. After printing, fold 180° in half and insert into the pegboard holes. Accessories (`peglock_holder`, `peglock_hook`) slide downward over the male wedge, locking the folded halves together and anchoring securely to the board.

## Features

- **Flat Support-Free Printing**: Prints flat on the build plate with layer lines oriented along the pegs for maximum shear strength.
- **Parametric Pegboard Sizing**: Configurable hole spacing, peg diameter, and board thickness.
- **Living Hinge**: 0.2 mm central hinge folds 180° without hardware.
- **Tapered Dovetail Wedge**: Forms a solid locking wedge when folded that mates with all Peglock sockets.
- **Customizer Presets**: Defaults fit standard 1/4" pegboard (5.7 mm snug fit); presets cover Sy's original 6.0 mm model and thin metal pegboards.

---

## Directory Structure

```text
peglock_attachment/
├── Makefile                   # Build automation for STL, 3MF, presets, and PNG renders
├── README.md                  # Documentation and printing recommendations
├── peglock_attachment.json    # Customizer preset configurations
├── peglock_attachment.scad    # Parametric OpenSCAD source model
├── BOSL2                      # Relative symlink to ../lib/BOSL2
└── peglock                    # Relative symlink to ../lib/peglock
```

---

## Using the OpenSCAD Customizer (GUI)

1. Open `peglock_attachment.scad` in OpenSCAD.
2. In the top menu, ensure **Window -> Customizer** is checked.
3. Select a preset (`Sys_Original_6mm` or `Thin_Metal_5_8in`) from the preset dropdown, or customize parameters.
4. Press `F5` to preview or `F6` to render, then `F7` to export to STL.

---

## Parameters Reference

All lengths are in millimeters unless noted.

### `[Pegboard]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Hole_Spacing` | `25.4` | | Pegboard hole center spacing (25.4 for 1" standard, 15.875 for 5/8" metal) |
| `Pin_Diameter` | `5.7` | | Pin diameter (5.7 for standard 1/4" hole fit, 6.0 for original Sy fit) |
| `Pegboard_Thickness` | `6.35` | | Pegboard thickness (6.35 for 1/4" board, 1.5875 for 1/16" thin metal) |
| `Retention_Hook_Rise` | `6.0` | | Height of the retention hook tab behind the pegboard |

---

## CLI Build & Automation

Run `make` commands from this directory or from the root repository directory:

```bash
# Build default STL, 3MF, preview PNG, and all presets
make all

# Build only default STL
make stl

# Build only default 3MF
make 3mf

# Generate a PNG preview image
make preview

# Build all parameter presets
make presets

# Clean build directory
make clean
```

---

## 3D Printing Recommendations

- **Orientation**: Print flat on the build plate (pegs pointing upward, hinge flat on the bed). Zero supports needed. Layer lines run parallel to the peg shank, maximizing shear resistance under load.
- **First Layer Height**: Exactly `0.20 mm` (critical for ensuring the 0.20 mm living hinge is extruded as a single continuous layer of filament).
- **First Layer Speed**: 20–25 mm/s to ensure clean bed adhesion across the narrow 0.5 mm hinge gap.
- **Perimeters / Walls**: 4–5 perimeters. The pegs and retention hooks should be 100% solid perimeters with no interior infill voids for maximum shear strength.
- **Infill**: 20–30% Gyroid or Grid for the wedge body.
- **Material Selection**:
  - **PETG**: Highly recommended. PETG offers high elongation at break and fatigue endurance, allowing the 0.2 mm living hinge to fold 180° repeatedly without stress-whitening or snapping.
  - **PLA / Tough PLA**: Can be used with proper handling. Fold the hinge immediately upon print completion while the bed/part is still warm (~50–60°C), or run the hinge line under hot tap water before the initial 180° fold.
- **Assembly**: Fold the clip 180° in half so the two wedge halves face together, insert the upper hook and lower peg into the pegboard holes, then slide an accessory (`peglock_hook`, `peglock_holder`) downward over the male wedge to lock both halves firmly into the board.
