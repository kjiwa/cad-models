# Shelly Plus Junction Box

A 3D-printable junction box for a Shelly Plus module and Wago connectors, with a screw-down lid and a wall mount. Print the box, lid, and mount separately with the Part parameter.

## Features

- Four corner screw posts in the wire space hold the lid with countersunk screws, rising to the underside of the lid plug.
- The lid plug fits the box opening with Lid_Clearance on each side.
- The vertical box corners and the lid edges are rounded.
- The mount is a strap with two screw tabs that grips the box.
- Set the connector counts per side and the module and connector sizes to fit other layouts.

<!-- BEGIN GENERATED -->

## Parameters

### Part

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Part` | `"box"` | Box, Lid, Mount | Part to print |

### Wago Connectors

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Wago_Connector_Depth` | `8.4` |  | Connector depth |
| `Wago_Connector_Height` | `18.6` |  | Connector length along the wire axis |
| `Wago_Connector_Width` | `18.8` |  | Connector width across the wire axis |
| `Wago_Connector_Housing_Height` | `5` |  | Housing wall height behind each connector |
| `Wago_Connector_Left_Count` | `2` | 0 to 4 | Connectors on the left side |
| `Wago_Connector_Right_Count` | `2` | 0 to 4 | Connectors on the right side |
| `Wago_Wire_Space` | `5` |  | Space for wires beside the connectors |

### Shelly

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Shelly_Width` | `42` |  | Module width |
| `Shelly_Height` | `37` |  | Module height |
| `Shelly_Depth` | `16` |  | Module depth |
| `Shelly_Housing_Front_Depth` | `4` |  | Depth of the front pocket that holds the module face |
| `Shelly_Wire_Space` | `5` |  | Space for wires around the module |
| `Shelly_Access_Hole_Diameter` | `10` |  | Diameter of the hole under the module for its button |

### Box

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Inner_Wall_Thickness` | `2` |  | Thickness of the housing walls |
| `Outer_Wall_Thickness` | `2` |  | Thickness of the outer walls, floor, and lid |
| `Wire_Hole_Diameter` | `10` |  | Diameter of the wire entry hole |
| `Corner_Radius` | `3` |  | Radius of the rounded vertical corners (3 for about 1/8") |

### Lid

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Post_Diameter` | `7` |  | Width of each square corner screw post |
| `Screw_Pilot_Diameter` | `2.5` |  | Diameter of the pilot hole in each post |
| `Screw_Hole_Diameter` | `3.5` |  | Diameter of the lid screw clearance hole |
| `Screw_Head_Diameter` | `7` |  | Diameter of the lid screw head countersink |
| `Lid_Clearance` | `0.2` |  | Gap on each side between the lid plug and the box opening |

### Mount

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Mount_Screw_Hole_Diameter` | `5` |  | Diameter of the mount tab screw holes |
| `Mount_Tab_Length` | `19.05` |  | Length of each mount tab (19.05 for 3/4") |
| `Mount_Width` | `19.05` |  | Width of the mount (19.05 for 3/4") |

<!-- END GENERATED -->

## Printing

- **Material**: PETG or another flame-retardant material. Do not use PLA.
- **Orientation**: As modeled: box opening up, lid flat with the plug up, mount on its tabs.
