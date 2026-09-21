# Ryobi 40V Battery Pegboard Holder

A parametric, 3D-printable pegboard holder for Ryobi 40V batteries with an angled forward tilt for easy insertion and retrieval without pegboard clearance issues above.

## Features

- **Parametric Battery Capacity**: Configurable number of side-by-side battery slots (`battery_count`, defaulting to 2).
- **Forward Tilt**: Angled 15 degrees forward so batteries pull out diagonally away from the pegboard, eliminating clearance constraints directly above.
- **Pegboard Locking Hooks**: Sized for 1/4" pegboard (1/4" thick, 1" hole spacing, 1/4" diameter holes) with rear retention tabs that lock within 1/4" clearance behind the board.
- **Secure Retention**: Combines slide rails for the battery's slide grooves and a bottom resting shelf to support battery weight without restricting pack width.
- **Reinforced Structure**: Full-width monolithic cradle wedge solidly backs the slide bed and rails across their entire width and height while transferring cantilevered loads directly into the backplate and pegboard hooks.
- **Optimized Fit & Finish**: Fully filleted and chamfered perimeter, continuous flush cradle flanks matching the slide bed and resting shelf, swept concave top styling, internal stress-relief rail fillets, and a central slide bed relief with debossed 40V identification.
- **Center Weight-Relief Windows**: Stylized stadium cutouts between battery slots reduce mass and prevent large-plate warping.
- **Through-Bed Screwdriver Access**: Concentric clearance holes in the slide bed allow driving wall mounting screws directly into studs or anchors behind the pegboard.
- **OpenSCAD Customizer Compatible**: Fully documented parameters with interactive sliders, drop-down menus, and grouped tabs.

---

## Directory Structure

```text
ryobi_40v_battery_holder/
├── Makefile                        # Build automation for STL, 3MF, and PNG renders
├── README.md                       # Project documentation & printing recommendations
├── ryobi_40v_battery_holder.scad   # Top-level assembly orchestrator & Customizer parameters
└── components/
    ├── backplate.scad              # Mounting backplate, screw holes, and weight-relief windows
    ├── bottom_shelf.scad           # Battery resting shelf and build-plate base foot
    ├── gussets.scad                # Structural reinforcement gusset styles and ribs
    ├── labels.scad                 # Component visibility filters and 3D preview labels
    ├── pegs.scad                   # Pegboard upper retention hooks and stabilizing pins
    ├── slide_bed.scad              # Angled battery slide bed with friction relief and debossed text
    ├── slide_rails.scad            # Battery slide retention rails with lead-in flares
    └── slot_cradle.scad            # Slot cradle assembly and screwdriver access channel
```

---

## Architecture

The model is organized into single-responsibility geometric components and pure orchestration modules:

- **Single-Responsibility Primitives**: Each component file isolates specific geometric operations (e.g. `backplate_blank`, `backplate_tilt_chamfer`, `backplate_screw_holes`, `rail_profile_2d`, `rail_lead_in_flare`, `cradle_base_foot_hull`).
- **Subassembly Orchestrators**: Mid-level modules (`backplate`, `mounting_pegs`, `slide_rails`, `gusset_ribs`, `slot_cradle`) compose primitives without mixing coordinate frames or responsibilities.
- **Top-Level Orchestrator**: `ryobi_40v_battery_holder.scad` declares Customizer parameters, computes derived dimensions, and invokes the top-level assembly.

---

## Using the OpenSCAD Customizer

1. Open `ryobi_40v_battery_holder.scad` in OpenSCAD.
2. In the top menu, ensure **Window -> Customizer** is checked.
3. Uncheck **Design -> Hide Customizer** if visible.
4. Expand the parameter tabs (`Holder Configuration`, `Component Inspection & Labels`, `Ryobi 40V Battery Interface`, `Pegboard Mounting`, `Structure & Reinforcement`, `Gusset Styling & Aesthetics`) in the Customizer panel on the right.
5. Adjust parameters to match your battery count or custom tolerances.
6. Press `F5` to preview or `F6` to render, then `F7` to export to STL.

---

## Parameters Reference

### `[Holder Configuration]`
| Parameter | Default | Range | Description |
|---|---|---|---|
| `battery_count` | `2` | `1` - `6` | Number of batteries held side-by-side |
| `tilt_angle` | `15` | `0` - `45` deg | Forward tilt angle from vertical |
| `slot_spacing_pegs` | `5` | `3` - `9` (odd) | Slot center-to-center spacing in pegboard holes (5" = 127 mm) |

### `[Component Inspection & Labels]`
| Parameter | Default | Range / Options | Description |
|---|---|---|---|
| `show_labels` | `true` | bool | Display 3D component name labels in OpenSCAD preview |
| `view_component` | `all` | `all`, `backplate`, `cradle`, `slide_bed`, `bottom_shelf`, `slide_rails`, `gussets`, `upper_hooks`, `lower_pins` | Isolate a specific component or view full assembly |
| `label_size` | `4.5` | `2.0` - `10.0` mm | Font size for 3D component text labels |

### `[Ryobi 40V Battery Interface]`
| Parameter | Default | Units | Description |
|---|---|---|---|
| `rail_width` | `62.0` | mm | Outer width across battery slide rails |
| `rail_thickness` | `5.5` | mm | Thickness of battery slide flange |
| `rail_lip_thickness` | `2.0` | mm | Thickness of retaining rail lip |
| `rail_lip_depth` | `4.5` | mm | Undercut depth of rail lip |
| `rail_length` | `80.0` | mm | Slide rail engagement length |
| `rail_clearance` | `0.5` | mm | Fit tolerance gap around rails |
| `bed_width` | `76.0` | mm | Slide bed and bottom shelf width |
| `bottom_shelf_depth` | `8.0` | mm | Depth of bottom resting shelf |
| `bottom_shelf_thickness` | `6.0` | mm | Thickness of bottom resting shelf |
| `enable_rails` | `true` | bool | Include central slide rails |

### `[Pegboard Mounting]`
| Parameter | Default | Units | Description |
|---|---|---|---|
| `peg_hole_spacing_in` | `1.0` | in | Pegboard hole center-to-center spacing |
| `pegboard_thickness_in` | `0.25` | in | Pegboard thickness |
| `pin_diameter` | `5.7` | mm | Pin diameter (tolerance fit for 1/4" / 6.35 mm hole) |
| `stabilizing_peg_pattern` | `all` | options | Stabilizing peg pattern below upper hooks (`all`, `span_2`, `span_1`) |
| `hook_rise` | `4.0` | mm | Vertical rise of hook tab behind pegboard |
| `peg_top_margin` | `6.35` | mm | Top margin above upper hooks |
| `tilt_chamfer` | `2.0` | mm | Rear top chamfer size for pegboard insertion clearance |
| `include_screw_holes` | `true` | bool | Include countersunk screw clearance holes |
| `screw_hole_diameter` | `4.5` | mm | Screw shank clearance diameter (#8 screw) |
| `countersink_diameter` | `9.0` | mm | Screw countersink head diameter |

### `[Structure & Reinforcement]`
| Parameter | Default | Units | Description |
|---|---|---|---|
| `backplate_thickness` | `5.0` | mm | Thickness of mounting backplate |
| `bracket_thickness` | `5.0` | mm | Thickness of support gusset ribs |
| `bed_thickness` | `5.0` | mm | Thickness of angled slide bed |
| `toe_height` | `3.5` | mm | Vertical height of integrated front toe |
| `toe_roundover` | `1.6` | mm | Bottom front roundover chamfer |
| `backplate_corner_radius` | `6.0` | mm | Corner radius for mounting backplate perimeter |
| `bed_corner_radius` | `6.0` | mm | Top corner radius for battery slide bed |
| `shelf_corner_radius` | `5.0` | mm | Front corner radius for bottom resting shelf |
| `rail_fillet_radius` | `1.4` | mm | Internal stress-relief fillet radius for slide rail lips |
| `rail_root_fillet` | `0.6` | mm | Internal stress-relief fillet radius at slide rail root |

### `[Gusset Styling & Aesthetics]`
| Parameter | Default | Range / Options | Description |
|---|---|---|---|
| `gusset_style` | `full_wedge` | options | Reinforcement & aesthetic style (`full_wedge`, `swept_ribs`, `buttress_wings`, `classic`) |
| `wedge_cored` | `false` | bool | Hollow out central monocoque cavity in full-width wedge (false uses slicer infill) |

---

## CLI Build & Automation

Run `make` commands from this directory or from the root repository directory:

```bash
# Build default STL, 3MF, and preview PNG
make all

# Build only default STL
make stl

# Build only default 3MF
make 3mf

# Generate a PNG preview image
make preview

# Clean build directory
make clean
```

Outputs are generated in the `build/` subdirectory.

---

## 3D Printing Recommendations

- **Material**: PETG or ABS/ASA recommended for load-bearing capacity and creep resistance under battery weight (PLA is suitable for indoor use with 1-2 batteries).
- **Print Orientation**: Upright resting flat on the bottom base (Z = 0) with the backplate vertical. The 15-degree cradle tilt is self-supporting (75 degrees from the build plate), slide rails print along the Z axis for smooth sliding, and peg shanks align with horizontal extrusion paths for tensile strength. Use tree supports for the rear hooks.
- **Perimeters / Walls**: 4 to 6 walls for structural strength through the gusset ribs and mounting pins.
- **Infill**: 30% - 50% Gyroid or Grid.
- **Top / Bottom Layers**: 4 to 5 layers.
