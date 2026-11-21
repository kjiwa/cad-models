# Mitsubishi Panel Hinge Clip

A 3D-printable replacement for the front panel hinge clip of a Mitsubishi MSZ-GS09NA mini split, molded `312L_P-1` and `312R_P-1`. The original is POM. The right clip mirrors the left.

Only the dimensions marked Caliper below were measured on the real part; the rest are estimates read from photos and are meant to be tuned. Print a test pair, compare it with the original, adjust, and repeat.

## Features

- One Customizer group per feature of the original, named for the letters in the sketch below.
- Every position is measured from one datum, so each parameter is a single caliper or depth-rod reading.
- `Highlight` tints one feature in the preview, so each group maps to the part on screen.
- `Part` selects the left clip, the right clip or both side by side.
- The lip and cradle sit on the +Y side of the left clip and mirror to -Y on the right clip.

<!-- BEGIN GENERATED -->

## Parameters

### Part

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Part` | `"left"` | Left (312L), Right (312R), Pair | Part to generate |

### Base Plate

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Plate_Thickness` | `2.15` |  | Thickness of the shoulders |

### Plate A

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Plate_A_Length` | `25` |  | Length of the angled plate along its slope |
| `Plate_A_Width` | `17` |  | Width of the angled plate |
| `Plate_A_Thickness` | `1.8` |  | Thickness of the angled plate |
| `Plate_A_Angle` | `45` | 0 to 90, step 5 | Angle of the plate above the base plate |

### Shoulder

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Shoulder_Length` | `5` |  | Length of the upper shoulder along the long axis |
| `Shoulder_Width` | `17` |  | Width of the upper shoulder without the lugs |

### Neck

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Neck_Length` | `4` |  | Length of the neck, where the original breaks |
| `Neck_Width` | `9.6` |  | Width of the neck |
| `Neck_Thickness` | `1.8` |  | Thickness of the neck |

### Barrel

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Barrel_Length` | `11.5` |  | Length of the barrel trough along the long axis |
| `Barrel_Width` | `17` |  | Width of the barrel across the rim |
| `Barrel_Depth` | `4` |  | Depth of the barrel below the top of the base plate |
| `Barrel_Wall` | `2.15` |  | Wall thickness of the barrel and its end walls |

### Lower Shoulder

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Lower_Length` | `6.5` |  | Length of the lower shoulder along the long axis |
| `Lower_Width` | `17` |  | Width of the lower shoulder without the lugs |

### Tongue

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Tongue_Length` | `19.45` |  | Developed length of the tongue from the lower shoulder to its tip |
| `Tongue_Width` | `10` |  | Width of the tongue |
| `Tongue_Thickness` | `2.4` |  | Thickness of the tongue |
| `Tongue_Drop_Length` | `7` |  | Length of the first leg of the tongue, which drops below the base plate |
| `Tongue_Drop_Angle` | `70` | 0 to 90, step 5 | Angle of the first tongue leg below horizontal |
| `Tongue_Rise_Angle` | `55` | 0 to 90, step 5 | Angle of the second tongue leg above horizontal |

### Lugs

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Lug_Length` | `5` |  | Length of a lug along the long axis |
| `Lug_Height` | `4` |  | Height of a lug above the bottom face of the base plate |
| `Lug_Projection` | `3.5` |  | Distance a lug projects beyond the shoulder |

### Fin

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Fin_Position` | `9` |  | Distance from the upper shoulder end face to the front base edge of the fin |
| `Fin_Height` | `30` |  | Height of the fin above the bottom face of the base plate |
| `Fin_Base_Width` | `13.3` |  | Width of the fin at its base along the long axis |
| `Fin_Top_Width` | `9` |  | Width of the fin at its top along the long axis |
| `Fin_Base_Thickness` | `3` |  | Thickness of the fin at its base |
| `Fin_Top_Thickness` | `2.15` |  | Thickness of the fin at its top |

### Lip

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Lip_Length` | `6` |  | Length of the lip along the long axis, at the back edge of the fin top |
| `Lip_Height` | `2.15` |  | Height of the lip down from the top of the fin |
| `Lip_Overhang` | `1.5` |  | Distance the lip overhangs the fin on the cradle side |

### Cradle

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Cradle_Radius` | `6` |  | Inside radius of the cradle |
| `Cradle_Wall` | `2.15` |  | Wall thickness of the cradle |
| `Cradle_Width` | `3` |  | Width of the cradle across the part |
| `Cradle_Position` | `7` |  | Distance from the upper shoulder end face to the cradle center |
| `Cradle_Offset` | `6.9` |  | Distance from the long centerline to the cradle center, on the lip side |
| `Cradle_Arc_Angle` | `90` | 30 to 180, step 5 | Angle the cradle arc spans |

### Legs

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Leg_Gap` | `6.45` |  | Gap between the inside faces of the two legs |
| `Leg_Width` | `6` |  | Width of a leg along the long axis |
| `Leg_Length` | `9.2` |  | Length of a leg below the bottom face of the base plate |
| `Leg_Thickness` | `2.15` |  | Wall thickness of a leg |
| `Leg_Position` | `23.75` |  | Distance from the upper shoulder end face to the leg center |
| `Foot_Height` | `1.5` |  | Height of a foot at the leg tip |
| `Foot_Projection` | `1` |  | Distance a foot projects past the leg face (0 to disable) |
| `Foot_Side` | `"outward"` | Outward, Inward | Face of the leg that carries the foot |

### Preview

| Parameter | Default | Options | Description |
| --- | --- | --- | --- |
| `Highlight` | `"none"` | None, Plate A, Shoulder, Neck, Barrel, Lower Shoulder, Tongue, Lugs, Fin, Lip, Cradle, Legs | Feature to tint in the preview |

<!-- END GENERATED -->

## Measuring

Datum: X runs along the long axis from the outer end face of the upper shoulder, the end the angled plate leaves from. Y is across the part from its centerline. Z is up from the bottom face of the base plate; the legs and barrel reach below it.

```
Side view                                     Top view

         F fin                                  A plate (angled)
        /|  lip F1                            +----------+
 A     / |                                    |          |
  \   /  |                                  L1|  B       |L2
   \ K cradle        T tongue              ---+--+ N +--+---
    \ |  |             \    /                    | C trough
  ---+-B-N-C--D--------+\  /                  ---+--+ D +--+---
         base plate     V                      L3 |  |   | L4
            G legs below                              | T |
```

| Letter | Feature | Group | Parameters | Source |
| --- | --- | --- | --- | --- |
| A | Angled plate | Plate A | `Plate_A_Length`, `Plate_A_Width`, `Plate_A_Thickness`, `Plate_A_Angle` | Estimate |
| P | Base plate | Base Plate | `Plate_Thickness` | Estimate |
| B | Upper shoulder | Shoulder | `Shoulder_Length`, `Shoulder_Width` | Estimate |
| N | Neck, where the original breaks | Neck | `Neck_Width`, `Neck_Thickness` | Caliper |
| N | Neck length | Neck | `Neck_Length` | Estimate |
| C | Barrel trough | Barrel | `Barrel_Length`, `Barrel_Width`, `Barrel_Depth`, `Barrel_Wall` | Estimate |
| D | Lower shoulder | Lower Shoulder | `Lower_Length`, `Lower_Width` | Estimate |
| T | Tongue size | Tongue | `Tongue_Length`, `Tongue_Width`, `Tongue_Thickness` | Caliper |
| T | Tongue bend | Tongue | `Tongue_Drop_Length`, `Tongue_Drop_Angle`, `Tongue_Rise_Angle` | Estimate |
| L1-L4 | Lugs | Lugs | `Lug_Length`, `Lug_Height`, `Lug_Projection` | Estimate |
| F | Fin size | Fin | `Fin_Height`, `Fin_Base_Width`, `Fin_Base_Thickness`, `Fin_Top_Thickness` | Caliper |
| F | Fin top and position | Fin | `Fin_Top_Width`, `Fin_Position` | Estimate |
| F1 | Lip | Lip | `Lip_Length`, `Lip_Height`, `Lip_Overhang` | Estimate |
| K | Cradle radius | Cradle | `Cradle_Radius` | Caliper |
| K | Cradle shape and position | Cradle | `Cradle_Wall`, `Cradle_Width`, `Cradle_Position`, `Cradle_Offset`, `Cradle_Arc_Angle` | Estimate |
| G1, G2 | Legs | Legs | `Leg_Gap`, `Leg_Width`, `Leg_Length`, `Leg_Thickness` | Caliper |
| G1, G2 | Leg position and feet | Legs | `Leg_Position`, `Foot_Height`, `Foot_Projection`, `Foot_Side` | Estimate |

Procedure:

1. Set `Highlight` to a feature and confirm it is the feature you mean to measure.
2. Measure it on the original with calipers. Take X positions from the datum with the depth rod.
3. Enter the readings in that feature's group. The asserts name any combination that cannot fit.
4. Save the values as a Customizer preset. OpenSCAD writes `mitsubishi_panel_hinge_clip.json`, and `make presets` then builds it.
5. Print a pair, compare it with the original, and repeat.

Measure first, in this order: the lug positions and sizes, the shoulder, barrel and lower shoulder lengths, `Fin_Position`, then the tongue bend and the angled plate. The notches in the lugs and the exact side of the cradle on the original are not modeled; confirm which side it sits on before printing.

## Printing

- **Quantity**: One left and one right clip.
- **Material**: The original is POM, which prints poorly. Try PETG or nylon; neither is verified for this use, and PLA creeps.
- **Orientation**: Unverified. The model keeps the measuring datum, so it does not sit flat on the bed. Try it on its side with tree supports under the legs and lugs.
- **Fit**: Check with the unit powered off. Keep the repaired original until a print has been fitted.
