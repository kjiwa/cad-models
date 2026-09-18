# Makita Hose Adapter

A 3D-printable hose adapter connecting tool dust extraction ports to Makita vacuums and dust extractors.

## Features

- **Tapered Transition**: Connects varying tool port diameters to Makita dust extraction hoses.
- **Parametric Diameters**: Configurable port diameters, section lengths, and wall thickness.
- **Automated CLI Build**: `Makefile` support to render STL, 3MF, and PNG preview images.

---

## Directory Structure

```text
makita_hose_adapter/
├── Makefile                # Build automation for STL, 3MF, and PNG renders
├── README.md               # Project documentation & printing recommendations
└── makita_hose_adapter.scad # Parametric OpenSCAD source model
```

---

## Parameters Reference

All dimensions are in millimeters.

| Parameter | Default | Description |
|---|---|---|
| `END_SECTION_HEIGHT` | `20` | Insertion depth of the end sections |
| `MIDDLE_SECTION_HEIGHT` | `10` | Height of the tapered transition section |
| `hose_adapter_thickness` | `2` | Wall thickness of the adapter shell |
| `makita_dust_extractor_port_diameter` | `37` | Inside diameter of Makita vacuum hose connection |
| `dust_port_diameter` | `34.5` | Inside diameter of the tool dust port |

### Common Tool Port Diameters

- **DeWalt DW618 router plunge base**: `34.5` mm
- **Ryobi P411 cordless random orbit sander**: `31.5` mm
- **Kreg pocket hole jig K4**: `30.5` mm

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

- **Material**: PETG or ABS/ASA recommended for impact and abrasion resistance.
- **Print Orientation**: Upright on either end section (no supports required).
- **Walls / Perimeters**: 3 to 4 perimeters for solid walls without infill gaps.
- **Layer Height**: 0.20 mm or 0.28 mm.
