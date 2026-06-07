/*
 * Eyemote Retinoscope Adapter
 * One-piece body + separate focus ring
 *
 * PRINT SETTINGS:
 * - Material: PETG or PLA+
 * - Layer height: 0.15mm or 0.2mm
 * - Supports: NONE (bridges are designed in)
 * - Infill: 25%
 * - Orientation: print both parts with the large flat face down
 *
 * ASSEMBLY:
 * 1. Press 20D 55mm lens into focus ring (snug fit, or use a drop of CA glue)
 * 2. Slide focus ring into main body — twist to focus
 * 3. Insert OV2640 camera module into its pocket, route FPC ribbon through the slot
 * 4. XIAO ESP32S3 Sense sits in the back pocket with round display facing out
 * 5. Slide 4.54mm socket over retinoscope peephole (replace rubber eyecup)
 * 6. Twist focus ring until streak reflex is sharp on screen
 */

// ═══════════════════════════════════════════════════
//  PARAMETERS — change these to fit your parts
// ═══════════════════════════════════════════════════

// Retinoscope
peephole_od = 4.54;        // peephole tube outer diameter (mm)
socket_depth = 12;          // how deep the socket goes over the tube

// Lens
lens_dia    = 55;           // 20D lens outer diameter (mm)
lens_thick  = 5;            // lens edge thickness (mm)
lens_focal  = 50;           // 20D = 50mm focal length
focus_travel = 15;          // how far the lens ring travels for focus (mm)

// Camera module (OV2640 module)
cam_w = 12;                 // module width (mm)
cam_h = 10;                 // module height (mm)
cam_d = 6;                  // module depth including lens (mm)
cam_fpc_w = 4;              // FPC ribbon width (mm)

// Body
wall_thick = 2.5;           // wall thickness (mm)
body_od = 22;               // outer diameter of the main tube (mm)
clearance = 0.25;           // print clearance for sliding parts (mm)

// XIAO ESP32S3 Sense
xiao_w = 21;
xiao_h = 17.5;
xiao_d = 4;

// Round display (GC9A01)
disp_dia = 27.5;
disp_thick = 4;
disp_r = disp_dia / 2;

// ═══════════════════════════════════════════════════
//  DERIVED VALUES
// ═══════════════════════════════════════════════════

// Distance from lens back to camera sensor surface
// 20D lens focal point is at 50mm. We want the sensor at roughly that distance.
// Subtract half the lens thickness so sensor plane is at focal length
optical_dist = lens_focal;  // 50mm from lens center to sensor

// Tube IDs
body_id = body_od - 2 * wall_thick;
lens_bore_dia = lens_dia + 0.5;  // slightly oversized bore for the lens

// ═══════════════════════════════════════════════════
//  MODULE: Main body
// ═══════════════════════════════════════════════════

module main_body() {
    difference() {
        union() {
            // Peephole socket (small tube at back)
            translate([0, 0, -socket_depth])
            cylinder(d = peephole_od + 4*wall_thick, h = socket_depth, $fn = 32);
            
            // Main tube
            cylinder(d = body_od, h = optical_dist + lens_thick/2 + 10, $fn = 64);
            
            // Lens seat (flared end)
            translate([0, 0, optical_dist + lens_thick/2])
            cylinder(d = body_od, h = 5, $fn = 64);
            
            // XIAO/Display pocket (box at back end)
            translate([-xiao_w/2 - 2, -body_od/2 - 5, -5])
            cube([xiao_w + 4, 5, 10]);
        }
        
        // Peephole bore
        translate([0, 0, -socket_depth - 1])
        cylinder(d = peephole_od + 0.3, h = socket_depth + 2, $fn = 32);
        
        // Main bore
        translate([0, 0, -1])
        cylinder(d = body_id, h = optical_dist + lens_thick/2 + 12, $fn = 64);
        
        // Lens bore (at front)
        translate([0, 0, optical_dist - lens_thick/2 - 1])
        cylinder(d = lens_bore_dia, h = lens_thick + 6, $fn = 80);
        
        // Camera module pocket
        // Position: camera sensor at ~50mm from lens center
        translate([0, 0, optical_dist - lens_thick/2 - cam_d - 2])
        cube([cam_w + 1, cam_h + 1, cam_d + 2], center = true);
        
        // FPC ribbon slot
        translate([cam_w/2 + 1, 0, optical_dist - lens_thick/2 - cam_d - 2])
        cube([4, cam_fpc_w + 1, cam_d + 15], center = true);
        
        // XIAO pocket slot
        translate([0, -body_od/2 - 6, -xiao_d/2 - 2])
        cube([xiao_w + 1, 6, xiao_d + 1], center = true);
        
        // Display cutout
        translate([0, -body_od/2 - 6, xiao_d - 1])
        cylinder(d = disp_dia + 1, h = disp_thick + 2, $fn = 64);
        
        // Viewing hole through body for the screen
        translate([0, -body_od/2 - 1, -1])
        cylinder(d = 18, h = 4, $fn = 48);
        
        // Lightening / vent holes
        for (i = [0 : 3]) {
            rotate([0, 0, i * 90 + 20])
            translate([body_od/2 + 1, 0, optical_dist/2])
            rotate([90, 0, 0])
            cylinder(d = 3, h = body_od + 2, $fn = 16);
        }
        
        // USB access slot
        translate([0, -body_od/2 - 1, -3])
        cube([8, 4, 4], center = true);
    }
}

// ═══════════════════════════════════════════════════
//  MODULE: Focus ring (holds the 20D lens)
// ═══════════════════════════════════════════════════

module focus_ring() {
    ring_id = body_id - clearance * 2;
    ring_od = body_id + 2 * wall_thick;
    ring_h = lens_thick + 5 + focus_travel;
    
    difference() {
        union() {
            // Outer ring body
            cylinder(d = ring_od, h = ring_h, $fn = 64);
            
            // Lens retaining lip
            translate([0, 0, ring_h - 1.5])
            cylinder(d = lens_bore_dia - 1, h = 1.5, $fn = 80);
        }
        
        // Inner bore (for the lens)
        translate([0, 0, -1])
        cylinder(d = lens_bore_dia - 2*clearance, h = ring_h + 2, $fn = 80);
        
        // Lens seat (step for lens to rest against)
        translate([0, 0, ring_h - lens_thick - 1])
        cylinder(d = lens_dia - 1, h = lens_thick + 2, $fn = 80);
        
        // Finger grooves for twisting
        for (i = [0 : 11]) {
            rotate([0, 0, i * 30])
            translate([ring_od/2 + 1, 0, ring_h/2])
            rotate([90, 0, 0])
            cylinder(d = 3, h = ring_od/2 + 2, $fn = 12);
        }
        
        // Lightening holes
        for (i = [0 : 5]) {
            rotate([0, 0, i * 60 + 15])
            translate([(ring_od - 5)/2, 0, ring_h/2])
            rotate([90, 0, 0])
            cylinder(d = 4, h = ring_od, $fn = 16);
        }
    }
}

// ═══════════════════════════════════════════════════
//  RENDER — uncomment the part you want to export
// ═══════════════════════════════════════════════════

// Main body
// main_body();

// Focus ring
// focus_ring();

// To see both aligned (for visualization only):
// translate([0, 0, 50]) color("red") focus_ring();
// color("blue") main_body();

// ═══════════════════════════════════════════════════
//  INSTRUCTIONS
// ═══════════════════════════════════════════════════
//
// 1. Open this file in OpenSCAD (free from openscad.org)
// 2. To export the main body:
//    - Comment out "focus_ring()" at the bottom
//    - Uncomment "main_body()"
//    - Preview (F5) then Render (F6) then Export STL (F7)
// 3. To export the focus ring:
//    - Comment out "main_body()"
//    - Uncomment "focus_ring()"
//    - Repeat export
