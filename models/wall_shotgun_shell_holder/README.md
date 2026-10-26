# Wall Shotgun Shell Holder

Parametric, 3D-printable rack for 12 gauge shotgun shells, for Sy's Peglock modular pegboard system and standard 1/4" pegboards. Shells stack base-first in vertical columns, each held by a rim slot that keeps the shell from tipping out of the front.

## Features

- `Mount_Type` selects Peglock wedge sockets, monolithic integrated pegboard pegs, or screw holes in side ears.
- Shells load from the top of a column and slide down; the rim slot is open at both ends of the column.
- A rounded seat at the bottom of each column stops the lowest shell.
- Each column's top entry flares open to guide a shell in, and the outer edges of the body are rounded except along the back, which is square against the plate.
- Screw ears sit beside the columns, so the screws never cut into a rim slot.

<!-- BEGIN GENERATED -->

## Parameters

### Layout

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Columns` | `2` | 1 to 6, step 1 | Number of shell columns |
| `Rows` | `5` | 1 to 10, step 1 | Number of shells per column |

### Shell

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Rim_Diameter` | `23` |  | Rim diameter, including clearance (23 for 0.906") |
| `Rim_Thickness` | `2` |  | Thickness of the rim slot (2 for 0.079") |
| `Shell_Diameter` | `20.5` |  | Shell body diameter, including clearance (20.5 for 0.807") |
| `Holder_Depth` | `10` |  | Height of the walls holding each shell (10 for 0.394") |
| `Wall_Thickness` | `4` |  | Thickness of the walls around and behind each shell (4 for 0.157") |
| `Entry_Chamfer` | `1` |  | Lead-in flaring each column's top entry (0 to disable) |
| `Corner_Radius` | `1` |  | Radius of the rounded outer edges of the body, except along the back (0 to disable) |

### Backplate

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Backplate_Thickness` | `1.5875` |  | Thickness of the backplate behind the columns |

### Pegboard

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Mount_Type` | `"peglock"` | Modular Peglock Socket, Integrated Pegboard Pegs, Screw Holes | Mounting interface: modular Peglock wedge socket, monolithic integrated pegboard pegs, or countersunk screw holes |
| `Hole_Columns` | `0` |  | Pegboard hole columns the mount engages (0 = auto) |
| `Hole_Spacing` | `25.4` |  | Pegboard hole center spacing (25.4 for 1" standard, 15.875 for 5/8" metal) |
| `Pin_Diameter` | `5.7` |  | Pin diameter (5.7 for standard 1/4" hole fit, 6.0 for original Sy fit) |
| `Pegboard_Thickness` | `6.35` |  | Pegboard thickness (6.35 for 1/4" board, 1.5875 for 1/16" thin metal) |
| `Retention_Hook_Rise` | `3.5` |  | Height of the retention hook tab behind the pegboard |
| `Stabilizing_Pin_Pattern` | `"all"` | All Rows, Top and Bottom Rows, Top Row Only, Bottom Row Only (Lowest Hole), Retention Hooks Only | Stabilizing pin rows below the retention hooks (ignored by the Peglock socket mount) |
| `Screw_Hole_Rows` | `1` |  | Screw hole rows down the backplate (screws mount) |
| `Screw_Hole_Inset` | `19.05` |  | Distance from the backplate edge to the outermost screw hole centers (a single column or row sits centered) |
| `Screw_Hole_Diameter` | `4.7625` |  | Screw shank hole diameter (4.7625 for 3/16") |
| `Screw_Head_Diameter` | `9.525` |  | Screw head or washer outer diameter (9.525 for 3/8") |
| `Include_Screw_Countersink` | `false` |  | Include a countersink cone for the screw head instead of a straight hole |

## Presets

- `Two_Column_Screw_Mount`

<!-- END GENERATED -->

## Printing

- **Orientation**: Upright as exported, columns opening upward (+Z).
- **Perimeters**: 3-4.
- **Material**: PETG or PLA.

## Credits

The mounting interface is from Sy's Peglock modular pegboard system, [CC BY-SA](https://creativecommons.org/licenses/by-sa/4.0/) ([Printables 249871](https://www.printables.com/model/249871)).
