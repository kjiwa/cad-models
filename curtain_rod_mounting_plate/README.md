# Curtain Rod Mounting Plate

Parametric 3D-printable mounting plate to secure curtain rod brackets to walls or window trim.
Designed in inches and automatically scaled to millimeters on export for 3D printing.

## Features

- **Hex Nut Boss**: Raised rear boss block with captive hexagonal pockets to capture bracket mounting nuts flush behind the plate.
- **Dual Column Wall Mounting**: Symmetrical screw clearance holes on left and right margins with configurable hole counts and vertical spacing.
- **Top Edge Chamfers**: Clean architectural bevel along the front perimeter.
- **Customizer Compatible**: Documented parameters for the OpenSCAD Customizer GUI.
- **Automated CLI Build**: `Makefile` targets to export STL, 3MF, and PNG preview renders.

---

## Directory Structure

```text
curtain_rod_mounting_plate/
├── Makefile                        # Build automation for STL, 3MF, and PNG renders
├── README.md                       # Project documentation & printing recommendations
└── curtain_rod_mounting_plate.scad # Parametric OpenSCAD source model
```

---

## Using the OpenSCAD Customizer (GUI)

1. Open `curtain_rod_mounting_plate.scad` in OpenSCAD.
2. In the top menu, ensure **Window -> Customizer** is checked.
3. Adjust parameters in the Customizer panel.
4. Press `F5` to preview or `F6` to render, then `F7` to export to STL.

---

## Parameters Reference

All dimensional parameters in the model are defined in inches and scaled by 25.4 on export.

### `[Dimensions]`
| Parameter | Default | Description |
|---|---|---|
| `plate_width` | `6.0` | Total width of the plate in inches |
| `plate_height` | `4.0` | Total height of the plate in inches |
| `plate_thickness` | `0.25` | Plate thickness in inches |
| `chamfer_size` | `0.125` | Chamfer size along top edges in inches |

### `[Mounting Holes]`
| Parameter | Default | Description |
|---|---|---|
| `screw_hole_diameter` | `0.1875` | Screw clearance hole diameter in inches (#8 clearance ~5/32") |
| `hole_side_margin` | `0.5` | Inset from side edges to screw hole centers in inches |
| `holes_per_column` | `2` | Number of screw holes per side column |
| `hole_spacing` | `3.0` | Vertical center-to-center spacing between outermost holes in inches |

### `[Hex Nut Boss]`
| Parameter | Default | Description |
|---|---|---|
| `boss_height` | `1.5` | Height of the boss block in inches |
| `boss_width` | `0.5` | Width of the boss block in inches |
| `boss_thickness` | `0.25` | Rear protrusion of the boss block in inches |
| `boss_x_offset` | `0.0` | Lateral offset of the boss along X axis in inches |
| `hex_nut_flats_dia` | `0.328125` | Distance across flats for hex nut in inches (~5/16") |
| `hex_nut_depth` | `0.125` | Depth of captive hex nut pockets in inches |
| `hex_nut_count` | `2` | Number of captive hex nut pockets |
| `hex_nut_spacing` | `0.875` | Vertical center-to-center spacing between outermost hex nuts in inches |

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

---

## 3D Printing Recommendations

- **Material**: PETG or ABS/ASA recommended for creep resistance under screw clamping tension.
- **Print Orientation**: Flat on the build plate. If printed front-face down on a smooth PEI sheet, top chamfers form a clean bevel against the bed with no supports required. If printed rear-face down, support the area around the raised boss.
- **Walls / Perimeters**: 4 to 6 walls for solid material around screw clearance holes and hex pockets.
- **Infill**: 30% - 50% Gyroid or Honeycomb.
- **Top / Bottom Layers**: 4 to 5 layers.

