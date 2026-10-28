# SW-Motech T-Lock MOLLE Adapter

A 3D-printable clone of an SW-Motech T-Lock MOLLE adapter. The ring and its two notches lock into the T-Lock holder, and MOLLE webbing threads through the four strap slots.

## Features

- `Fit_Clearance` trims the ring's outside and both notches by that gap per side for a printed fit. The default of 0.3 mm is provisional: measure the real adapter's ring and notches, test-print, then set it. 0 reproduces the nominal size.
- The bayonet opening inside the ring does not change with `Fit_Clearance`.
- The strap slot edges are rounded on both faces, where the webbing bears, and the plate's top edge is rounded. The ring and notch faces stay sharp, since they locate in the holder.
- Set the ring, notch, plate, tab, and slot sizes.

<!-- BEGIN GENERATED -->

## Parameters

### Lock Cylinder

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Lock_Outer_Diameter` | `34` |  | Ring outer diameter (before Fit_Clearance) |
| `Lock_Outer_Corner_Radius` | `1` |  | Radius of the rounded ring top edge |
| `Lock_Inner_Diameter_Long` | `25` |  | Long diameter of the bayonet opening |
| `Lock_Inner_Diameter_Short` | `20` |  | Short diameter of the bayonet opening |
| `Lock_Inner_Tab_Length` | `20` |  | Length of the opening's tab (along the long diameter) |
| `Lock_Inner_Tab_Width` | `15` |  | Width of the opening's tab (along the short diameter) |
| `Lock_Top_Thickness` | `3` |  | Height of the wide inner recess, measured from the plate |
| `Lock_Depth` | `5` |  | Ring height above the plate |
| `Lock_Notch_Depth` | `1` |  | Radial depth of each notch beyond the ring (before Fit_Clearance) |
| `Lock_Notch_Width` | `3` |  | Notch width (before Fit_Clearance) |
| `Lock_Notch_Corner_Radius` | `1` |  | Radius of the notch corners |

### Fit

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Fit_Clearance` | `0.3` |  | Gap per side on the ring's outside and the notches, trimmed from the nominal size |

### Strap Plate

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Strap_Plate_Length` | `80` |  | Plate length |
| `Strap_Plate_Width` | `50` |  | Plate width, not counting the tabs |
| `Strap_Plate_Thickness` | `3` |  | Plate thickness |
| `Strap_Plate_Corner_Radius` | `5` |  | Radius of the plate's rounded corners |
| `Strap_Plate_Edge_Radius` | `0.8` |  | Radius of the rounded top edge around the plate |
| `Strap_Plate_Tab_Length` | `30` |  | Length of each tab |
| `Strap_Plate_Tab_Width` | `10` |  | Width of each tab beyond the plate |
| `Strap_Plate_Tab_Corner_Radius` | `5` |  | Radius of the tab's outer corners |

### Strap Slots

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Strap_Hole_Width` | `5` |  | Slot width |
| `Strap_Hole_Length` | `26` |  | Slot length |
| `Strap_Hole_Corner_Radius` | `2.5` |  | Radius of the slot ends |
| `Strap_Hole_Edge_Radius` | `0.8` |  | Radius of the rounded slot edges on both faces, where the webbing bears |

<!-- END GENERATED -->

## Printing

- **Material**: PETG or ABS.
- **Orientation**: Plate down, as modeled.
