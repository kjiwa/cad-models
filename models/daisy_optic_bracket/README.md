# Daisy Optic Bracket

A 3D-printable half of a split clamp that holds an optic rail above a blaster rail. The two halves close sideways around both rails and two screws clamp them.

## Features

- The halves clamp the optic rail and the blaster rail together.
- Lugs drop into adjacent cross-slots of the blaster rail as the halves close.
- The two outer long corners, the end faces and the rail channel mouths are chamfered.
- Each half has a counterbore for an M4 socket head cap screw at one screw hole and a hex pocket for an M4 nut at the other; both open on the outer face and print without supports.
- Set both rail profiles, the cross-slot size and pitch, the lug count, offset and clearance, and the screw and nut sizes.
- The `Kronos_Front_Half_A` and `Kronos_Front_Half_B` presets seat the bracket in the second and third cross-slots of a Nerf Rival Kronos rail, stopping 0.5 mm behind the front sight.

<!-- BEGIN GENERATED -->

## Parameters

### Optic Rail

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Optic_Rail_Width_Large` | `12.7` |  | Width of the wide part of the optic rail |
| `Optic_Rail_Width_Small` | `8.8` |  | Width of the narrow part of the optic rail |
| `Optic_Rail_Depth_Large` | `4.6` |  | Depth of the wide part of the optic rail |
| `Optic_Rail_Depth_Small` | `2.5` |  | Depth of the narrow part of the optic rail measured from the top |
| `Optic_Rail_Depth` | `10` |  | Depth of the optic rail |

### Blaster Rail

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Blaster_Rail_Width_Large` | `18` |  | Width of the wide part of the blaster rail |
| `Blaster_Rail_Width_Small` | `12.5` |  | Width of the narrow part of the blaster rail |
| `Blaster_Rail_Depth_Large` | `4.2` |  | Depth of the wide part of the blaster rail |
| `Blaster_Rail_Depth_Small` | `3.1` |  | Depth of the narrow part of the blaster rail measured from the top |
| `Blaster_Rail_Depth` | `7.3` |  | Depth of the blaster rail |

### Rail Slots

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Rail_Slot_Width` | `5.3` |  | Width of a blaster rail cross-slot along the rail |
| `Rail_Slot_Pitch` | `10.1` |  | Distance between adjacent cross-slot centers |
| `Rail_Slot_Depth` | `4.7625` |  | Depth of a cross-slot from the rail top (4.7625 for 3/16") |
| `Lug_Clearance` | `0.3` |  | Gap left around each lug in its slot |
| `Lug_Count` | `2` | 0 to 4, step 1 | Number of lugs (0 to disable) |
| `Lug_Offset` | `0` |  | Shift of the lugs from the bracket center, positive away from the origin end; the two halves of a pair take opposite signs |

### Bracket

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Bracket_Length` | `51.4` |  | Length of the bracket along the rails |
| `Bracket_Thickness` | `5` |  | Wall thickness outside the wider rail |
| `Outer_Chamfer` | `2.5` |  | Size of the chamfer on the two outer long corners |
| `Edge_Chamfer` | `0.5` |  | Size of the chamfer on the end faces and rail channel mouths |

### Screw

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Screw_Diameter` | `4.4` |  | Diameter of the clamping screw holes |
| `Screw_Spacing` | `35.4` |  | Distance between the two screw holes |
| `Screw_Offset` | `3.75` |  | Offset of the screw axis from the rail seam towards the optic |
| `Screw_Head_Diameter` | `7` |  | Diameter of the screw head |
| `Screw_Head_Height` | `4` |  | Height of the screw head |
| `Screw_Length` | `22` |  | Length of the screw under the head, widening the bracket to fit |
| `Nut_Across_Flats` | `7` |  | Nut across the flats |
| `Nut_Thickness` | `3.2` |  | Nut thickness |
| `Pocket_Clearance` | `0.3` |  | Gap added around the screw head and the nut |

## Presets

- `Kronos_Front_Half_A`
- `Kronos_Front_Half_B`

<!-- END GENERATED -->

## Printing

- **Quantity**: Print two identical halves, or one of each Kronos preset; turn one half end for end (180 degrees about the axis running from the blaster rail to the optic rail) to close the clamp. The Kronos presets shift the lugs, so print one of each and turn one half end for end the same way. Each half has the counterbore at the screw hole nearer the origin end of the printed model and the nut pocket at the far hole. Turning one half end for end puts its counterbore opposite the other half's nut pocket at each screw.
- **Material**: PETG or ABS.
- **Orientation**: On the outer face, as modeled, so the screw holes stand upright and the pockets bridge.
- **Hardware**: Two M4 x 22 socket head cap screws and two M4 nuts, one of each per joint. A longer screw widens the bracket automatically. The screw holes are 4.4 mm clearance holes.
- **Assembly**: Close the halves around the rails so each lug drops into a cross-slot.
