# Peglock Attachment

Parametric, 3D-printable board attachment clip for Sy's Peglock modular pegboard system.

Prints flat with an integrated 0.2 mm living hinge. After printing, fold 180° in half and insert into the pegboard holes. Accessories (`peglock_holder`, `peglock_hook`) slide downward over the male wedge, locking the folded halves together and anchoring securely to the board.

## Features

- **Flat Support-Free Printing**: Prints flat on the build plate with layer lines oriented along the pegs for maximum shear strength.
- **Parametric Pegboard Sizing**: Configurable hole spacing, peg diameter, and board thickness.
- **Living Hinge**: 0.2 mm central hinge folds 180° without hardware.
- **Tapered Dovetail Wedge**: Forms a solid locking wedge when folded that mates with all Peglock sockets.
- **Customizer Presets**: Presets for standard 1/4" pegboard (5.7 mm snug fit), Sy's original 6.0 mm model, and thin metal pegboards.

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
3. Select a preset (e.g. `Default (Standard 1/4" - 5.7mm Fit)`, `Sy's Original (6.0mm)`, or `Potting Bench (Thin Metal)`) from the preset dropdown, or customize parameters.
4. Press `F5` to preview or `F6` to render, then `F7` to export to STL.

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

- **Material**: PETG is recommended for flexibility and fatigue resistance in the living hinge. Tough PLA or standard PLA also works well if folded slowly when warm.
- **First Layer Height**: 0.20 mm (critical for ensuring the living hinge is exactly one layer thick).
- **Perimeters / Walls**: 3–4 perimeters so that the pins and hooks print mostly or fully solid.
- **Infill**: 20–30% Gyroid or Grid.
- **Orientation**: Print flat on the build plate (pegs pointing upward, hinge flat on the bed). Zero supports needed.
