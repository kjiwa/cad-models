# Stop Block

A 3D-printable stop block that clamps over a fence with a bolt through a slot in each leg, for indexing workpieces against a ruler. The defaults fit a 35 mm deep, 66 mm tall fence.

## Features

- The faces on the fence and both end faces stay flat and square so the block seats true and indexes accurately.
- Every other corner is rounded, so the block is comfortable to handle and slide.
- A relief at the fence's top edge and at the table keeps sawdust from holding the block off.
- Entry chamfers on both slots guide the bolt and seat its washer.
- Set the fence size, leg thicknesses, width, corner radius, and bolt size.

<!-- BEGIN GENERATED -->

## Parameters

### Fence

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Fence_Height` | `66` |  | Fence height the block sits over |
| `Fence_Depth` | `35` |  | Fence depth the block sits against |

### Block

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Width` | `19` |  | Block width along the fence |
| `Top_Thickness` | `10` |  | Thickness of the leg over the top of the fence |
| `Front_Thickness` | `19` |  | Thickness of the leg against the front of the fence |
| `Edge_Radius` | `4` |  | Radius of the rounded outer corners |
| `Dust_Relief` | `2` |  | Size of the dust relief at both fence corners (0 to disable) |

### Hardware

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Bolt_Diameter` | `7` |  | Bolt diameter, also the slot width |
| `Bolt_Hole_Offset` | `10` |  | Distance from the fence edges to the slot ends |

<!-- END GENERATED -->

## Printing

- **Material**: PETG or ABS; PLA creeps under sustained clamping.
- **Orientation**: Flat on one end face, so layers run along the legs. Do not print standing on a leg.
- **Walls**: Use at least 4 perimeters and 40% infill around the slots.
- **Hardware**: A bolt through each slot with a washer; pair with a knob from the `knob` model.
