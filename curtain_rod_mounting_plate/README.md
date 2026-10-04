# Curtain Rod Mounting Plate

Parametric 3D-printable mounting plate to secure curtain rod brackets to walls or window trim.
All dimensions are in millimeters.

## Features

- **Hex Nut Boss**: Raised rear boss block with captive hexagonal pockets to capture bracket mounting nuts flush behind the plate.
- **Dual Column Wall Mounting**: Symmetrical screw clearance holes on left and right margins with configurable hole counts and vertical span.
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

All dimensions are in millimeters.

### `[Plate]`
| Parameter | Default | Description |
|---|---|---|
| `Plate_Width` | `152.4` | Width of the mounting plate (6") |
| `Plate_Height` | `101.6` | Height of the mounting plate (4") |
| `Plate_Thickness` | `6.35` | Thickness of the mounting plate (1/4") |
| `Edge_Chamfer` | `3.175` | Chamfer size along the top edges (1/8") |

### `[Screw Holes]`
| Parameter | Default | Description |
|---|---|---|
| `Screw_Hole_Diameter` | `4.7625` | Diameter of the wall screw holes and bracket screw holes through the boss (3/16", #8 screws) |
| `Holes_Per_Side` | `2` | Number of wall screw holes per side |
| `Hole_Span` | `76.2` | Vertical center-to-center distance between the outermost holes on each side (3") |
| `Hole_Edge_Inset` | `12.7` | Distance from the side edge to the screw hole centers (1/2") |

### `[Nut Boss]`
| Parameter | Default | Description |
|---|---|---|
| `Boss_Width` | `12.7` | Width of the boss block (1/2") |
| `Boss_Height` | `38.1` | Height of the boss block (1-1/2") |
| `Boss_Thickness` | `6.35` | Rear protrusion of the boss block (1/4") |
| `Boss_Offset` | `0` | Offset of the boss along X from the plate center |
| `Nut_Count` | `2` | Number of hex nut pockets |
| `Nut_Span` | `22.225` | Vertical center-to-center distance between the outermost nut pockets (7/8") |
| `Nut_Width_Across_Flats` | `8.334375` | Distance across the flats of the hex nut (21/64") |
| `Nut_Pocket_Depth` | `3.175` | Depth of each hex nut pocket (1/8") |
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

