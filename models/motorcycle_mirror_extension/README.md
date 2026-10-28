# Motorcycle Mirror Extension

A 3D-printable copy of a metal motorcycle mirror riser. The lower socket bolts to the mirror boss with a socket-head screw (M10x1.25, 34 Nm on a Honda), and the mirror stem threads into the upper socket, which sits higher and farther out.

## Features

- The default thread is the outside of an E-Z LOK 650-10F 9/16"-12 insert. Install the insert in the printed thread, because printed threads are weaker than metal.
- The `M10_Bolt` preset cuts the M10x1.25 stem thread directly, with no insert.
- The underside of the arm runs at 45 degrees, so the part prints upright without support.
- The bottom face is flat where it bears on the boss; the outer edges are rounded.
- The thread mouth and counterbore mouth have lead-in chamfers.
- Set the extension height and length, both socket sizes, the thread, and the screw sizes.

<!-- BEGIN GENERATED -->

## Parameters

### Arm

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Extension_Height` | `36` |  | Height from the boss to the top of the upper socket |
| `Extension_Length` | `40.5` |  | Horizontal distance from the screw axis to the thread axis |

### Lower Socket

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Lower_Socket_Diameter` | `19.5` |  | Outside diameter of the lower socket |
| `Screw_Diameter` | `10.5` |  | Mounting screw clearance diameter (M10) |
| `Screw_Depth` | `6` |  | Thickness of the shoulder under the screw head |
| `Screw_Head_Diameter` | `16.5` |  | Counterbore diameter for the screw head |
| `Screw_Head_Depth` | `7` |  | Counterbore depth above the shoulder |

### Upper Socket

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Upper_Socket_Diameter` | `19.5` |  | Outside diameter of the upper socket |
| `Thread_Depth` | `16` |  | Depth of the threaded bore |
| `Thread_Diameter` | `14.2875` |  | Outside diameter of the thread (14.2875 for a 9/16" insert, 10 for M10) |
| `Thread_Pitch` | `2.116667` |  | Thread pitch (2.116667 for 9/16"-12, 1.25 for M10) |

### Finish

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Edge_Radius` | `1` |  | Radius of the rounded outer edges |
| `Thread_Chamfer` | `1` |  | Width of the lead-in chamfer at the thread mouth |
| `Counterbore_Chamfer` | `0.5` |  | Width of the lead-in chamfer at the counterbore mouth |

## Presets

- `M10_Bolt`

<!-- END GENERATED -->

## Printing

- **Material**: PETG or ABS.
- **Orientation**: Upright, as modeled, so the thread axis is vertical and the flanks print cleanest.
- **Support**: None.
