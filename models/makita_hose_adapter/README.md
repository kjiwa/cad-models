# Makita Hose Adapter

A 3D-printable adapter connecting tool dust extraction ports to Makita vacuums and dust extractors.

## Features

- Tapered transition between a tool port and a Makita dust extraction hose.
- Configurable port diameters, section lengths, and wall thickness.

<!-- BEGIN GENERATED -->

## Parameters

### Adapter

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Tool_Port_Diameter` | `34.5` |  | Inside diameter of the tool dust port (the default fits the DeWalt DW618) |
| `Hose_Port_Diameter` | `37` |  | Inside diameter of the Makita vacuum hose connection |
| `Wall_Thickness` | `2` |  | Wall thickness of the adapter shell |
| `End_Length` | `20` |  | Length of each cylindrical end section |
| `Taper_Length` | `10` |  | Length of the tapered middle section |

## Presets

- `Ryobi_P411`
- `Kreg_K4`

<!-- END GENERATED -->

## Printing

- **Material**: PETG or ABS/ASA for impact and abrasion resistance.
- **Orientation**: Upright on either end section, no supports required.
- **Walls**: 3 to 4 perimeters for solid walls without infill gaps.
- **Layer Height**: 0.20 mm or 0.28 mm.

## Tool Port Diameters

- DeWalt DW618 router plunge base: `34.5` mm (the default)
- Ryobi P411 cordless random orbit sander: `31.5` mm (`Ryobi_P411`)
- Kreg pocket hole jig K4: `30.5` mm (`Kreg_K4`)
