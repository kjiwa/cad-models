# Curtain Rod Mounting Plate

Parametric 3D-printable mounting plate to secure curtain rod brackets to walls or window trim.

## Features

- Raised rear boss block with captive hexagonal pockets that hold bracket mounting nuts flush behind the plate.
- Symmetrical wall screw holes on the left and right margins with configurable count and vertical span.
- Chamfered top edges.

<!-- BEGIN GENERATED -->

## Parameters

### Plate

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Plate_Width` | `152.4` |  | Width of the mounting plate |
| `Plate_Depth` | `101.6` |  | Depth of the mounting plate |
| `Plate_Thickness` | `6.35` |  | Thickness of the mounting plate |
| `Edge_Chamfer` | `3.175` |  | Chamfer size along the top edges |

### Nut Boss

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Boss_Width` | `12.7` |  | Width of the boss block |
| `Boss_Depth` | `38.1` |  | Depth of the boss block |
| `Boss_Thickness` | `6.35` |  | Rear protrusion of the boss block |
| `Boss_Offset` | `0` |  | Offset of the boss along X from the plate center |
| `Nut_Count` | `2` | 1 to 10, step 1 | Number of hex nut pockets |
| `Nut_Span` | `22.225` |  | Vertical center-to-center distance between the outermost nut pockets |
| `Nut_Width_Across_Flats` | `8.334375` |  | Distance across the flats of the hex nut |
| `Nut_Pocket_Depth` | `3.175` |  | Depth of each hex nut pocket |

### Screw Holes

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Screw_Hole_Diameter` | `4.7625` |  | Diameter of the wall screw holes and bracket screw holes through the boss (4.7625 for #8 screws) |
| `Hole_Count` | `2` | 1 to 10, step 1 | Number of wall screw holes per side |
| `Hole_Span` | `76.2` |  | Vertical center-to-center distance between the outermost holes per side |
| `Hole_Edge_Inset` | `12.7` |  | Distance from the side edge to the screw hole centers |

<!-- END GENERATED -->

## Printing

- **Material**: PETG or ABS/ASA for creep resistance under screw clamping tension.
- **Orientation**: Flat on the build plate. Front-face down on a smooth PEI sheet, the top chamfers form a clean bevel against the bed with no supports. Rear-face down, support the area around the raised boss.
- **Walls**: 4 to 6 for solid material around screw holes and hex pockets.
- **Infill**: 30% to 50% Gyroid or Honeycomb.
- **Top / Bottom Layers**: 4 to 5.
