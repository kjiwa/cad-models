# Peglock Holder

Parametric, 3D-printable open-front bin and organizer for Sy's Peglock modular pegboard system and standard 1/4" pegboards.

## Features

- **Dual Mounting Modes**: Toggle between Sy's Peglock modular locking wedge sockets and monolithic integrated pegboard pegs.
- **Parametric Capacity**: Configurable pocket dimensions (width, depth, height, rows, and columns) and a separate width and depth per column.
- **Multi-Row Organization**: Independent pockets with intact internal partitions or continuous open slots.
- **Customizer Compatible**: Designed for use in the OpenSCAD Customizer with parameter controls.
- **Automated CLI Build**: `Makefile` support to render STL, 3MF, presets, and PNG preview images.

---

## Directory Structure

```text
peglock_holder/
├── Makefile                # Build automation for STL, 3MF, presets, and PNG renders
├── README.md               # Documentation and printing recommendations
├── peglock_holder.json     # Customizer preset configurations
├── peglock_holder.scad     # Parametric OpenSCAD source model
├── BOSL2                   # Relative symlink to ../lib/BOSL2
├── pegboard                # Relative symlink to ../lib/pegboard
└── peglock                 # Relative symlink to ../lib/peglock
```

---

## Using the OpenSCAD Customizer (GUI)

1. Open `peglock_holder.scad` in OpenSCAD.
2. In the top menu, ensure **Window -> Customizer** is checked.
3. Select a preset (`Knife_Holder`, `Olfa_Knife_Holder`, `Thin_Olfa_Knife_Holder`) or customize parameters.
4. Press `F5` to preview or `F6` to render, then `F7` to export to STL.

---

## Parameters Reference

All lengths are in millimeters unless noted.

### `[Layout]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Columns` | `1` | `1`-`10` | Number of pocket columns |
| `Rows` | `1` | `1`-`6` | Number of pocket rows |
| `Vertical_Alignment` | `bottom` | `bottom`, `center` | Where the pockets sit on the backplate (bottom is centered once the body nearly fills the plate) |

### `[Pocket]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Pocket_Widths` | `12.7` | | Inner width of each pocket: one value for every column or one comma-separated value per column (12.7 for 1/2") |
| `Pocket_Depths` | `6.35` | | Inner depth of each pocket, same format as `Pocket_Widths` |
| `Pocket_Height` | `12.7` | | Inner height of each pocket |
| `Entry_Chamfer` | `0.5` | | Lead-in at each pocket mouth (0 to disable) |
| `Tilt_Angle` | `0` | | Forward tilt of the pockets in degrees, 0 to 45 (0 to disable) |
| `Include_Bottom` | `true` | | Include the pocket bottoms |
| `Wall_Thickness` | `1.5875` | | Thickness of the pocket walls |
| `Corner_Radius` | `3.175` | | Radius of the rounded pocket body corners (0 to disable) |
| `Bottom_Edge_Radius` | `0` | | Rounds the pocket body's underside edges, except where it meets the plate; limited to `Wall_Thickness` (0 to disable) |
| `Junction_Gusset_Chamfer` | `0` | | Size of the triangular web under the pockets where they meet the plate, clamped to the plate below them; open-bottom pockets cut through it (0 to disable) |

### `[Front]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Lip_Thickness` | `3.175` | | Thickness of the front lip |
| `Lip_Height` | `3.175` | | Height of the front lip (0 to disable) |
| `Opening_Width` | `6.35` | | Width of the front access opening (0 to disable) |
| `Opening_Chamfer` | `1.0` | | Front opening lead-in chamfer (0 to disable) |
| `Include_Opening_Back_Rows` | `true` | | Include the front access opening on every row, not only the front-most |

### `[Backplate]`
The plate is narrower than the body by `Corner_Radius` on each side, so it stays within the flat of the body's back face.

| Parameter | Default | Options | Description |
|---|---|---|---|
| `Backplate_Thickness` | `1.5875` | | Thickness of the backplate behind the pockets (thicker resists flex under heavy loads; no load rating is claimed) |

### `[Pegboard]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Mount_Type` | `peglock` | `peglock`, `monolithic` | Mounting interface: modular Peglock wedge socket or monolithic integrated pegboard pegs |
| `Hole_Columns` | `0` | `0`-`10` | Pegboard hole columns the mount engages, as Peglock sockets or peg columns (0 = auto: as many as fit within the body width) |
| `Hole_Spacing` | `25.4` | | Pegboard hole center spacing (25.4 for 1" standard, 15.875 for 5/8" metal) |
| `Pin_Diameter` | `5.7` | | Pin diameter (5.7 for standard 1/4" hole fit, 6.0 for original Sy fit) |
| `Pegboard_Thickness` | `6.35` | | Pegboard thickness (6.35 for 1/4" board, 1.5875 for 1/16" thin metal) |
| `Retention_Hook_Rise` | `3.5` | | Height of the retention hook tab behind the pegboard |
| `Stabilizing_Pin_Pattern` | `all` | `all`, `top_and_bottom`, `top`, `bottom`, `none` | Stabilizing pin rows below the retention hooks (`bottom` is the lowest hole; ignored by the Peglock socket mount) |

---

## 3D Printing Recommendations

- **Orientation**: Print upright on its base with pockets opening facing upward (+Z). Zero supports required (the 45° lead-in chamfer of the female Peglock socket prints cleanly without sagging).
- **Perimeters / Walls**: 3–4 perimeters. This makes the 1.5875 mm pocket dividers and side walls 100% solid plastic, maximizing stiffness and preventing infill chatter.
- **Infill**: 20–25% Gyroid or Grid for the mounting block.
- **Bottom / Top Layers**: 4–5 solid bottom layers (at least 0.8–1.0 mm) for a rigid, durable floor when holding hardware or metal tools.
- **Material Selection**:
  - **PETG**: Recommended for chemical resistance, oil resistance, and drop toughness in workshop environments.
  - **PLA / PLA+**: Rigid and easy to print with clean vertical wall dimensional accuracy.

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

<!-- BEGIN GENERATED -->

## Parameters

### Layout

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Columns` | `1` | 1 to 10, step 1 | Number of pocket columns |
| `Rows` | `1` | 1 to 6, step 1 | Number of pocket rows |
| `Vertical_Alignment` | `"bottom"` | Pockets Near Bottom, Pockets Centered | Where the pockets sit on the backplate (bottom is centered once the body nearly fills the plate) |

### Pocket

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Pocket_Widths` | `"12.7"` |  | Inner width of each pocket: one value for every column or one comma-separated value per column (12.7 for 1/2") |
| `Pocket_Depths` | `"6.35"` |  | Inner depth of each pocket, same format as Pocket_Widths |
| `Pocket_Height` | `12.7` |  | Inner height of each pocket |
| `Entry_Chamfer` | `0.5` |  | Lead-in at each pocket mouth (0 to disable) |
| `Tilt_Angle` | `0` | 0 to 45, step 5 | Forward tilt of the pockets in degrees (0 to disable) |
| `Include_Bottom` | `true` |  | Include the pocket bottoms |
| `Wall_Thickness` | `1.5875` |  | Thickness of the pocket walls |
| `Corner_Radius` | `3.175` |  | Radius of the rounded pocket body corners (0 to disable) |
| `Bottom_Edge_Radius` | `0` |  | Rounds the pocket body's underside edges, except where it meets the plate (0 to disable) |
| `Junction_Gusset_Chamfer` | `0` |  | Size of the triangular web under the pockets where they meet the plate, clamped to the plate below them (0 to disable) |

### Front

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Lip_Thickness` | `3.175` |  | Thickness of the front lip |
| `Lip_Height` | `3.175` |  | Height of the front lip (0 to disable) |
| `Opening_Width` | `6.35` |  | Width of the front access opening (0 to disable) |
| `Opening_Chamfer` | `1.0` |  | Front opening lead-in chamfer (0 to disable) |
| `Include_Opening_Back_Rows` | `true` |  | Include the front access opening on every row, not only the front-most |

### Backplate

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Backplate_Thickness` | `1.5875` |  | Thickness of the backplate behind the pockets (thicker resists flex under heavy loads) |

### Pegboard

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Mount_Type` | `"peglock"` | Modular Peglock Socket, Integrated Pegboard Pegs | Mounting interface: modular Peglock wedge socket or monolithic integrated pegboard pegs |
| `Hole_Columns` | `0` |  | Pegboard hole columns the mount engages (0 = auto) |
| `Hole_Spacing` | `25.4` |  | Pegboard hole center spacing (25.4 for 1" standard, 15.875 for 5/8" metal) |
| `Pin_Diameter` | `5.7` |  | Pin diameter (5.7 for standard 1/4" hole fit, 6.0 for original Sy fit) |
| `Pegboard_Thickness` | `6.35` |  | Pegboard thickness (6.35 for 1/4" board, 1.5875 for 1/16" thin metal) |
| `Retention_Hook_Rise` | `3.5` |  | Height of the retention hook tab behind the pegboard |
| `Stabilizing_Pin_Pattern` | `"all"` | All Rows, Top and Bottom Rows, Top Row Only, Bottom Row Only (Lowest Hole), Retention Hooks Only | Stabilizing pin rows below the retention hooks (ignored by the Peglock socket mount) |

## Presets

- `Knife_Holder`
- `Olfa_Knife_Holder`
- `Thin_Olfa_Knife_Holder`

<!-- END GENERATED -->
