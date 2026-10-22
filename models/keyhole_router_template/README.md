# Keyhole Router Template

A 3D-printable router template for cutting hanging slots (keyholes) in picture frames and other workpieces. A 5/8" guide bushing follows each slot, and a narrower venting slot lets chips escape.

## Features

- `three_slot` lines up with a frame corner and routes one long and two short slots that are always level.
- `edge_guide` straddles a workpiece between two fences and routes one slot, chosen with `Fenced_Slot`; the `Edge_Guide` preset is a 6" x 1-1/2" plate with one short slot.
- `Workpiece_Width` sets the gap between the fences; the `edge_guide` plate depth is that width plus both fences.
- V-notches in the plate edge mark each slot's center and both bushing-stop ends, and cut through both fences on `edge_guide`.
- A narrow venting slot extends past both ends of each guide channel.
- Plate corners are rounded.

<!-- BEGIN GENERATED -->

## Parameters

### Style

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Style` | `"three_slot"` | Three Slots, Single Slot With Side Fences | Template layout |

### Plate

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Plate_Width` | `228.6` |  | Plate width along the slots (X) (228.6 for 9" three_slot, 152.4 for 6" edge_guide) |
| `Plate_Depth` | `76.2` |  | Plate depth across the slots (Y), three_slot only (76.2 for 3") |
| `Plate_Thickness` | `6.35` |  | Plate thickness, which sets the guide bushing engagement (6.35 for 1/4") |
| `Mark_Depth` | `2.38125` |  | Depth of the 90 degree alignment notches at each slot center and bushing-stop end (0 to disable) |

### Slots

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Guide_Width` | `16.66875` |  | Guide channel width, the guide bushing diameter plus clearance (16.66875 for 21/32" around a 5/8" bushing) |
| `Short_Slot_Length` | `31.75` |  | Center-to-center length of the short slot (31.75 for 1-1/4") |
| `Long_Slot_Length` | `139.7` |  | Center-to-center length of the long slot (139.7 for 5-1/2") |
| `Fenced_Slot` | `"short"` | Short Slot, Long Slot | Slot routed by edge_guide |

### Venting Slots

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Venting_Slot_Length` | `12.7` |  | Length the venting slot extends past each end of the guide channel (12.7 for 1/2") |
| `Venting_Slot_Width` | `6.35` |  | Venting slot width (6.35 for 1/4") |

### Fences

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Workpiece_Width` | `31.75` |  | Width of the workpiece the fences straddle plus clearance, edge_guide only (31.75 for 1-1/4") |
| `Fence_Thickness` | `3.175` |  | Fence thickness, edge_guide only (3.175 for 1/8") |
| `Fence_Height` | `6.35` |  | Fence height above the plate, edge_guide only (6.35 for 1/4") |

## Presets

- `Edge_Guide`

<!-- END GENERATED -->

## Printing

- **Material**: PLA or PETG; the plate is rigid.
- **Orientation**: Flat on the bed, no supports required.
- **Use**: Secure the template with double-faced tape and use dust extraction while routing; chips do not clear a keyhole slot on their own. Drilling a pilot hole first reduces router load.
- **Alignment**: Line the notches up with pencil marks on the workpiece. The center notch marks the slot center; the end notches mark where the bushing stops, so the router bit reaches the slot ends.
- **Bit Depth**: Set the bit depth to (stock thickness + keyhole depth) / 2.
