# Pipe Clamp Wall Mount

A 3D-printable wall rack of angled openings that holds any round rod, pipe clamp bar, or tool handle. One block holds several, each in an opening that leans back toward the wall, with screws driven through the back wall between the openings. The defaults fit 1-1/8" pipe.

## Features

- Pipes lean back into the wall so they stay put.
- One hidden counterbored screw per pipe.
- A tip on top and a matching socket underneath align blocks end to end. The socket has clearance around the tip, so stacked blocks seat flush instead of rocking on the tip.
- Chamfered edges and flared opening mouths.
- The notch defaults changed, so new blocks do not stack with blocks printed from the old defaults.

<!-- BEGIN GENERATED -->

## Parameters

### Holders

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Holder_Count` | `4` | 1 to 12, step 1 | Number of pipe openings |
| `Pipe_Diameter` | `28.575` |  | Pipe outside diameter (28.575 for 1-1/8") |
| `Pipe_Spacing` | `12.7` |  | Gap between neighboring pipes (12.7 for 1/2") |
| `Holder_Width` | `25.4` |  | Width of the block (X) (25.4 for 1") |
| `Back_Wall_Thickness` | `12.7` |  | Thickness of the wall behind the pipes (12.7 for 1/2") |
| `Opening_Angle` | `30` | 0 to 60, step 1 | Angle the openings lean from horizontal, so pipes stay put |
| `Edge_Chamfer` | `1.5875` |  | Chamfer on the block's vertical edges and the opening mouths (1.5875 for 1/16") (0 to disable) |

### Alignment Notch

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Notch_Bottom_Width` | `9.525` |  | Notch width at its base (9.525 for 3/8") |
| `Notch_Top_Width` | `6.35` |  | Notch width at its tip (6.35 for 1/4") |
| `Notch_Height` | `4.7625` |  | Notch height, a male tip on top and a female socket on the bottom for stacking blocks (4.7625 for 3/16") |
| `Notch_Clearance` | `0.2` |  | Gap around the tongue inside the socket so stacked blocks seat flush |

### Screw Holes

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Screw_Head_Diameter` | `15.875` |  | Counterbore head diameter (15.875 for 5/8") |
| `Screw_Hole_Diameter` | `4.7625` |  | Screw shank hole diameter (4.7625 for 3/16") |
| `Screw_Hole_Depth` | `9.525` |  | Depth of the shank hole behind each pipe (9.525 for 3/8") |

<!-- END GENERATED -->

## Printing

- **Material**: PETG or ABS/ASA.
