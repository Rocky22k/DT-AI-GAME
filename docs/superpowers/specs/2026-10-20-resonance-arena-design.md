# Resonance Arena — Design Specification

## Overview
**Resonance Arena** is a fast-paced 3D top-down elemental spellcaster built in **Godot 4.6** for Year 12 Digital Technology (12DT). The game directly adapts the visual systems and math of the acclaimed **Codrops *Elemental Sandbox*** into real-time Godot 4.6 shaders, procedural geometry, and particle combat.

The player controls an elemental spellcaster in a dark crystalline arena, weaving between enemy swarms while using precision skillshot aiming (line-cast *Frost Fracture* and zone-cast *Voltaic Snare*) to survive escalating waves.

---

## 1. Camera & Player Controls

### 1.1 Camera Rig
- **Angle & Perspective:** Isometric / top-down perspective (~55° pitch down, FOV 60).
- **Tracking:** Follows player with smooth exponential dampening (`lerp`), incorporating a subtle look-ahead offset toward the mouse cursor (~15% bias) so players can see downrange while aiming.

### 1.2 Character Movement
- **WASD / Movement:** Instant-response directional movement with tight acceleration and deceleration (default speed: 7.5 m/s) using `CharacterBody3D`.
- **Facing Direction:** The character pivots smoothly to face the mouse cursor's projected hit position on the ground plane ($Y = 0$).
- **Phase Dash (Spacebar):**
  - Sudden burst of speed (18 m/s for 0.2s) in the direction of current movement.
  - Grants invulnerability frames (i-frames) during the dash.
  - Spawns a glowing particle ghost / trail.
  - Cooldown: 1.2 seconds with HUD indicator.

---

## 2. Signature Elemental Abilities & Targeting (Codrops System)

Both abilities use real-time ground-projected shader indicators inspired directly by the *Elemental Sandbox* targeting mechanics.

### 2.1 Aim Controller
- A continuous ground-plane raycast from the screen mouse coordinate to $Y = 0$.
- Determines cast origin, heading vector, and clamped cast distance.

### 2.2 Ability 1: Frost Fracture (Line Cast — Key Q / Left Click)
- **Targeting (Line SDF):**
  - Holding the cast button reveals a ground decal/quad with an SDF arrow shader.
  - The arrow shaft dynamically stretches between min range (3m) and max range (15m), maintaining consistent width and pulsing directional chevrons.
- **Execution:**
  - On release, a fracture wave races forward along the cast vector at 30 m/s.
  - Procedural crystalline ice spikes (`MeshInstance3D` with prismatic ice refraction/specular shader) erupt upward from the floor in an alternating, clustered pattern behind the shockwave.
  - **Combat Effect:** Enemies struck take high direct damage and are frozen in place for 1.5 seconds.
  - **Lifetime:** Crystals remain standing for 1.0s, glinting with rim light, then shatter into fading GPU particle shards.
  - Cooldown: 2.5 seconds.

### 2.3 Ability 2: Voltaic Snare (Far Cast / Zone AoE — Key E / Right Click)
- **Targeting (Zone SDF):**
  - Displays a circular targeting decal on the ground at the mouse hit point, clamped to a 14m radius from the caster.
  - Features an animated thick perimeter ring that overshoots slightly when armed ("snap" feel) and settles to a 4.0m radius circle.
- **Execution:**
  - Lightning strikes down into the target center from above.
  - An electrified vortex field ignites on the ground with crawling tendrils and violet arcs.
  - **Combat Effect:** Enemies within the zone are pulled inward toward the center, taking continuous electric damage and slowed movement. After 2.0s, the snare collapses and detonates in an outward shockwave.
  - Cooldown: 5.0 seconds.

---

## 3. Arena, Enemies, & Combat Loop

### 3.1 Arena Environment
- Circular obsidian amphitheater with subtle grid lines and an emissive outer boundary ring.
- Forward+ lighting with dynamic point lights cast by active abilities (ice glint light, violet lightning flash).
- Soft particle dust and floating embers in the atmosphere.

### 3.2 Enemy: "Crystalline Shardling"
- Stylized, aggressive geometric automatons (`CharacterBody3D`) with glowing central cores.
- **AI Behavior:**
  - Spawn in rings at the arena edge.
  - Continuously track and swarm toward the player.
  - Flank slightly to avoid clumped single-file conga lines.
- **Hit Reaction & Death:**
  - Flash white on hit.
  - Shatter on death into physically simulated shard debris with glowing dissolution.

### 3.3 Wave Progression & Game State
- **Wave 1:** 6 enemies, gentle introduction.
- **Wave 2:** 12 enemies, faster movement speed.
- **Wave 3:** 20 enemies with mixed rushers.
- **Game Loop States:**
  - `PLAYING`: Active wave combat.
  - `WAVE_CLEARED`: 2-second breather with wave banner before next wave.
  - `GAME_OVER`: Player defeated; score displayed with immediate restart option (`R` key).
  - `VICTORY`: All waves cleared.

---

## 4. Technical Architecture (Godot 4.6)

### 4.1 Project Configuration
- Engine: Godot 4.6 Forward+ (D3D12 / Vulkan Desktop).
- Viewport: 1920x1080 (resizable, keep aspect ratio).
- Physics: 3D Physics 60 Hz.

### 4.2 File & Scene Structure
```
DT AI GAME/
├── project.godot
├── scenes/
│   ├── main.tscn              # Root scene wiring arena, player, spawner, and HUD
│   ├── arena.tscn             # Environment, floor mesh, lights, world boundaries
│   ├── player.tscn            # Player CharacterBody3D, camera rig, aim indicator
│   ├── enemy.tscn             # Shardling CharacterBody3D with health & navigation
│   ├── vfx/
│   │   ├── frost_lance.tscn   # Spawns crystal spikes along the line
│   │   ├── frost_crystal.tscn # Individual procedural crystal mesh + light
│   │   ├── voltaic_snare.tscn # Area vortex, pull field, electric particles
│   │   ├── dash_ghost.tscn    # Player dash visual trail
│   │   └── shatter_debris.tscn# Enemy death physics fragments
│   └── ui/
│       └── hud.tscn           # Health bar, ability cooldown icons, wave tracker
├── scripts/
│   ├── main.gd                # Game coordinator (wave flow, state transitions)
│   ├── player.gd              # Movement, dash, aiming state machine
│   ├── enemy.gd               # Pathing, damage reception, death burst
│   ├── aim_indicator.gd       # Dynamic shader param updater for line/circle
│   ├── frost_lance.gd         # Eruption calculation and spike sequencing
│   ├── voltaic_snare.gd       # Pull physics and periodic damage
│   └── hud.gd                 # Health, cooldown timers, game over overlay
├── shaders/
│   ├── aim_line.gdshader      # SDF arrow with animated chevrons
│   ├── aim_circle.gdshader    # SDF ring with pulsing reticle
│   ├── ice_crystal.gdshader   # Stylized prismatic ice with rim glow
│   ├── electric_field.gdshader# Animated noise-driven lightning disc
│   └── arena_floor.gdshader   # Dark reflective obsidian with reactive grid
└── docs/
    └── superpowers/specs/
        └── 2026-10-20-resonance-arena-design.md
```

### 4.3 Key Design Boundaries & Isolation
- **Abilities as decoupled nodes:** Spells instantiate independent scene instances in the world root so they continue their lifecycle even if the player dashes or changes orientation.
- **Aim indicators decoupled from cast logic:** The `aim_indicator` only computes and displays preview visuals on the ground; on fire, it hands off standard `(origin, direction, distance)` parameters to the ability spawner.
- **Shader-driven visuals:** Ground previews, ice reflections, and electric field rings run entirely in GPU shaders to keep CPU overhead negligible.

---

## 5. Verification & Testing Strategy
1. **Movement & Camera:** Verify WASD responsiveness, mouse facing rotation, and dash invulnerability in an empty arena.
2. **Aim Indicators:** Verify line arrow and circle decal accurately project onto the ground without clipping or distorting.
3. **Frost Fracture:** Verify crystal eruption sequence, collision boxes, and freeze duration on test enemies.
4. **Voltaic Snare:** Verify inward pull force vector and area damage tick rate.
5. **Wave Loop:** Verify enemy spawn timing, wave progression, game over on player health depletion, and clean restart with `R`.
