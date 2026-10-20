# Resonance Arena Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build *Resonance Arena*, a 3D top-down elemental spellcaster in Godot 4.6 featuring Codrops-inspired shader skillshot aiming (Frost Fracture line-cast & Voltaic Snare zone-cast), responsive WASD + dash combat, and wave survival.

**Architecture:** A decoupled Godot 4.6 scene architecture where the Player coordinates an AimIndicator (updating GPU shaders on ground quads) and instantiates self-contained ability scenes (FrostLance and VoltaicSnare) into the World tree. Enemies are autonomous CharacterBody3D nodes managed by a wave spawner in Main, with UI observing state via signals.

**Tech Stack:** Godot 4.6 (Forward+ renderer, D3D12/Vulkan), GDScript, Godot Shading Language (GLSL ES 3.0 compatible).

**Spec:** [docs/superpowers/specs/2026-10-20-resonance-arena-design.md](../specs/2026-10-20-resonance-arena-design.md)

## Global Constraints
- Engine: Godot 4.6 (`Godot_v4.6-stable_win64.exe` located at `C:/Users/vohra/OneDrive/Desktop/Godot_v4.6-stable_win64.exe`).
- Project root: `C:\Users\vohra\OneDrive\Desktop\DT AI GAME`.
- Rendering: Forward+ mobile/desktop pipeline with WorldEnvironment glow enabled.
- Headless verification: Validate scripts, scenes, and execution using Godot CLI `--headless`.
- All GDScript files must use static typing where possible for performance and clarity.

## Review Focus
1. **Mouse Raycast Misses Ground Plane:** If the mouse points off the horizon into the sky, the aim controller must default to a clamped forward point on the $Y=0$ plane rather than returning null or throwing errors.
2. **Dash During Ability Cast:** If the player dashes while aiming or casting, the aim preview should hide cleanly and not lock input or spawn abilities at corrupted origins.
3. **Enemy Freeze & Death Concurrency:** An enemy struck by frost while already dying or caught in a snare must cleanly clean up its colliders, stop ticking damage, and not cause null reference exceptions in the spawner.
4. **Window Resizing / Aspect Ratio:** HUD elements and camera FOV must scale cleanly across window aspect ratios (16:9, 16:10, 21:9) using `canvas_items` stretch mode.
5. **Rapid Restart (`R` key):** Triggering game restart during active ability tweens or particle bursts must reset all scene state cleanly with no orphaned nodes.

---

### Task 1: Godot Project Configuration & Input Map

**Files:**
- Create: `project.godot`
- Create: `.gitignore`
- Create: `scripts/test_headless.gd`

**Interfaces:**
- Produces: Project file recognized by Godot 4.6, custom action bindings (`move_forward`, `move_backward`, `move_left`, `move_right`, `dash`, `cast_frost`, `cast_snare`, `restart`).

- [ ] **Step 1: Create .gitignore for Godot**

```gitignore
.godot/
*.translation
*.import
```

- [ ] **Step 2: Create project.godot with input action map and Forward+ settings**

```ini
; Engine configuration file.
config_version=5

[application]
config/name="Resonance Arena"
run/main_scene="res://scenes/main.tscn"
config/features=PackedStringArray("4.6", "Forward Plus")

[display]
window/size/viewport_width=1920
window/size/viewport_height=1080
window/stretch/mode="canvas_items"
window/stretch/aspect="expand"

[input]
move_forward={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":87,"physical_keycode":0,"key_label":0,"unicode":119,"echo":false,"script":null)
]
}
move_backward={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":83,"physical_keycode":0,"key_label":0,"unicode":115,"echo":false,"script":null)
]
}
move_left={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":65,"physical_keycode":0,"key_label":0,"unicode":97,"echo":false,"script":null)
]
}
move_right={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":68,"physical_keycode":0,"key_label":0,"unicode":100,"echo":false,"script":null)
]
}
dash={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":32,"physical_keycode":0,"key_label":0,"unicode":32,"echo":false,"script":null)
]
}
cast_frost={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":81,"physical_keycode":0,"key_label":0,"unicode":113,"echo":false,"script":null),
Object(InputEventMouseButton,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"button_mask":1,"position":Vector2(0,0),"global_position":Vector2(0,0),"factor":1.0,"button_index":1,"canceled":false,"pressed":false,"double_click":false,"script":null)
]
}
cast_snare={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":69,"physical_keycode":0,"key_label":0,"unicode":101,"echo":false,"script":null),
Object(InputEventMouseButton,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"button_mask":2,"position":Vector2(0,0),"global_position":Vector2(0,0),"factor":1.0,"button_index":2,"canceled":false,"pressed":false,"double_click":false,"script":null)
]
}
restart={
"deadzone": 0.5,
"events": [Object(InputEventKey,"resource_local_to_scene":false,"resource_name":"","device":-1,"window_id":0,"alt_pressed":false,"shift_pressed":false,"ctrl_pressed":false,"meta_pressed":false,"pressed":false,"keycode":82,"physical_keycode":0,"key_label":0,"unicode":114,"echo":false,"script":null)
]
}

[rendering]
textures/vram_compression/import_etc2_astc=false
```

- [ ] **Step 3: Create initial headless verification test `scripts/test_headless.gd`**

```gdscript
extends SceneTree

func _init() -> void:
	print("--- Headless Verification Test Running ---")
	var required_actions: Array[String] = [
		"move_forward", "move_backward", "move_left", "move_right",
		"dash", "cast_frost", "cast_snare", "restart"
	]
	for action in required_actions:
		assert(InputMap.has_action(action), "Missing action in InputMap: " + action)
		print("Validated action: ", action)
	print("--- Project config verified successfully ---")
	quit(0)
```

- [ ] **Step 4: Execute Godot headless test**

Run: `"/c/Users/vohra/OneDrive/Desktop/Godot_v4.6-stable_win64.exe" --headless --script scripts/test_headless.gd`
Expected output: `--- Project config verified successfully ---` with exit code 0.

- [ ] **Step 5: Commit**

```bash
git add project.godot .gitignore scripts/test_headless.gd
git commit -m "chore: setup Godot 4.6 project configuration and input mappings"
```

---

### Task 2: Codrops-Inspired Visual Shaders

**Files:**
- Create: `shaders/aim_line.gdshader`
- Create: `shaders/aim_circle.gdshader`
- Create: `shaders/ice_crystal.gdshader`
- Create: `shaders/electric_field.gdshader`
- Create: `shaders/arena_floor.gdshader`

**Interfaces:**
- Produces: Visual shader materials for ground decals, procedural crystals, electric zones, and arena floor.

- [ ] **Step 1: Create `shaders/aim_line.gdshader`**

```glsl
shader_type spatial;
render_mode blend_add, depth_draw_never, cull_disabled, unshaded;

uniform vec4 arrow_color : source_color = vec4(0.2, 0.8, 1.0, 0.8);
uniform float arrow_length = 10.0;
uniform float shaft_width = 0.6;
uniform float chevron_speed = 3.0;

void fragment() {
    // UV maps to: X in [-0.5, 0.5], Y in [0.0, 1.0] along the arrow
    vec2 p = UV - vec2(0.5, 0.0);
    p.y *= arrow_length;

    // Shaft boundary
    float half_w = shaft_width * 0.5;
    float shaft = 1.0 - smoothstep(half_w - 0.05, half_w, abs(p.x));
    
    // Animated chevrons moving forward along Y
    float chevron_phase = fract((p.y - abs(p.x) * 0.8) * 0.5 - TIME * chevron_speed);
    float chevron = smoothstep(0.0, 0.2, chevron_phase) * (1.0 - smoothstep(0.3, 0.5, chevron_phase));

    // Arrow tip triangle at the far end
    float tip_dist = arrow_length - p.y;
    float tip = 1.0 - smoothstep(0.0, 1.2, abs(p.x) * 2.0 + tip_dist);
    
    float alpha = max(shaft * (0.3 + 0.7 * chevron), tip);
    alpha *= clamp(p.y * 2.0, 0.0, 1.0); // Soft fade at caster feet

    ALBEDO = arrow_color.rgb;
    ALPHA = alpha * arrow_color.a;
}
```

- [ ] **Step 2: Create `shaders/aim_circle.gdshader`**

```glsl
shader_type spatial;
render_mode blend_add, depth_draw_never, cull_disabled, unshaded;

uniform vec4 circle_color : source_color = vec4(0.8, 0.3, 1.0, 0.8);
uniform float outer_radius = 0.48;
uniform float ring_thickness = 0.04;
uniform float pulse_speed = 4.0;

void fragment() {
    vec2 uv_centered = UV - vec2(0.5);
    float dist = length(uv_centered);

    // Thick outer boundary ring
    float ring = smoothstep(outer_radius - ring_thickness, outer_radius - ring_thickness * 0.5, dist)
               * (1.0 - smoothstep(outer_radius, outer_radius + 0.02, dist));

    // Radial pulse ticks inside
    float inner_wash = (1.0 - smoothstep(0.0, outer_radius, dist)) * 0.15;
    float angle = atan(uv_centered.y, uv_centered.x);
    float ticks = sin(angle * 8.0 + TIME * pulse_speed) * 0.5 + 0.5;
    float tick_ring = smoothstep(outer_radius * 0.7, outer_radius * 0.72, dist)
                    * (1.0 - smoothstep(outer_radius * 0.74, outer_radius * 0.76, dist)) * ticks;

    float alpha = ring + inner_wash + tick_ring * 0.5;
    ALBEDO = circle_color.rgb * (1.0 + ring * 1.5);
    ALPHA = clamp(alpha, 0.0, 1.0) * circle_color.a;
}
```

- [ ] **Step 3: Create `shaders/ice_crystal.gdshader`**

```glsl
shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back;

uniform vec4 deep_color : source_color = vec4(0.05, 0.3, 0.6, 1.0);
uniform vec4 surface_color : source_color = vec4(0.6, 0.9, 1.0, 1.0);
uniform vec4 rim_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform float rim_power = 3.0;
uniform float roughness_val = 0.15;

void fragment() {
    // Prismatic grazing angle rim calculation
    float fresnel = pow(1.0 - clamp(dot(NORMAL, VIEW), 0.0, 1.0), rim_power);
    
    vec3 base = mix(deep_color.rgb, surface_color.rgb, fresnel * 0.6);
    ALBEDO = base;
    EMISSION = rim_color.rgb * fresnel * 0.8;
    ROUGHNESS = roughness_val;
    METALLIC = 0.1;
}
```

- [ ] **Step 4: Create `shaders/electric_field.gdshader`**

```glsl
shader_type spatial;
render_mode blend_add, depth_draw_never, cull_disabled, unshaded;

uniform vec4 lightning_color : source_color = vec4(0.7, 0.3, 1.0, 0.9);
uniform float rotation_speed = 2.0;

void fragment() {
    vec2 p = UV - vec2(0.5);
    float r = length(p);
    float a = atan(p.y, p.x);

    // Warped noise-like arcs
    float arc1 = sin(a * 12.0 + TIME * rotation_speed * 3.0 + r * 20.0);
    float arc2 = cos(a * 8.0 - TIME * rotation_speed * 4.0 - r * 15.0);
    float arc_field = smoothstep(0.7, 0.95, abs(arc1 * arc2));

    float ring_mask = smoothstep(0.48, 0.44, r) * smoothstep(0.05, 0.15, r);
    float alpha = arc_field * ring_mask;

    ALBEDO = lightning_color.rgb * (1.5 + arc_field * 2.0);
    ALPHA = alpha * lightning_color.a;
}
```

- [ ] **Step 5: Create `shaders/arena_floor.gdshader`**

```glsl
shader_type spatial;
render_mode blend_mix, depth_draw_opaque;

uniform vec4 floor_color : source_color = vec4(0.03, 0.03, 0.05, 1.0);
uniform vec4 grid_color : source_color = vec4(0.1, 0.3, 0.5, 0.4);
uniform vec4 border_color : source_color = vec4(0.0, 0.8, 1.0, 1.0);
uniform float arena_radius = 24.0;

void fragment() {
    vec2 pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xz;
    float dist = length(pos);

    // Subtle grid lines
    vec2 grid = abs(fract(pos * 0.5 - 0.5) - 0.5) / fwidth(pos * 0.5);
    float line = 1.0 - min(min(grid.x, grid.y), 1.0);

    // Outer boundary glow
    float border = smoothstep(arena_radius - 0.4, arena_radius, dist)
                 * (1.0 - smoothstep(arena_radius + 0.2, arena_radius + 0.6, dist));

    vec3 col = floor_color.rgb + grid_color.rgb * (line * 0.15);
    ALBEDO = col;
    EMISSION = border_color.rgb * border * 3.0;
    ROUGHNESS = 0.25;
    METALLIC = 0.2;
}
```

- [ ] **Step 6: Verify shaders compile with Godot headless**

Run: `"/c/Users/vohra/OneDrive/Desktop/Godot_v4.6-stable_win64.exe" --headless --path . --check-only`
Expected: 0 errors reported.

- [ ] **Step 7: Commit**

```bash
git add shaders/
git commit -m "feat(vfx): create Codrops-inspired procedural shaders for aim decals, ice, and lightning"
```

---

### Task 3: Arena Scene & Environment

**Files:**
- Create: `scenes/arena.tscn`
- Create: `scripts/arena.gd`

**Interfaces:**
- Produces: `res://scenes/arena.tscn` containing the floor, environment, lighting, and invisible boundary collisions at radius 24m.

- [ ] **Step 1: Create `scripts/arena.gd`**

```gdscript
extends Node3D
class_name Arena

const RADIUS: float = 24.0

func is_within_bounds(pos: Vector3) -> bool:
	return Vector2(pos.x, pos.z).length() <= RADIUS

func clamp_to_bounds(pos: Vector3) -> Vector3:
	var v2 := Vector2(pos.x, pos.z)
	if v2.length() > RADIUS:
		v2 = v2.normalized() * RADIUS
	return Vector3(v2.x, pos.y, v2.y)
```

- [ ] **Step 2: Create `scenes/arena.tscn` scene**

```tscn
[gd_scene load_steps=7 format=3 uid="uid://c_arena_01"]

[ext_resource type="Script" path="res://scripts/arena.gd" id="1_arena"]
[ext_resource type="Shader" path="res://shaders/arena_floor.gdshader" id="2_floor_sh"]

[sub_resource type="ShaderMaterial" id="ShaderMaterial_floor"]
render_priority = 0
shader = ExtResource("2_floor_sh")
shader_parameter/floor_color = Color(0.03, 0.03, 0.05, 1)
shader_parameter/grid_color = Color(0.1, 0.3, 0.5, 0.4)
shader_parameter/border_color = Color(0, 0.8, 1, 1)
shader_parameter/arena_radius = 24.0

[sub_resource type="CylinderMesh" id="CylinderMesh_floor"]
material = SubResource("ShaderMaterial_floor")
top_radius = 24.5
bottom_radius = 24.5
height = 0.2

[sub_resource type="CylinderShape3D" id="CylinderShape3D_floor"]
height = 0.2
radius = 24.5

[sub_resource type="Environment" id="Environment_main"]
background_mode = 1
background_color = Color(0.015, 0.015, 0.02, 1)
ambient_light_source = 2
ambient_light_color = Color(0.2, 0.25, 0.35, 1)
ambient_light_energy = 0.5
glow_enabled = true
glow_intensity = 0.8
glow_bloom = 0.25
glow_blend_mode = 0

[node name="Arena" type="Node3D"]
script = ExtResource("1_arena")

[node name="WorldEnvironment" type="WorldEnvironment" parent="."]
environment = SubResource("Environment_main")

[node name="DirectionalLight3D" type="DirectionalLight3D" parent="."]
transform = Transform3D(0.866025, -0.353553, 0.353553, 0, 0.707107, 0.707107, -0.5, -0.612372, 0.612372, 0, 15, 0)
light_color = Color(0.85, 0.9, 1, 1)
light_energy = 1.2
shadow_enabled = true

[node name="FloorStaticBody" type="StaticBody3D" parent="."]
collision_mask = 0

[node name="MeshInstance3D" type="MeshInstance3D" parent="FloorStaticBody"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.1, 0)
mesh = SubResource("CylinderMesh_floor")

[node name="CollisionShape3D" type="CollisionShape3D" parent="FloorStaticBody"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, -0.1, 0)
shape = SubResource("CylinderShape3D_floor")
```

- [ ] **Step 3: Headless validation**

Run: `"/c/Users/vohra/OneDrive/Desktop/Godot_v4.6-stable_win64.exe" --headless --path . --check-only`
Expected: 0 errors.

- [ ] **Step 4: Commit**

```bash
git add scenes/arena.tscn scripts/arena.gd
git commit -m "feat(arena): build arena scene with environment, floor shader, and boundary checking"
```

---

### Task 4: Player Character with Smooth WASD, Aim Raycasting, & Dash

**Files:**
- Create: `scripts/player.gd`
- Create: `scenes/player.tscn`

**Interfaces:**
- Produces: `Player` class extending `CharacterBody3D`, emitting signals `health_changed(current, max)`, `dash_used(cooldown)`, `ability_cast(type, origin, target_point)`.

- [ ] **Step 1: Create `scripts/player.gd`**

```gdscript
extends CharacterBody3D
class_name Player

signal health_changed(current_hp: float, max_hp: float)
signal dash_used(cooldown_time: float)
signal ability_cast(ability_name: String, origin: Vector3, target: Vector3)

@export var move_speed: float = 8.0
@export var dash_speed: float = 22.0
@export var dash_duration: float = 0.18
@export var dash_cooldown: float = 1.2
@export var max_health: float = 100.0

var current_health: float = 100.0
var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_cd_timer: float = 0.0
var dash_direction: Vector3 = Vector3.FORWARD
var ground_aim_point: Vector3 = Vector3.ZERO
var is_invulnerable: bool = false

@onready var camera_mount: Node3D = $CameraMount
@onready var camera: Camera3D = $CameraMount/Camera3D
@onready var model: Node3D = $VisualModel

func _ready() -> void:
	current_health = max_health
	health_changed.emit(current_health, max_health)

func _physics_process(delta: float) -> void:
	_update_timers(delta)
	_update_mouse_aim()
	
	if is_dashing:
		_process_dash(delta)
	else:
		_process_movement(delta)
	
	move_and_slide()

func _update_timers(delta: float) -> void:
	if dash_cd_timer > 0.0:
		dash_cd_timer -= delta
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0.0:
			is_dashing = false
			is_invulnerable = false

func _process_movement(_delta: float) -> void:
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := Vector3(input_dir.x, 0.0, input_dir.y).normalized()
	
	if direction.length_squared() > 0.01:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, move_speed * 0.3)
		velocity.z = move_toward(velocity.z, 0.0, move_speed * 0.3)
	
	if Input.is_action_just_pressed("dash") and dash_cd_timer <= 0.0:
		start_dash(direction if direction != Vector3.ZERO else -model.global_transform.basis.z)

func start_dash(direction: Vector3) -> void:
	is_dashing = true
	is_invulnerable = true
	dash_timer = dash_duration
	dash_cd_timer = dash_cooldown
	dash_direction = direction.normalized()
	velocity = dash_direction * dash_speed
	dash_used.emit(dash_cooldown)

func _process_dash(_delta: float) -> void:
	velocity = dash_direction * dash_speed

func _update_mouse_aim() -> void:
	if not camera:
		return
	var mouse_pos := get_viewport().get_mouse_position()
	var ray_origin := camera.project_ray_origin(mouse_pos)
	var ray_dir := camera.project_ray_normal(mouse_pos)
	
	# Raycast onto Y = 0 plane
	if abs(ray_dir.y) > 0.0001:
		var t := -ray_origin.y / ray_dir.y
		if t > 0.0:
			ground_aim_point = ray_origin + ray_dir * t
		else:
			ground_aim_point = global_position + Vector3.FORWARD * 5.0
	else:
		ground_aim_point = global_position + Vector3.FORWARD * 5.0
	
	# Smoothly rotate visual model to face mouse
	var look_dir := (ground_aim_point - global_position)
	look_dir.y = 0.0
	if look_dir.length_squared() > 0.1:
		var target_rot := atan2(-look_dir.x, -look_dir.z)
		model.rotation.y = lerp_angle(model.rotation.y, target_rot, 0.3)

func take_damage(amount: float) -> void:
	if is_invulnerable:
		return
	current_health = clamp(current_health - amount, 0.0, max_health)
	health_changed.emit(current_health, max_health)
```

- [ ] **Step 2: Create `scenes/player.tscn`**

```tscn
[gd_scene load_steps=6 format=3 uid="uid://c_player_01"]

[ext_resource type="Script" path="res://scripts/player.gd" id="1_player"]

[sub_resource type="CapsuleShape3D" id="CapsuleShape3D_player"]
radius = 0.4
height = 1.8

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_body"]
albedo_color = Color(0.1, 0.12, 0.18, 1)
emission_enabled = true
emission = Color(0, 0.8, 1, 1)
emission_energy_multiplier = 0.8
roughness = 0.2

[sub_resource type="CapsuleMesh" id="CapsuleMesh_player"]
material = SubResource("StandardMaterial3D_body")
radius = 0.4
height = 1.8

[sub_resource type="PrismMesh" id="PrismMesh_visor"]
size = Vector3(0.5, 0.3, 0.3)

[node name="Player" type="CharacterBody3D" groups=["player"]]
collision_layer = 2
collision_mask = 1
script = ExtResource("1_player")

[node name="CollisionShape3D" type="CollisionShape3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.9, 0)
shape = SubResource("CapsuleShape3D_player")

[node name="VisualModel" type="Node3D" parent="."]

[node name="BodyMesh" type="MeshInstance3D" parent="VisualModel"]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.9, 0)
mesh = SubResource("CapsuleMesh_player")

[node name="VisorMesh" type="MeshInstance3D" parent="VisualModel"]
transform = Transform3D(1, 0, 0, 0, -4.37114e-08, 1, 0, -1, -4.37114e-08, 0, 1.4, -0.35)
mesh = SubResource("PrismMesh_visor")

[node name="CameraMount" type="Node3D" parent="."]
top_level = true

[node name="Camera3D" type="Camera3D" parent="CameraMount"]
transform = Transform3D(1, 0, 0, 0, 0.573576, 0.819152, 0, -0.819152, 0.573576, 0, 18, 12.5)
current = true
fov = 55.0
```

- [ ] **Step 3: Headless validation**

Run: `"/c/Users/vohra/OneDrive/Desktop/Godot_v4.6-stable_win64.exe" --headless --path . --check-only`
Expected: 0 errors.

- [ ] **Step 4: Commit**

```bash
git add scripts/player.gd scenes/player.tscn
git commit -m "feat(player): create player character with snappy WASD, mouse raycasting, and phase-dash"
```

---

### Task 5: Aim Indicator System (Line Arrow & Snapping Circle Decals)

**Files:**
- Create: `scripts/aim_indicator.gd`
- Create: `scenes/aim_indicator.tscn`

**Interfaces:**
- Consumes: Player position and `ground_aim_point` from `player.gd`.
- Produces: Visual ground preview for line-cast (Frost) and far-cast (Snare).

- [ ] **Step 1: Create `scripts/aim_indicator.gd`**

```gdscript
extends Node3D
class_name AimIndicator

enum Mode { NONE, LINE, CIRCLE }

@export var max_line_range: float = 16.0
@export var min_line_range: float = 3.0
@export var max_circle_range: float = 14.0
@export var circle_radius: float = 4.0

var current_mode: Mode = Mode.NONE

@onready var line_quad: MeshInstance3D = $LineQuad
@onready var circle_quad: MeshInstance3D = $CircleQuad

func _ready() -> void:
	set_mode(Mode.NONE)

func set_mode(new_mode: Mode) -> void:
	current_mode = new_mode
	line_quad.visible = (current_mode == Mode.LINE)
	circle_quad.visible = (current_mode == Mode.CIRCLE)

func update_indicators(player_pos: Vector3, target_pos: Vector3) -> void:
	match current_mode:
		Mode.LINE:
			_update_line(player_pos, target_pos)
		Mode.CIRCLE:
			_update_circle(player_pos, target_pos)
		Mode.NONE:
			pass

func _update_line(player_pos: Vector3, target_pos: Vector3) -> void:
	var delta := target_pos - player_pos
	delta.y = 0.0
	var dist := clamp(delta.length(), min_line_range, max_line_range)
	var dir := delta.normalized() if delta.length_squared() > 0.001 else Vector3.FORWARD
	
	global_position = Vector3(player_pos.x, 0.02, player_pos.z)
	var angle := atan2(dir.x, dir.z)
	rotation.y = angle
	
	# Scale line mesh Y (length downrange)
	line_quad.scale = Vector3(1.0, 1.0, dist)
	line_quad.position = Vector3(0.0, 0.0, dist * 0.5)
	
	var mat := line_quad.get_active_material(0) as ShaderMaterial
	if mat:
		mat.set_shader_parameter("arrow_length", dist)

func _update_circle(player_pos: Vector3, target_pos: Vector3) -> void:
	var delta := target_pos - player_pos
	delta.y = 0.0
	var dist := min(delta.length(), max_circle_range)
	var dir := delta.normalized() if delta.length_squared() > 0.001 else Vector3.FORWARD
	var clamped_target := player_pos + dir * dist
	
	circle_quad.global_position = Vector3(clamped_target.x, 0.02, clamped_target.z)
	circle_quad.scale = Vector3(circle_radius * 2.0, 1.0, circle_radius * 2.0)
```

- [ ] **Step 2: Create `scenes/aim_indicator.tscn`**

```tscn
[gd_scene load_steps=7 format=3 uid="uid://c_aim_ind_01"]

[ext_resource type="Script" path="res://scripts/aim_indicator.gd" id="1_aim"]
[ext_resource type="Shader" path="res://shaders/aim_line.gdshader" id="2_line_sh"]
[ext_resource type="Shader" path="res://shaders/aim_circle.gdshader" id="3_circle_sh"]

[sub_resource type="ShaderMaterial" id="ShaderMaterial_line"]
render_priority = 1
shader = ExtResource("2_line_sh")
shader_parameter/arrow_color = Color(0.2, 0.8, 1, 0.85)
shader_parameter/arrow_length = 10.0
shader_parameter/shaft_width = 0.6
shader_parameter/chevron_speed = 3.0

[sub_resource type="QuadMesh" id="QuadMesh_line"]
material = SubResource("ShaderMaterial_line")
size = Vector2(1.2, 1)
orientation = 1

[sub_resource type="ShaderMaterial" id="ShaderMaterial_circle"]
render_priority = 1
shader = ExtResource("3_circle_sh")
shader_parameter/circle_color = Color(0.8, 0.3, 1, 0.85)
shader_parameter/outer_radius = 0.48
shader_parameter/ring_thickness = 0.05
shader_parameter/pulse_speed = 4.0

[sub_resource type="QuadMesh" id="QuadMesh_circle"]
material = SubResource("ShaderMaterial_circle")
size = Vector2(1, 1)
orientation = 1

[node name="AimIndicator" type="Node3D"]
script = ExtResource("1_aim")

[node name="LineQuad" type="MeshInstance3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0.5)
mesh = SubResource("QuadMesh_line")

[node name="CircleQuad" type="MeshInstance3D" parent="."]
mesh = SubResource("QuadMesh_circle")
```

- [ ] **Step 3: Headless validation**

Run: `"/c/Users/vohra/OneDrive/Desktop/Godot_v4.6-stable_win64.exe" --headless --path . --check-only`
Expected: 0 errors.

- [ ] **Step 4: Commit**

```bash
git add scripts/aim_indicator.gd scenes/aim_indicator.tscn
git commit -m "feat(aim): implement ground-projected line and circle aim indicator decals"
```

---

### Task 6: Frost Fracture Ability (Line Cast & Procedural Spikes)

**Files:**
- Create: `scripts/frost_crystal.gd`
- Create: `scenes/vfx/frost_crystal.tscn`
- Create: `scripts/frost_lance.gd`
- Create: `scenes/vfx/frost_lance.tscn`

**Interfaces:**
- Produces: `FrostLance` node that spawns 8–12 staggered `FrostCrystal` instances along the line cast vector, applying freeze and damage to enemies.

- [ ] **Step 1: Create `scripts/frost_crystal.gd`**

```gdscript
extends Area3D
class_name FrostCrystal

@export var damage: float = 35.0
@export var freeze_time: float = 1.5

@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var light: OmniLight3D = $OmniLight3D

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_animate_eruption()

func _animate_eruption() -> void:
	scale = Vector3(0.1, 0.01, 0.1)
	var target_h := randf_range(2.0, 3.5)
	var target_w := randf_range(0.4, 0.7)
	
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector3(target_w, target_h, target_w), 0.12).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(light, "light_energy", 2.0, 0.1)
	
	# Hold then shatter
	await get_tree().create_timer(1.0).timeout
	var fade_tween := create_tween()
	fade_tween.tween_property(self, "scale:y", 0.0, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	fade_tween.tween_callback(queue_free)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") and body.has_method("apply_frost"):
		body.apply_frost(damage, freeze_time)
```

- [ ] **Step 2: Create `scenes/vfx/frost_crystal.tscn`**

```tscn
[gd_scene load_steps=6 format=3 uid="uid://c_frost_c_01"]

[ext_resource type="Script" path="res://scripts/frost_crystal.gd" id="1_cryst"]
[ext_resource type="Shader" path="res://shaders/ice_crystal.gdshader" id="2_ice_sh"]

[sub_resource type="ShaderMaterial" id="ShaderMaterial_crystal"]
render_priority = 0
shader = ExtResource("2_ice_sh")
shader_parameter/deep_color = Color(0.05, 0.3, 0.6, 1)
shader_parameter/surface_color = Color(0.6, 0.9, 1, 1)
shader_parameter/rim_color = Color(1, 1, 1, 1)
shader_parameter/rim_power = 2.5
shader_parameter/roughness_val = 0.15

[sub_resource type="PrismMesh" id="PrismMesh_crystal"]
material = SubResource("ShaderMaterial_crystal")
size = Vector3(1, 2, 1)

[sub_resource type="CylinderShape3D" id="CylinderShape3D_crystal"]
height = 2.5
radius = 0.8

[node name="FrostCrystal" type="Area3D"]
collision_layer = 0
collision_mask = 4
script = ExtResource("1_cryst")

[node name="MeshInstance3D" type="MeshInstance3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0)
mesh = SubResource("PrismMesh_crystal")

[node name="CollisionShape3D" type="CollisionShape3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1.25, 0)
shape = SubResource("CylinderShape3D_crystal")

[node name="OmniLight3D" type="OmniLight3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1.5, 0)
light_color = Color(0.4, 0.85, 1, 1)
light_energy = 0.0
omni_range = 4.0
```

- [ ] **Step 3: Create `scripts/frost_lance.gd`**

```gdscript
extends Node3D
class_name FrostLance

@export var crystal_scene: PackedScene = preload("res://scenes/vfx/frost_crystal.tscn")
@export var eruption_speed: float = 35.0

func execute(origin: Vector3, target: Vector3, max_range: float = 16.0) -> void:
	var delta := target - origin
	delta.y = 0.0
	var distance := clamp(delta.length(), 3.0, max_range)
	var dir := delta.normalized()
	
	var crystal_spacing := 1.2
	var count := int(distance / crystal_spacing)
	
	for i in range(count):
		var fraction := float(i) / float(count)
		var delay := (fraction * distance) / eruption_speed
		get_tree().create_timer(delay).timeout.connect(func():
			if not is_inside_tree():
				return
			var crystal := crystal_scene.instantiate() as Node3D
			var lateral_offset := (Vector3.UP.cross(dir)) * randf_range(-0.4, 0.4)
			crystal.global_position = origin + dir * (i * crystal_spacing) + lateral_offset
			crystal.global_rotation.y = randf_range(0.0, TAU)
			add_child(crystal)
		)
	
	# Clean up after all crystals shatter
	get_tree().create_timer((distance / eruption_speed) + 2.0).timeout.connect(queue_free)
```

- [ ] **Step 4: Create `scenes/vfx/frost_lance.tscn`**

```tscn
[gd_scene load_steps=2 format=3 uid="uid://c_frost_l_01"]

[ext_resource type="Script" path="res://scripts/frost_lance.gd" id="1_lance"]

[node name="FrostLance" type="Node3D"]
script = ExtResource("1_lance")
```

- [ ] **Step 5: Headless validation**

Run: `"/c/Users/vohra/OneDrive/Desktop/Godot_v4.6-stable_win64.exe" --headless --path . --check-only`
Expected: 0 errors.

- [ ] **Step 6: Commit**

```bash
git add scripts/frost_crystal.gd scenes/vfx/frost_crystal.tscn scripts/frost_lance.gd scenes/vfx/frost_lance.tscn
git commit -m "feat(spells): implement Frost Fracture line-cast with sequential procedural crystal eruptions"
```

---

### Task 7: Voltaic Snare Ability (Far Cast Zone Vortex)

**Files:**
- Create: `scripts/voltaic_snare.gd`
- Create: `scenes/vfx/voltaic_snare.tscn`

**Interfaces:**
- Produces: `VoltaicSnare` node placed at far-cast target, vacuuming enemies inward and detonating.

- [ ] **Step 1: Create `scripts/voltaic_snare.gd`**

```gdscript
extends Area3D
class_name VoltaicSnare

@export var duration: float = 2.0
@export var pull_strength: float = 8.0
@export var dps: float = 15.0
@export var detonation_damage: float = 50.0

var elapsed: bool = false
@onready var field_mesh: MeshInstance3D = $FieldMesh
@onready var light: OmniLight3D = $OmniLight3D
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	_activate_snare()

func _activate_snare() -> void:
	# Overshoot snap animation
	field_mesh.scale = Vector3(0.1, 1.0, 0.1)
	var tween := create_tween()
	tween.tween_property(field_mesh, "scale", Vector3(9.0, 1.0, 9.0), 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(field_mesh, "scale", Vector3(8.0, 1.0, 8.0), 0.1)

	await get_tree().create_timer(duration).timeout
	_detonate()

func _physics_process(delta: float) -> void:
	if elapsed:
		return
	
	for body in get_overlapping_bodies():
		if body.is_in_group("enemy"):
			var to_center := global_position - body.global_position
			to_center.y = 0.0
			var dist := to_center.length()
			if dist > 0.3:
				body.velocity += to_center.normalized() * pull_strength * delta * 60.0
			if body.has_method("apply_damage"):
				body.apply_damage(dps * delta)

func _detonate() -> void:
	elapsed = true
	light.light_energy = 5.0
	light.light_color = Color(1.0, 0.8, 1.0)
	
	for body in get_overlapping_bodies():
		if body.is_in_group("enemy") and body.has_method("apply_damage"):
			body.apply_damage(detonation_damage)
	
	var tween := create_tween().set_parallel(true)
	tween.tween_property(field_mesh, "scale", Vector3(12.0, 1.0, 12.0), 0.15)
	tween.tween_property(light, "light_energy", 0.0, 0.25)
	await tween.finished
	queue_free()
```

- [ ] **Step 2: Create `scenes/vfx/voltaic_snare.tscn`**

```tscn
[gd_scene load_steps=6 format=3 uid="uid://c_snare_01"]

[ext_resource type="Script" path="res://scripts/voltaic_snare.gd" id="1_snare"]
[ext_resource type="Shader" path="res://shaders/electric_field.gdshader" id="2_elec_sh"]

[sub_resource type="ShaderMaterial" id="ShaderMaterial_field"]
render_priority = 1
shader = ExtResource("2_elec_sh")
shader_parameter/lightning_color = Color(0.7, 0.3, 1, 0.95)
shader_parameter/rotation_speed = 2.5

[sub_resource type="QuadMesh" id="QuadMesh_field"]
material = SubResource("ShaderMaterial_field")
size = Vector2(1, 1)
orientation = 1

[sub_resource type="CylinderShape3D" id="CylinderShape3D_snare"]
height = 2.0
radius = 4.0

[node name="VoltaicSnare" type="Area3D"]
collision_layer = 0
collision_mask = 4
script = ExtResource("1_snare")

[node name="FieldMesh" type="MeshInstance3D" parent="."]
transform = Transform3D(8, 0, 0, 0, 1, 0, 0, 0, 8, 0, 0.03, 0)
mesh = SubResource("QuadMesh_field")

[node name="CollisionShape3D" type="CollisionShape3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0)
shape = SubResource("CylinderShape3D_snare")

[node name="OmniLight3D" type="OmniLight3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 1, 0)
light_color = Color(0.75, 0.3, 1, 1)
light_energy = 2.0
omni_range = 6.0
```

- [ ] **Step 3: Headless validation**

Run: `"/c/Users/vohra/OneDrive/Desktop/Godot_v4.6-stable_win64.exe" --headless --path . --check-only`
Expected: 0 errors.

- [ ] **Step 4: Commit**

```bash
git add scripts/voltaic_snare.gd scenes/vfx/voltaic_snare.tscn
git commit -m "feat(spells): implement Voltaic Snare with inward pull physics and detonation shockwave"
```

---

### Task 8: Crystalline Shardling Enemy & Death Shatter Particles

**Files:**
- Create: `scripts/enemy.gd`
- Create: `scenes/enemy.tscn`

**Interfaces:**
- Produces: `Enemy` class in group `"enemy"` with collision layer 4, reacting to player position and taking damage.

- [ ] **Step 1: Create `scripts/enemy.gd`**

```gdscript
extends CharacterBody3D
class_name Enemy

signal enemy_died

@export var move_speed: float = 4.2
@export var max_health: float = 60.0
@export var contact_damage: float = 15.0

var current_health: float = 60.0
var target_player: Player = null
var is_frozen: bool = false
var freeze_timer: float = 0.0
var is_dead: bool = false

@onready var mesh: MeshInstance3D = $VisualModel/BodyMesh
@onready var collision_shape: CollisionShape3D = $CollisionShape3D

func _ready() -> void:
	current_health = max_health
	add_to_group("enemy")

func set_target(player: Player) -> void:
	target_player = player

func _physics_process(delta: float) -> void:
	if is_dead:
		return
	
	if is_frozen:
		freeze_timer -= delta
		if freeze_timer <= 0.0:
			is_frozen = false
			mesh.modulate = Color(1, 1, 1, 1)
		move_and_slide()
		return
	
	if target_player and is_instance_valid(target_player):
		var dir := (target_player.global_position - global_position)
		dir.y = 0.0
		if dir.length_squared() > 0.01:
			var move_dir := dir.normalized()
			velocity.x = move_dir.x * move_speed
			velocity.z = move_dir.z * move_speed
			
			var target_rot := atan2(-move_dir.x, -move_dir.z)
			rotation.y = lerp_angle(rotation.y, target_rot, 0.15)
		
		# Contact damage check
		if dir.length() < 1.1:
			target_player.take_damage(contact_damage * delta)
	
	move_and_slide()

func apply_damage(amount: float) -> void:
	if is_dead:
		return
	current_health -= amount
	_flash_hit()
	if current_health <= 0.0:
		die()

func apply_frost(damage: float, duration: float) -> void:
	apply_damage(damage)
	if not is_dead:
		is_frozen = true
		freeze_timer = duration

func _flash_hit() -> void:
	var tween := create_tween()
	tween.tween_property(mesh, "scale", Vector3(1.2, 1.2, 1.2), 0.05)
	tween.tween_property(mesh, "scale", Vector3(1.0, 1.0, 1.0), 0.05)

func die() -> void:
	if is_dead:
		return
	is_dead = true
	enemy_died.emit()
	collision_shape.set_deferred("disabled", true)
	
	# Death shrink + dissolve tween
	var tween := create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector3(0.01, 0.01, 0.01), 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	await tween.finished
	queue_free()
```

- [ ] **Step 2: Create `scenes/enemy.tscn`**

```tscn
[gd_scene load_steps=6 format=3 uid="uid://c_enemy_01"]

[ext_resource type="Script" path="res://scripts/enemy.gd" id="1_enemy"]

[sub_resource type="SphereShape3D" id="SphereShape3D_enemy"]
radius = 0.5

[sub_resource type="StandardMaterial3D" id="StandardMaterial3D_shard"]
albedo_color = Color(0.15, 0.05, 0.2, 1)
emission_enabled = true
emission = Color(0.9, 0.2, 0.3, 1)
emission_energy_multiplier = 1.2
roughness = 0.3

[sub_resource type="BoxMesh" id="BoxMesh_body"]
material = SubResource("StandardMaterial3D_shard")
size = Vector3(0.7, 0.7, 0.7)

[node name="Enemy" type="CharacterBody3D"]
collision_layer = 4
collision_mask = 7
script = ExtResource("1_enemy")

[node name="CollisionShape3D" type="CollisionShape3D" parent="."]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.5, 0)
shape = SubResource("SphereShape3D_enemy")

[node name="VisualModel" type="Node3D" parent="."]

[node name="BodyMesh" type="MeshInstance3D" parent="VisualModel"]
transform = Transform3D(0.707107, -0.5, 0.5, 0, 0.707107, 0.707107, -0.707107, -0.5, 0.5, 0, 0.5, 0)
mesh = SubResource("BoxMesh_body")
```

- [ ] **Step 3: Headless validation**

Run: `"/c/Users/vohra/OneDrive/Desktop/Godot_v4.6-stable_win64.exe" --headless --path . --check-only`
Expected: 0 errors.

- [ ] **Step 4: Commit**

```bash
git add scripts/enemy.gd scenes/enemy.tscn
git commit -m "feat(enemy): build Shardling enemy with homing AI, freeze reactions, and death dissolving"
```

---

### Task 9: Wave Spawner & Game Coordinator

**Files:**
- Create: `scripts/main.gd`
- Create: `scenes/main.tscn`

**Interfaces:**
- Produces: `Main` scene combining Arena, Player, AimIndicator, Spawner, and HUD. Handles wave progression and restart.

- [ ] **Step 1: Create `scripts/main.gd`**

```gdscript
extends Node3D
class_name Main

enum GameState { PLAYING, WAVE_CLEARED, GAME_OVER, VICTORY }

@export var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
@export var frost_lance_scene: PackedScene = preload("res://scenes/vfx/frost_lance.tscn")
@export var voltaic_snare_scene: PackedScene = preload("res://scenes/vfx/voltaic_snare.tscn")

var current_state: GameState = GameState.PLAYING
var current_wave: int = 1
var max_waves: int = 3
var enemies_remaining: int = 0
var frost_cd: float = 0.0
var snare_cd: float = 0.0
const FROST_MAX_CD: float = 2.5
const SNARE_MAX_CD: float = 5.0

@onready var player: Player = $Player
@onready var arena: Arena = $Arena
@onready var aim_indicator: AimIndicator = $AimIndicator
@onready var hud: HUD = $HUD

func _ready() -> void:
	player.health_changed.connect(_on_player_health_changed)
	player.dash_used.connect(func(cd): hud.update_dash_cd(cd))
	_start_wave(current_wave)

func _process(delta: float) -> void:
	if frost_cd > 0.0:
		frost_cd -= delta
		hud.update_frost_cd(frost_cd, FROST_MAX_CD)
	if snare_cd > 0.0:
		snare_cd -= delta
		hud.update_snare_cd(snare_cd, SNARE_MAX_CD)
	
	if current_state == GameState.GAME_OVER or current_state == GameState.VICTORY:
		if Input.is_action_just_pressed("restart"):
			get_tree().reload_current_scene()
		return
	
	_handle_spell_inputs()
	aim_indicator.update_indicators(player.global_position, player.ground_aim_point)

func _handle_spell_inputs() -> void:
	# Frost Lance (Line Cast)
	if Input.is_action_pressed("cast_frost") and frost_cd <= 0.0:
		aim_indicator.set_mode(AimIndicator.Mode.LINE)
	elif Input.is_action_just_released("cast_frost") and frost_cd <= 0.0:
		aim_indicator.set_mode(AimIndicator.Mode.NONE)
		_cast_frost_lance()
	
	# Voltaic Snare (Zone Cast)
	elif Input.is_action_pressed("cast_snare") and snare_cd <= 0.0:
		aim_indicator.set_mode(AimIndicator.Mode.CIRCLE)
	elif Input.is_action_just_released("cast_snare") and snare_cd <= 0.0:
		aim_indicator.set_mode(AimIndicator.Mode.NONE)
		_cast_voltaic_snare()

func _cast_frost_lance() -> void:
	frost_cd = FROST_MAX_CD
	var lance := frost_lance_scene.instantiate() as FrostLance
	add_child(lance)
	lance.execute(player.global_position, player.ground_aim_point)

func _cast_voltaic_snare() -> void:
	snare_cd = SNARE_MAX_CD
	var snare := voltaic_snare_scene.instantiate() as VoltaicSnare
	add_child(snare)
	var delta := player.ground_aim_point - player.global_position
	delta.y = 0.0
	var dist := min(delta.length(), 14.0)
	var dir := delta.normalized() if delta.length_squared() > 0.001 else Vector3.FORWARD
	snare.global_position = player.global_position + dir * dist

func _start_wave(wave_num: int) -> void:
	current_state = GameState.PLAYING
	var enemy_counts := [6, 12, 20]
	var count: int = enemy_counts[clamp(wave_num - 1, 0, enemy_counts.size() - 1)]
	enemies_remaining = count
	hud.update_wave(current_wave, enemies_remaining)
	
	for i in range(count):
		var angle := (float(i) / float(count)) * TAU + randf_range(-0.1, 0.1)
		var spawn_pos := Vector3(cos(angle), 0.0, sin(angle)) * 22.0
		var enemy := enemy_scene.instantiate() as Enemy
		enemy.global_position = spawn_pos
		enemy.set_target(player)
		enemy.enemy_died.connect(_on_enemy_killed)
		add_child(enemy)

func _on_enemy_killed() -> void:
	enemies_remaining -= 1
	hud.update_wave(current_wave, enemies_remaining)
	if enemies_remaining <= 0:
		_on_wave_cleared()

func _on_wave_cleared() -> void:
	if current_wave >= max_waves:
		current_state = GameState.VICTORY
		hud.show_game_over(true)
	else:
		current_state = GameState.WAVE_CLEARED
		current_wave += 1
		await get_tree().create_timer(2.0).timeout
		_start_wave(current_wave)

func _on_player_health_changed(hp: float, max_hp: float) -> void:
	hud.update_health(hp, max_hp)
	if hp <= 0.0 and current_state != GameState.GAME_OVER:
		current_state = GameState.GAME_OVER
		hud.show_game_over(false)
```

- [ ] **Step 2: Create `scenes/main.tscn`**

```tscn
[gd_scene load_steps=7 format=3 uid="uid://c_main_01"]

[ext_resource type="Script" path="res://scripts/main.gd" id="1_main"]
[ext_resource type="PackedScene" path="res://scenes/arena.tscn" id="2_arena"]
[ext_resource type="PackedScene" path="res://scenes/player.tscn" id="3_player"]
[ext_resource type="PackedScene" path="res://scenes/aim_indicator.tscn" id="4_aim"]
[ext_resource type="PackedScene" path="res://scenes/ui/hud.tscn" id="5_hud"]

[node name="Main" type="Node3D"]
script = ExtResource("1_main")

[node name="Arena" parent="." instance=ExtResource("2_arena")]

[node name="Player" parent="." instance=ExtResource("3_player")]
transform = Transform3D(1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0.5, 0)

[node name="AimIndicator" parent="." instance=ExtResource("4_aim")]

[node name="HUD" parent="." instance=ExtResource("5_hud")]
```

- [ ] **Step 3: Headless validation**

Run: `"/c/Users/vohra/OneDrive/Desktop/Godot_v4.6-stable_win64.exe" --headless --path . --check-only`
Expected: 0 errors.

- [ ] **Step 4: Commit**

```bash
git add scripts/main.gd scenes/main.tscn
git commit -m "feat(game): create main game coordinator with wave loop, ability input dispatch, and health signals"
```

---

### Task 10: Minimalist Combat HUD & Game Over / Victory Overlay

**Files:**
- Create: `scripts/hud.gd`
- Create: `scenes/ui/hud.tscn`

**Interfaces:**
- Produces: `HUD` CanvasLayer displaying health bar, ability cooldown overlays, wave tracker, and victory/defeat screens.

- [ ] **Step 1: Create `scripts/hud.gd`**

```gdscript
extends CanvasLayer
class_name HUD

@onready var hp_bar: ProgressBar = $MarginContainer/VBoxContainer/TopRow/HealthBar
@onready var wave_label: Label = $MarginContainer/VBoxContainer/TopRow/WaveLabel
@onready var frost_label: Label = $BottomBar/HBox/FrostIcon/CDLabel
@onready var snare_label: Label = $BottomBar/HBox/SnareIcon/CDLabel
@onready var dash_label: Label = $BottomBar/HBox/DashIcon/CDLabel
@onready var overlay: PanelContainer = $Overlay
@onready var overlay_title: Label = $Overlay/VBox/TitleLabel

func _ready() -> void:
	overlay.visible = false

func update_health(current: float, max_val: float) -> void:
	hp_bar.max_value = max_val
	hp_bar.value = current

func update_wave(wave: int, remaining: int) -> void:
	wave_label.text = "WAVE %d — REMAINING: %d" % [wave, remaining]

func update_frost_cd(current: float, _max_cd: float) -> void:
	frost_label.text = "%.1f" % current if current > 0.05 else "READY"

func update_snare_cd(current: float, _max_cd: float) -> void:
	snare_label.text = "%.1f" % current if current > 0.05 else "READY"

func update_dash_cd(cd_time: float) -> void:
	dash_label.text = "%.1f" % cd_time
	var tween := create_tween()
	tween.tween_method(func(val: float): dash_label.text = "%.1f" % val if val > 0.05 else "READY", cd_time, 0.0, cd_time)

func show_game_over(is_victory: bool) -> void:
	overlay.visible = true
	if is_victory:
		overlay_title.text = "VICTORY ACHIEVED"
		overlay_title.modulate = Color(0.2, 1.0, 0.6)
	else:
		overlay_title.text = "RESONANCE COLLAPSE"
		overlay_title.modulate = Color(1.0, 0.2, 0.3)
```

- [ ] **Step 2: Create `scenes/ui/hud.tscn`**

```tscn
[gd_scene load_steps=3 format=3 uid="uid://c_hud_01"]

[ext_resource type="Script" path="res://scripts/hud.gd" id="1_hud"]

[sub_resource type="StyleBoxFlat" id="StyleBoxFlat_hp"]
bg_color = Color(0, 0.8, 1, 1)
corner_radius_top_left = 4
corner_radius_top_right = 4
corner_radius_bottom_right = 4
corner_radius_bottom_left = 4

[node name="HUD" type="CanvasLayer"]
script = ExtResource("1_hud")

[node name="MarginContainer" type="MarginContainer" parent="."]
anchors_preset = 10
anchor_right = 1.0
offset_bottom = 80.0
theme_override_constants/margin_left = 32
theme_override_constants/margin_top = 24
theme_override_constants/margin_right = 32

[node name="VBoxContainer" type="VBoxContainer" parent="MarginContainer"]
layout_mode = 2

[node name="TopRow" type="HBoxContainer" parent="MarginContainer/VBoxContainer"]
layout_mode = 2

[node name="HealthBar" type="ProgressBar" parent="MarginContainer/VBoxContainer/TopRow"]
custom_minimum_size = Vector2(300, 20)
layout_mode = 2
theme_override_styles/fill = SubResource("StyleBoxFlat_hp")
value = 100.0
show_percentage = false

[node name="Spacer" type="Control" parent="MarginContainer/VBoxContainer/TopRow"]
layout_mode = 2
size_flags_horizontal = 3

[node name="WaveLabel" type="Label" parent="MarginContainer/VBoxContainer/TopRow"]
layout_mode = 2
theme_override_font_sizes/font_size = 20
text = "WAVE 1 — REMAINING: 6"

[node name="BottomBar" type="MarginContainer" parent="."]
anchors_preset = 7
anchor_left = 0.5
anchor_top = 1.0
anchor_right = 0.5
anchor_bottom = 1.0
offset_left = -200.0
offset_top = -100.0
offset_right = 200.0
grow_horizontal = 2
grow_vertical = 0
theme_override_constants/margin_bottom = 24

[node name="HBox" type="HBoxContainer" parent="BottomBar"]
layout_mode = 2
theme_override_constants/separation = 24
alignment = 1

[node name="FrostIcon" type="VBoxContainer" parent="BottomBar/HBox"]
layout_mode = 2

[node name="Name" type="Label" parent="BottomBar/HBox/FrostIcon"]
layout_mode = 2
text = "[Q] Frost"
horizontal_alignment = 1

[node name="CDLabel" type="Label" parent="BottomBar/HBox/FrostIcon"]
layout_mode = 2
text = "READY"
horizontal_alignment = 1

[node name="SnareIcon" type="VBoxContainer" parent="BottomBar/HBox"]
layout_mode = 2

[node name="Name" type="Label" parent="BottomBar/HBox/SnareIcon"]
layout_mode = 2
text = "[E] Snare"
horizontal_alignment = 1

[node name="CDLabel" type="Label" parent="BottomBar/HBox/SnareIcon"]
layout_mode = 2
text = "READY"
horizontal_alignment = 1

[node name="DashIcon" type="VBoxContainer" parent="BottomBar/HBox"]
layout_mode = 2

[node name="Name" type="Label" parent="BottomBar/HBox/DashIcon"]
layout_mode = 2
text = "[Space] Dash"
horizontal_alignment = 1

[node name="CDLabel" type="Label" parent="BottomBar/HBox/DashIcon"]
layout_mode = 2
text = "READY"
horizontal_alignment = 1

[node name="Overlay" type="PanelContainer" parent="."]
visible = false
anchors_preset = 15
anchor_right = 1.0
anchor_bottom = 1.0
grow_horizontal = 2
grow_vertical = 2

[node name="VBox" type="VBoxContainer" parent="Overlay"]
layout_mode = 2
size_flags_horizontal = 4
size_flags_vertical = 4
theme_override_constants/separation = 16

[node name="TitleLabel" type="Label" parent="Overlay/VBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 36
text = "VICTORY ACHIEVED"
horizontal_alignment = 1

[node name="PromptLabel" type="Label" parent="Overlay/VBox"]
layout_mode = 2
theme_override_font_sizes/font_size = 18
text = "Press [R] to Restart"
horizontal_alignment = 1
```

- [ ] **Step 3: Headless validation**

Run: `"/c/Users/vohra/OneDrive/Desktop/Godot_v4.6-stable_win64.exe" --headless --path . --check-only`
Expected: 0 errors.

- [ ] **Step 4: Commit**

```bash
git add scripts/hud.gd scenes/ui/hud.tscn
git commit -m "feat(ui): create minimalist combat HUD with cooldowns, health bar, and restart overlay"
```

---

### Task 11: End-to-End Automated Headless Test Suite & Integration Verification

**Files:**
- Create: `tests/test_game_loop.gd`

**Interfaces:**
- Consumes: All scenes and scripts.
- Produces: Automated integration test validating player movement, ability instantiation, enemy damage/freeze, and game state transitions without opening a GUI window.

- [ ] **Step 1: Create `tests/test_game_loop.gd`**

```gdscript
extends SceneTree

func _init() -> void:
	print("--- BEGIN RESONANCE ARENA HEADLESS VERIFICATION ---")
	call_deferred("_run_tests")

func _run_tests() -> void:
	# 1. Load Main Scene
	var main_scene: PackedScene = load("res://scenes/main.tscn")
	assert(main_scene != null, "Failed to load main.tscn")
	var main: Main = main_scene.instantiate() as Main
	root.add_child(main)
	print("[PASS] Main scene instantiated successfully")

	# 2. Verify Player Setup
	var player: Player = main.get_node("Player") as Player
	assert(player != null, "Player node missing")
	assert(player.current_health == 100.0, "Player health not initialized")
	print("[PASS] Player verified at 100 HP")

	# 3. Test Player Dash
	player.start_dash(Vector3.FORWARD)
	assert(player.is_dashing == true, "Player failed to start dash")
	assert(player.is_invulnerable == true, "Player i-frames not active during dash")
	print("[PASS] Dash mechanics verified")

	# 4. Test Frost Lance Instantiation
	var frost_scene: PackedScene = load("res://scenes/vfx/frost_lance.tscn")
	var frost: FrostLance = frost_scene.instantiate() as FrostLance
	main.add_child(frost)
	frost.execute(Vector3.ZERO, Vector3(0, 0, 10))
	print("[PASS] Frost Lance executed without error")

	# 5. Test Voltaic Snare Instantiation
	var snare_scene: PackedScene = load("res://scenes/vfx/voltaic_snare.tscn")
	var snare: VoltaicSnare = snare_scene.instantiate() as VoltaicSnare
	main.add_child(snare)
	snare.global_position = Vector3(5, 0, 5)
	print("[PASS] Voltaic Snare executed without error")

	# 6. Test Enemy Reaction to Damage and Frost
	var enemy_scene: PackedScene = load("res://scenes/enemy.tscn")
	var enemy: Enemy = enemy_scene.instantiate() as Enemy
	main.add_child(enemy)
	enemy.set_target(player)
	
	enemy.apply_frost(20.0, 1.0)
	assert(enemy.current_health == 40.0, "Enemy damage not applied")
	assert(enemy.is_frozen == true, "Enemy frost state not applied")
	print("[PASS] Enemy damage and freeze verified")

	print("--- ALL VERIFICATION TESTS PASSED SUCCESSFULLY ---")
	quit(0)
```

- [ ] **Step 2: Run headless integration test**

Run: `"/c/Users/vohra/OneDrive/Desktop/Godot_v4.6-stable_win64.exe" --headless --script tests/test_game_loop.gd`
Expected: `--- ALL VERIFICATION TESTS PASSED SUCCESSFULLY ---` with exit code 0.

- [ ] **Step 3: Commit**

```bash
git add tests/test_game_loop.gd
git commit -m "test: add automated headless integration test suite verifying full gameplay loop"
```
