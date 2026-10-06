# Pegboard Single-Edge Razor Blade Dispenser

A parametric, 3D-printable pegboard dispenser for single-edge utility razor blades, with side-by-side towers for metal blades and plastic scraper blades on standard 1/4" pegboard.

## Features

- Metal and plastic blades dispense from separate chutes, with debossed front badges (`METAL`, `PLASTIC`). `Slot_Pattern` sets the order of towers.
- Pocket depths fit sleeved metal blades (23.0 mm, for 22.0 mm paper-sleeved blades), bare metal blades (20.5 mm), and plastic blades (20.0 mm, for 18.7 mm blades), front-aligned so multi-tower faces stay coplanar.
- Exit gates sized for one blade at a time: 1.7 mm for metal (~1.2 mm sleeved blade) and 2.1 mm for plastic (~1.6 mm body).
- A 45 degree lead-in chamfer on the gate ceiling bridges without internal supports.
- A 20 mm open-top front channel lets a finger support the bottom of a blade stack, and the bottom channel runs to the chute rear wall so the bottom blade can be pushed forward onto the front shelf for pinch-grip extraction.
- A bellmouth opening blends from the vertical sight slot into the exit gate for thumb feed, and full-height sight slots show the remaining blades.
- Drop-in gravity followers press on the blade stack. Each has a top pull fin, a front indicator tab, debossed badges, and a cylindrical coin cradle for ballast.
- Standard 1/4" pegboard hooks with heel relief and stabilizing pins, or countersunk #8 screw holes with front driver tunnels for flush mounting (`Include_Pegs`).
- Backplate with top-rear tilt insertion chamfer, rounded corners, and weight-relief windows.

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

## Printing

- **Material**: PETG is strongly recommended for layer adhesion, impact resistance, and slight flex that keeps the pegboard hooks from snapping during installation. PLA+ / Tough PLA is an alternative.
- **Orientation**: Upright on its base against the build plate (Z = 0), backplate vertical. The floor area adheres without a brim.
- **Walls**: 4 to 5 perimeters (min 1.6-2.0 mm total), so the 5.7 mm pins and retention hooks print almost entirely as solid loops.
- **Infill**: 25% to 30% Gyroid or Cubic.
- **Top / Bottom Layers**: 5 minimum (1.0 mm at 0.2 mm layer height) for rigid floors and clean ceiling bridging.
- **Supports**: "Touching buildplate only" tree or organic supports under the rear pegboard hooks and pins, with "Don't support bridges" enabled so no support enters the chutes or exit gates.
- **Temperature and Cooling**: The high end of the filament's range (240-245 C for PETG) with 30%-50% fan, to maximize inter-layer fusion across horizontal hook layers.

## Followers

Followers slide freely on the blade stacks, applying downward force and damping rattle when few blades remain.

- **Infill**: 100%. Followers are 22.0 to 27.2 mm tall, so solid printing is quick and gives ~15-20 g of baseline weight.
- **Orientation**: Flat on the base (Z = 0), pull fin up. No supports.
- **Perimeters**: 4 to 5.
- **Layer Height**: 0.20 mm, or 0.16 mm for crisp badges.
- **Material**: PLA or PETG. PETG is tougher and matches the body; PLA is ~0.4 g lighter.

### Coin Ballast

The follower floor is a concave cylindrical cradle (r = coin diameter / 2 + 0.4 mm), so each coin sits flush, self-centres, and cannot rattle. The cradle prints without supports, and the pull fin sits forward on the front wall shoulder so coins drop in from above. Dimensions follow `Coin_Type`:

| Coin | Follower Height | Usable Chute Space (100 mm tower) | Plastic Chute Ballast | Metal Chute Ballast | Follower Mass, PETG (Plastic / Metal) |
| --- | --- | --- | --- | --- | --- |
| Penny (default) | 22.0 mm | 86.5 mm (~53 metal / ~40 plastic blades) | 8 pennies | 10 pennies | 38.4 g / 45.4 g |
| Nickel | 24.2 mm | 84.3 mm (~51 metal / ~38 plastic blades) | 6 nickels | 7 nickels | 49.7 g / 57.3 g |
| Quarter | 27.2 mm | 81.3 mm (~49 metal / ~36 plastic blades) | 7 quarters | 8 quarters | 60.3 g / 69.0 g |

Pennies keep room for a full 50-blade pack. Pre-1982 copper pennies raise the follower mass to 43.3 g / 51.5 g.

### Other Ballast

`Include_Ballast_Pocket = false` prints a solid follower; `Coin_Type = "custom"` sets a rectangular pocket with `Custom_Pocket_*`.

| Option | Preparation | Added Mass | Follower Mass, PETG (Plastic / Metal) |
| --- | --- | --- | --- |
| Solid plastic | No pocket, 100% infill | 0 g | 18.4 g / 20.4 g |
| Steel hex nuts | 4x M5 or 2x M6 in the custom pocket; rattles unless bedded in putty | ~5 g | 23.4 g / 25.4 g |
| Steel micro-shot (2 mm) | Fill and lock with thin CA glue | ~15-20 g | 33-38 g / 35-40 g |
| Tungsten putty | Press into the pocket | ~25-35 g | 43-53 g / 45-55 g |
| Tungsten super shot | 1.5-2.5 mm beads wicked with thin CA glue | ~30-45 g | 48-63 g / 50-65 g |
