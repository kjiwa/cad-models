# Pipe Clamp Wall Mount

A 3D-printable wall rack of angled pipe clamps. One block holds several pipes, each in an opening that leans back toward the wall, with screws driven through the back wall between the openings.

## Features

- **Angled Openings**: Pipes lean back into the wall so they stay put.
- **Counterbored Screw Holes**: One hidden screw per pipe.
- **Stackable**: A tip on top and a matching socket underneath align blocks end to end.

---

## Directory Structure

```text
pipe_clamp_wall_mount/
├── Makefile
├── README.md
├── pipe_clamp_wall_mount.scad     # Parametric OpenSCAD source model
└── BOSL2     # Relative symlink to ../lib/BOSL2
```

---

## Parameters Reference

All lengths are in millimeters.

### `[Holders]`
| Parameter | Default | Description |
|---|---|---|
| `Holder_Count` | `4` | Number of pipe openings |
| `Pipe_Diameter` | `28.575` | Pipe outside diameter (28.575 for 1-1/8") |
| `Pipe_Spacing` | `12.7` | Gap between neighboring pipes (12.7 for 1/2") |
| `Holder_Width` | `25.4` | Width of the block (X) (25.4 for 1") |
| `Back_Wall_Thickness` | `12.7` | Thickness of the wall behind the pipes (12.7 for 1/2") |
| `Opening_Angle` | `30` | Angle the openings lean from horizontal, so pipes stay put |

### `[Alignment Notch]`
| Parameter | Default | Description |
|---|---|---|
| `Notch_Bottom_Width` | `6.35` | Notch width at its base (6.35 for 1/4") |
| `Notch_Top_Width` | `3.175` | Notch width at its tip (3.175 for 1/8") |
| `Notch_Height` | `3.175` | Notch height, a male tip on top and a female socket on the bottom for stacking blocks (3.175 for 1/8") |

### `[Screw Holes]`
| Parameter | Default | Description |
|---|---|---|
| `Screw_Head_Diameter` | `15.875` | Counterbore head diameter (15.875 for 5/8") |
| `Screw_Hole_Diameter` | `4.7625` | Screw shank hole diameter (4.7625 for 3/16") |
| `Screw_Hole_Depth` | `9.525` | Depth of the shank hole behind each pipe (9.525 for 3/8") |

The defaults fit 1-1/8" pipe.

---

## CLI Build

```bash
make all       # STL, 3MF, preview PNG, and presets
make bundle    # single-file .scad in ../dist/
```

Outputs are generated in `build/`.

---

## 3D Printing Recommendations

- **Material**: PETG or ABS/ASA.
