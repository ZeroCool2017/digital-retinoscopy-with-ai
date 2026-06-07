#!/usr/bin/env python3
"""Generate Eyemote Retinoscope Adapter STL — fixed version.
Design: body of revolution + XIAO mount plate."""

import numpy as np
from stl import mesh
import math, os

# ═══════════════════════════════════════════════════════
# PARAMETERS (mm)
# ═══════════════════════════════════════════════════════
PEEP_ID = 4.6            # peephole tube outer diameter
PEEP_SOCKET_OD = 14      # socket outer diameter
SOCKET_DEPTH = 12        # socket depth
LENS_DIA = 55            # 20D lens diameter
LENS_FOCAL = 50          # 20D = 50mm focal length
BODY_ID = 18             # body tube inner diameter
WALL = 2.5               # wall thickness
LENS_BORE_ID = LENS_DIA + 0.8  # 55.8mm — clearance for sliding focus ring
LENS_BORE_OD = LENS_BORE_ID + 2*WALL  # 60.8mm
BODY_OD = BODY_ID + 2*WALL  # 23mm

# XIAO / Display
XIAO_W = 21
XIAO_H = 17.5
XIAO_D = 4

# Section lengths
BODY_LEN = 8             # straight body section from sensor forward
FLARE_LEN = 10           # length of the flare cone
LENS_START = LENS_FOCAL - 6  # lens bore starts 6mm before focal center
LENS_BORE_LEN = 14       # depth of lens bore (allows focus travel)

SEGMENTS = 48

# ═══════════════════════════════════════════════════════
# PROFILE — body of revolution
# Each entry: (z, inner_r, outer_r)
# Z=0 = camera sensor plane
# Negative Z = toward retinoscope
# Positive Z = toward lens
# ═══════════════════════════════════════════════════════
profile = [
    # Peephole socket
    (-SOCKET_DEPTH, PEEP_ID/2, PEEP_SOCKET_OD/2),      # socket tip
    (0, PEEP_ID/2, PEEP_SOCKET_OD/2),                  # socket base = Z=0
    
    # Body straight section (camera sensor at Z=0)
    (0, BODY_ID/2, BODY_OD/2),                          # start of body
    (BODY_LEN, BODY_ID/2, BODY_OD/2),                   # end of straight section
    
    # Flare from body OD to lens bore OD
    (BODY_LEN, BODY_ID/2, BODY_OD/2),                   # start of flare (inner)
    (BODY_LEN + FLARE_LEN, LENS_BORE_ID/2, LENS_BORE_OD/2),  # end of flare
    
    # Continue at full width to lens bore
    (BODY_LEN + FLARE_LEN, LENS_BORE_ID/2, LENS_BORE_OD/2),
    (LENS_START, LENS_BORE_ID/2, LENS_BORE_OD/2),       # lens bore starts
    
    # Lens holder section
    (LENS_START, LENS_BORE_ID/2, LENS_BORE_OD/2),
    (LENS_START + LENS_BORE_LEN, LENS_BORE_ID/2, LENS_BORE_OD/2),  # lens bore ends
    
    # Front face
    (LENS_START + LENS_BORE_LEN, LENS_BORE_ID/2 - 0.5, LENS_BORE_OD/2),
    (LENS_START + LENS_BORE_LEN + 1, 22, LENS_BORE_OD/2 + 1),  # front lip
]

# ═══════════════════════════════════════════════════════
# Build lathe mesh
# ═══════════════════════════════════════════════════════
def build_lathe(profile, seg=SEGMENTS):
    n = len(profile)
    n_angles = seg
    total_tris = 4 * n * n_angles  # overestimate
    
    data = np.zeros(total_tris, dtype=mesh.Mesh.dtype)
    tri_idx = 0
    
    z_vals = np.array([p[0] for p in profile])
    inner_r = np.array([p[1] for p in profile])
    outer_r = np.array([p[2] for p in profile])
    
    angles = np.linspace(0, 2*math.pi, n_angles, endpoint=False)
    ca = np.cos(angles)
    sa = np.sin(angles)
    
    for i in range(1, n):
        z0, z = z_vals[i-1], z_vals[i]
        ir0, ir = inner_r[i-1], inner_r[i]
        or0, o_r = outer_r[i-1], outer_r[i]
        
        # Skip zero-length segments
        if abs(z - z0) < 0.001:
            continue
        
        for j in range(n_angles):
            jn = (j + 1) % n_angles
            
            # Outer wall
            v0 = [or0*ca[j], or0*sa[j], z0]
            v1 = [or0*ca[jn], or0*sa[jn], z0]
            v2 = [o_r*ca[j], o_r*sa[j], z]
            v3 = [o_r*ca[jn], o_r*sa[jn], z]
            data['vectors'][tri_idx] = [v0, v1, v2]; tri_idx += 1
            data['vectors'][tri_idx] = [v1, v3, v2]; tri_idx += 1
            
            # Inner wall
            iv0 = [ir0*ca[j], ir0*sa[j], z0]
            iv1 = [ir0*ca[jn], ir0*sa[jn], z0]
            iv2 = [ir*ca[j], ir*sa[j], z]
            iv3 = [ir*ca[jn], ir*sa[jn], z]
            data['vectors'][tri_idx] = [iv0, iv2, iv1]; tri_idx += 1
            data['vectors'][tri_idx] = [iv1, iv2, iv3]; tri_idx += 1
    
    # Back cap
    z0 = z_vals[0]; ir0 = inner_r[0]; or0 = outer_r[0]
    for j in range(n_angles):
        jn = (j + 1) % n_angles
        vi1 = [ir0*ca[j], ir0*sa[j], z0]
        vi2 = [ir0*ca[jn], ir0*sa[jn], z0]
        vo1 = [or0*ca[j], or0*sa[j], z0]
        vo2 = [or0*ca[jn], or0*sa[jn], z0]
        data['vectors'][tri_idx] = [vi1, vo1, vi2]; tri_idx += 1
        data['vectors'][tri_idx] = [vi2, vo1, vo2]; tri_idx += 1
    
    # Front cap
    zf = z_vals[-1]; irf = inner_r[-1]; orf = outer_r[-1]
    for j in range(n_angles):
        jn = (j + 1) % n_angles
        vi1 = [irf*ca[j], irf*sa[j], zf]
        vi2 = [irf*ca[jn], irf*sa[jn], zf]
        vo1 = [orf*ca[j], orf*sa[j], zf]
        vo2 = [orf*ca[jn], orf*sa[jn], zf]
        data['vectors'][tri_idx] = [vi1, vi2, vo1]; tri_idx += 1
        data['vectors'][tri_idx] = [vi2, vo2, vo1]; tri_idx += 1
    
    # Trim unused entries
    return mesh.Mesh(data[:tri_idx])

print("Building main body...")
main_mesh = build_lathe(profile)
print(f"  {len(main_mesh.vectors)} triangles")
print(f"  Total length: {profile[-1][0] - profile[0][0]:.0f}mm")
print(f"  Lens center: ~{LENS_START + LENS_BORE_LEN/2:.0f}mm from sensor")

# ═══════════════════════════════════════════════════════
# XIAO / Display mount (flat pocket on the back)
# ═══════════════════════════════════════════════════════
def make_box(cx, cy, cz, w, h, d):
    hw, hh, hd = w/2, h/2, d/2
    verts = np.array([
        [cx-hw, cy-hh, cz-hd], [cx+hw, cy-hh, cz-hd],
        [cx+hw, cy+hh, cz-hd], [cx-hw, cy+hh, cz-hd],
        [cx-hw, cy-hh, cz+hd], [cx+hw, cy-hh, cz+hd],
        [cx+hw, cy+hh, cz+hd], [cx-hw, cy+hh, cz+hd],
    ])
    faces = np.array([
        [0,1,2],[0,2,3],[4,6,5],[4,7,6],
        [0,4,1],[1,4,5],[2,6,3],[3,6,7],
        [0,3,7],[0,7,4],[1,5,6],[1,6,2],
    ])
    data = np.zeros(len(faces), dtype=mesh.Mesh.dtype)
    for i, f in enumerate(faces):
        data['vectors'][i] = verts[f]
    return mesh.Mesh(data)

print("Building XIAO mount...")
xiao_mount = make_box(
    0, -(PEEP_SOCKET_OD/2 + 3),  # below the body
    -2,                          # center Z
    XIAO_W + 4, 10, 18            # w, h, d
)

print("Building lens carriage...")
# Lens carriage = simple tube with inner bore for lens
carriage_profile = [
    (0, LENS_DIA/2 - 0.1, LENS_BORE_ID/2 - 0.15),
    (10, LENS_DIA/2 - 0.1, LENS_BORE_ID/2 - 0.15),
]
carriage_mesh = build_lathe(carriage_profile)
print(f"  {len(carriage_mesh.vectors)} triangles")

# ═══════════════════════════════════════════════════════
# SAVE
# ═══════════════════════════════════════════════════════
out_dir = os.path.expanduser("~/eyemote-adapter/stl")
os.makedirs(out_dir, exist_ok=True)

# Combine main body + XIAO mount
combined = mesh.Mesh(np.concatenate([main_mesh.data, xiao_mount.data]))
path = os.path.join(out_dir, "ret-adapter-main-body.stl")
combined.save(path)
print(f"\nSaved: {path}")

path = os.path.join(out_dir, "ret-adapter-lens-carriage.stl")
carriage_mesh.save(path)
print(f"Saved: {path}")

print(f"""
═══ SUMMARY ═══
Body length: {profile[-1][0] - profile[0][0]:.0f}mm
Camera sensor to lens center: ~{LENS_START + LENS_BORE_LEN/2:.0f}mm (target 50mm)
Focus adjustment range: ±{LENS_BORE_LEN/2 - 6:.0f}mm from center
Peephole bore: {PEEP_ID}mm diameter (for {PEEP_ID}mm tube)
Lens bore: {LENS_BORE_ID:.0f}mm (for {LENS_DIA}mm lens)
Body end diameters: {PEEP_SOCKET_OD}mm → {LENS_BORE_OD:.0f}mm
""")
