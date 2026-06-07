# Eyemote: A $50 Digital Retinoscope for Global Eye Care

**Who I am**
Dr. Lindsey Marvel, O.D. — optometrist, Caddo Nation, Oklahoma. Self-taught hardware engineer. I've spent the last year building the hardware I wish existed when I was learning retinoscopy.

**The problem**
Retinoscopy is the single most important skill for determining a patient's prescription — especially in children, nonverbal patients, and anyone who can't sit through a subjective refraction. It's also the hardest skill to teach and learn.

Commercial digital retinoscopes (Keeler, Welch Allyn) cost $3,000–$8,000. They're video recorders bolted onto a $50 light. They don't help you *see* the reflex better — they help you *record* it. A whole generation of optometry students graduates without confidence in retinoscopy because their preceptor can't look through the scope with them.

**The solution**
A self-contained digital retinoscope head that replaces the rubber eyecup. It costs under $50 in parts:

- ESP32-S3 XIAO Sense ($12) — camera + processor + WiFi
- Round 240x240 GC9A01 display ($8)
- 20D 55mm magnifying lens ($6)
- 3D printed housing ($2)
- 500mAh LiPo battery ($6)

Total: ~$34–$50 depending on sourcing.

**How it works**
The camera captures the retinoscopy streak reflex in real-time. The round display shows it to the examiner — no phone, no laptop, no cable, no cloud. The whole device replaces the rubber eyecup on any standard retinoscope. You hold the retinoscope normally, look at the display instead of the peephole, and see the reflex in real-time — exactly the same motion you already use.

**The underserved angle**
Retinoscopy is how every child gets their first glasses prescription. In rural Oklahoma, on tribal lands, in community health centers — there are clinics where a $3,000+ digital retinoscope will never be approved. A $50 device that fits in a pocket doesn't need purchase orders. It doesn't need IT support. It needs a USB-C cable and a 3D printer.

For global eye care: the World Health Organization estimates 1 billion people lack access to basic eye exams. The equipment gap isn't technology — it's cost. A device at this price point changes who gets care and who doesn't.

**Where it goes next**
The current prototype is standalone: camera → display, real-time, no latency. The next step is adding a Raspberry Pi data pipeline for:

- Recording reflex videos for teaching
- Uploading to Microsoft AI for diabetic retinopathy screening
- Telemedicine: a remote preceptor can see exactly what the student sees
- Training AI models on real retinoscopy reflexes (nobody has this dataset)

**What I need**
- $15,000–$30,000 to refine the hardware, run clinical validation, and produce 100 units for field testing
- An engineering partner to help with the Raspberry Pi integration and data pipeline
- Clinical partners in rural and underserved settings to test and validate

**Why now**
Microsoft AI for Health has the AI. Keeler has the $3,000 device. Nobody has connected them to the 200,000 optometrists who just need a $50 tool to do their job better. The hardware is done. The lens is in hand. The STL files print in 4 hours. The only missing piece is the bridge between clinic and cloud.

---

**Contact**
Dr. Lindsey Marvel, O.D.
Eyemote Vision
Caddo Nation, Oklahoma

*"I can't see the reflex" should never be the reason a child goes without glasses.*
