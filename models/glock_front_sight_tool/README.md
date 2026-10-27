# Glock Front Sight Tool

A 3D-printable cap that slips over a Glock slide, with a slot for the front sight, to hold the slide square while drifting or pressing the sight.

## Features

- Four slide sizes cover the common Glock models.
- The cavity is the slide width plus a clearance, with a chamfered entry so the cap starts onto the slide easily.
- The sight slot opens at one end and has a chamfered entry.
- Set the clearance, sight slot, tool size, wall thickness, and edge rounding.

<!-- BEGIN GENERATED -->

## Parameters

### Slide

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Slide_Size` | `"standard"` | Compact G42, Slimline G43X G43 G48, Standard G17 G19 G45 G24, Wide G21 G29 | Slide size: compact 21 mm, slimline 22 mm, standard 25.5 mm, wide 28.5 mm |
| `Slide_Clearance` | `0.2` |  | Total clearance added to the cavity width |

### Sight

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Sight_Width` | `3.5` |  | Width of the sight slot |
| `Sight_Length` | `10` |  | Length of the sight slot from the open end |

### Tool

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Tool_Height` | `15` |  | Tool height |
| `Tool_Length` | `20` |  | Tool length |
| `Wall_Thickness` | `3` |  | Wall thickness around the slide and over the sight |
| `Entry_Chamfer` | `1` |  | Size of the entry chamfers on the cavity and the sight slot |
| `Edge_Radius` | `1.5` |  | Radius of the rounded outer edges |

<!-- END GENERATED -->

## Printing

- **Material**: PETG or ABS.
- **Orientation**: Cavity facing down, as modeled.
- **Fit**: Glock slide widths are rounded and carry no tolerances. Test-print and adjust `Slide_Clearance`.
