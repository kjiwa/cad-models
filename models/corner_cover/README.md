# Corner Cover

A 3D-printable cap for the outside corner of a mitered sill, such as a deck sill, whose sharp butt joint snags skin and clothing. It slips over both sills near the corner from above.

**The defaults are placeholders** for a 1-1/4" square sill. Measure the sill before printing and set the parameters below.

## Features

- Every outer edge is rounded to the wall thickness, so nothing sharp is left at the corner.
- The cavity follows the mitered sills, including corners other than 90 degrees.
- A lip under the sill, with a 45 degree top, snaps the cover on without adhesive and prints without supports.
- Both sill ends are open, so the cover covers only the corner and the sills continue past it.
- Set the sill size, corner angle, reach, wall thickness, fit clearance, and lip.

## Measure

- Sill width across the top and sill height, at the corner.
- The interior angle between the sills at the corner.
- Whether the sill's underside is flat where the lip reaches; set Lip_Depth to 0 if not.

<!-- BEGIN GENERATED -->

## Parameters

### Sill

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Sill_Width` | `31.75` |  | Sill width across the top (31.75 for 1-1/4") |
| `Sill_Height` | `31.75` |  | Sill height (31.75 for 1-1/4") |
| `Corner_Angle` | `90` | 60 to 180, step 5 | Interior angle between the two sills at the corner |

### Cover

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Cover_Length` | `50.8` |  | Reach of the cover along each sill from the corner (50.8 for 2") |
| `Wall_Thickness` | `3.175` |  | Cover wall thickness, also the radius of the rounded outer edges (3.175 for 1/8") |
| `Fit_Clearance` | `0.2` |  | Gap between the sill and the cover |
| `Lip_Depth` | `3.175` |  | How far the lip reaches under the sill (0 to disable) |

<!-- END GENERATED -->

## Printing

- **Material**: PETG for outdoor use; TPU flexes enough to snap over the lip but is untested here.
- **Orientation**: Top face down, open side up, so the lip prints without supports.
- **Fit**: Print a short test with a smaller Cover_Length first, and adjust Fit_Clearance. Add VHB tape on the top face if the lip alone is loose.
