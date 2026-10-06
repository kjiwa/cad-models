# Peglock Attachment

Parametric, 3D-printable board attachment clip for Sy's Peglock modular pegboard system.

Prints flat with an integrated 0.2 mm living hinge. After printing, fold 180 degrees in half and insert into the pegboard holes. Accessories (`peglock_holder`, `peglock_hook`) slide downward over the male wedge, locking the folded halves together and anchoring securely to the board.

## Features

- Prints flat and support-free, with layer lines along the pegs for maximum shear strength.
- Configurable hole spacing, peg diameter, and board thickness. The defaults fit standard 1/4" pegboard (5.7 mm snug fit); presets cover Sy's original 6.0 mm model and thin metal pegboards.
- 0.2 mm central hinge folds 180 degrees without hardware.
- Tapered dovetail wedge forms a locking wedge when folded that mates with all Peglock sockets.

<!-- BEGIN GENERATED -->

## Parameters

### Pegboard

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Hole_Spacing` | `25.4` |  | Pegboard hole center spacing (25.4 for 1" standard, 15.875 for 5/8" metal) |
| `Pin_Diameter` | `5.7` |  | Pin diameter (5.7 for standard 1/4" hole fit, 6.0 for original Sy fit) |
| `Pegboard_Thickness` | `6.35` |  | Pegboard thickness (6.35 for 1/4" board, 1.5875 for 1/16" thin metal) |
| `Retention_Hook_Rise` | `6.0` |  | Height of the retention hook tab behind the pegboard |

## Presets

- `Sys_Original_6mm`
- `Thin_Metal_5_8in`

<!-- END GENERATED -->

## Printing

- **Orientation**: Flat on the build plate, pegs pointing upward and hinge flat on the bed. No supports. Layer lines run parallel to the peg shank, maximizing shear resistance under load.
- **First Layer Height**: Exactly 0.20 mm, so the 0.20 mm living hinge extrudes as one continuous layer.
- **First Layer Speed**: 20-25 mm/s for clean adhesion across the narrow 0.5 mm hinge gap.
- **Perimeters**: 4-5. The pegs and retention hooks should be solid perimeters with no interior infill voids.
- **Infill**: 20-30% Gyroid or Grid for the wedge body.
- **Material**:
  - **PETG**: Recommended. High elongation at break and fatigue endurance let the hinge fold 180 degrees repeatedly without stress-whitening or snapping.
  - **PLA / Tough PLA**: Fold the hinge immediately after printing while the bed and part are still warm (~50-60 C), or run the hinge line under hot tap water before the first fold.
- **Assembly**: Fold the clip 180 degrees so the two wedge halves face together, insert the upper hook and lower peg into the pegboard holes, then slide an accessory downward over the male wedge to lock both halves into the board.

## Credits

The mounting interface is from Sy's Peglock modular pegboard system, [CC BY-SA](https://creativecommons.org/licenses/by-sa/4.0/) ([Printables 249871](https://www.printables.com/model/249871)).
