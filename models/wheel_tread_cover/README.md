# Wheel Tread Cover

A 3D-printable sleeve with a herringbone tread that slips over a wheel to add grip. The defaults fit a 6.75" wheel, 2-1/16" wide.

## Features

- A star profile twisted along the width and mirrored about the middle forms the herringbone tread.
- The top end wraps around the wheel's rounded edge to form a lip that keeps the sleeve from walking off.
- Set the inside diameter, width, wall thickness, edge radius, wrap angle, and ridge count.

<!-- BEGIN GENERATED -->

## Parameters

### Sleeve

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Inner_Diameter` | `171.45` |  | Inside diameter, matching the wheel (171.45 for 6.75") |
| `Width` | `52.3875` |  | Sleeve width along the axle (52.3875 for 2-1/16") |
| `Thickness` | `3.175` |  | Sleeve wall thickness (3.175 for 1/8") |
| `Edge_Radius` | `6.35` |  | Radius of the wheel's rounded outer edge (6.35 for 1/4") |
| `Wrap_Angle` | `45` | 0 to 90, step 5 | Angle the top end wraps around the wheel edge, 45 or less prints without supports (0 to disable) |

### Tread

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Tread_Count` | `100` | 4 to 200, step 1 | Number of tread ridges around the circumference |
| `Tread_Depth` | `1.5875` |  | Ridge height above the sleeve surface (1.5875 for 1/16") |

<!-- END GENERATED -->

## Printing

- **Material**: TPU or another flexible filament for a snug, grippy fit.
- **Orientation**: Straight end down, wrapped end up. A wrap angle of 45 or less needs no supports.
- **Fit**: Width is the wheel's full tread width; a wider sleeve overhangs. For a stretch fit in TPU, set the inside diameter 1-2% under the wheel.
