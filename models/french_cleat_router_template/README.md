# French Cleat Router Template

A 3D-printable router template for cutting a French cleat: a fence wall and a top plate with a cleat-shaped opening that a pattern bit with a bearing follows. The defaults fit a 3/4" workpiece and a 3/4" x 3-3/4" cleat at 30 degrees.

## Features

- Inside corners of the opening come out at the finishing bit's radius (1/8" for a 1/4" bit), so round over the cleat edges at least that much to seat them; this also leaves no sharp edges. Jigsaw the waste, flush-trim with a large pattern bit, which is stiffer and takes the bulk, and finish with the small one.
- Set Corner_Bit_Diameter to the finishing bit for dog-bone slots that let it cut square inside corners. Larger bits stop short of the corners.
- Cleat_Angle 0 cuts a rectangular opening, such as for a bottom stability cleat.
- Set each pattern bit so the top of its cutter is flush with the underside of the plate. The cutter must be at least as long as the workpiece is thick.
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
| `Template_Plate_Thickness` | `12.7` |  | Top plate thickness, at least the bit bearing height (12.7 for 1/2") |
| `Template_Wall_Thickness` | `6.35` |  | Fence wall thickness (6.35 for 1/4") |
| `Corner_Radius` | `6.35` |  | Radius of the rounded far plate corners (6.35 for 1/4") (0 to disable) |
| `Edge_Chamfer` | `1.5875` |  | Chamfer on the outer top plate edges (1.5875 for 1/16") (0 to disable) |

### Cleat

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Cleat_Angle` | `30` | 0 to 45, step 1 | Angle of the cleat bevel |
| `Cleat_Thickness` | `19.05` |  | Cleat thickness (19.05 for 3/4") |
| `Cleat_Height` | `95.25` |  | Cleat height (95.25 for 3-3/4") |

### Router Bit

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Corner_Bit_Diameter` | `0` |  | Corner bit diameter for dog-bone reliefs that let it cut square inside corners (6.35 for 1/4") (0 to disable) |

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
