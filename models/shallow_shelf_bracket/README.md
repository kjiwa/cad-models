# Shallow Shelf Bracket

A 3D-printable bracket that hangs a shallow shelf from a wall. The defaults are 2" tall, 8" deep, and 3/4" wide, with 1/4" arms.

## Features

- A cove-curved gusset joins the arms with less material than a straight brace and a stiffer feel at the wall.
- Each arm has a countersunk screw hole driven from the gusset side, with a boss that seats the head where the cove is thin.
- The mounting faces and corner stay flat and square; every other edge and corner is rounded.
- Holes are teardrop-shaped, so the bracket prints on its side without supports.
- Set the arm sizes, width, edge and corner radii, and the screw hole sizes and positions.

<!-- BEGIN GENERATED -->

## Parameters

### Bracket

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Height` | `50.8` |  | Wall arm height (50.8 for 2") |
| `Depth` | `203.2` |  | Shelf arm depth (203.2 for 8") |
| `Width` | `19.05` |  | Bracket width (19.05 for 3/4") |
| `Wall_Thickness` | `6.35` |  | Arm thickness (6.35 for 1/4") |
| `Edge_Radius` | `1.5` |  | Radius of the rounded face edges |
| `Corner_Radius` | `3` |  | Radius of the rounded outer corners |

### Screw Holes

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Screw_Diameter` | `4.7625` |  | Screw shank diameter (4.7625 for 3/16") |
| `Screw_Head_Diameter` | `9.525` |  | Screw head diameter (9.525 for 3/8") |
| `Screw_Hole_Depth` | `12.7` |  | Distance from the mounting face to the head seat (12.7 for 1/2") |
| `Screw_Hole_Offset` | `50.8` |  | Distance from the arm end to the hole (50.8 for 2") |

<!-- END GENERATED -->

## Printing

- **Material**: PETG or ABS; PLA creeps under a loaded shelf.
- **Orientation**: On its side, as modeled, so the layers run along both arms. The default needs a bed about 210 mm long.
- **Walls**: Use at least 4 perimeters; the layers carry the load along the arms.
