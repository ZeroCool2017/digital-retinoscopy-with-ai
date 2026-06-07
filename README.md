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
  stl/                   — 2 STL files for printing
    ret-adapter-main-body.stl
    ret-adapter-lens-carriage.stl
  ret-adapter.scad       — parametric OpenSCAD design
  generate_stl.py        — Python script to regenerate STLs

docs/
  eyemote-pitch.md       — general pitch / grant proposal
  eyemote-pitch-lanier.md — pitch for Jaron Lanier / Microsoft Research
  CITATIONS.md           — references and sources
```

## Print settings

| Part | Material | Layer | Supports | Infill |
|------|----------|-------|----------|--------|
| Main body | PETG | 0.15-0.2mm | None | 25% |
| Lens carriage | PETG | 0.15mm | None | 25% |

## Assembly

1. Press 20D 55mm lens into lens carriage
2. Insert OV2640 camera module into body pocket, route FPC ribbon through slot
3. Slide lens carriage into front of body — twist to focus
4. Mount XIAO + LiPo battery on the flat back pocket
5. Round display mounts on the back facing you
6. Slide peephole socket over retinoscope tube (replaces rubber eyecup)
7. Twist lens carriage until reflex is sharp on screen

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
