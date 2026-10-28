# Cat Eye Spoke Reflector

A copy of the Cat Eye RR-250-WU spoke reflector: a faceted disc on a mount plate, faced with 3M 3432 microprismatic tape and clamped to two spokes by M4 screws into the printed spoke nuts.

## Features

- Pick the reflector, the spoke nut, or the tape template with `Part`.
- Each face is flat near the middle and slopes toward the rim, so every facet points at its own side. Side reflectors are tested at wide entrance angles, and microprismatic tape loses return off-axis.
- The mount plate sits at mid-height, with a slot for each screw. The nut has a groove for the spoke, and its top edge is rounded.
- The template is one face unfolded at its creases, so one outline fits both faces.

<!-- BEGIN GENERATED -->

## Parameters

### Part

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Part` | `"reflector"` | Reflector, Spoke Nut, Tape Template | Part to print |

### Reflector

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Reflector_Diameter` | `66` |  | Reflector disc diameter |
| `Reflector_Thickness` | `18` |  | Reflector thickness at the center |

### Mount

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Mount_Length` | `120` |  | Mount plate length |
| `Mount_Width` | `15` |  | Mount plate width |
| `Mount_Thickness` | `3` |  | Mount plate thickness |
| `Mount_Slot_Length` | `15` |  | Length of the screw slots |
| `Mount_Slot_Width` | `4.5` |  | Width of the screw slots |

### Nut

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Nut_Length` | `10.7` |  | Nut length |
| `Nut_Width` | `8.75` |  | Nut width |
| `Nut_Height` | `5` |  | Nut height |
| `Spoke_Diameter` | `2` |  | Spoke diameter |
| `Screw_Diameter` | `3.5` |  | Screw hole diameter (3.5 for an M4 tap) |
| `Nut_Edge_Radius` | `0.5` |  | Radius of the rounded nut top edge |

### Template

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Template_Thickness` | `1.5` |  | Tape template thickness |

<!-- END GENERATED -->

## Hardware

- Two M4 screws and two printed nuts per reflector. The nut hole is 3.5 mm so the screw taps its own thread.
- 3M 3432 microprismatic tape, two pieces per reflector.

## Tape

1. Print the `template` part.
2. Lay the template on the tape backing and cut around it.
3. Peel the backing, press the tape onto the face, and fold it over the creases.
4. Repeat for the other face.

## Printing

- **Material**: PETG or ASA; the reflector sits outdoors.
- **Orientation**: Reflector on its flat side, as modeled, with supports under the mount arms. Nut and template as modeled.
- **Perimeters**: 3 or more on the nut.
