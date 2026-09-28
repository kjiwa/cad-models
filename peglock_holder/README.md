# Peglock Holder

Parametric, 3D-printable open-front bin and organizer for Sy's Peglock modular pegboard system.

## Features

- **Parametric Capacity**: Configurable pocket dimensions (width, depth, height, rows, and columns).
- **Peglock Interface**: Interfaces with Sy's Peglock locking wedge mounting system.
- **Customizer Compatible**: Designed for use in the OpenSCAD Customizer with parameter controls.
- **Automated CLI Build**: `Makefile` support to render STL, 3MF, and PNG preview images.

---

## Directory Structure

```text
peglock_holder/
├── Makefile                # Build automation for STL, 3MF, presets, and PNG renders
├── README.md               # Documentation and printing recommendations
├── peglock_holder.json     # Customizer preset configurations
├── peglock_holder.scad     # Parametric OpenSCAD source model
├── BOSL2                   # Relative symlink to ../lib/BOSL2
└── peglock                 # Relative symlink to ../lib/peglock
```

---

## Using the OpenSCAD Customizer (GUI)

1. Open `peglock_holder.scad` in OpenSCAD.
2. In the top menu, ensure **Window -> Customizer** is checked.
3. Adjust parameters in the Customizer panel.
4. Press `F5` to preview or `F6` to render, then `F7` to export to STL.

---

## Parameters Reference

All dimensions are in millimeters unless otherwise noted.

### `[Holder]`
| Parameter | Default | Description |
|---|---|---|
| `Holder_Width` | `12.7` | Interior pocket width of each bin cell |
| `Holder_Depth` | `6.35` | Interior pocket depth (front-to-back) of each bin cell |
| `Holder_Height` | `12.7` | Interior pocket height of each bin cell |
| `Holder_Closed_Bottom` | `true` | Adds a solid floor to each pocket when true; leaves the pocket open-bottom when false |
| `Holder_Front_Opening` | `6.35` | Width of the front access opening cut into each pocket |
| `Holder_Front_Lip_Thickness` | `3.175` | Thickness of the retaining lip along the front opening |
| `Holder_Front_Lip_Height` | `3.175` | Height of the retaining lip along the front opening |
| `Holder_Wall_Thickness` | `1.5875` | Thickness of the walls separating pockets and the backer plate |
| `Holder_Roundover` | `3.175` | Fillet radius applied to backer and pocket edges |
| `Holder_Rows` | `1` | Number of pocket rows stacked vertically |
| `Holder_Columns` | `1` | Number of pocket columns arranged side by side |

### `[Peglock]`
| Parameter | Default | Description |
|---|---|---|
| `Peglock_Width` | `22` | Width of each Peglock wedge mounting socket |
| `Peglock_Height` | `35.4` | Height of each Peglock wedge mounting socket |
| `Peglock_Depth` | `6` | Depth (front-to-back) of each Peglock wedge mounting socket |
| `Peglock_Spacing` | `25.4` | Center-to-center spacing between adjacent Peglock sockets, matching pegboard hole spacing |
| `Peglock_Roundover` | `3.175` | Fillet radius applied to Peglock socket edges |

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
