# CAD Models

Parametric, 3D-printable OpenSCAD models, each in its own directory under `models/` with a `.scad` source, a
`Makefile`, and a README covering its own parameters and printing recommendations:

- `models/bora_centipede_riser` — risers and locking nuts for Bora Centipede work stands
- `models/curtain_rod_mounting_plate` — mounting plate for curtain rod brackets
- `models/entryway_table` — plywood entryway table with angled legs
- `models/keyhole_router_template` — router template for hanging slots in frames and other workpieces
- `models/knob` — fluted or knurled knob with a captive nut pocket, for stop blocks and miter gauge handles
- `models/makita_hose_adapter` — dust extraction hose adapter for Makita tools
- `models/peglock_attachment` — board attachment clips for Sy's Peglock pegboard system
- `models/stop_block` — fence stop block with rounded corners and dust relief, for indexing against a ruler
- `models/table_saw_blade_spacer` — arbor spacers for a table saw
- `models/wall_bit_holder` — hex bit rack for Sy's Peglock pegboard system
- `models/wall_holder` — bin/organizer for Sy's Peglock pegboard system
- `models/wall_hook` — hooks and socket racks for Sy's Peglock pegboard system
- `models/wall_magnet_mount` — magnet pockets and mount for Sy's Peglock pegboard system
- `models/pipe_clamp_wall_mount` — wall rack of angled pipe clamps
- `models/razor_blade_dispenser` — pegboard dispenser for single-edge razor blades
- `models/ryobi_40v_battery_holder` — pegboard holder for Ryobi 40V batteries
- `models/shotgun_mini_shell_adapter` — Mossberg 12 gauge adapter for 1.75" mini shells, compatible with the OPSol Mini-Clip fit
- `models/wheel_tread_cover` — herringbone tread sleeve for a wheel

## Setup

Requires [OpenSCAD](https://openscad.org/) 2021.01 or later and Python 3. A recent development snapshot is much
faster: its Manifold backend renders in under a second what 2021.01 takes close to a minute to render. `make bundle` and
`make dist` also need [uv](https://docs.astral.sh/uv/) and a snapshot new enough for `onescad --verify`.

Models import the libraries in `lib/` (BOSL2, threads-scad, peglock, pegboard). `make setup` symlinks them into the
OpenSCAD user library directory once: `~/Documents/OpenSCAD/libraries` on macOS, `~/.local/share/OpenSCAD/libraries`
on Linux. To use another location, set `OPENSCADPATH` to a directory containing them, for example
`OPENSCADPATH=$PWD/lib openscad ...`.

## Customizer

1. Open the model's `.scad` file in OpenSCAD.
2. Enable **Window > Customizer**.
3. Pick a preset from the dropdown, if the model has a `.json`, or edit parameters.
4. Press `F5` to preview, `F6` to render, then `F7` to export an STL.

Each model's README lists its parameters and presets.

## Building

From the repository root:

```bash
make all       # every model: default STL, 3MF, preview PNG, and presets
make <model>   # one model, e.g. make bora_centipede_riser
make stl       # default STL for every model
make 3mf       # default 3MF for every model
make preview   # preview PNG for every model
make presets   # every parameter preset for every model
make check     # evaluate every model and preset without rendering, failing on any warning
make bundle    # verified single-file .scad per model in dist/
make dist      # build everything and collect artifacts and bundles in dist/
make readme    # regenerate each model README's Parameters and Presets sections
make clean     # remove build and dist artifacts
```

Add `-j` to build models in parallel, e.g. `make -j8 all`.

Each model directory accepts the same targets, e.g. `make -C models/bora_centipede_riser stl`. Outputs go to the model's
`build/` directory.

Each model README holds a block between `<!-- BEGIN GENERATED -->` and `<!-- END GENERATED -->` produced from the
`.scad` Customizer block and `.json` presets. Edit the `.scad`, then run `make readme`;
`tests/test_readme_params.py` fails when a block is out of date.

## License

Original models and their `.scad` sources are licensed
[CC-BY-NC-SA-4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/): credit is required,
published remixes must stay open under the same license, and commercial use (including selling
prints) requires the author's permission. Commercial licenses: contact kamil.jiwa@gmail.com.

Submodules under `lib/` and mounting interfaces derived from other authors' work keep their own
licenses and are not covered by this repository's LICENSE:

- `lib/BOSL2` ([BelfrySCAD/BOSL2](https://github.com/BelfrySCAD/BOSL2)) — BSD-2-Clause
- `lib/threads-scad` ([rcolyer/threads-scad](https://github.com/rcolyer/threads-scad)) — CC0-1.0
- `lib/peglock`, `models/peglock_attachment`, `models/wall_bit_holder`, `models/wall_holder`, `models/wall_hook`, and `models/wall_magnet_mount` interface with Sy's Peglock modular pegboard mounting
  system, [CC BY-SA](https://creativecommons.org/licenses/by-sa/4.0/) ([Printables 249871](https://www.printables.com/model/249871)); only the mounting interface is reused, credited here
