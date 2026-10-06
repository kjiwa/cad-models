# Entryway Table

A parametric model of an entryway table designed for plywood construction with angled legs and decorative apron rings.

## Features

- Layered plywood boards with alternating veneer colors, for visualization.
- Four L-shaped legs of two boards each, with a 3.75 degree taper on the lower inner face and an accent groove below the apron.
- Front, back, and side apron boards; `Apron_Width` and `Apron_Depth` default to the span between the legs.

<!-- BEGIN GENERATED -->

## Parameters

### Tabletop

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Top_Width` | `1219.2` |  | Tabletop width along X |
| `Top_Depth` | `279.4` |  | Tabletop depth along Y |
| `Top_Overhang` | `38.1` |  | Tabletop overhang beyond the leg outer faces |

### Legs

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Leg_Height` | `914.4` |  | Leg height from floor to underside of the top |
| `Leg_Board_Width` | `50.8` |  | Width of each board in the L-shaped leg |

### Apron

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Apron_Height` | `203.2` |  | Height of the apron boards |
| `Apron_Width` | `0` |  | Width of the front and back apron boards (0 = auto) |
| `Apron_Depth` | `0` |  | Depth of the side apron boards (0 = auto) |

### Plywood

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Board_Thickness` | `19.05` |  | Plywood sheet thickness |
| `Ply_Count` | `5` | 1 to 10, step 1 | Number of plies for alternating veneer visualization |

<!-- END GENERATED -->

## Building

The table is built from plywood, not printed. Cut every board from sheet of `Board_Thickness`; the rendered model shows each board's position and size.
