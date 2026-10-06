# Bora Centipede Parametric Risers

Parametric, hardware-compatible risers and locking nuts for Bora Centipede work stands.

Bora sells 6" risers that raise the stands to 36". However, when using a sheet of plywood or workbench top, the working height rises to 36-3/4", which is too high to serve as an infeed or outfeed table for 36" table saws. This model allows customizable riser heights, including 5-1/4" risers (133.35 mm) to account for workbench top thickness, as well as the standard 6" height (152.4 mm) and matching knurled locking nuts.

Also posted on [Printables](https://www.printables.com/model/890834-bora-centipede-parametric-risers).

## Features

- **Hardware Compatibility**: Matches Bora Centipede top thread and base mount dimensions.
- **Parametric Height & Diameter**: Configurable overall height, web thickness, and cutouts.
- **Integrated Locking Nut**: Knurled perimeter with internal metric threading.
- **Truss Web Structure**: Arch cutouts reduce material consumption and print time while preserving axial load capacity.
- **Customizer Presets**: Predefined configurations for 5.25" risers, 6" risers, and locking nuts.
- **Automated CLI Build**: `Makefile` support to render STL, 3MF, and PNG preview images.

---

## Directory Structure

```text
bora_centipede_riser/
├── Makefile                   # Build automation for STL, 3MF, and PNG renders
├── README.md                  # Project documentation & printing recommendations
├── bora_centipede_riser.json  # Customizer parameter presets
├── bora_centipede_riser.scad  # Parametric OpenSCAD source model
└── threads-scad               # Symlink to ../lib/threads-scad submodule
```

---

## Using the OpenSCAD Customizer (GUI)

1. Open `bora_centipede_riser.scad` in OpenSCAD.
2. In the top menu, ensure **Window -> Customizer** is checked.
3. Select a preset from the dropdown (`5.25in`, `6in`, or `Nut`) or customize parameters.
4. Press `F5` to preview or `F6` to render, then `F7` to export to STL.

---

## Parameters Reference

All dimensions are in millimeters unless otherwise noted.

### `[Part]`
| Parameter | Default | Description |
|---|---|---|
| `Part` | `"riser"` | Component to render: `"riser"` or `"nut"` |

### `[Body]`
| Parameter | Default | Description |
|---|---|---|
| `Height` | `152.4` | Overall riser height (152.4 for 6", 133.35 for 5.25") |
| `Diameter` | `66` | Outside diameter of the riser body |

### `[Top]`
| Parameter | Default | Description |
|---|---|---|
| `Top_Thickness` | `4` | Thickness of the top plate |
| `Stud_Base_Diameter` | `15` | Diameter of the raised boss under the threaded stud |
| `Stud_Base_Height` | `6` | Height of the raised boss under the threaded stud |

### `[Bottom]`
| Parameter | Default | Description |
|---|---|---|
| `Bottom_Thickness` | `6` | Thickness of the bottom plate |
| `Bolt_Hole_Diameter` | `16` | Diameter of the mounting bolt clearance hole |
| `Nut_Recess_Diameter` | `27` | Diameter of the stand nut recess |
| `Nut_Recess_Height` | `32.75` | Depth of the stand nut recess |
| `Nut_Recess_Radius` | `6.25` | Corner radius of the stand nut recess |

### `[Reinforcement]`
| Parameter | Default | Description |
|---|---|---|
| `Reinforcement_Style` | `"flared_ribs"` | Reinforcement between the plates: `"flared_ribs"` (open truss), `"conical_vault"` (architectural column), or `"none"` (unreinforced) |
| `Web_Thickness` | `3.6` | Thickness of the crossed vertical webs |
| `Arch_Inner_Diameter` | `46` | Diameter of the arched cutouts between the webs |
| `Arch_End_Margin` | `4` | Distance from each plate to the ends of the arched cutouts |
| `Rib_Flare_Width` | `4` | Sideways flare added to each web at the plates (`flared_ribs` only) |
| `Rib_Flare_Height` | `10` | Height of the web flare transition (`flared_ribs` only) |
| `Cone_Height` | `8` | Height of the top and bottom cones (`conical_vault` only) |
| `Cone_Top_Diameter` | `36` | Narrow end diameter of the top cone (`conical_vault` only) |
| `Cone_Bottom_Diameter` | `40` | Narrow end diameter of the bottom cone (`conical_vault` only) |

### `[Thread]`
| Parameter | Default | Description |
|---|---|---|
| `Thread_Pitch` | `2` | Thread pitch shared by the stud and the nut |
| `Stud_Thread_Diameter` | `12.5` | Outer diameter of the threaded stud |
| `Stud_Thread_Length` | `10` | Length of the threaded stud |
| `Nut_Thread_Diameter` | `13.5` | Nominal diameter of the nut thread, including clearance |

### `[Nut]`
| Parameter | Default | Description |
|---|---|---|
| `Nut_Diameter` | `22` | Outside diameter of the locking nut |
| `Nut_Height` | `6.35` | Thickness of the locking nut (1/4 inch) |
| `Knurl_Count` | `15` | Number of grip notches around the perimeter |
| `Knurl_Diameter` | `1` | Diameter of each grip notch |

---

## Reinforcement Styles & Trade-Offs

The model provides three selectable reinforcement styles via `Reinforcement_Style`:

### 1. `flared_ribs` (Default — Open Cruciform Truss)
* **Aesthetic**: 100% faithful to the open-air Bora Centipede truss design. The quadrants between the four vertical spines remain completely open and transparent from top to bottom.
* **Mechanics**: Each rib smoothly widens in thickness (from 3.6 mm at the waist to 11.6 mm at the plate junctions) over a 10 mm ramp. This triples the contact surface area at the plates (from 387 mm² to 1,120 mm² at the top; 234 mm² to 700 mm² at the bottom) and eliminates the sharp 90° notch where layer delamination starts under lateral bending.
* **Filament & Print Time**: 93.5 cm³ (~116 g solid PLA, or ~55 g sliced at 20% infill). Adds only ~12 g of filament over the unreinforced model.
* **Best For**: General woodworking and job-site use where retaining the lightweight, open-air aesthetic of the original risers is desired.

### 2. `conical_vault` (Architectural Column)
* **Aesthetic**: Sculpted architectural column aesthetic reminiscent of a classical Tuscan or Doric order capital and plinth. Under the top circular plate, a continuous 45° revolved cone flares from 36 mm to 66 mm. Above the bottom plate, a matching inverted cone tapers from 66 mm to 40 mm. The center between the cones remains completely open.
* **Mechanics**: Maximum possible bending and shear strength ($5\times$ to $8\times$ over unreinforced). The continuous 360° conical vault provides unbroken perimeter support beneath the entire rim of the top plate. This prevents plate flexure or diaphragm peeling when heavy dog clamps, edge vises, or workpieces exert off-axis forces between the spines. At the base, the cone acts as a rigid collar around the nut cavity.
* **Filament & Print Time**: 111.5 cm³ (~138 g solid PLA, or ~65 g sliced at 20% infill). Adds ~25 g over unreinforced (+10 g over `flared_ribs`).
* **Best For**: Heavy-duty workshop environments with extreme lateral racking, heavy timber, or off-axis clamping forces.

### 3. `none` (Unreinforced Original)
* **Aesthetic**: Pure geometric replica of the original injection-molded part with straight 3.6 mm ribs meeting the plates at 90°.
* **Filament & Print Time**: 74.3 cm³ (~92 g solid PLA, or ~45 g sliced at 20% infill).
* **Note**: In upright FDM printing, horizontal layer lines at the sharp 90° spine-to-plate transition are susceptible to tensile shear delamination under lateral loads.

**A note on testing**: `flared_ribs` (the default) targets a real field-reported failure mode — the top plate peeling off the ribs, i.e. delamination at the 90° rib-to-plate joint — by replacing that butt joint with a filleted ramp, but this reinforcement has not yet been physically load-tested. `none` reproduces the original, field-tested Printables geometry exactly (byte-identical except for a 3mm→4mm top-thickness bump and a screw-cutout epsilon fix) for anyone who wants the known-working part while `flared_ribs`/`conical_vault` are validated.

---

## CLI Build & Automation

Run `make` commands from this directory or from the root repository directory:

```bash
# Build default STL, 3MF, preview PNG, and all presets
make all

# Build only default STL
make stl

# Build only default 3MF
make 3mf

# Generate preview PNG
make preview

# Build all presets defined in bora_centipede_riser.json
make presets

# Clean build directory
make clean
```

Outputs are generated in the `build/` subdirectory:
- `build/bora_centipede_riser.stl` / `.3mf` / `_preview.png` (default 6" riser)
- `build/bora_centipede_riser_5_25in.stl` / `.3mf` / `_preview.png` (5.25" riser preset)
- `build/bora_centipede_riser_6in.stl` / `.3mf` / `_preview.png` (6" riser preset)
- `build/bora_centipede_riser_Nut.stl` / `.3mf` / `_preview.png` (Nut preset)

---

## 3D Printing Recommendations

- **Material**: PLA, PETG, or PLA+ (PLA provides optimal compressive stiffness and dimensional stability under vertical load).
- **Print Orientation**: Upright on the flat base (100% self-supporting with 45° gussets, zero supports required).
- **Layer Height**: 0.20 mm or 0.24 mm (superior Z-axis inter-layer adhesion compared to 0.30 mm draft).
- **Perimeters**: 4 walls (with a standard 0.40/0.45 mm line width, 4 perimeters make the 3.6 mm ribs 100% solid perimeter plastic).
- **Solid Layers**: 5 or more top and bottom solid layers for rigid cap diaphragms.
- **Infill**: 20% Gyroid (provides isotropic shear resistance in the central core and caps).
- **Print Temperature & Cooling**: Increase nozzle temperature by 5–10°C over nominal and reduce part cooling fan speed (30–50%) to maximize inter-layer weld strength and shear resistance.
