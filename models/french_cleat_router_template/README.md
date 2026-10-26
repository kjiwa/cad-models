# French Cleat Router Template

A 3D-printable router template for cutting a French cleat: a fence wall and a top plate with a cleat-shaped opening that a pattern bit with a bearing follows. The defaults fit a 3/4" workpiece and a 3/4" x 3-3/4" cleat at 30 degrees.

## Features

- Router_Bit_Diameter cuts a dog-bone relief at each closed inside corner of the opening, so square-cornered parts fit; set it to 0 for plain corners.
- The far plate corners are rounded and the outer top edges chamfered; the routed edge and the fence face stay sharp.
- Two countersunk screw holes in the fence wall fasten the template to the workpiece.
- Set the template, cleat, screw, and router bit dimensions to fit other stock and bits.

<!-- BEGIN GENERATED -->

## Parameters

### Template

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Template_Length` | `171.45` |  | Template length along the cleat (171.45 for 6-3/4") |
| `Template_Width` | `76.2` |  | Template width from the fence wall (76.2 for 3") |
| `Template_Overhang_Height` | `19.05` |  | Workpiece thickness under the top plate (19.05 for 3/4") |
| `Template_Wall_Thickness` | `6.35` |  | Fence wall thickness (6.35 for 1/4") |
| `Corner_Radius` | `6.35` |  | Radius of the rounded far plate corners (6.35 for 1/4") (0 to disable) |
| `Edge_Chamfer` | `1.5875` |  | Chamfer on the outer top plate edges (1.5875 for 1/16") (0 to disable) |

### Cleat

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Cleat_Angle` | `30` | 15 to 45, step 1 | Angle of the cleat bevel |
| `Cleat_Thickness` | `19.05` |  | Cleat thickness (19.05 for 3/4") |
| `Cleat_Height` | `95.25` |  | Cleat height (95.25 for 3-3/4") |

### Router Bit

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Router_Bit_Diameter` | `22.225` |  | Pattern bit diameter, cuts a dog-bone relief at each closed corner of the opening (22.225 for 7/8") (0 to disable) |
| `Router_Bit_Cutter_Height` | `31.75` |  | Bit cutter height (31.75 for 1-1/4") |
| `Router_Bit_Guide_Bushing_Height` | `6.35` |  | Bearing height above the cutter (6.35 for 1/4") |

### Screw Holes

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Screw_Hole_Diameter` | `4.7625` |  | Screw hole diameter (4.7625 for 3/16") |
| `Screw_Head_Diameter` | `7.9375` |  | Screw head diameter (7.9375 for 5/16") |
| `Screw_Head_Thickness` | `3.175` |  | Screw head thickness (3.175 for 1/8") |
| `Screw_Hole_Offset` | `25.4` |  | Screw hole distance from each template end (25.4 for 1") |

<!-- END GENERATED -->

## Printing

- **Material**: PETG; the bearing heats the opening edge and dents PLA.
- **Orientation**: Top plate down on the bed.
- **Router bit**: Pattern bit with a bearing, bearing diameter equal to the cutter diameter.
