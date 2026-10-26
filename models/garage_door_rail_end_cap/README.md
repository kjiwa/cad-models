# Garage Door Rail End Cap

A 3D-printable bumper cap for the end of a garage door rail, so cabinet doors stay off the cut rail end. The pocket follows the rail profile: a curved bottom, one straight side, and a flange across the top.

## Features

- The closed end is a separate bumper thickness, so it can be thicker than the side walls.
- The outer edges and bumper face are rounded, and the pocket mouth is chamfered so the cap slides onto the rail.
- Fit_Clearance widens the pocket: leave it at 0 for a snug TPU fit, or about 0.2 for PETG.

<!-- BEGIN GENERATED -->

## Parameters

### Rail

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Rail_Outer_Height` | `55` |  | Overall rail height (55 for about 2-11/64") |
| `Rail_Outer_Width` | `25.4` |  | Overall rail width (25.4 for 1") |
| `Rail_Thickness` | `3.175` |  | Rail sheet thickness (3.175 for 1/8") |
| `Rail_Bottom_Outer_Radius` | `11.1125` |  | Outer radius of the curved rail bottom (11.1125 for 7/16") |

### End Cap

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `End_Cap_Wall_Thickness` | `3.175` |  | Wall thickness around the rail (3.175 for 1/8") |
| `End_Cap_Depth` | `12.7` |  | Cap length along the rail (12.7 for 1/2") |
| `Bumper_Thickness` | `3.175` |  | Thickness of the closed end that faces the cabinet door (3.175 for 1/8") |
| `Fit_Clearance` | `0` |  | Extra pocket width around the rail, about 0.2 for PETG (0 to disable) |
| `Edge_Radius` | `1.5875` |  | Radius of the rounded outer edges and bumper face (1.5875 for 1/16") |
| `Mouth_Chamfer` | `0.79375` |  | Width of the chamfer at the pocket mouth (0.79375 for 1/32") |

<!-- END GENERATED -->

## Printing

- **Material**: TPU recommended, so the cap grips the rail and cushions the door. PETG works with a small Fit_Clearance.
- **Orientation**: Closed end down, as modeled.
