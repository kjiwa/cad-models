# Miter Clamp Spacer

A 3D-printable corner spacer for clamping a mitered frame: a right-triangle block with a slot that holds the frame corner. The defaults fit 25/32" frame stock.

## Features

- The slot is the frame thickness and the overhang step is the frame edge width the spacer overlaps.
- A relief at the inside corner keeps the frame corner from binding.
- The outer corner and the outer leg edges are chamfered; the diagonal face stays sharp. Set Edge_Chamfer to 0 for square edges.

<!-- BEGIN GENERATED -->

## Parameters

### Frame

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Frame_Thickness` | `19.84375` |  | Frame thickness (19.84375 for 25/32") |
| `Frame_Overhang` | `3.175` |  | Frame edge width the spacer overlaps (3.175 for 1/8") |

### Spacer

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Holder_Thickness` | `28.575` |  | Spacer thickness (28.575 for 1-1/8") |
| `Corner_Relief_Diameter` | `3.175` |  | Diameter of the relief cut into the inside corner (3.175 for 1/8") |
| `Length` | `30` |  | Side length of the square the spacer is cut from, at least Holder_Thickness (30 for 1-3/16") |
| `Edge_Chamfer` | `1.5875` |  | Chamfer on the outer edges (1.5875 for 1/16") (0 to disable) |

<!-- END GENERATED -->

## Printing

- **Material**: PETG or PLA.
- **Orientation**: Flat, as modeled.
