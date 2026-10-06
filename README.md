# CAD Models

Parametric, 3D-printable OpenSCAD models, each in its own directory with a `.scad` source, a
`Makefile`, and a README covering its own parameters and printing recommendations:

- `bora_centipede_riser` — risers and locking nuts for Bora Centipede work stands
- `curtain_rod_mounting_plate` — mounting plate for curtain rod brackets
- `entryway_table` — plywood entryway table with angled legs
- `keyhole_router_template` — router template for hanging slots in frames and other workpieces
- `makita_hose_adapter` — dust extraction hose adapter for Makita tools
- `peglock_attachment` — board attachment clips for Sy's Peglock pegboard system
- `peglock_bit_holder` — hex bit rack for Sy's Peglock pegboard system
- `peglock_holder` — bin/organizer for Sy's Peglock pegboard system
- `peglock_hook` — hooks and socket racks for Sy's Peglock pegboard system
- `peglock_magnet_mount` — magnet pockets and mount for Sy's Peglock pegboard system
- `pipe_clamp_wall_mount` — wall rack of angled pipe clamps
- `razor_blade_dispenser` — pegboard dispenser for single-edge razor blades
- `ryobi_40v_battery_holder` — pegboard holder for Ryobi 40V batteries
- `shotgun_mini_shell_adapter` — Mossberg 12 gauge adapter for 1.75" mini shells, compatible with the OPSol Mini-Clip fit
- `wheel_tread_cover` — herringbone tread sleeve for a wheel

## Building

Requires [OpenSCAD](https://openscad.org/) and Python 3. `make bundle` and `make dist` also need
[uv](https://docs.astral.sh/uv/) and an OpenSCAD snapshot new enough for `onescad --verify`. From the repository root:

```bash
make setup     # symlink lib/ into your OpenSCAD user library directory (once)
make all       # build every model: default STL, 3MF, preview PNG, and presets
make <model>   # build one model, e.g. make bora_centipede_riser
make stl       # export default STL for every model
make 3mf       # export default 3MF for every model
make preview   # export preview PNG for every model
make presets   # build all parameter presets for every model
make bundle    # write single-file .scad per model into dist/, verified
make dist      # build everything and collect artifacts and bundles into dist/
make clean     # remove build and dist artifacts
```

Each model directory accepts the same targets individually, e.g. `make -C bora_centipede_riser stl`.

## License

Original models and their `.scad` sources are licensed
[CC-BY-NC-SA-4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/): credit is required,
published remixes must stay open under the same license, and commercial use (including selling
prints) requires the author's permission. Commercial licenses: contact kamil.jiwa@gmail.com.

Submodules under `lib/` and mounting interfaces derived from other authors' work keep their own
licenses and are not covered by this repository's LICENSE:

- `lib/BOSL2` ([BelfrySCAD/BOSL2](https://github.com/BelfrySCAD/BOSL2)) — BSD-2-Clause
- `lib/threads-scad` ([rcolyer/threads-scad](https://github.com/rcolyer/threads-scad)) — CC0-1.0
- `lib/peglock`, `peglock_attachment`, `peglock_bit_holder`, `peglock_holder`, `peglock_hook`, and `peglock_magnet_mount` interface with Sy's Peglock modular pegboard mounting
  system, [CC BY-SA](https://creativecommons.org/licenses/by-sa/4.0/) ([Printables 249871](https://www.printables.com/model/249871)); only the mounting interface is reused, credited here
