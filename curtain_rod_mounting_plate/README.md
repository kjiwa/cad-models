# Curtain Rod Mounting Plate

A parametric, 3D-printable mounting plate designed to secure curtain rod brackets to walls, window trims, or studs.

## Features

- **Fully Parametric**: Customizable plate dimensions, corner fillets, screw hole spacing, countersinks, and rod bracket attachment mounts.
- **OpenSCAD Customizer Compatible**: Fully documented parameters with interactive sliders, drop-down menus, and grouped tabs.
- **Presets Included**: Pre-configured JSON parameter sets (`Standard`, `Heavy_Duty`, `Compact_Slotted`).
- **Automated CLI Build**: `Makefile` support to render STL, 3MF, and PNG preview images from the terminal.

---

## Directory Structure

```text
curtain_rod_mounting_plate/
├── Makefile                                # Build automation for STL, 3MF, and PNG renders
├── README.md                               # Project documentation & printing recommendations
├── curtain_rod_mounting_plate.json         # Customizer preset configurations
└── curtain_rod_mounting_plate.scad         # Parametric OpenSCAD source model
```

---

## Using the OpenSCAD Customizer (GUI)

1. Open `curtain_rod_mounting_plate.scad` in OpenSCAD.
2. In the top menu, ensure **Window -> Customizer** is checked.
3. Uncheck **Design -> Hide Customizer** if visible.
4. Expand the parameter tabs (`Plate Dimensions`, `Mounting Holes`, `Rod Bracket Mount`, `Quality & Rendering`) in the Customizer panel on the right.
5. Select a pre-configured preset from the preset dropdown at the top of the Customizer panel, or adjust parameters directly.
6. Press `F5` to preview or `F6` to render, then `F7` to export to STL.

---

## Parameters Reference

### `[Plate Dimensions]`
| Parameter | Default | Range / Options | Description |
|---|---|---|---|
| `plate_width` | `80` | `30` - `200` mm | Total width (X axis) of the plate |
| `plate_height` | `50` | `20` - `150` mm | Total height (Y axis) of the plate |
| `plate_thickness` | `5` | `2` - `20` mm | Thickness (Z axis) of the plate |
| `corner_radius` | `6` | `0` - `25` mm | Fillet radius for rounded corners (0 for sharp corners) |

### `[Mounting Holes]`
| Parameter | Default | Range / Options | Description |
|---|---|---|---|
| `hole_pattern` | `4_corners` | `4_corners`, `2_horizontal`, `2_vertical` | Layout pattern for wall mounting screws |
| `screw_hole_diameter` | `4.5` | `2.0` - `10.0` mm | Screw shank clearance hole diameter |
| `hole_edge_margin` | `10` | `4.0` - `30.0` mm | Inset distance from edges to hole centers |
| `countersink_enable` | `true` | `true` / `false` | Add conical countersink for flathead screws |
| `countersink_diameter` | `8.5` | `4.0` - `16.0` mm | Outer top rim diameter of countersink |
| `countersink_angle` | `90` | `90` (Metric) / `82` (US) | Included angle of countersink cone |

### `[Rod Bracket Mount]`
| Parameter | Default | Range / Options | Description |
|---|---|---|---|
| `mount_type` | `center_hole` | `none`, `center_hole`, `slotted`, `pilot_holes` | Type of bracket attachment cutout |
| `center_hole_diameter`| `6.5` | `2.0` - `20.0` mm | Diameter of central bolt or screw hole |

### `[Quality & Rendering]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `render_quality` | `standard` | `preview`, `standard`, `fine`, `production` | Controls polygon facet resolution (`$fn`) |

---

## CLI Build & Automation

Run `make` commands from this directory or from the root repository directory:

```bash
# Build default STL, 3MF, all JSON presets, and preview PNG
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

Outputs will be generated in the `build/` subdirectory.

---

## 3D Printing Recommendations

- **Material**: PETG or ABS/ASA recommended for durability and resistance to screw tension creep (PLA is acceptable for lightweight curtains).
- **Print Orientation**: Flat on the build plate (Z=0 on bed) for maximum shear strength and clean countersinks without supports.
- **Walls / Perimeters**: 4 to 6 perimeters (ensures screw holes and bracket mounting areas are mostly solid plastic).
- **Infill**: 30% - 50% Gyroid or Honeycomb for uniform load distribution.
- **Top / Bottom Layers**: 4 to 5 layers.
