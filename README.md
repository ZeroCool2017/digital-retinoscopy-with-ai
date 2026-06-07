# Digital Retinoscopy with AI

A self-contained digital retinoscope head that replaces the rubber eyecup on any standard retinoscope. Real-time reflex visualization on a round display. Under $50 in parts.

**Built by an optometrist, for the 1 billion people without access to basic eye exams.**

## What it is

- ESP32-S3 XIAO Sense camera → 240x240 round GC9A01 display
- Real-time retinoscopy reflex — no phone, no laptop, no cloud
- 3D printed housing replaces the rubber eyecup
- 20D 55mm lens for magnification with adjustable sliding focus
- Battery-powered (JST 1.25mm LiPo, 500-1000mAh)
- Total BOM cost: ~$34-50

## Repository contents

```
firmware/
  standalone_demo.ino    — working OV2640 firmware (RGB565, ~15fps)

hardware/
  stl/                   — 3 STL files for printing
    ret-adapter-main-body.stl
    ret-adapter-lens-carriage.stl
    ret-adapter-centering-ring.stl
  ret-adapter.scad       — parametric OpenSCAD design

docs/
  eyemote-pitch.md       — general pitch / grant proposal
  eyemote-pitch-lanier.md — pitch for Jaron Lanier / Microsoft Research
```

## Print settings

| Part | Material | Layer | Supports | Infill |
|------|----------|-------|----------|--------|
| Main body | PETG | 0.15-0.2mm | None | 25% |
| Lens carriage | PETG | 0.15mm | None | 25% |
| Centering ring | PETG | 0.15mm | None | 25% |

## Assembly

1. Glue centering ring into peephole socket
2. Press 20D 55mm lens into lens carriage
3. Insert OV2640 camera module into body, route FPC ribbon
4. Slide lens carriage into front — friction fit for focus adjustment
5. Mount XIAO + LiPo on back pocket, round display facing you
6. Slide over retinoscope peephole tube (replaces rubber eyecup)

## BOM

| Part | Cost |
|------|------|
| XIAO ESP32S3 Sense | ~$12 |
| GC9A01 round display | ~$8 |
| 20D 55mm lens | ~$6 |
| LiPo battery 500mAh JST1.25 | ~$6 |
| 3D printed parts | ~$2 |
| Misc (ribbon, wire) | ~$2 |
| **Total** | **~$34-50** |

## Next: AI pipeline

Current prototype is standalone camera→display. Next step:
- Raspberry Pi data capture for reflex video recording
- Upload pipeline for AI-based retinopathy screening
- Telemedicine — remote preceptor sees what student sees

## License

Open source — hardware design and firmware.
