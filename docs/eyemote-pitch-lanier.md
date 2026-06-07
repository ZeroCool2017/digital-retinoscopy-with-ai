# Eyemote — Pitch for Jaron Lanier / Microsoft Research

**Subject: A $50 digital retinoscope — hardware is built, need the data pipeline**

---

Jaron,

I'm an optometrist in Oklahoma (Caddo Nation) and a self-taught hardware engineer. I built a digital retinoscope head that replaces the rubber eyecup on any standard retinoscope for $50 in parts.

**What it is:**
ESP32-S3 XIAO Sense camera → round 240x240 display. Real-time. No phone. No laptop. No cloud. The examiner sees the retinoscopy reflex on the display instead of through a peephole. The whole device slides onto the retinoscope the same way the rubber eyecup did.

**What it costs:**
- Parts: $34–$50
- Commercial equivalent (Keeler): $3,000
- That's not a 2x difference. That's 60x.

**Why it matters:**
1 billion people lack access to basic eye exams. Retinoscopy is how every child gets their first glasses — but it's the hardest skill to teach because the preceptor can't see what the student sees. A $50 device that shows the reflex in real-time changes who can learn this skill, where it can be practiced, and how much it costs to deliver.

Microsoft AI for Health already has AI models for diabetic retinopathy screening. Those models need high-quality input. My device can produce that input in any clinic, for $50, connected to a Raspberry Pi.

**What I need from Microsoft Research:**
- Help with the Raspberry Pi data pipeline (recording reflex video, structured data upload)
- A connection to the AI for Health team for clinical validation
- $15k–$30k for 100 field-test units in rural Oklahoma and tribal clinics

**What Microsoft gets:**
- A hardware platform that feeds real retinoscopy data into your AI pipeline
- A direct deployment path into underserved communities (I'm already in them)
- A demonstration that low-cost open-source hardware can match clinical-grade tools

I built the thing. The STLs print in 4 hours. The lens is in hand. The camera works. What I don't have is the software layer that turns a live reflex into a recorded, uploadable, AI-readable dataset.

Do you know anyone at Microsoft who'd want to close that gap with me?

— Dr. Lindsey Marvel, O.D.
  Eyemote Vision, Caddo Nation, Oklahoma
