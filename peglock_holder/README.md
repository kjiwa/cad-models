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
├── peglock_mount           # Relative symlink to ../lib/peglock_mount
└── peglock_openscad        # Relative symlink to ../lib/peglock_openscad
```

---

## Using the OpenSCAD Customizer (GUI)

1. Open `peglock_holder.scad` in OpenSCAD.
2. In the top menu, ensure **Window -> Customizer** is checked.
3. Adjust parameters in the Customizer panel.
4. Press `F5` to preview or `F6` to render, then `F7` to export to STL.

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
