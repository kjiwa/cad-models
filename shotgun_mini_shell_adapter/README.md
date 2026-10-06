# Shotgun Mini Shell Adapter

A 3D-printable adapter for Mossberg 12 gauge shotguns that holds 1.75" (44.45 mm) mini shells. It is compatible with the fit of the commercial OPSol Mini-Clip; this is an independent design. The defaults fit a Mossberg 12 gauge 1.75" shell.

## Features

- Every default is tuned to the receiver and shell. Change them only with a test print.
- Support-free: the sloped front faces are 45 degrees and the rear notch is a 2 mm bridge.

<!-- BEGIN GENERATED -->

## Parameters

### Overall Dimensions

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Width` | `35` |  | Adapter width along the barrel (X) |
| `Depth` | `26` |  | Adapter depth across the receiver (Y) |
| `Height` | `20.5` |  | Adapter height (Z) |

### Rear Cutout

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Rear_Cutout_Height` | `9.5` |  | Height of the notch across the rear |
| `Rear_Cutout_Depth` | `2` |  | Depth of the notch into the rear face |

### Front Cutout

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Front_Cutout_Depth` | `7` |  | Depth of the square notch across the front |
| `Front_Cutout_Angle` | `45` | 15 to 75, step 5 | Angle of the sloped front cut from vertical |
| `Front_Cutout_Drop` | `4` |  | Distance below the base where the sloped front cut starts |

### Side Relief

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Side_Relief_Depth` | `4.75` |  | Depth of the relief cut into each side of the top |
| `Side_Slope_Start` | `-2.5` |  | Position along X where the side slope starts |
| `Side_Slope_Rise` | `2.5` |  | Rise of the side slope over its run |
| `Side_Slope_Run` | `11` |  | Run of the side slope over its rise |

### Bore

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Bore_Diameter` | `12.7` |  | Diameter of the shell bore (12.7 for 1/2") |
| `Bore_Depth` | `18.35` |  | Depth of the shell bore |
| `Bore_Setback` | `2.5` |  | Distance from the rear face to the bore edge along X |

### Slot

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Slot_Width` | `9.9` |  | Width of the slot (Y) |
| `Slot_Depth` | `12.5` |  | Depth of the slot |
| `Slot_Gap` | `1` |  | Gap between the bore and the slot along X |
| `Slot_Corner_Radius` | `1.5` |  | Corner radius of the slot ahead of the bore |

<!-- END GENERATED -->

## Printing

- **Material**: TPU or another flexible filament, since the adapter flexes to seat in the receiver.
- **Orientation**: As modelled, flat on the bottom face with the shell bore vertical. No supports (the largest overhang is a 2 mm bridge at the rear notch and 45 degree faces at the front), the bore wall prints as continuous perimeters, and the bottom face gives the largest bed contact.
- **Walls**: 4 or more perimeters; the bore wall beside each top relief is under 2 mm thick.
- **Testing**: Cycled with snap caps only. It has not been tested with live shells.
