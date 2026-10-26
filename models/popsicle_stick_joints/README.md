# Popsicle Stick Joints

A 3D-printable joint that holds popsicle sticks at an angle, for frames and small structures. Each arm is a pocket that a stick slides into. The default is a two-way 90 degree corner.

## Features

- Slot In has a closed top, so sticks hold without glue; Glue Guide leaves the top open for gluing.
- Set the stick count and the angle between sticks; an angle of 0 with one stick makes a cap, and 180 makes a straight joiner.
- The pocket roof is a flat bridge across the stick width and the pocket mouths have a lead-in, so sticks start easily.
- Outer top edges are rounded and bottom edges chamfered, so the joint is comfortable to hold.
- Set the stick size, arm length, and wall thickness.

<!-- BEGIN GENERATED -->

## Parameters

### Joint

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Top` | `"closed"` | Slot In, Glue Guide | Closed top holds the sticks in place, open top guides glue |
| `Stick_Count` | `2` | 1 to 12, step 1 | Number of sticks |
| `Joint_Angle` | `90` | 0 to 180, step 1 | Angle between neighboring sticks, with a Stick_Count of 1 for a cap |

### Sticks

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Stick_Width` | `10` |  | Stick width (9.55 for a standard popsicle stick) |
| `Stick_Thickness` | `2` |  | Stick thickness (2.15 for a standard popsicle stick) |

### Arms

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Arm_Length` | `14` |  | Arm length from the hub |
| `Wall_Thickness` | `2` |  | Wall thickness around each stick |
| `Edge_Radius` | `1` |  | Radius of the rounded top outer edges |
| `Bottom_Chamfer` | `1` |  | Chamfer of the bottom outer edges, kept at 45 degrees so it prints without supports |
| `Mouth_Chamfer` | `0.5` |  | Width of the lead-in chamfer on each pocket mouth |

## Presets

- `Cap`
- `Two_Way_30`
- `Two_Way_45`
- `Two_Way_60`
- `Two_Way_120`
- `Straight`

<!-- END GENERATED -->

## Printing

- **Material**: PLA or PETG.
- **Orientation**: Flat, as modeled. The Slot In pockets print without supports.
