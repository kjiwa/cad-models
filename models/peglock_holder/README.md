# Peglock Holder

Parametric, 3D-printable open-front bin and organizer for Sy's Peglock modular pegboard system and standard 1/4" pegboards.

## Features

- `Mount_Type` selects Peglock wedge sockets or monolithic integrated pegboard pegs.
- Configurable pocket dimensions (rows and columns) with a separate width and depth per column.
- Independent pockets with intact internal partitions or continuous open slots.
- The backplate is narrower than the body by `Corner_Radius` on each side, so it stays within the flat of the body's back face.

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

## Printing

- **Orientation**: Upright on its base, pockets opening upward (+Z). No supports (the 45 degree lead-in chamfer of the female Peglock socket prints cleanly without sagging).
- **Perimeters**: 3-4. This makes the 1.5875 mm pocket dividers and side walls solid plastic, maximizing stiffness and preventing infill chatter.
- **Infill**: 20-25% Gyroid or Grid for the mounting block.
- **Bottom / Top Layers**: 4-5 solid bottom layers (at least 0.8-1.0 mm) for a rigid floor when holding hardware or metal tools.
- **Material**:
  - **PETG**: Recommended for chemical resistance, oil resistance, and drop toughness in workshop environments.
  - **PLA / PLA+**: Rigid, with clean vertical wall accuracy.

## Credits

The mounting interface is from Sy's Peglock modular pegboard system, [CC BY-SA](https://creativecommons.org/licenses/by-sa/4.0/) ([Printables 249871](https://www.printables.com/model/249871)).
