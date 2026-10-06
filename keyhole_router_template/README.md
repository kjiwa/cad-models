# Keyhole Router Template

A 3D-printable router template for cutting hanging slots (keyholes) in picture frames and other workpieces. A 5/8" guide bushing follows each slot, and a narrower venting slot lets chips escape.

## Features

- **Two Styles**: `three_slot` lines up with a frame corner and routes one long and two short slots that are always level; `edge_guide` straddles a workpiece between two fences and routes one short slot.
- **Venting Slots**: A narrow slot extends past both ends of each guide channel.

---

## Directory Structure

```text
keyhole_router_template/
├── Makefile
├── README.md
├── keyhole_router_template.json     # Customizer preset configurations
└── keyhole_router_template.scad     # Parametric OpenSCAD source model
```

---

## Parameters Reference

All lengths are in millimeters.

### `[Part]`
| Parameter | Default | Description |
|---|---|---|
| `Style` | `three_slot` | Template layout |

### `[Plate]`
| Parameter | Default | Description |
|---|---|---|
| `Plate_Length` | `228.6` | Plate length along the slots (X) (228.6 for 9" three_slot, 152.4 for 6" edge_guide) |
| `Plate_Width` | `76.2` | Plate width across the slots (Y), including the fences for edge_guide (76.2 for 3" three_slot, 38.1 for 1-1/2" edge_guide) |
| `Plate_Thickness` | `6.35` | Plate thickness, which sets the guide bushing engagement (6.35 for 1/4") |

### `[Slots]`
| Parameter | Default | Description |
|---|---|---|
| `Guide_Width` | `16.66875` | Guide channel width, the guide bushing diameter plus clearance (16.66875 for 21/32" around a 5/8" bushing) |
| `Short_Slot_Length` | `31.75` | Center-to-center length of the short slot (31.75 for 1-1/4") |
| `Long_Slot_Length` | `139.7` | Center-to-center length of the long slot, three_slot only (139.7 for 5-1/2") |

### `[Venting Slots]`
| Parameter | Default | Description |
|---|---|---|
| `Venting_Slot_Length` | `12.7` | Length the venting slot extends past each end of the guide channel (12.7 for 1/2") |
| `Venting_Slot_Width` | `6.35` | Venting slot width (6.35 for 1/4") |

### `[Fences]`
| Parameter | Default | Description |
|---|---|---|
| `Fence_Thickness` | `3.175` | Fence thickness, edge_guide only (3.175 for 1/8") |
| `Fence_Height` | `6.35` | Fence height above the plate, edge_guide only (6.35 for 1/4") |

### Presets

- `Frame_Three_Slot`: 9" x 3" plate with three slots (the defaults).
- `Edge_Guide`: 6" x 1-1/2" plate with fences and one short slot.

---

## CLI Build

```bash
make all       # STL, 3MF, preview PNG, and presets
make bundle    # single-file .scad in ../dist/
```

Outputs are generated in `build/`.

---

## 3D Printing Recommendations

- **Material**: PLA or PETG; the plate is rigid.
- **Print Orientation**: Flat on the bed, no supports required.
- **Use**: Secure the template with double-faced tape and use dust extraction while routing; chips do not clear a keyhole slot on their own. Drilling a pilot hole first reduces router load.
- **Bit Depth**: Set the bit depth to (stock thickness + keyhole depth) / 2.
