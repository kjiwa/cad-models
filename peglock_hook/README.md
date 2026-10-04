# Peglock Hook

Parametric, 3D-printable tool hooks and socket racks for Sy's Peglock modular pegboard system and standard 1/4" pegboards.

## Features

- **Dual Mounting Modes**: Toggle between Sy's Peglock modular locking wedge sockets and monolithic integrated pegboard pegs.
- **Custom Hook Profiles**: Circle, Square, Triangle, and RightTriangle profiles.
- **Configurable Grid Layout**: Parametric row and column counts, spacing, depth, and item capacity.
- **Stress-Relief Root Fillet**: Optional parametric fillet at the hook arm root to resist cantilever shear.
- **Presets Included**: Pre-configured JSON parameter sets for socket racks (`Sockets (1/4)`, `Sockets (3/8)`, `Sockets (1/2)`) and a tilted vertical-lip hook (`Tilted_Vertical_Lip`).
- **Automated CLI Build**: `Makefile` support to render base models and all JSON parameter presets.

---

## Directory Structure

```text
peglock_hook/
├── Makefile                # Build automation for STL, 3MF, presets, and PNG renders
├── README.md               # Documentation and printing recommendations
├── peglock_hook.json       # Customizer preset configurations (socket sets)
├── peglock_hook.scad       # Parametric OpenSCAD source model
├── BOSL2                   # Relative symlink to ../lib/BOSL2
├── pegboard                # Relative symlink to ../lib/pegboard
└── peglock                 # Relative symlink to ../lib/peglock
```

---

## Using the OpenSCAD Customizer (GUI)

1. Open `peglock_hook.scad` in OpenSCAD.
2. In the top menu, ensure **Window -> Customizer** is checked.
3. Select a preset (e.g. `Sockets (1/4)`) from the preset dropdown, or customize parameters.
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

### `[Hook]`
| Parameter | Default | Description |
|---|---|---|
| `Hook_Shape` | `"Square"` | Cross-sectional profile of the hook: `Circle`, `Square`, `Triangle`, or `RightTriangle` |
| `Hook_Width` | `12.7` | Width of each hook arm |
| `Hook_Height` | `6.35` | Height of each hook arm |
| `Hook_Depth` | `6.35` | Depth (front-to-back) of each hook arm's straight section |
| `Hook_Wall_Thickness` | `1.5875` | Thickness of the backer plate behind the hooks |
| `Hook_Lip_Thickness` | `3.175` | Thickness of the retaining lip capping each hook arm |
| `Hook_Lip_Height` | `3.175` | Height the retaining lip rises above the hook arm to catch hung items |
| `Hook_Roundover` | `1.5875` | Fillet radius applied to hook and backer edges |
| `Hook_Root_Fillet` | `0` | Fillet radius at hook arm root to eliminate stress concentration (0 to disable; proportionally clamped to hook depth and lip height) |
| `Hook_Tilt_Angle` | `0` | Upward tilt of the hook arm in degrees, 0 to 45 (0 for horizontal) |
| `Hook_Lip_Orientation` | `"perpendicular"` | Retaining lip orientation when tilted: `"perpendicular"` (square to the arm) or `"vertical"` (parallel to the backplate); no effect at 0 degrees |
| `Hook_Vertical_Align` | `"bottom"` | Where the hooks sit on the backplate: `"bottom"` or `"center"` |
| `Hook_Rows` | `1` | Number of hook rows stacked vertically |
| `Hook_Columns` | `1` | Number of hook columns arranged side by side |
| `Hook_Item_Quantity` | `1` | Number of hooks printed back-to-back at each grid position, for hanging multiple items per socket |
| `Hook_Row_Spacing` | `19.05` | Center-to-center vertical spacing between hook rows |
| `Hook_Column_Spacing` | `19.05` | Center-to-center horizontal spacing between hook columns |

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

- **Orientation**: Print flat on the build plate with the backer plate on the bed and hooks pointing vertically upward (+Z). Zero supports required.
- **Perimeters / Walls**: 4–6 perimeters. This ensures the hook arms and Peglock socket walls print 100% solid perimeters without hollow infill voids.
- **Infill**: 25–40% Gyroid or Grid for the backer plate.
- **Top / Bottom Shells**: 4–5 solid layers (at least 0.8–1.0 mm) for backplate rigidity under cantilever torque.
- **Material Selection**:
  - **PETG**: Recommended for workshop durability and impact resistance.
  - **PLA / Tough PLA**: Excellent stiffness and dimensional accuracy for socket racks and lighter tools. Increase hotend temperature by +5°C to maximize Z-layer tensile adhesion at the hook root.
- **Root Strengthening**: For hanging heavier tools, set `Hook_Root_Fillet = 1.6` to eliminate the sharp 90° corner where the hook meets the backplate.

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
