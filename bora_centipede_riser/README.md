# Bora Centipede Parametric Risers

Parametric, hardware-compatible risers and locking nuts for Bora Centipede work stands.

Bora sells 6" risers that raise the stands to 36". However, when using a sheet of plywood or workbench top, the working height rises to 36-3/4", which is too high to serve as an infeed or outfeed table for 36" table saws. This model allows customizable riser heights, including 5-1/4" risers (133.35 mm) to account for workbench top thickness, as well as the standard 6" height (152.4 mm) and matching knurled locking nuts.

Original design published on [Printables](https://www.printables.com/model/890834-bora-centipede-parametric-risers).

## Features

- **Hardware Compatibility**: Matches Bora Centipede top thread and base mount dimensions.
- **Parametric Height & Diameter**: Configurable overall height, web thickness, and cutouts.
- **Integrated Locking Nut**: Knurled perimeter with internal metric threading.
- **Truss Web Structure**: Arch cutouts reduce material consumption and print time while preserving axial load capacity.
- **Customizer Presets**: Predefined configurations for 5.25" risers, 6" risers, and locking nuts.
- **Automated CLI Build**: `Makefile` support to render STL, 3MF, and PNG preview images.

---

## Directory Structure

```text
bora_centipede_riser/
├── Makefile                   # Build automation for STL, 3MF, and PNG renders
├── README.md                  # Project documentation & printing recommendations
├── bora_centipede_riser.json  # Customizer parameter presets
├── bora_centipede_riser.scad  # Parametric OpenSCAD source model
├── threads-scad               # Symlink to ../lib/threads-scad submodule
└── threads.scad               # Symlink to ../lib/threads-scad/threads.scad
```

---

## Using the OpenSCAD Customizer (GUI)

1. Open `bora_centipede_riser.scad` in OpenSCAD.
2. In the top menu, ensure **Window -> Customizer** is checked.
3. Select a preset from the dropdown (`5.25in`, `6in`, or `Nut`) or customize parameters.
4. Press `F5` to preview or `F6` to render, then `F7` to export to STL.

---

## Parameters Reference

All dimensions are in millimeters unless otherwise noted.

### `[General]`
| Parameter | Default | Description |
|---|---|---|
| `Riser_Or_Nut` | `"Riser"` | Component to render: `"Riser"` or `"Nut"` |

### `[Riser]`
| Parameter | Default | Description |
|---|---|---|
| `Riser_Height` | `152.4` | Overall riser height (6 inches = 152.4 mm; 5.25 inches = 133.35 mm) |
| `Riser_Diameter` | `66` | Outside diameter of the riser body |

### `[Riser Top Cap]`
| Parameter | Default | Description |
|---|---|---|
| `Riser_Top_Thickness` | `3` | Top cap plate thickness |
| `Riser_Top_Thread_Platform_Diameter` | `15` | Diameter of the raised thread boss |
| `Riser_Top_Thread_Platform_Height` | `6` | Height of the raised thread boss |
| `Riser_Top_Thread_Pitch` | `2` | Thread pitch in mm |
| `Riser_Top_Thread_Height` | `10` | Height of the threaded stud |
| `Riser_Top_Thread_Width` | `12.5` | Outer diameter of the threaded stud |

### `[Riser Bottom Cap]`
| Parameter | Default | Description |
|---|---|---|
| `Riser_Bottom_Thickness` | `6` | Bottom cap plate thickness |
| `Riser_Bottom_Screw_Cutout_Diameter` | `16` | Clearance hole for mounting screw |
| `Riser_Bottom_Nut_Cutout_Diameter` | `27` | Recess diameter for stand nut |
| `Riser_Bottom_Nut_Cutout_Height` | `32.75` | Depth of bottom nut cavity |
| `Riser_Bottom_Nut_Cutout_Corner_Radius` | `6.25` | Fillet radius for bottom cavity |

### `[Supports]`
| Parameter | Default | Description |
|---|---|---|
| `Riser_Support_Thickness` | `3` | Wall thickness of crossed vertical ribs |
| `Riser_Support_Inner_Diameter` | `46` | Inner diameter of rib cutouts |
| `Riser_Support_Inner_Cutout_Offset` | `4` | Offset for rib cutouts from caps |

### `[Nut]`
| Parameter | Default | Description |
|---|---|---|
| `Nut_Diameter` | `22` | Outer diameter of the locking nut |
| `Nut_Height` | `6.35` | Thickness of the locking nut (1/4 inch) |
| `Nut_Thread_Width` | `13.5` | Inner thread diameter (includes clearance) |
| `Nut_Knurl_Count` | `15` | Number of grip notches on perimeter |
| `Nut_Knurl_Diameter` | `1` | Diameter of knurl cutout cylinder |

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

# Generate preview PNG
make preview

# Build all presets defined in bora_centipede_riser.json
make presets

# Clean build directory
make clean
```

Outputs are generated in the `build/` subdirectory:
- `build/bora_centipede_riser.stl` / `.3mf` / `_preview.png` (default 6" riser)
- `build/bora_centipede_riser_5_25in.stl` / `.3mf` / `_preview.png` (5.25" riser preset)
- `build/bora_centipede_riser_6in.stl` / `.3mf` / `_preview.png` (6" riser preset)
- `build/bora_centipede_riser_Nut.stl` / `.3mf` / `_preview.png` (Nut preset)

---

## 3D Printing Recommendations

- **Material**: PLA or PETG (PLA provides good compressive stiffness for vertical load).
- **Print Orientation**: Upright on the flat base (no supports required).
- **Layer Height**: 0.30 mm draft works well and reduces print time.
- **Perimeters**: 3 to 4 walls for strength.
- **Infill**: 15% - 20% Gyroid or Grid.
