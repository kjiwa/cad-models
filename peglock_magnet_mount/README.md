# Peglock Magnet Mount

Parametric, 3D-printable magnet mount for Sy's Peglock modular pegboard system and standard 1/4" pegboards. A grid of round magnet pockets in a thin slab holds tools, bits, or sheet-metal fixtures on the pegboard. The defaults hold a single 12 mm magnet.

## Features

- `Mount_Type` selects Peglock wedge sockets or monolithic integrated pegboard pegs.
- Configurable magnet diameter and depth, rows, columns, and spacing.
- Pockets are cut to the nominal magnet size and the magnets are glued in.

<!-- BEGIN GENERATED -->

## Parameters

### Layout

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Columns` | `1` | 1 to 10, step 1 | Number of magnet columns |
| `Rows` | `1` | 1 to 6, step 1 | Number of magnet rows |
| `Magnet_Spacing` | `2` |  | Spacing between magnets and around the grid edge |

### Magnet

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Magnet_Diameter` | `12` |  | Magnet pocket diameter (12 for a 12 mm disc) |
| `Magnet_Depth` | `3.5` |  | Magnet pocket depth, which is also the slab thickness |
| `Corner_Radius` | `1.5875` |  | Radius of the rounded slab edges (0 to disable) |

### Backplate

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Backplate_Thickness` | `1.5875` |  | Thickness of the backplate behind the magnet slab |

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

- **Orientation**: Magnet pockets facing up (+Z). No supports.
- **Magnets**: Epoxy the magnets into the pockets. JB Weld and UV-cure epoxy both held over about 10 prints. Check polarity before the glue sets.
- **Perimeters**: 3-4, so the spacing between pockets is solid plastic.
- **Material**: PETG or PLA; both hold the magnets once glued.

## Credits

The mounting interface is from Sy's Peglock modular pegboard system, [CC BY-SA](https://creativecommons.org/licenses/by-sa/4.0/) ([Printables 249871](https://www.printables.com/model/249871)).
