# Wheel Tread Cover

A 3D-printable sleeve with a herringbone tread that slips over a wheel to add grip.

## Features

- **Herringbone Tread**: A star profile twisted along the width and mirrored about the middle.
- **Parametric Fit**: Set the inside diameter, width, wall thickness, and ridge count.

---

## Directory Structure

```text
wheel_tread_cover/
├── Makefile
├── README.md
├── wheel_tread_cover.scad     # Parametric OpenSCAD source model
└── BOSL2     # Relative symlink to ../lib/BOSL2
```

---

## Parameters Reference

All lengths are in millimeters.

### `[Sleeve]`
| Parameter | Default | Description |
|---|---|---|
| `Inner_Diameter` | `171.45` | Inside diameter, matching the wheel (171.45 for 6.75") |
| `Width` | `52.3875` | Sleeve width along the axle (52.3875 for 2-1/16") |
| `Thickness` | `3.175` | Sleeve wall thickness (3.175 for 1/8") |

### `[Tread]`
| Parameter | Default | Description |
|---|---|---|
| `Tread_Count` | `100` | Number of tread ridges around the circumference |
| `Tread_Depth` | `1.5875` | Ridge height above the sleeve surface (1.5875 for 1/16") |

The defaults fit a 6.75" wheel, 2-1/16" wide.

---

## CLI Build

```bash
make all       # STL, 3MF, preview PNG, and presets
make bundle    # single-file .scad in ../dist/
```

Outputs are generated in `build/`.

---

## 3D Printing Recommendations

- **Material**: TPU or another flexible filament for a snug, grippy fit.
- **Print Orientation**: Flat on one end face, no supports required.

<!-- BEGIN GENERATED -->

## Parameters

### Sleeve

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Inner_Diameter` | `171.45` |  | Inside diameter, matching the wheel (171.45 for 6.75") |
| `Width` | `52.3875` |  | Sleeve width along the axle (52.3875 for 2-1/16") |
| `Thickness` | `3.175` |  | Sleeve wall thickness (3.175 for 1/8") |

### Tread

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Tread_Count` | `100` | 4 to 200, step 1 | Number of tread ridges around the circumference |
| `Tread_Depth` | `1.5875` |  | Ridge height above the sleeve surface (1.5875 for 1/16") |

<!-- END GENERATED -->
