# Pegboard Single-Edge Razor Blade Dispenser

A parametric, 3D-printable pegboard dispenser for single-edge utility razor blades, supporting side-by-side towers for metal blades and plastic scraper blades on standard 1/4" pegboard.

## Features

- **Side-by-Side Dual Compartments**: Dispenses metal blades and plastic blades from separate dedicated chutes with debossed front identification badges (`METAL` and `PLASTIC`).
- **Parametric Capacity & Count**: Configurable dispenser height (`dispenser_height`) and number of side-by-side towers (`dispenser_count`).
- **Calibrated Single-Blade Exit Gates**: Independent exit gate heights for metal blades (`1.7 mm`, matching ~1.1 mm spine) and plastic blades (`2.1 mm`, matching ~1.5 mm body), preventing double feeding.
- **Support-Free Internal Bridging**: 45-degree lead-in chamfer on the exit gate ceiling prevents sagging during bridging so chutes print cleanly without internal support.
- **Ergonomic Pinch-Grip Retrieval**: Front resting shelf combined with a bottom finger-scoop cutout allows pinching the bottom blade from above and below to slide it out smoothly.
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
    ├── labels.scad                 # Component visibility filters and 3D preview inspection labels
    ├── pegs.scad                   # Pegboard hook and pin layout orchestrator
    └── tower_body.scad             # Monolithic dispenser shell, front shelf, top funnel, debossed text
```


---

## Customizer Parameters

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
| `chute_width` | `40.8` | Internal blade cavity width in mm |
| `chute_depth` | `20.5` | Internal blade cavity depth in mm |
| `metal_exit_height` | `1.7` | Exit gate height for metal blade slot in mm |
| `plastic_exit_height` | `2.1` | Exit gate height for plastic blade slot in mm |

### `[Grip & Front Features]`
| Parameter | Default | Description |
|---|---|---|
| `grip_notch_width` | `22.0` | Width of bottom finger scoop cutout in mm |
| `grip_notch_depth` | `12.0` | Depth of bottom finger scoop cutout under blade in mm |
| `shelf_extension` | `6.0` | Forward extension of front resting shelf in mm |
| `enable_sight_slots` | `true` | Enable front vertical sight slots for inventory |
| `sight_slot_width` | `10.0` | Width of front sight slot in mm |
| `enable_badge_labels` | `true` | Enable debossed front text badges |
| `badge_text_size` | `4.0` | Font size for front debossed text badges in mm |
| `badge_deboss_depth` | `0.6` | Deboss depth into front face in mm |

### `[Pegboard Mounting]`
| Parameter | Default | Description |
|---|---|---|
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
| `top_funnel_lead` | `1.6` | Chamfer depth for top loading funnel in mm |

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

- **Material**: PLA or PETG. PETG is recommended for high-durability workshop environments.
- **Orientation**: Print standing upright on its base flat against the build plate (Z = 0) with the backplate vertical.
- **Supports**: Only tree supports needed under the rear pegboard hooks. The vertical chute cavities, top funnels, and internal 45-degree exit gate chamfers print completely support-free.
- **Walls / Perimeters**: 3 to 4 walls for strong hook engagement and rigid tower walls.
- **Infill**: 20% to 30% Gyroid or Grid.
- **Top / Bottom Layers**: 4 to 5 layers.
