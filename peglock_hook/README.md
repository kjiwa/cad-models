# Peglock Hook

Parametric, 3D-printable tool hooks and socket racks for Sy's Peglock modular pegboard system.

## Features

- **Custom Hook Profiles**: Circle, Square, Triangle, and RightTriangle profiles.
- **Configurable Grid Layout**: Parametric row and column counts, spacing, depth, and item capacity.
- **Peglock Interface**: Interfaces with Sy's Peglock locking wedge mounting system.
- **Presets Included**: Pre-configured JSON parameter sets for socket racks (`Sockets (1/4)`, `Sockets (3/8)`, `Sockets (1/2)`).
- **Automated CLI Build**: `Makefile` support to render base models and all JSON parameter presets.

---

## Directory Structure

```text
peglock_hook/
├── Makefile                # Build automation for STL, 3MF, presets, and PNG renders
├── README.md               # Documentation and printing recommendations
├── peglock_hook.json       # Customizer preset configurations (socket sets)
├── peglock_hook.scad       # Parametric OpenSCAD source model
├── BOSL2                   # Relative symlink to ../lib/BOSL2
├── peglock_mount           # Relative symlink to ../lib/peglock_mount
└── peglock_openscad        # Relative symlink to ../lib/peglock_openscad
```

---

## Using the OpenSCAD Customizer (GUI)

1. Open `peglock_hook.scad` in OpenSCAD.
2. In the top menu, ensure **Window -> Customizer** is checked.
3. Select a preset (e.g. `Sockets (1/4)`) from the preset dropdown, or customize parameters.
4. Press `F5` to preview or `F6` to render, then `F7` to export to STL.

---

## CLI Build & Automation

Run `make` commands from this directory or from the root repository directory:

```bash
# Build default STL, 3MF, preview PNG, and all JSON presets
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
