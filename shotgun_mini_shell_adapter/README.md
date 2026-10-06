# Shotgun Mini Shell Adapter

A 3D-printable adapter for Mossberg 12 gauge shotguns that holds 1.75" (44.45 mm) mini shells. It is compatible with the fit of the commercial OPSol Mini-Clip; this is an independent design.

## Features

- **Fit-Critical Dimensions**: Every default is tuned to the receiver and shell. Change them only with a test print.
- **Support-Free**: The sloped front faces are 45 degrees and the rear notch is a 2 mm bridge.

---

## Directory Structure

```text
shotgun_mini_shell_adapter/
├── Makefile
├── README.md
├── shotgun_mini_shell_adapter.json     # Customizer preset configurations
└── shotgun_mini_shell_adapter.scad     # Parametric OpenSCAD source model
```

---

## Parameters Reference

All lengths are in millimeters.

### `[Overall Dimensions]`
| Parameter | Default | Description |
|---|---|---|
| `Length` | `35` | Adapter length along the barrel (X) |
| `Width` | `26` | Adapter width across the receiver (Y) |
| `Height` | `20.5` | Adapter height (Z) |

### `[Rear Cutout]`
| Parameter | Default | Description |
|---|---|---|
| `Rear_Cutout_Height` | `9.5` | Height of the notch across the rear |
| `Rear_Cutout_Depth` | `2` | Depth of the notch into the rear face |

### `[Front Cutout]`
| Parameter | Default | Description |
|---|---|---|
| `Front_Cutout_Depth` | `7` | Depth of the square notch across the front |
| `Front_Angled_Cutout_Angle` | `45` | Angle of the sloped front cut from vertical |
| `Front_Angled_Cutout_Offset_Z` | `4` | Height at which the sloped front cut starts, below the base |

### `[Top Side Cutouts]`
| Parameter | Default | Description |
|---|---|---|
| `Top_Side_Cutout_Depth` | `4.75` | Depth of the relief cut into each side of the top |
| `Top_Side_Cutout_Slope_Offset_X` | `-2.5` | Position along X where the side slope starts |
| `Top_Side_Cutout_Slope_Rise` | `2.5` | Rise of the side slope over its run |
| `Top_Side_Cutout_Slope_Run` | `11` | Run of the side slope over its rise |

### `[Top Cylindrical Cutout]`
| Parameter | Default | Description |
|---|---|---|
| `Top_Cylindrical_Cutout_Diameter` | `12.7` | Diameter of the shell bore (12.7 for 1/2") |
| `Top_Cylindrical_Cutout_Depth` | `18.35` | Depth of the shell bore |
| `Top_Cylindrical_Cutout_Offset_X` | `2.5` | Distance from the rear face to the bore edge along X |

### `[Top Rectangular Cutout]`
| Parameter | Default | Description |
|---|---|---|
| `Top_Rectangular_Cutout_Corner_Radius` | `1.5` | Corner radius of the slot ahead of the bore |
| `Top_Rectangular_Cutout_Width` | `9.9` | Width of the slot (Y) |
| `Top_Rectangular_Cutout_Depth` | `12.5` | Depth of the slot |
| `Top_Rectangular_Cutout_Offset_From_Cylinder` | `1` | Gap between the bore and the slot along X |

### Presets

- `Mossberg_12ga_1_75in`: the defaults.

---

## CLI Build

```bash
make all       # STL, 3MF, preview PNG, and presets
make bundle    # single-file .scad in ../dist/
```

Outputs are generated in `build/`.

---

## 3D Printing Recommendations

- **Material**: TPU or another flexible filament, since the adapter flexes to seat in the receiver.
- **Print Orientation**: As modelled, flat on the bottom face with the shell bore vertical. No supports are needed (the largest overhang is a 2 mm bridge at the rear notch and 45 degree faces at the front), the bore wall prints as continuous perimeters, and the bottom face gives the largest bed contact.
- **Walls / Perimeters**: 4 or more perimeters; the bore wall beside each top relief is under 2 mm thick.
- **Testing**: Cycled with snap caps only. It has not been tested with live shells.
