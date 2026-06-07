/*
 * Eyemote Retinoscope Adapter — parametric OpenSCAD design
 *
 * A self-contained digital retinoscope head that replaces the
 * rubber eyecup on any standard retinoscope.
 *
 * PARTS:
 *   1. main_body()     — the body tube with peephole socket, camera pocket, lens bore
 *   2. focus_ring()    — holds the 20D 55mm lens, slides into lens bore for focus
 *
 * PRINT SETTINGS:
 *   Material: PETG
 *   Layer: 0.15-0.2mm
 *   Supports: NONE (bridges under 5mm)
 *   Infill: 25%
 *   Orient main body with large flat face down
 */

// ═══════════════════════════════════════════════════
//  PARAMETERS
// ═══════════════════════════════════════════════════

// Retinoscope peephole
PEEP_OD = 4.54;         // outer diameter of peephole tube (mm)
SOCKET_DEPTH = 12;      // how deep the socket goes over the tube

// 20D magnifying lens
LENS_DIA   = 55;         // outer diameter of the 20D lens (mm)
LENS_THICK = 5;          // lens edge thickness (mm)
LENS_FOCAL = 50;         // 20D = 50mm focal length (mm)

// Camera module (OV2640 for XIAO ESP32S3 Sense)
CAM_W = 12;              // module width (mm)
CAM_H = 10;              // module height (mm)
CAM_D = 6;               // module depth including lens barrel (mm)

// XIAO ESP32S3 Sense
XIAO_W = 21;
XIAO_H = 17.5;
XIAO_D = 4;

// Round display (GC9A01)
DISP_DIA = 27.5;
DISP_THICK = 4;

// Body geometry
WALL = 2.5;              // wall thickness (mm)
CLEAR = 0.3;             // sliding clearance (mm)

// Derived
SOCKET_OD = 14;          // outer diameter of the peephole socket
BODY_ID = 18;            // inner diameter of the main body section
LENS_BORE_ID = LENS_DIA + 0.8;  // bore for lens (with clearance, mm)
LENS_BORE_OD = LENS_BORE_ID + 2*WALL;  // outer diameter at lens end

// Z-axis convention:
// Z=0 = camera sensor plane
// Negative Z = toward retinoscope (back)
// Positive Z = toward lens (front)

// Body section lengths
BACK_LEN = 12;           // from peephole socket base to camera sensor (mm)
BODY_LEN = 8;            // body section before flare (mm)
FLARE_LEN = 10;          // length of the flare section (mm)
LENS_SEAT_LEN = 8;       // depth of the lens holder section (mm)

// Total body from sensor to tip
TOTAL_FRONT = BODY_LEN + FLARE_LEN + LENS_SEAT_LEN;

// Focus ring
RING_H = LENS_THICK + 3 + 15;  // lens thickness + grip + focus travel
RING_FLANGE_H = 2;              // thickness of the front retaining flange

// ═══════════════════════════════════════════════════
//  MODULE: Main body
// ═══════════════════════════════════════════════════

module main_body() {
    // The body is built as a single piece and then we subtract all the hollow parts.
    $fn = 64;
    
    difference() {
        // ── Solid body ──────────────────────────
        union() {
            // Peephole socket (small tube at back)
            translate([0, 0, -SOCKET_DEPTH])
            cylinder(d = SOCKET_OD, h = SOCKET_DEPTH + 0.5);
            
            // Main body tube (straight section)
            cylinder(d = BODY_ID + 2*WALL, h = BODY_LEN);
            
            // Flare section (cone from body OD to lens bore OD)
            translate([0, 0, BODY_LEN])
            cylinder(
                d1 = BODY_ID + 2*WALL,
                d2 = LENS_BORE_ID + 2*WALL,
                h = FLARE_LEN
            );
            
            // Lens holder section (straight)
            translate([0, 0, BODY_LEN + FLARE_LEN])
            cylinder(d = LENS_BORE_ID + 2*WALL, h = LENS_SEAT_LEN);
            
            // Additional front lip
            translate([0, 0, BODY_LEN + FLARE_LEN + LENS_SEAT_LEN])
            cylinder(d = LENS_BORE_ID + 2*WALL + 2, h = 3);
        }
        
        // ── Subtractions ────────────────────────
        
        // Peephole bore
        translate([0, 0, -SOCKET_DEPTH - 1])
        cylinder(d = PEEP_OD + 0.3, h = SOCKET_DEPTH + 2);
        
        // Main bore (camera section)
        translate([0, 0, -1])
        cylinder(d = BODY_ID, h = BODY_LEN + 2);
        
        // Flare bore
        translate([0, 0, BODY_LEN - 1])
        cylinder(
            d1 = BODY_ID,
            d2 = LENS_BORE_ID,
            h = FLARE_LEN + 2
        );
        
        // Lens bore
        translate([0, 0, BODY_LEN + FLARE_LEN - 1])
        cylinder(d = LENS_BORE_ID, h = LENS_SEAT_LEN + 5);
        
        // Camera module pocket
        // Position: camera module sits ~10mm in front of sensor, on the tube wall
        translate([0, BODY_ID/2, BODY_LEN/2])
        cube([CAM_W + 1, CAM_D + 2, CAM_H + 1], center = true);
        
        // FPC ribbon slot
        translate([CAM_W/2 + 2, 0, BODY_LEN/2])
        cube([3, 20, CAM_H/2 + 1], center = true);
        
        // XIAO mount cutout (flat area on the side)
        translate([0, -(BODY_ID + 2*WALL)/2 - 4, -3])
        cube([XIAO_W + 4, 8, XIAO_D + 10], center = true);
        
        // Display hole (viewing cutout through the body wall)
        translate([0, -(BODY_ID + 2*WALL)/2 - 1, 4])
        cylinder(d = 18, h = 8, $fn = 48);
        
        // USB access slot
        translate([0, -(BODY_ID + 2*WALL)/2 - 1, -XIAO_D/2 - 2])
        cube([9, 6, 5], center = true);
        
        // Weight relief holes
        for (a = [0 : 60 : 300]) {
            rotate([0, 0, a])
            translate([(BODY_ID + 2*WALL)/2 + 1, 0, BODY_LEN/2])
            rotate([90, 0, 0])
            cylinder(d = 3, h = (BODY_ID + 2*WALL) + 2);
        }
    }
}

// ═══════════════════════════════════════════════════
//  MODULE: Focus ring (holds the 20D lens)
// ═══════════════════════════════════════════════════

module focus_ring() {
    $fn = 64;
    
    ring_od = LENS_BORE_ID - CLEAR;        // slides inside the lens bore
    ring_bore = LENS_DIA - 0.2;             // press-fit for the lens
    
    difference() {
        // Outer ring
        cylinder(d = ring_od, h = RING_H);
        
        // Lens bore
        translate([0, 0, -1])
        cylinder(d = ring_bore, h = RING_H - LENS_THICK + 1);
        
        // Lens seat ledge (smaller ID so the lens rests on it)
        translate([0, 0, RING_H - LENS_THICK - 1.5])
        cylinder(d = LENS_DIA - 2, h = LENS_THICK + 2);
        
        // Front access (lets light through to the lens)
        translate([0, 0, -1])
        cylinder(d = 45, h = 2);  // 45mm clear aperture
        
        // Finger grip grooves
        for (i = [0 : 11]) {
            rotate([0, 0, i * 30])
            translate([ring_od/2 + 1, 0, RING_H/2])
            rotate([90, 0, 0])
            cylinder(d = 3.5, h = ring_od/2 + 2);
        }
        
        // Lightening holes
        for (i = [0 : 5]) {
            rotate([0, 0, i * 60 + 15])
            translate([(ring_od - 4)/2, 0, RING_H/2])
            rotate([90, 0, 0])
            cylinder(d = 5, h = ring_od);
        }
    }
}

// ═══════════════════════════════════════════════════
//  RENDER
// ═══════════════════════════════════════════════════

// Uncomment the part you want to export:

// main_body();
// translate([0, 0, TOTAL_FRONT + 10]) focus_ring();

// Assembly view:
// color("gray", 0.5) main_body();
// translate([0, 0, 55]) color("orange") focus_ring();
