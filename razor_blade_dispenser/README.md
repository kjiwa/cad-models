# Pegboard Single-Edge Razor Blade Dispenser

A parametric, 3D-printable pegboard dispenser for single-edge utility razor blades, supporting side-by-side towers for metal blades and plastic scraper blades on standard 1/4" pegboard.

## Features

- **Side-by-Side Dual Compartments**: Dispenses metal blades and plastic scraper blades from separate dedicated chutes with debossed front identification badges (`METAL` and `PLASTIC`).
- **Tailored Cavity Depths with Flush Front**: Independent internal pocket depths for sleeved metal blades (`23.0 mm`, accommodating 22.0 mm paper-sleeved blades) and plastic blades (`20.0 mm`, accommodating 18.7 mm blades), front-aligned so multi-tower dispenser faces remain coplanar.
- **Parametric Capacity & Count**: Configurable dispenser height (`dispenser_height`) and number of side-by-side towers (`dispenser_count`).
- **Calibrated Single-Blade Exit Gates**: Independent exit gate heights for metal blades (`1.7 mm`, matching ~1.2 mm sleeved blade) and plastic blades (`2.1 mm`, matching ~1.6 mm body), preventing double feeding.
- **Support-Free Internal Bridging**: 45-degree lead-in chamfer on the exit gate ceiling prevents sagging during bridging so chutes print cleanly without internal support.
- **Full-Height Open-Top Finger Loading Channel**: 20 mm wide front channel extends completely through the top rim with rounded entry lead-in chamfers, enabling an index finger to support the bottom of a blade stack from entry all the way to the floor without blades tumbling or jamming.
- **Drop-In Gravity Follower Weights**: Low-profile (12.0 mm tall) follower weights slide freely inside each chute, applying consistent downward normal force on the blade stack for positive traction on the bottom blade, eliminating blade shifting during extraction, and dampening workshop vibration. Features an ergonomic top pull fin, a front indicator tab that tracks inventory through the front channel, debossed badges (`M` / `P` on front, `METAL` / `PLASTIC` on top), and an optional ballast pocket for standard coins (pennies) or hex nuts.
- **Full-Depth Slide-Out Channel & Front Shelf**: Bottom finger channel extends all the way to the chute rear wall, exposing the full blade underside so the user can easily push the bottom blade forward from underneath onto the front resting shelf for pinch-grip extraction.
- **Smooth Bellmouth Flared Front Opening**: Parametric flared opening profile blending seamlessly from the vertical sight slot into the exit gate. Provides continuous G1/G2 tangent curvature that eliminates sharp corners, directional kinks, and inward pinch points for comfortable downward thumb feed and blade extraction.
- **Dual Pegboard & Wall Mounting**: Standard 1/4" pegboard hooks with heel relief, plus countersunk #8 screw mounting clearance holes with front driver pass-through tunnels and an `include_pegs` toggle for flush wall or cabinet mounting.
- **Sleeved vs. Bare Metal Blade Calibration**: Configurable pocket depths for paper-sleeved blades (`23.0 mm`) and bare unwrapped blades (`20.5 mm`), eliminating stack tilt and slop.
- **Front Inventory Sight Slots**: Full-height vertical slots allow visual tracking of remaining blades and downward thumb feed.
- **Pegboard Locking Hooks**: Standard 1/4" pegboard mounting (1" pitch, 1/4" board thickness) reusing contoured retention hooks with heel relief and stabilizing pins that lock within 1/4" wall clearance.
- **Open Top Drop-In Loading**: Chamfered top funnels facilitate effortless blade reloading.
- **Monolithic Backplate**: Top-rear tilt insertion chamfer, rounded corners, optional countersunk screw holes (#8 screw), and weight-relief windows.
- **OpenSCAD Customizer Compatible**: Fully documented parameters with interactive sliders and drop-down menus.

---

## Directory Structure

```text
razor_blade_dispenser/
├── Makefile                        # Build automation for STL, 3MF, preview PNG, and presets
├── README.md                       # Project documentation & printing recommendations
├── razor_blade_dispenser.json      # Customizer parameter presets
├── razor_blade_dispenser.scad      # Top-level assembly orchestrator & Customizer parameters
└── components/
    ├── backplate.scad              # Mounting backplate, screw holes, and weight-relief windows
    ├── dispensing_chute.scad       # Blade cavity, calibrated exit gates, finger scoop, and sight slot
    ├── follower.scad               # Parametric gravity follower weights with indicator tab & ballast pocket
    ├── labels.scad                 # Component visibility filters and 3D preview inspection labels
    ├── pegs.scad                   # Pegboard hook and pin layout orchestrator
    └── tower_body.scad             # Monolithic dispenser shell, front shelf, top funnel, debossed text
```


---

## Customizer Parameters

### `[Component Selection]`
| Parameter | Default | Description |
|---|---|---|
| `part` | `dispenser` | Component part to generate (`dispenser`, `assembly`, `follower_metal`, `follower_plastic`, `followers`) |

### `[Dispenser Configuration]`
| Parameter | Default | Description |
|---|---|---|
| `slot_pattern` | `MP` | Slot types: `M` for Metal, `P` for Plastic (e.g. `P`, `M`, `MP`, `MMMMPPMMM`) |
| `dispenser_count` | `0` | Number of towers (0 auto-derives from `slot_pattern` length) |
| `dispenser_height` | `100.0` | Total vertical tower height in mm |
| `slot_spacing_pegs` | `2` | Tower spacing in pegboard hole increments (1 in / 25.4 mm) |

### `[Blade Cavity & Exit Gates]`
| Parameter | Default | Description |
|---|---|---|
| `chute_width` | `41.0` | Internal blade cavity width in mm |
| `metal_blade_type` | `sleeved` | Packaging type: `sleeved` (22.0 mm depth) or `bare` (19.5 mm depth) |
| `metal_chute_depth` | `23.0` | Internal cavity depth for sleeved metal blades in mm |
| `bare_metal_chute_depth` | `20.5` | Internal cavity depth for bare metal blades in mm |
| `plastic_chute_depth` | `20.0` | Internal blade cavity depth for plastic blades in mm (fits 18.7 mm blades) |
| `metal_exit_height` | `1.7` | Exit gate height for metal blade slot in mm |
| `plastic_exit_height` | `2.1` | Exit gate height for plastic blade slot in mm |
| `chute_depth` | `0` | Legacy global chute depth override (0 uses independent depths) |

### `[Grip & Front Features]`
| Parameter | Default | Description |
|---|---|---|
| `grip_notch_width` | `22.0` | Width of bottom finger scoop cutout in mm |
| `grip_notch_depth` | `0` | Depth of bottom finger scoop channel in mm (0 for full depth extending to rear wall) |
| `shelf_extension` | `6.0` | Forward extension of front resting shelf in mm |
| `opening_flare_width` | `26.0` | Bottom width of outward flared opening ramp in mm |
| `opening_flare_height` | `12.0` | Vertical height of outward flared opening ramp in mm |
| `enable_sight_slots` | `true` | Enable front vertical sight slots for inventory |
| `sight_slot_width` | `20.0` | Width of front finger loading channel and sight slot in mm |
| `slot_top_chamfer` | `2.0` | Lead-in corner chamfer for top entry into the front slot in mm |
| `enable_badge_labels` | `true` | Enable debossed front text badges |
| `badge_text_size` | `3.2` | Font size for debossed text badges in mm |
| `badge_deboss_depth` | `0.6` | Deboss depth into front face in mm |

### `[Gravity Follower Weight]`
| Parameter | Default | Description |
|---|---|---|
| `follower_height` | `12.0` | Vertical thickness of follower weight in mm |
| `follower_clearance` | `0.5` | Perimeter clearance between follower and chute pocket in mm |
| `follower_tab_lead` | `1.5` | Protrusion of front indicator tab beyond dispenser front face in mm |
| `include_ballast_pocket` | `true` | Include internal ballast pocket for standard coins (pennies) or hex nuts |
| `ballast_pocket_width` | `22.0` | Width of internal ballast pocket in mm |
| `ballast_pocket_depth` | `12.0` | Depth of internal ballast pocket in mm |
| `ballast_pocket_height` | `8.0` | Height of internal ballast pocket in mm |

### `[Pegboard & Wall Mounting]`
| Parameter | Default | Description |
|---|---|---|
| `include_pegs` | `true` | Include rear pegboard mounting hooks and pins (false for flush wall mounting) |
| `include_screw_holes` | `true` | Include countersunk screw clearance holes in backplate |
| `screw_hole_diameter` | `4.5` | Screw shank clearance hole diameter in mm (#8 screw) |
| `countersink_diameter` | `9.0` | Screw flathead countersink diameter in mm (#8 flathead) |
| `peg_hole_spacing_in` | `1.0` | Pegboard hole center-to-center spacing in inches |
| `pegboard_thickness_in` | `0.25` | Pegboard thickness in inches |
| `pin_diameter` | `5.7` | Pin diameter in mm (tolerance fit for 1/4" hole) |
| `stabilizing_peg_pattern` | `bottom` | Stabilizing pin rows (`bottom`, `top_and_bottom`, `all`, `none`) |
| `hook_rise` | `3.5` | Vertical rise of hook tab behind pegboard in mm |
| `peg_top_margin` | `6.35` | Top margin above upper hooks in mm |
| `tilt_chamfer` | `2.0` | Rear top chamfer for pegboard insertion clearance in mm |

### `[Structure & Sizing]`
| Parameter | Default | Description |
|---|---|---|
| `backplate_thickness` | `5.0` | Thickness of mounting backplate in mm |
| `floor_thickness` | `3.5` | Thickness of bottom resting floor in mm |
| `rear_wall_thickness` | `3.5` | Wall thickness between blade cavity and backplate in mm |
| `front_wall_thickness` | `3.5` | Front wall thickness in mm |
| `tower_corner_radius` | `4.0` | Corner radius for outer tower body in mm |
| `top_corner_radius` | `4.0` | Radius for softening top-left and top-right shoulders in mm |
| `top_funnel_lead` | `2.5` | Chamfer depth for top loading funnel in mm |

---

## CLI Build & Automation

```bash
# Build default STL, 3MF, preview PNG, and all presets
make all

# Build only default STL
make stl

# Build only default 3MF
make 3mf

# Generate a PNG preview image
make preview

# Build all parameter presets from razor_blade_dispenser.json
make presets

# Clean build artifacts
make clean
```

---

## 3D Printing Recommendations

- **Material**: PETG is strongly recommended for workshop durability, superior layer adhesion, impact resistance, and slight flex that prevents pegboard hooks from snapping during installation or repositioning. PLA+ / Tough PLA is a viable alternative if PETG is unavailable.
- **Orientation**: Print standing upright on its base flat against the build plate (Z = 0) with the backplate vertical. The generous floor surface area provides rock-solid bed adhesion without needing a brim.
- **Walls / Perimeters**: Set to **4 to 5 perimeters** (min 1.6 mm - 2.0 mm total wall thickness). This ensures the 5.7 mm diameter pegboard mounting pins and retention hooks are printed almost entirely as solid concentric loops, maximizing shear and tensile strength.
- **Infill**: 25% to 30% **Gyroid** or **Cubic** infill for uniform multi-axis load distribution.
- **Top / Bottom Solid Layers**: 5 layers minimum (1.0 mm thickness at 0.2 mm layer height) for rigid floors and clean ceiling bridging.
- **Supports**: Set supports to **"Touching buildplate only"** with **Tree Supports** (or Organic Supports) under the rear pegboard hooks and pins. Ensure *"Don't support bridges"* is enabled so no support material is placed inside the vertical blade chutes or exit gates—the internal 45-degree chamfers bridge completely support-free.
- **Extrusion Temperature & Cooling**: Print at the higher end of the filament manufacturer's temperature range (e.g. 240°C–245°C for PETG) with moderate cooling fan speed (30%–50%) to maximize inter-layer fusion across horizontal hook layers.
