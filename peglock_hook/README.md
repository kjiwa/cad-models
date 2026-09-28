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
└── peglock                 # Relative symlink to ../lib/peglock
```

---

## Using the OpenSCAD Customizer (GUI)

1. Open `peglock_hook.scad` in OpenSCAD.
2. In the top menu, ensure **Window -> Customizer** is checked.
3. Select a preset (e.g. `Sockets (1/4)`) from the preset dropdown, or customize parameters.
4. Press `F5` to preview or `F6` to render, then `F7` to export to STL.

---

## Parameters Reference

All dimensions are in millimeters unless otherwise noted.

### `[Hook]`
| Parameter | Default | Description |
|---|---|---|
| `Hook_Shape` | `"Square"` | Cross-sectional profile of the hook: `Circle`, `Square`, `Triangle`, or `RightTriangle` |
| `Hook_Width` | `12.7` | Width of each hook arm |
| `Hook_Height` | `6.35` | Height of each hook arm |
| `Hook_Depth` | `6.35` | Depth (front-to-back) of each hook arm's straight section |
| `Hook_Wall_Thickness` | `1.5875` | Thickness of the backer plate behind the hooks |
| `Hook_Lip_Thickness` | `3.175` | Thickness of the retaining lip capping each hook arm |
| `Hook_Lip_Height` | `3.175` | Height the retaining lip rises above the hook arm to catch hung items |
| `Hook_Roundover` | `1.5875` | Fillet radius applied to hook and backer edges |
| `Hook_Rows` | `1` | Number of hook rows stacked vertically |
| `Hook_Columns` | `1` | Number of hook columns arranged side by side |
| `Hook_Item_Quantity` | `1` | Number of hooks printed back-to-back at each grid position, for hanging multiple items per socket |
| `Hook_Row_Spacing` | `19.05` | Center-to-center vertical spacing between hook rows |
| `Hook_Column_Spacing` | `19.05` | Center-to-center horizontal spacing between hook columns |

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
