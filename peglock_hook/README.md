# Peglock Hook

Parametric, 3D-printable tool hooks and socket racks for Sy's Peglock modular pegboard system and standard 1/4" pegboards.

## Features

- `Mount_Type` selects Peglock wedge sockets or monolithic integrated pegboard pegs.
- Circle, square, triangle, and right triangle arm profiles.
- Configurable row and column counts, spacing, arm depth, and hooks per arm.
- Optional fillet at the arm root to resist cantilever shear.
- Presets cover socket racks.

<!-- BEGIN GENERATED -->

## Parameters

### Layout

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Columns` | `1` | 1 to 10, step 1 | Number of hook columns |
| `Rows` | `1` | 1 to 6, step 1 | Number of hook rows |
| `Column_Spacing` | `19.05` |  | Center-to-center distance between hook columns (at least Arm_Width) |
| `Row_Spacing` | `19.05` |  | Center-to-center distance between hook rows |
| `Vertical_Alignment` | `"bottom"` | Hooks Near Bottom, Hooks Centered | Where the hooks sit on the backplate |

### Arm

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Arm_Shape` | `"square"` | Circle, Square, Triangle, Right Triangle | Cross-section profile of the hook arm |
| `Arm_Width` | `12.7` |  | Width of the hook arm |
| `Arm_Depth` | `6.35` |  | Depth of the hook arm from the backplate to the lip |
| `Arm_Height` | `6.35` |  | Height of the hook arm |
| `Arm_Tilt_Angle` | `0` | 0 to 45, step 5 | Upward tilt of the hook arm in degrees (0 to disable) |
| `Arm_Edge_Radius` | `1.5875` |  | Radius of the rounded arm edges |
| `Root_Fillet_Radius` | `0` |  | Stress relief fillet radius at the arm root (0 to disable) |
| `Hook_Count` | `1` | 1 to 5, step 1 | Number of hooks chained along each arm |

### Lip

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Lip_Thickness` | `3.175` |  | Thickness of the retaining lip |
| `Lip_Height` | `3.175` |  | Height of the retaining lip above the arm |
| `Lip_Orientation` | `"perpendicular"` | Square to Hook Arm, Parallel to Backplate | Orientation of the retaining lip when the arm is tilted |

### Backplate

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Backplate_Thickness` | `1.5875` |  | Thickness of the mounting backplate |

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

- `Sockets_1_4in`
- `Sockets_3_8in`
- `Sockets_1_2in`

<!-- END GENERATED -->

## Printing

- **Orientation**: Flat on the build plate with the backer plate on the bed and hooks pointing upward (+Z). No supports.
- **Perimeters**: 4-6, so the hook arms and Peglock socket walls print as solid perimeters without hollow infill voids.
- **Infill**: 25-40% Gyroid or Grid for the backer plate.
- **Top / Bottom Shells**: 4-5 solid layers (at least 0.8-1.0 mm) for backplate rigidity under cantilever torque.
- **Material**:
  - **PETG**: Recommended for workshop durability and impact resistance.
  - **PLA / Tough PLA**: Stiff and accurate for socket racks and lighter tools. Raise the hotend temperature 5 C to maximize Z-layer adhesion at the hook root.
- **Root Strengthening**: For heavier tools, set `Root_Fillet_Radius = 1.6` to remove the sharp 90 degree corner where the hook meets the backplate.

## Credits

The mounting interface is from Sy's Peglock modular pegboard system, [CC BY-SA](https://creativecommons.org/licenses/by-sa/4.0/) ([Printables 249871](https://www.printables.com/model/249871)).
