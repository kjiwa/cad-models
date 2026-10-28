# Honda Chassis Plugs

Cosmetic caps for the open frame tubes and pillion holder tubes of a Honda CB300R, modeled on Puig's finned plugs. They are not load-bearing.

## Features

- The default is the frame plug (20 mm stem). The `Pillion_Holder_Left` (34 mm stem) and `Pillion_Holder_Right` (35 mm stem) presets are the pillion holder plugs.
- Ribs along the stem give an interference fit, in TPU or PLA, and are the default. `Stem_Diameter` is measured over the rib crests; set `Rib_Count` to 0 for a straight stem.
- Fins are Puig-style graduated flanges that flex to grip the tube. Printed cap down, each is a flat flange with nothing under it, so they suit SLA or experiments; set `Fin_Count` above 0 to add them.
- The visible cap edge is rounded, and the tip of a stem without ribs has a lead-in chamfer (the first rib leads in otherwise).

<!-- BEGIN GENERATED -->

## Parameters

### Cap

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Cap_Diameter` | `37` |  | Cap outside diameter |
| `Cap_Thickness` | `7.5` |  | Cap thickness |
| `Cap_Corner_Radius` | `3.75` |  | Radius of the rounded cap edge (at most half the cap thickness) |

### Stem

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Stem_Length` | `16` |  | Length of the stem, from the cap to the tip |
| `Stem_Diameter` | `20` |  | Stem outside diameter, measured over the rib crests |
| `Wall_Thickness` | `3` |  | Wall thickness of the cap floor and the hollow stem |
| `Rib_Count` | `10` | 0 to 20, step 1 | Number of ribs along the stem (0 to disable) |
| `Rib_Height` | `1` |  | Radial height of each rib |
| `Stem_Chamfer` | `1` |  | Width of the lead-in chamfer at the tip of a stem without ribs |

### Fins

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Fin_Count` | `0` | 0 to 12, step 1 | Number of fins along the stem (0 to disable) |
| `Fin_Thickness` | `0.3` |  | Fin thickness |
| `Fin_Large_Diameter` | `30` |  | Diameter of the fin nearest the cap |
| `Fin_Small_Diameter` | `25` |  | Diameter of the fin nearest the tip |

## Presets

- `Pillion_Holder_Left`
- `Pillion_Holder_Right`

<!-- END GENERATED -->

## Printing

- **Quantity**: two frame plugs and one of each pillion holder plug.
- **Material**: TPU for the best grip, or PLA.
- **Orientation**: Cap down, as modeled.
