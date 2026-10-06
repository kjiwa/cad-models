# Ryobi 40V Battery Pegboard Holder

A parametric, 3D-printable pegboard holder for Ryobi 40V batteries with an angled forward tilt for easy insertion and retrieval without pegboard clearance issues above.

## Features

- Side-by-side battery slots (`Battery_Count`, default 2).
- Tilted 15 degrees forward so batteries pull out diagonally away from the pegboard, clear of anything directly above.
- Hooks sized for 1/4" pegboard (6.35 mm thick, 25.4 mm hole spacing) with rear retention tabs that lock within 1/4" behind the board.
- Slide rails for the battery's slide grooves and a bottom shelf carry the battery weight.
- A full-width monolithic wedge backs the slide bed and rails and transfers cantilevered loads into the backplate and hooks.
- Filleted and chamfered perimeter, rail stress-relief fillets, and a slide bed relief with debossed 40V mark.
- Stadium cutouts between slots reduce mass and warping.
- Concentric clearance holes in the slide bed let wall screws be driven through to studs or anchors behind the pegboard.

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

## Printing

- **Material**: PETG or ABS/ASA for load capacity and creep resistance under battery weight (PLA suits indoor use with 1-2 batteries).
- **Orientation**: Upright on the bottom base (Z = 0), backplate vertical. The 15 degree cradle tilt is self-supporting (75 degrees from the plate), rails print along Z for smooth sliding, and peg shanks follow horizontal extrusion paths for tensile strength. Use tree supports for the rear hooks.
- **Walls**: 4 to 6 for strength through the gusset ribs and pins.
- **Infill**: 30% to 50% Gyroid or Grid.
- **Top / Bottom Layers**: 4 to 5.

## Architecture

Each file under `components/` isolates one geometric concern (backplate, bottom shelf, gussets, labels, pegs, slide bed, slide rails, slot cradle). Mid-level modules (`backplate`, `mounting_pegs`, `slide_rails`, `gusset_ribs`, `slot_cradle`) compose single-purpose primitives without mixing coordinate frames. `ryobi_40v_battery_holder.scad` declares the Customizer parameters, computes derived dimensions, and invokes the assembly.
