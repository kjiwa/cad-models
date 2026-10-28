# Knob

A 3D-printable knob with a through bolt bore and a hex pocket that captures a nut or bolt head. One model covers a stop block knob, a large blade-storage knob, and a miter gauge handle. The defaults are the stop block knob.

## Features

- A fluted grip scoops the rim between rounded lobes for the most torque from fingertips, and a knurled grip suits a long handle.
- The top edge is rounded and the bottom edge chamfered, so the knob is comfortable to turn and sits flat.
- Both bore ends are chamfered to guide the bolt.
- The hex pocket opens at the bottom, or at the top for a handle that holds the bolt head deep inside.
- The cap plugs a top pocket flush, pinning the bolt head so the pocket is not left open.
- Set the diameter, height, flute count, hardware sizes, and pocket depth.

<!-- BEGIN GENERATED -->

## Parameters

### Part

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Part` | `"knob"` | Knob, Cap | Part to print |

### Grip

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Grip` | `"fluted"` | Fluted, Knurled | Rim style |
| `Diameter` | `19` |  | Knob diameter |
| `Height` | `12` |  | Knob height |
| `Flute_Count` | `5` | 3 to 12, step 1 | Number of flutes around the rim |
| `Texture_Size` | `2` |  | Diamond size of the knurled grip |
| `Top_Rounding` | `2` |  | Radius of the rounded top edge |
| `Bottom_Chamfer` | `1` |  | Chamfer of the bottom edge |

### Hardware

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Bolt_Diameter` | `7` |  | Bolt diameter |
| `Nut_Width` | `10.825` |  | Nut or bolt head across the flats |
| `Nut_Thickness` | `5.5` |  | Nut or bolt head thickness |
| `Pocket_End` | `"bottom"` | Bottom, Top | End of the knob where the hex pocket opens |
| `Pocket_Depth` | `0` |  | Depth of the hex pocket (0 = auto) |
| `Cap_Clearance` | `0.15` |  | Gap around the cap in the pocket |

## Presets

- `Rockler_Blade_Holder_Knob`
- `M10_Lock_Knob`
- `Miter_Gauge_Handle`
- `Miter_Gauge_Handle_Cap`

<!-- END GENERATED -->

## Printing

- **Material**: PETG or ABS for knobs that see torque; PLA is fine for light use.
- **Orientation**: Bottom down, with the pocket opening at the top or the bed. The knob prints without supports.
- **Fit**: Nut_Width is the nut across its flats. Add 0.1 to 0.2 mm for your printer if the nut does not drop in.
- **Miter gauge handle**: Nut_Thickness is the bolt head height, assumed 3.97 mm (5/32"); set it to your bolt head. Print the cap in the `Miter_Gauge_Handle_Cap` preset flat face down and slide it into the top pocket.
