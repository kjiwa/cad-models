# Peglock Hook

Parametric, 3D-printable tool hooks and socket racks for Sy's Peglock modular pegboard system and standard 1/4" pegboards.

## Features

- **Dual Mounting Modes**: Toggle between Sy's Peglock modular locking wedge sockets and monolithic integrated pegboard pegs.
- **Custom Hook Profiles**: Circle, square, triangle, and right triangle arm profiles.
- **Configurable Grid Layout**: Parametric row and column counts, spacing, arm length, and hooks per arm.
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

All lengths are in millimeters unless noted.

### `[Layout]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Columns` | `1` | | Number of hook columns |
| `Rows` | `1` | | Number of hook rows |
| `Column_Spacing` | `19.05` | | Center-to-center distance between hook columns (at least `Arm_Width`) |
| `Row_Spacing` | `19.05` | | Center-to-center distance between hook rows |
| `Vertical_Alignment` | `bottom` | `bottom`, `center` | Where the hooks sit on the backplate |

### `[Arm]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Arm_Shape` | `square` | `circle`, `square`, `triangle`, `right_triangle` | Cross-section profile of the hook arm |
| `Arm_Width` | `12.7` | | Width of the hook arm |
| `Arm_Length` | `6.35` | | Length of the hook arm from the backplate to the lip |
| `Arm_Height` | `6.35` | | Height of the hook arm |
| `Arm_Tilt_Angle` | `0` | | Upward tilt of the hook arm in degrees, 0 to 45 (0 for horizontal) |
| `Arm_Edge_Radius` | `1.5875` | | Radius of the rounded arm edges |
| `Hooks_Per_Arm` | `1` | | Number of hooks chained along each arm (1 to 5) |

### `[Lip]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Lip_Height` | `3.175` | | Height of the retaining lip above the arm |
| `Lip_Thickness` | `3.175` | | Thickness of the retaining lip |
| `Lip_Orientation` | `perpendicular` | `perpendicular`, `vertical` | Orientation of the retaining lip when the arm is tilted: square to the arm or parallel to the backplate; no effect at 0 degrees |

### `[Backplate]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Backplate_Thickness` | `1.5875` | | Thickness of the mounting backplate |
| `Root_Fillet_Radius` | `0` | | Stress relief fillet radius at the arm root (0 for standard/tested profile, above 0 to strengthen; proportionally clamped to arm length and lip height) |

### `[Pegboard]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Mount_Type` | `peglock` | `peglock`, `monolithic` | Mounting interface: modular Peglock wedge socket or monolithic integrated pegboard pegs |
| `Hole_Columns` | `0` | `0`-`10` | Pegboard hole columns the mount engages, as Peglock sockets or peg columns (0 = auto: as many sockets or pegs as fit within the body width) |
| `Hole_Spacing` | `25.4` | | Pegboard hole center spacing (25.4 for 1" standard, 15.875 for 5/8" metal) |
| `Pin_Diameter` | `5.7` | | Pin diameter (5.7 for standard 1/4" hole fit, 6.0 for original Sy fit) |
| `Pegboard_Thickness` | `6.35` | | Pegboard thickness (6.35 for 1/4" board, 1.5875 for 1/16" thin metal) |
| `Retention_Hook_Rise` | `3.5` | | Height of the retention hook tab behind the pegboard |

---

## 3D Printing Recommendations

- **Orientation**: Print flat on the build plate with the backer plate on the bed and hooks pointing vertically upward (+Z). Zero supports required.
- **Perimeters / Walls**: 4–6 perimeters. This ensures the hook arms and Peglock socket walls print 100% solid perimeters without hollow infill voids.
- **Infill**: 25–40% Gyroid or Grid for the backer plate.
- **Top / Bottom Shells**: 4–5 solid layers (at least 0.8–1.0 mm) for backplate rigidity under cantilever torque.
- **Material Selection**:
  - **PETG**: Recommended for workshop durability and impact resistance.
  - **PLA / Tough PLA**: Excellent stiffness and dimensional accuracy for socket racks and lighter tools. Increase hotend temperature by +5°C to maximize Z-layer tensile adhesion at the hook root.
- **Root Strengthening**: For hanging heavier tools, set `Root_Fillet_Radius = 1.6` to eliminate the sharp 90° corner where the hook meets the backplate.

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
