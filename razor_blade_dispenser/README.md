# Pegboard Single-Edge Razor Blade Dispenser

A parametric, 3D-printable pegboard dispenser for single-edge utility razor blades, supporting side-by-side towers for metal blades and plastic scraper blades on standard 1/4" pegboard.

## Features

- **Side-by-Side Dual Compartments**: Dispenses metal blades and plastic scraper blades from separate dedicated chutes with debossed front identification badges (`METAL` and `PLASTIC`).
- **Tailored Cavity Depths with Flush Front**: Independent internal pocket depths for sleeved metal blades (`23.0 mm`, accommodating 22.0 mm paper-sleeved blades) and plastic blades (`20.0 mm`, accommodating 18.7 mm blades), front-aligned so multi-tower dispenser faces remain coplanar.
- **Parametric Capacity & Count**: Configurable dispenser height (`dispenser_height`) and number of side-by-side towers (`dispenser_count`).
- **Calibrated Single-Blade Exit Gates**: Independent exit gate heights for metal blades (`1.7 mm`, matching ~1.2 mm sleeved blade) and plastic blades (`2.1 mm`, matching ~1.6 mm body), preventing double feeding.
- **Support-Free Internal Bridging**: 45-degree lead-in chamfer on the exit gate ceiling prevents sagging during bridging so chutes print cleanly without internal support.
- **Full-Height Open-Top Finger Loading Channel**: 20 mm wide front channel extends completely through the top rim with rounded entry lead-in chamfers, enabling an index finger to support the bottom of a blade stack from entry all the way to the floor without blades tumbling or jamming.
- **Drop-In Gravity Follower Weights**: Low-profile follower weights slide freely inside each chute, applying consistent downward normal force on the blade stack for positive traction on the bottom blade, eliminating blade shifting during extraction, and dampening workshop vibration. Features an ergonomic top pull fin, a front indicator tab that tracks inventory through the front channel, debossed badges (`M` / `P` on front, `METAL` / `PLASTIC` on top when printed solid), and a conforming cylindrical coin cradle optimized for standard currency (pennies default, with nickels and quarters supported) that eliminates dead-space voids and prevents rattling.
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
| `coin_type` | `penny` | Standard coin type for drop-in ballast (`penny`, `nickel`, `quarter`, `custom`) |
| `follower_height` | `0` | Vertical thickness of follower in mm (0 auto-calculates minimum height for `coin_type` + 2.5 mm floor) |
| `follower_clearance` | `0.5` | Perimeter clearance between follower and chute pocket in mm |
| `follower_tab_lead` | `1.5` | Protrusion of front indicator tab beyond dispenser front face in mm |
| `include_ballast_pocket` | `true` | Include internal ballast pocket for coins or custom filler |
| `ballast_pocket_width` | `22.0` | Custom ballast pocket width in mm (used when `coin_type = "custom"`) |
| `ballast_pocket_depth` | `12.0` | Custom ballast pocket depth in mm (used when `coin_type = "custom"`) |
| `ballast_pocket_height` | `8.0` | Custom ballast pocket height in mm (used when `coin_type = "custom"`) |

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

### `[Component Inspection & Labels]`
| Parameter | Default | Description |
|---|---|---|
| `show_labels` | `true` | Display 3D component name labels in OpenSCAD preview |
| `view_component` | `all` | Component to inspect (`all`, `backplate`, `towers`, `chutes`, `upper_hooks`, `lower_pins`, `followers`) |
| `label_size` | `4.5` | Font size for 3D component text labels in mm |

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

---

### Gravity Follower Print Settings & Ballast Guide

The gravity followers slide freely on top of the razor blade stacks to apply downward normal force, preventing blades from lifting or tilting during extraction and eliminating vibration rattle when only a few blades remain.

#### Infill & Print Settings
- **Infill**: Set to **100% solid infill** (aligned rectilinear or monotonic). Followers are only 22.0 mm to 27.2 mm tall; solid printing takes under 25 minutes, consumes only ~$0.06 in filament, and provides vital baseline tare weight (~15–20 g). Solid plastic also ensures that if adhesives are used with loose media, liquid cannot leak into internal infill voids.
- **Orientation**: Print flat on the bottom base ($Z = 0$) with the top pull fin pointing upward. Zero support material is required.
- **Perimeters**: 4 to 5 walls (min 1.6 mm - 2.0 mm total wall thickness) for durable side surfaces and crisp debossed badges.
- **Layer Height**: 0.20 mm standard (or 0.16 mm for high-definition debossed badges).

#### Material Comparison: PLA vs. PETG
Both PLA and PETG are 100% viable for follower printing:

| Consideration | PLA / PLA+ | PETG | Impact on Follower Performance |
|---|---|---|---|
| **Material Density** | $1.24\text{ g/cm}^3$ | $1.27\text{ g/cm}^3$ | PETG is ~2.4% denser, adding ~0.4 g of tare weight. |
| **Surface Sliding Friction** | Low / Hard | Moderate | PLA slides with slightly less resistance; however, with the built-in 0.5 mm perimeter clearance, PETG slides smoothly without binding. |
| **Drop Impact Resistance** | Moderate (can chip on concrete) | High (tough, absorbs impact) | PETG survives drops onto concrete shop floors when removing followers during reloads. |
| **Thermal Resistance** | ~55°C | ~75°C | PETG resists deformation in hot, unconditioned summer garages or sheds. |
| **Aesthetic Match** | Sharp debossed text | Matches dispenser body | Printing in PETG matches the dispenser body filament. |

#### Conforming Cylindrical Coin Cradle
Standardizing on coins provides immediate, low-cost ballast using spare pocket change. Rather than a flat pocket floor where circular coins touch at a single tangent point and leave empty corner voids, the follower floor features a concave cylindrical cradle matching the coin's curvature ($r = \text{diameter}/2 + 0.4\text{ mm}$):
- **Flush Contact**: The entire bottom rim of each coin rests directly against the printed floor with zero void space.
- **Anti-Rattle & Self-Centering**: Coins automatically center in the trough and cannot rock, tilt, or rattle side-to-side during blade extraction.
- **Support-Free Internal Bridging**: The upward-curving cradle prints cleanly without supports because every layer builds upon solid plastic below.
- **Unobstructed Loading**: The top pull fin is mounted forward on the solid front wall shoulder, allowing coins to drop straight down into the magazine from above.

#### Coin Ballast Comparison Table

Follower dimensions auto-calculate from `coin_type` to minimize height and preserve dispenser capacity:

| Coin Standard | Follower Height | Usable Chute Space (100mm tower) | Plastic Chute Capacity & Added Ballast | Metal Chute Capacity & Added Ballast | Total Follower Mass (PETG) | User Experience & Cost |
|---|---|---|---|---|---|---|
| **Penny** *(Default)* | **22.0 mm** | **86.5 mm** (~53 metal / ~40 plastic blades) | **8 pennies** ($20.0\text{ g}$ zinc / $24.9\text{ g}$ copper) | **10 pennies** ($25.0\text{ g}$ zinc / $31.1\text{ g}$ copper) | **38.4 g (P) / 45.4 g (M)** | **Recommended Sweet Spot**: Preserves capacity for a full 50-blade retail pack with $0.08–$0.10 in pocket change. |
| **Nickel** | **24.2 mm** | **84.3 mm** (~51 metal / ~38 plastic blades) | **6 nickels** ($30.0\text{ g}$) | **7 nickels** ($35.0\text{ g}$) | **49.7 g (P) / 57.3 g (M)** | **Substantial Ballast**: $0.30–$0.35 in nickels; standard circulating currency in US & Canada. |
| **Quarter** | **27.2 mm** | **81.3 mm** (~49 metal / ~36 plastic blades) | **7 quarters** ($39.7\text{ g}$) | **8 quarters** ($45.4\text{ g}$) | **60.3 g (P) / 69.0 g (M)** | **Maximum Weight**: Heavyweight glide, but consumes 5.2 mm more vertical chute space. |

*(Note: In zinc pennies, total mass is 38.4 g Plastic / 45.4 g Metal; with pre-1982 copper pennies, total mass is 43.3 g Plastic / 51.5 g Metal. In PLA, followers are ~0.4 g lighter).*

#### Alternative Fillers (Custom Cavity or Non-Coin Options)

For non-coin ballast, `include_ballast_pocket = false` prints a solid 100% infill follower, or `coin_type = "custom"` enables custom rectangular pocket dimensions:

| Option | Preparation | Added Mass | Total Follower Mass (PETG) | Evaluation |
|---|---|---|---|---|
| **Solid Plastic (No Pocket)** | Print with `include_ballast_pocket = false` at 100% infill | 0.0 g | **18.4 g (P) / 20.4 g (M)** | **Minimum Viable Option**: $0 hardware cost, functional baseline. |
| **Steel Hex Nuts (M5 / M6)** | Drop 4x M5 or 2x M6 nuts into custom pocket | ~5.0 g | **23.4 g (P) / 25.4 g (M)** | Readily available workshop scrap; slight rattle unless bedded in blutack. |
| **Steel Micro-Shot (2 mm)** | Fill cavity and lock with thin cyanoacrylate (CA) glue | ~15–20 g | **33–38 g (P) / 35–40 g (M)** | Dense, rattle-free composite block; requires liquid CA glue. |
| **Tungsten Putty** | Press moldable pinewood derby putty into cavity | ~25–35 g | **43–53 g (P) / 45–55 g (M)** | Non-toxic, self-retaining, zero mess, ultra-dense feel. |
| **Tungsten Super Shot (TSS)** | Pour 1.5–2.5 mm beads and wick with thin CA glue | ~30–45 g | **48–63 g (P) / 50–65 g (M)** | Maximum attainable density; requires CA glue to prevent loose bead spill. |
