# Peglock Bit Holder

Parametric, 3D-printable hex bit holder for Sy's Peglock modular pegboard system and standard 1/4" pegboards. Tilted tiers of hexagonal pockets hold 1/4" hex shank drill and driver bits, with a grip slot along each row for lifting bits out. The defaults fit 1/4" hex bits.

## Features

- `Mount_Type` selects Peglock wedge sockets or monolithic integrated pegboard pegs.
- Rows of hexagon pockets lean forward so bits sit at an angle, stacked as a sawtooth with a solid wedge under each tier.
- A relief slot runs along each row through the hex corners and dividers, so bits can be pinched out.
- Each pocket mouth has a lead-in, and the outer edges of the body are rounded; the plate is narrowed by `Corner_Radius` on each side.

<!-- BEGIN GENERATED -->

## Parameters

### Layout

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Columns` | `10` | 1 to 20, step 1 | Number of bits per row |
| `Rows` | `2` | 1 to 6, step 1 | Number of stacked tiers |

### Pocket

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Bit_Width` | `6.75` |  | Hex shank width across flats, including clearance (6.75 for 1/4" bits) |
| `Pocket_Height` | `15` |  | Depth of each pocket |
| `Wall_Thickness` | `2.68` |  | Thickness of the thinnest wall, at the hex corners |
| `Relief_Width` | `1.5875` |  | Width of the grip slot along each row (0 to disable) |
| `Tilt_Angle` | `15` | 5 to 45, step 5 | Forward tilt of each tier in degrees |
| `Entry_Chamfer` | `0.5` |  | Lead-in at each pocket mouth (0 to disable) |
| `Corner_Radius` | `1` |  | Radius of the rounded outer edges of the body (0 to disable) |

### Backplate

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Backplate_Thickness` | `1.5875` |  | Thickness of the backplate behind the pockets |

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

<!-- END GENERATED -->

## Printing

- **Orientation**: Upright as exported, pockets opening upward (+Z). The solid wedge under each tier carries the tilted pocket floor.
- **Perimeters**: 3-4, so the walls between pockets are solid plastic.
- **Material**: PETG or PLA.

## Credits

The mounting interface is from Sy's Peglock modular pegboard system, [CC BY-SA](https://creativecommons.org/licenses/by-sa/4.0/) ([Printables 249871](https://www.printables.com/model/249871)).
