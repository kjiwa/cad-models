# Table Saw Blade Spacer

3D-printable spacers for a table saw arbor, printed one part at a time. The defaults are 2" discs, 3/32" thick, for a 13 mm arbor.

## Features

- Four parts: a bottom disc with a large bore, a middle disc with a raised hub, a top disc, and the hub ring alone.
- The ring centers the bottom disc on the arbor, and the hub on the middle disc locates the next spacer.
- Every circular edge is chamfered so the spacers do not catch or chip, while the faces stay flat and the stack height stays exact.
- Set the disc and hub sizes, thicknesses, both bores, and the chamfer.

<!-- BEGIN GENERATED -->

## Parameters

### Part

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Part` | `"bottom"` | Bottom, Middle, Top, Ring | Part to print |

### Disc

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Outer_Diameter` | `50.8` |  | Disc outside diameter (50.8 for 2") |
| `Thickness` | `2.38125` |  | Disc thickness (2.38125 for 3/32") |
| `Bottom_Bore_Diameter` | `15.5` |  | Bore of the bottom disc |
| `Bore_Diameter` | `13` |  | Bore of the other parts |

### Hub

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Hub_Diameter` | `15.5` |  | Hub outside diameter |
| `Hub_Thickness` | `2.38125` |  | Hub thickness (2.38125 for 3/32") |

### Finish

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Edge_Chamfer` | `0.4` |  | Chamfer on every circular edge (0 to disable) |

<!-- END GENERATED -->

## Printing

- **Material**: PETG or ABS; PLA is acceptable for light duty.
- **Orientation**: Flat on a face; no supports.
- **Fit**: Measure your arbor and set the bore diameters with a test print. The stack height is the sum of the part heights, so check it against your arbor length before use.
