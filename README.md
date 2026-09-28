# CAD Models

Parametric, 3D-printable OpenSCAD models, each in its own directory with a `.scad` source, a
`Makefile`, and a README covering its own parameters and printing recommendations:

- `bora_centipede_riser` — risers and locking nuts for Bora Centipede work stands
- `curtain_rod_mounting_plate` — mounting plate for curtain rod brackets
- `entryway_table` — plywood entryway table with angled legs
- `makita_hose_adapter` — dust extraction hose adapter for Makita tools
- `peglock_holder` — bin/organizer for Sy's Peglock pegboard system
- `peglock_hook` — hooks and socket racks for Sy's Peglock pegboard system
- `razor_blade_dispenser` — pegboard dispenser for single-edge razor blades
- `ryobi_40v_battery_holder` — pegboard holder for Ryobi 40V batteries

## Building

Requires [OpenSCAD](https://openscad.org/) and Python 3. From the repository root:

```bash
make setup     # symlink lib/ into your OpenSCAD user library directory (once)
make all       # build every model: default STL, 3MF, preview PNG, and presets
make <model>   # build one model, e.g. make bora_centipede_riser
make stl       # export default STL for every model
make 3mf       # export default 3MF for every model
make preview   # export preview PNG for every model
make presets   # build all parameter presets for every model
make dist      # build everything and collect artifacts into dist/
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
- `lib/peglock_openscad` ([loudej/peglock_openscad](https://github.com/loudej/peglock_openscad)) —
  unlicensed (no LICENSE file upstream); resolution pending
- `peglock_holder` and `peglock_hook` interface with Sy's Peglock modular pegboard mounting
  system, CC-BY; only the mounting interface is reused, credited here
