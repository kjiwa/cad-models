# Pegboard Single-Edge Razor Blade Dispenser

A parametric, 3D-printable pegboard dispenser for single-edge utility razor blades, supporting side-by-side towers for metal blades and plastic scraper blades on standard 1/4" pegboard.

## Features

- **Side-by-Side Dual Compartments**: Dispenses metal blades and plastic scraper blades from separate dedicated chutes with debossed front identification badges (`METAL` and `PLASTIC`).
- **Tailored Cavity Depths with Flush Front**: Independent internal pocket depths for sleeved metal blades (`23.0 mm`, accommodating 22.0 mm paper-sleeved blades) and plastic blades (`20.0 mm`, accommodating 18.7 mm blades), front-aligned so multi-tower dispenser faces remain coplanar.
- **Parametric Capacity & Count**: Configurable dispenser height (`Tower_Height`) and number of side-by-side towers (`Tower_Count`).
- **Calibrated Single-Blade Exit Gates**: Independent exit gate heights for metal blades (`1.7 mm`, matching ~1.2 mm sleeved blade) and plastic blades (`2.1 mm`, matching ~1.6 mm body), preventing double feeding.
- **Support-Free Internal Bridging**: 45-degree lead-in chamfer on the exit gate ceiling prevents sagging during bridging so chutes print cleanly without internal support.
- **Full-Height Open-Top Finger Loading Channel**: 20 mm wide front channel extends completely through the top rim with rounded entry lead-in chamfers, enabling an index finger to support the bottom of a blade stack from entry all the way to the floor without blades tumbling or jamming.
- **Drop-In Gravity Follower Weights**: Low-profile follower weights slide freely inside each chute, applying consistent downward normal force on the blade stack for positive traction on the bottom blade, eliminating blade shifting during extraction, and dampening workshop vibration. Features an ergonomic top pull fin, a front indicator tab that tracks inventory through the front channel, debossed badges (`M` / `P` on front, `METAL` / `PLASTIC` on top when printed solid), and a conforming cylindrical coin cradle optimized for standard currency (pennies default, with nickels and quarters supported) that eliminates dead-space voids and prevents rattling.
- **Full-Depth Slide-Out Channel & Front Shelf**: Bottom finger channel extends all the way to the chute rear wall, exposing the full blade underside so the user can easily push the bottom blade forward from underneath onto the front resting shelf for pinch-grip extraction.
- **Smooth Bellmouth Flared Front Opening**: Parametric flared opening profile blending seamlessly from the vertical sight slot into the exit gate. Provides continuous G1/G2 tangent curvature that eliminates sharp corners, directional kinks, and inward pinch points for comfortable downward thumb feed and blade extraction.
- **Dual Pegboard & Wall Mounting**: Standard 1/4" pegboard hooks with heel relief, plus countersunk #8 screw mounting clearance holes with front driver pass-through tunnels and an `Include_Pegs` toggle for flush wall or cabinet mounting.
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

### `[Part]`
| Parameter | Default | Description |
|---|---|---|
| `Part` | `dispenser` | Part to generate (`dispenser`, `assembly`, `follower_metal`, `follower_plastic`, `followers`) |

### `[Layout]`
| Parameter | Default | Description |
|---|---|---|
| `Slot_Pattern` | `MP` | Slot pattern: `M` for metal blade, `P` for plastic scraper blade (e.g. `P`, `M`, `MP`, `MMMMPPMMM`) |
| `Tower_Count` | `0` | Number of towers, one per `Slot_Pattern` character (0 = auto) |
| `Tower_Height` | `100.0` | Total height of the towers and backplate |
| `Slot_Spacing_Count` | `2` | Tower center-to-center spacing in pegboard holes |

### `[Blade Chute]`
| Parameter | Default | Description |
|---|---|---|
| `Chute_Width` | `41.0` | Blade pocket width (fits 39.15 plastic and 39.9 metal blades) |
| `Metal_Blade_Packaging` | `sleeved` | Metal blade packaging: `sleeved` (22.0 depth) or `bare` (19.5 depth) |
| `Sleeved_Metal_Chute_Depth` | `23.0` | Blade pocket depth for sleeved metal blades |
| `Bare_Metal_Chute_Depth` | `20.5` | Blade pocket depth for bare metal blades |
| `Plastic_Chute_Depth` | `20.0` | Blade pocket depth for plastic blades (fits 18.7) |
| `Metal_Exit_Height` | `1.7` | Bottom exit gate height for metal blades |
| `Plastic_Exit_Height` | `2.1` | Bottom exit gate height for plastic blades |

### `[Tower Body]`
| Parameter | Default | Description |
|---|---|---|
| `Floor_Thickness` | `3.5` | Thickness of the bottom floor |
| `Rear_Wall_Thickness` | `3.5` | Thickness of the rear wall between chute and backplate |
| `Front_Wall_Thickness` | `3.5` | Thickness of the front wall |
| `Tower_Corner_Radius` | `4.0` | Corner radius of the tower exterior |
| `Shoulder_Radius` | `4.0` | Radius of the top left and right shoulders across the full depth |
| `Top_Funnel_Chamfer` | `2.5` | Lead-in chamfer depth at the top of the chute |

### `[Front Access]`
| Parameter | Default | Description |
|---|---|---|
| `Front_Shelf_Depth` | `6.0` | Forward extension of the front resting shelf |
| `Finger_Notch_Width` | `22.0` | Width of the bottom finger notch |
| `Finger_Notch_Depth` | `0` | Depth of the bottom finger notch, full depth to the chute rear wall (0 = auto) |
| `Opening_Flare_Width` | `26.0` | Bottom width of the flared opening ramp |
| `Opening_Flare_Height` | `12.0` | Height of the flared opening ramp |
| `Include_Sight_Slots` | `true` | Include front vertical sight slots to see the blade inventory |
| `Sight_Slot_Width` | `20.0` | Width of the front sight slot |
| `Sight_Slot_Top_Chamfer` | `2.0` | Lead-in chamfer at the top of the sight slot |

### `[Badges]`
| Parameter | Default | Description |
|---|---|---|
| `Include_Badges` | `true` | Include debossed `METAL` and `PLASTIC` badges on the front face |
| `Badge_Text_Size` | `3.2` | Font size of the badge text |
| `Badge_Depth` | `0.6` | Deboss depth of the badge text |

### `[Follower]`
| Parameter | Default | Description |
|---|---|---|
| `Coin_Type` | `penny` | Coin used as ballast (`penny`, `nickel`, `quarter`, `custom`) |
| `Follower_Height` | `0` | Follower height, coin diameter plus 2.5 floor (0 = auto) |
| `Follower_Clearance` | `0.5` | Perimeter clearance between the follower and chute pocket |
| `Follower_Tab_Protrusion` | `1.5` | Protrusion of the front indicator tab beyond the dispenser front face |
| `Include_Ballast_Pocket` | `true` | Include an internal ballast pocket for coins or custom ballast |
| `Custom_Pocket_Width` | `22.0` | Ballast pocket width (custom only) |
| `Custom_Pocket_Depth` | `12.0` | Ballast pocket depth (custom only) |
| `Custom_Pocket_Height` | `8.0` | Ballast pocket height (custom only) |

### `[Backplate]`
| Parameter | Default | Description |
|---|---|---|
| `Backplate_Thickness` | `5.0` | Thickness of the mounting backplate |
| `Insertion_Chamfer` | `2.0` | Rear top chamfer that clears the pegboard during insertion |

### `[Pegboard]`
| Parameter | Default | Description |
|---|---|---|
| `Include_Pegs` | `true` | Include rear pegboard retention hooks and stabilizing pins (off for flush wall mounting) |
| `Hole_Spacing` | `25.4` | Pegboard hole center spacing (25.4 for 1" standard, 15.875 for 5/8" metal) |
| `Pin_Diameter` | `5.7` | Pin diameter (5.7 for standard 1/4" hole fit, 6.0 for original Sy fit) |
| `Pegboard_Thickness` | `6.35` | Pegboard thickness (6.35 for 1/4" board, 1.5875 for 1/16" thin metal) |
| `Retention_Hook_Rise` | `3.5` | Height of the retention hook tab behind the pegboard |
| `Retention_Hook_Margin` | `6.35` | Distance from the backplate top to the retention hooks |
| `Stabilizing_Pin_Pattern` | `bottom` | Stabilizing pin rows below the retention hooks (`top`, `bottom`, `top_and_bottom`, `all`, `none`; `bottom` is the lowest hole) |

### `[Screw Holes]`
| Parameter | Default | Description |
|---|---|---|
| `Include_Screw_Holes` | `true` | Include countersunk screw clearance holes |
| `Screw_Hole_Diameter` | `4.5` | Screw shank clearance hole diameter (#8 screw) |
| `Countersink_Diameter` | `9.0` | Screw countersink head diameter |

### `[Preview]`
| Parameter | Default | Description |
|---|---|---|
| `Show_Component` | `all` | Component to show (`all`, `backplate`, `towers`, `chutes`, `retention_hooks`, `stabilizing_pins`, `pegs`, `followers`) |
| `Show_Labels` | `true` | Show 3D component labels in preview |
| `Label_Size` | `4.5` | Label text size |

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

Follower dimensions auto-calculate from `Coin_Type` to minimize height and preserve dispenser capacity:

| Coin Standard | Follower Height | Usable Chute Space (100mm tower) | Plastic Chute Capacity & Added Ballast | Metal Chute Capacity & Added Ballast | Total Follower Mass (PETG) | User Experience & Cost |
|---|---|---|---|---|---|---|
| **Penny** *(Default)* | **22.0 mm** | **86.5 mm** (~53 metal / ~40 plastic blades) | **8 pennies** ($20.0\text{ g}$ zinc / $24.9\text{ g}$ copper) | **10 pennies** ($25.0\text{ g}$ zinc / $31.1\text{ g}$ copper) | **38.4 g (P) / 45.4 g (M)** | **Recommended Sweet Spot**: Preserves capacity for a full 50-blade retail pack with $0.08–$0.10 in pocket change. |
| **Nickel** | **24.2 mm** | **84.3 mm** (~51 metal / ~38 plastic blades) | **6 nickels** ($30.0\text{ g}$) | **7 nickels** ($35.0\text{ g}$) | **49.7 g (P) / 57.3 g (M)** | **Substantial Ballast**: $0.30–$0.35 in nickels; standard circulating currency in US & Canada. |
| **Quarter** | **27.2 mm** | **81.3 mm** (~49 metal / ~36 plastic blades) | **7 quarters** ($39.7\text{ g}$) | **8 quarters** ($45.4\text{ g}$) | **60.3 g (P) / 69.0 g (M)** | **Maximum Weight**: Heavyweight glide, but consumes 5.2 mm more vertical chute space. |

*(Note: In zinc pennies, total mass is 38.4 g Plastic / 45.4 g Metal; with pre-1982 copper pennies, total mass is 43.3 g Plastic / 51.5 g Metal. In PLA, followers are ~0.4 g lighter).*

#### Alternative Fillers (Custom Cavity or Non-Coin Options)

For non-coin ballast, `Include_Ballast_Pocket = false` prints a solid 100% infill follower, or `Coin_Type = "custom"` enables custom rectangular pocket dimensions:

| Option | Preparation | Added Mass | Total Follower Mass (PETG) | Evaluation |
|---|---|---|---|---|
| **Solid Plastic (No Pocket)** | Print with `Include_Ballast_Pocket = false` at 100% infill | 0.0 g | **18.4 g (P) / 20.4 g (M)** | **Minimum Viable Option**: $0 hardware cost, functional baseline. |
| **Steel Hex Nuts (M5 / M6)** | Drop 4x M5 or 2x M6 nuts into custom pocket | ~5.0 g | **23.4 g (P) / 25.4 g (M)** | Readily available workshop scrap; slight rattle unless bedded in blutack. |
| **Steel Micro-Shot (2 mm)** | Fill cavity and lock with thin cyanoacrylate (CA) glue | ~15–20 g | **33–38 g (P) / 35–40 g (M)** | Dense, rattle-free composite block; requires liquid CA glue. |
| **Tungsten Putty** | Press moldable pinewood derby putty into cavity | ~25–35 g | **43–53 g (P) / 45–55 g (M)** | Non-toxic, self-retaining, zero mess, ultra-dense feel. |
| **Tungsten Super Shot (TSS)** | Pour 1.5–2.5 mm beads and wick with thin CA glue | ~30–45 g | **48–63 g (P) / 50–65 g (M)** | Maximum attainable density; requires CA glue to prevent loose bead spill. |

<!-- BEGIN GENERATED -->

## Parameters

### Part

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Part` | `"dispenser"` | Main Dispenser, Dispenser & Followers, Metal Follower Only, Plastic Follower Only, Both Followers | Part to generate |

### Layout

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Slot_Pattern` | `"MP"` |  | Slot pattern: M for metal blade, P for plastic scraper blade (e.g. "MP", "M", "P", "MMMMPPMMM") |
| `Tower_Count` | `0` | 0 to 20, step 1 | Number of towers, one per Slot_Pattern character (0 = auto) |
| `Tower_Height` | `100.0` |  | Total height of the towers and backplate |
| `Slot_Spacing_Count` | `2` | 2 to 4, step 1 | Tower center-to-center spacing in pegboard holes |

### Blade Chute

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Chute_Width` | `41.0` |  | Blade pocket width (fits 39.15 plastic and 39.9 metal blades) |
| `Metal_Blade_Packaging` | `"sleeved"` | Paper-Sleeved (22.0 Depth), Bare Unwrapped (19.5 Depth) | Metal blade packaging (sleeved is the standard paper sleeve, bare is an unwrapped blade) |
| `Sleeved_Metal_Chute_Depth` | `23.0` |  | Blade pocket depth for sleeved metal blades (fits 22.0) |
| `Bare_Metal_Chute_Depth` | `20.5` |  | Blade pocket depth for bare metal blades (fits 19.5) |
| `Plastic_Chute_Depth` | `20.0` |  | Blade pocket depth for plastic blades (fits 18.7) |
| `Metal_Exit_Height` | `1.7` |  | Bottom exit gate height for metal blades (fits a 1.2 sleeved spine) |
| `Plastic_Exit_Height` | `2.1` |  | Bottom exit gate height for plastic blades (fits a 1.6 blade body) |

### Tower Body

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Floor_Thickness` | `3.5` |  | Thickness of the bottom floor |
| `Rear_Wall_Thickness` | `3.5` |  | Thickness of the rear wall between chute and backplate |
| `Front_Wall_Thickness` | `3.5` |  | Thickness of the front wall |
| `Tower_Corner_Radius` | `4.0` |  | Corner radius of the tower exterior |
| `Shoulder_Radius` | `4.0` |  | Radius of the top left and right shoulders across the full depth |
| `Top_Funnel_Chamfer` | `2.5` |  | Lead-in chamfer depth at the top of the chute |

### Front Access

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Front_Shelf_Depth` | `6.0` |  | Forward extension of the front resting shelf |
| `Finger_Notch_Width` | `22.0` |  | Width of the bottom finger notch |
| `Finger_Notch_Depth` | `0` |  | Depth of the bottom finger notch, full depth to the chute rear wall (0 = auto) |
| `Opening_Flare_Width` | `26.0` |  | Bottom width of the flared opening ramp |
| `Opening_Flare_Height` | `12.0` |  | Height of the flared opening ramp |
| `Include_Sight_Slots` | `true` |  | Include front vertical sight slots to see the blade inventory |
| `Sight_Slot_Width` | `20.0` |  | Width of the front sight slot |
| `Sight_Slot_Top_Chamfer` | `2.0` |  | Lead-in chamfer at the top of the sight slot |

### Badges

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Include_Badges` | `true` |  | Include debossed "METAL" and "PLASTIC" badges on the front face |
| `Badge_Text_Size` | `3.2` |  | Font size of the badge text |
| `Badge_Depth` | `0.6` |  | Deboss depth of the badge text |

### Follower

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Coin_Type` | `"penny"` | US/Canadian Penny (19.05), US Nickel (21.21), US/Canadian Quarter (24.26), Custom Pocket Dimensions | Coin used as ballast (sets the cradle size and minimum height) |
| `Follower_Height` | `0` |  | Follower height, coin diameter plus 2.5 floor (0 = auto) |
| `Follower_Clearance` | `0.5` |  | Perimeter clearance between the follower and chute pocket |
| `Follower_Tab_Protrusion` | `1.5` |  | Protrusion of the front indicator tab beyond the dispenser front face |
| `Include_Ballast_Pocket` | `true` |  | Include an internal ballast pocket for coins or custom ballast |
| `Custom_Pocket_Width` | `22.0` |  | Ballast pocket width (custom only) |
| `Custom_Pocket_Depth` | `12.0` |  | Ballast pocket depth (custom only) |
| `Custom_Pocket_Height` | `8.0` |  | Ballast pocket height (custom only) |

### Backplate

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Backplate_Thickness` | `5.0` |  | Thickness of the mounting backplate |
| `Insertion_Chamfer` | `2.0` |  | Rear top chamfer that clears the pegboard during insertion |

### Pegboard

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Include_Pegs` | `true` |  | Include rear pegboard retention hooks and stabilizing pins (off for flush wall mounting) |
| `Hole_Spacing` | `25.4` |  | Pegboard hole center spacing (25.4 for 1" standard, 15.875 for 5/8" metal) |
| `Pin_Diameter` | `5.7` |  | Pin diameter (5.7 for standard 1/4" hole fit, 6.0 for original Sy fit) |
| `Pegboard_Thickness` | `6.35` |  | Pegboard thickness (6.35 for 1/4" board, 1.5875 for 1/16" thin metal) |
| `Retention_Hook_Rise` | `3.5` |  | Height of the retention hook tab behind the pegboard |
| `Stabilizing_Pin_Pattern` | `"bottom"` | All Rows, Top and Bottom Rows, Top Row Only, Bottom Row Only (Lowest Hole), Retention Hooks Only | Stabilizing pin rows below the retention hooks |
| `Retention_Hook_Margin` | `6.35` |  | Distance from the backplate top to the retention hooks |

### Screw Holes

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Include_Screw_Holes` | `true` |  | Include countersunk screw clearance holes |
| `Screw_Hole_Diameter` | `4.5` |  | Screw shank clearance hole diameter (#8 screw) |
| `Countersink_Diameter` | `9.0` |  | Screw countersink head diameter |

### Preview

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Show_Component` | `"all"` | All Components, Backplate, Dispenser Towers, Negative Chute Space, Retention Hooks, Stabilizing Pins, All Pegs, Gravity Followers | Component to show, or all for the full assembly |
| `Show_Labels` | `true` |  | Show 3D component labels in preview |
| `Label_Size` | `4.5` |  | Label text size |

## Presets

- `Single_Metal`
- `Single_Plastic`
- `Follower_Metal`
- `Follower_Plastic`
- `Followers_Dual`
- `Followers_Nickel`
- `Followers_Quarter`

<!-- END GENERATED -->
