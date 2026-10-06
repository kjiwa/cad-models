# Ryobi 40V Battery Pegboard Holder

A parametric, 3D-printable pegboard holder for Ryobi 40V batteries with an angled forward tilt for easy insertion and retrieval without pegboard clearance issues above.

## Features

- **Parametric Battery Capacity**: Configurable number of side-by-side battery slots (`Battery_Count`, defaulting to 2).
- **Forward Tilt**: Angled 15 degrees forward so batteries pull out diagonally away from the pegboard, eliminating clearance constraints directly above.
- **Pegboard Locking Hooks**: Sized for 1/4" pegboard (6.35 mm thick, 25.4 mm hole spacing, 1/4" diameter holes) with rear retention tabs that lock within 1/4" clearance behind the board.
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
    ├── pegs.scad                   # Pegboard retention hooks and stabilizing pins
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
4. Expand the parameter tabs (`Layout`, `Battery Rails`, `Slide Bed and Shelf`, `Gussets`, `Backplate`, `Pegboard`, `Screw Holes`, `Preview`) in the Customizer panel on the right.
5. Adjust parameters to match your battery count or custom tolerances.
6. Press `F5` to preview or `F6` to render, then `F7` to export to STL.

---

## Parameters Reference

All lengths are in millimeters unless noted.

### `[Layout]`
| Parameter | Default | Range | Description |
|---|---|---|---|
| `Battery_Count` | `2` | `1` - `6` | Number of battery slots side by side |
| `Slot_Spacing_Count` | `4` | `3` - `8` | Slot center-to-center spacing in pegboard holes |
| `Tilt_Angle` | `15` | `0` - `45`, degrees | Forward tilt from vertical |

### `[Battery Rails]`
| Parameter | Default | Description |
|---|---|---|
| `Rail_Width` | `62.0` | Width across the outer edges of the battery slide rails |
| `Rail_Length` | `80.0` | Length of rail engagement along the slide bed |
| `Rail_Thickness` | `5.5` | Thickness of the battery slide flange |
| `Rail_Lip_Thickness` | `2.0` | Thickness of the retaining lip |
| `Rail_Lip_Depth` | `4.5` | Undercut depth of the retaining lip |
| `Rail_Clearance` | `0.5` | Fit gap around the rails |
| `Rail_Lip_Radius` | `1.4` | Fillet radius on the rail lips |
| `Rail_Root_Radius` | `0.6` | Stress-relief fillet radius at the rail root |
| `Include_Rails` | `true` | Include the central slide rails |

### `[Slide Bed and Shelf]`
| Parameter | Default | Description |
|---|---|---|
| `Bed_Width` | `76.0` | Width of the slide bed and bottom shelf |
| `Bed_Thickness` | `5.0` | Thickness of the angled slide bed |
| `Bed_Corner_Radius` | `6.0` | Top corner radius of the slide bed |
| `Shelf_Depth` | `8.0` | Depth of the bottom support shelf |
| `Shelf_Thickness` | `6.0` | Thickness of the bottom support shelf |
| `Shelf_Corner_Radius` | `5.0` | Front corner radius of the bottom shelf |
| `Toe_Height` | `3.5` | Height of the integrated front toe |
| `Toe_Radius` | `1.6` | Bottom front edge radius of the toe |

### `[Gussets]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Gusset_Style` | `full_wedge` | `full_wedge`, `swept_ribs`, `buttress_wings`, `classic` | Gusset style |
| `Gusset_Thickness` | `5.0` | | Thickness of the gusset ribs |
| `Include_Hollow_Wedge` | `false` | bool | Hollow out the wedge cavity, otherwise slicer infill fills it (`full_wedge` only) |

### `[Backplate]`
| Parameter | Default | Description |
|---|---|---|
| `Backplate_Thickness` | `5.0` | Thickness of the mounting backplate |
| `Backplate_Corner_Radius` | `6.0` | Corner radius of the backplate perimeter |
| `Insertion_Chamfer` | `2.0` | Rear top chamfer that clears the pegboard during insertion |

### `[Pegboard]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Hole_Spacing` | `25.4` | | Pegboard hole center spacing (25.4 for 1" standard, 15.875 for 5/8" metal) |
| `Pin_Diameter` | `5.7` | | Pin diameter (5.7 for standard 1/4" hole fit, 6.0 for original Sy fit) |
| `Pegboard_Thickness` | `6.35` | | Pegboard thickness (6.35 for 1/4" board, 1.5875 for 1/16" thin metal) |
| `Retention_Hook_Rise` | `3.5` | | Height of the retention hook tab behind the pegboard |
| `Retention_Hook_Margin` | `6.35` | | Distance from the backplate top to the retention hooks |
| `Stabilizing_Pin_Pattern` | `all` | `all`, `top_and_bottom`, `top`, `bottom`, `none` | Stabilizing pin rows below the retention hooks (`bottom` is the lowest hole; the centre column skips the top row when screw holes are on) |

### `[Screw Holes]`
| Parameter | Default | Description |
|---|---|---|
| `Include_Screw_Holes` | `true` | Include countersunk screw clearance holes |
| `Screw_Hole_Diameter` | `4.5` | Screw shank clearance hole diameter (#8 screw) |
| `Countersink_Diameter` | `9.0` | Screw countersink head diameter |

### `[Preview]`
| Parameter | Default | Options | Description |
|---|---|---|---|
| `Show_Component` | `all` | `all`, `backplate`, `cradle`, `slide_bed`, `bottom_shelf`, `slide_rails`, `gussets`, `retention_hooks`, `stabilizing_pins` | Component to show, or all for the full assembly |
| `Show_Labels` | `true` | bool | Show 3D component labels in preview |
| `Label_Size` | `4.5` | | Label text size |

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

<!-- BEGIN GENERATED -->

## Parameters

### Layout

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Battery_Count` | `2` | 1 to 6, step 1 | Number of battery slots side by side |
| `Slot_Spacing_Count` | `4` | 3 to 8, step 1 | Slot center-to-center spacing in pegboard holes |
| `Tilt_Angle` | `15` | 0 to 45, step 5 | Forward tilt from vertical in degrees |

### Battery Rails

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Rail_Width` | `62.0` |  | Width across the outer edges of the battery slide rails |
| `Rail_Length` | `80.0` |  | Length of rail engagement along the slide bed |
| `Rail_Thickness` | `5.5` |  | Thickness of the battery slide flange |
| `Rail_Lip_Thickness` | `2.0` |  | Thickness of the retaining lip |
| `Rail_Lip_Depth` | `4.5` |  | Undercut depth of the retaining lip |
| `Rail_Clearance` | `0.5` |  | Fit gap around the rails |
| `Rail_Lip_Radius` | `1.4` |  | Fillet radius on the rail lips |
| `Rail_Root_Radius` | `0.6` |  | Stress-relief fillet radius at the rail root |
| `Include_Rails` | `true` |  | Include the central slide rails |

### Slide Bed and Shelf

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Bed_Width` | `76.0` |  | Width of the slide bed and bottom shelf |
| `Bed_Thickness` | `5.0` |  | Thickness of the angled slide bed |
| `Bed_Corner_Radius` | `6.0` |  | Top corner radius of the slide bed |
| `Shelf_Depth` | `8.0` |  | Depth of the bottom support shelf |
| `Shelf_Thickness` | `6.0` |  | Thickness of the bottom support shelf |
| `Shelf_Corner_Radius` | `5.0` |  | Front corner radius of the bottom shelf |
| `Toe_Height` | `3.5` |  | Height of the integrated front toe |
| `Toe_Radius` | `1.6` |  | Bottom front edge radius of the toe |

### Gussets

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Gusset_Style` | `"full_wedge"` | Full-Width Sculpted Wedge, Swept Architectural Ribs, Sculpted Buttress Wings, Classic Flat Wedges | Gusset style |
| `Gusset_Thickness` | `5.0` |  | Thickness of the gusset ribs |
| `Include_Hollow_Wedge` | `false` |  | Hollow out the wedge cavity, otherwise slicer infill fills it (full_wedge only) |

### Backplate

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Backplate_Thickness` | `5.0` |  | Thickness of the mounting backplate |
| `Backplate_Corner_Radius` | `6.0` |  | Corner radius of the backplate perimeter |
| `Insertion_Chamfer` | `2.0` |  | Rear top chamfer that clears the pegboard during insertion |

### Pegboard

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Hole_Spacing` | `25.4` |  | Pegboard hole center spacing (25.4 for 1" standard, 15.875 for 5/8" metal) |
| `Pin_Diameter` | `5.7` |  | Pin diameter (5.7 for standard 1/4" hole fit, 6.0 for original Sy fit) |
| `Pegboard_Thickness` | `6.35` |  | Pegboard thickness (6.35 for 1/4" board, 1.5875 for 1/16" thin metal) |
| `Retention_Hook_Rise` | `3.5` |  | Height of the retention hook tab behind the pegboard |
| `Stabilizing_Pin_Pattern` | `"all"` | All Rows, Top and Bottom Rows, Top Row Only, Bottom Row Only (Lowest Hole), Retention Hooks Only | Stabilizing pin rows below the retention hooks |
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
| `Show_Component` | `"all"` | All Components, Backplate, Full Cradle, Slide Bed, Bottom Shelf, Slide Rails, Gussets, Retention Hooks, Stabilizing Pins | Component to show, or all for the full assembly |
| `Show_Labels` | `true` |  | Show 3D component labels in preview |
| `Label_Size` | `4.5` |  | Label text size |

<!-- END GENERATED -->
