# Bora Centipede Parametric Risers

Parametric, hardware-compatible risers and locking nuts for Bora Centipede work stands.

Bora sells 6" risers that raise the stands to 36". However, when using a sheet of plywood or workbench top, the working height rises to 36-3/4", which is too high to serve as an infeed or outfeed table for 36" table saws. This model allows customizable riser heights, including 5-1/4" risers (133.35 mm) to account for workbench top thickness, as well as the standard 6" height (152.4 mm) and matching knurled locking nuts.

Also posted on [Printables](https://www.printables.com/model/890834-bora-centipede-parametric-risers).

## Features

- Matches Bora Centipede top thread and base mount dimensions.
- Arch cutouts between the webs reduce material and print time while preserving axial load capacity.
- Knurled locking nut with internal metric threading, selected with `Part`.

<!-- BEGIN GENERATED -->

## Parameters

### Part

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Part` | `"riser"` | Riser, Nut | Component to render |

### Body

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Height` | `152.4` |  | Overall riser height (152.4 for 6", 133.35 for 5.25") |
| `Diameter` | `66` |  | Outside diameter of the riser body |

### Top

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Top_Thickness` | `4` |  | Thickness of the top plate |
| `Stud_Base_Diameter` | `15` |  | Diameter of the raised boss under the threaded stud |
| `Stud_Base_Height` | `6` |  | Height of the raised boss under the threaded stud |

### Bottom

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Bottom_Thickness` | `6` |  | Thickness of the bottom plate |
| `Bolt_Hole_Diameter` | `16` |  | Diameter of the mounting bolt clearance hole |
| `Nut_Recess_Diameter` | `27` |  | Diameter of the stand nut recess |
| `Nut_Recess_Height` | `32.75` |  | Depth of the stand nut recess |
| `Nut_Recess_Radius` | `6.25` |  | Corner radius of the stand nut recess |

### Reinforcement

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Reinforcement_Style` | `"flared_ribs"` | Flared Ribs, Conical Vault, None | Reinforcement between the top and bottom plates |
| `Web_Thickness` | `3.6` |  | Thickness of the crossed vertical webs |
| `Arch_Inner_Diameter` | `46` |  | Diameter of the arched cutouts between the webs |
| `Arch_End_Margin` | `4` |  | Distance from each plate to the ends of the arched cutouts |
| `Rib_Flare_Width` | `4.0` |  | Sideways flare added to each web at the plates (flared_ribs only) |
| `Rib_Flare_Height` | `10.0` |  | Height of the web flare transition (flared_ribs only) |
| `Cone_Height` | `8.0` |  | Height of the top and bottom cones (conical_vault only) |
| `Cone_Top_Diameter` | `36.0` |  | Narrow end diameter of the top cone (conical_vault only) |
| `Cone_Bottom_Diameter` | `40.0` |  | Narrow end diameter of the bottom cone (conical_vault only) |

### Thread

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Thread_Pitch` | `2` |  | Thread pitch shared by the stud and the nut |
| `Stud_Thread_Diameter` | `12.5` |  | Outer diameter of the threaded stud |
| `Stud_Thread_Length` | `10` |  | Length of the threaded stud |
| `Nut_Thread_Diameter` | `13.5` |  | Nominal diameter of the nut thread, including clearance |

### Nut

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Nut_Diameter` | `22` |  | Outside diameter of the locking nut |
| `Nut_Height` | `6.35` |  | Thickness of the locking nut |
| `Knurl_Count` | `15` | 3 to 40, step 1 | Number of grip notches around the perimeter |
| `Knurl_Diameter` | `1` |  | Diameter of each grip notch |

## Presets

- `Riser_5_25in`
- `Nut`

<!-- END GENERATED -->

## Printing

- **Material**: PLA, PETG, or PLA+ (PLA provides optimal compressive stiffness and dimensional stability under vertical load).
- **Orientation**: Upright on the flat base (100% self-supporting with 45 degree gussets, zero supports required).
- **Layer Height**: 0.20 mm or 0.24 mm (superior Z-axis inter-layer adhesion compared to 0.30 mm draft).
- **Perimeters**: 4 walls (with a standard 0.40/0.45 mm line width, 4 perimeters make the 3.6 mm ribs 100% solid perimeter plastic).
- **Solid Layers**: 5 or more top and bottom solid layers for rigid cap diaphragms.
- **Infill**: 20% Gyroid (provides isotropic shear resistance in the central core and caps).
- **Temperature and Cooling**: Increase nozzle temperature by 5-10 C over nominal and reduce part cooling fan speed (30-50%) to maximize inter-layer weld strength and shear resistance.

## Reinforcement Styles

### `flared_ribs` (default, open cruciform truss)

- **Aesthetic**: Faithful to the open-air Bora Centipede truss design. The quadrants between the four vertical spines remain open from top to bottom.
- **Mechanics**: Each rib widens from 3.6 mm at the waist to 11.6 mm at the plate junctions over a 10 mm ramp. This triples the contact area at the plates (387 to 1,120 mm2 at the top; 234 to 700 mm2 at the bottom) and removes the sharp 90 degree notch where layer delamination starts under lateral bending.
- **Filament**: 93.5 cm3 (~116 g solid PLA, ~55 g sliced at 20% infill), ~12 g more than unreinforced.
- **Best for**: General woodworking and job-site use.

### `conical_vault` (architectural column)

- **Aesthetic**: Classical column capital and plinth. Under the top plate, a continuous 45 degree cone flares from 36 mm to 66 mm; above the bottom plate, a matching inverted cone tapers from 66 mm to 40 mm. The centre between the cones stays open.
- **Mechanics**: Highest bending and shear strength (5x to 8x over unreinforced). The 360 degree vault supports the whole rim of the top plate, preventing plate flexure or peeling under off-axis forces from dog clamps, edge vises, or workpieces. At the base, the cone acts as a rigid collar around the nut cavity.
- **Filament**: 111.5 cm3 (~138 g solid PLA, ~65 g sliced at 20% infill), ~25 g more than unreinforced.
- **Best for**: Heavy-duty use with lateral racking, heavy timber, or off-axis clamping forces.

### `none` (unreinforced)

- **Aesthetic**: Geometric replica of the original injection-molded part, with straight 3.6 mm ribs meeting the plates at 90 degrees.
- **Filament**: 74.3 cm3 (~92 g solid PLA, ~45 g sliced at 20% infill).
- **Note**: In upright FDM printing, layer lines at the 90 degree spine-to-plate transition are prone to tensile shear delamination under lateral loads.

`flared_ribs` targets a field-reported failure, the top plate peeling off the ribs at the 90 degree joint, by replacing the butt joint with a filleted ramp. It has not been load-tested. `none` reproduces the original, field-tested Printables geometry (byte-identical except a 3 mm to 4 mm top-thickness bump and a screw-cutout epsilon fix).
