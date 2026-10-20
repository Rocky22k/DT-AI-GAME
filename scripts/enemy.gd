extends CharacterBody3D
class_name Enemy

signal enemy_died

@export var move_speed: float = 4.5
@export var max_health: float = 60.0
@export var contact_damage: float = 15.0

var current_health: float = 60.0
var target_player: Player = null
var is_frozen: bool = false
var freeze_timer: float = 0.0
var is_dead: bool = false

var visual_model: Node3D
var body_mesh: MeshInstance3D
var ring_orbit: Node3D
var collision_shape: CollisionShape3D
var hit_light: OmniLight3D
var orbit_angle: float = 0.0

var normal_mat: StandardMaterial3D
var frozen_mat: StandardMaterial3D

func _enter_tree() -> void:
	_init_nodes()

func _ready() -> void:
	_init_nodes()
	current_health = max_health
	add_to_group("enemy")

	# Setup materials for hit / frost reactions
	normal_mat = StandardMaterial3D.new()
	normal_mat.albedo_color = Color(0.12, 0.06, 0.18, 1.0)
	normal_mat.emission_enabled = true
	normal_mat.emission = Color(0.95, 0.15, 0.35, 1.0)
	normal_mat.emission_energy_multiplier = 1.8
	normal_mat.roughness = 0.25

	frozen_mat = StandardMaterial3D.new()
	frozen_mat.albedo_color = Color(0.1, 0.5, 0.8, 1.0)
	frozen_mat.emission_enabled = true
	frozen_mat.emission = Color(0.4, 0.9, 1.0, 1.0)
	frozen_mat.emission_energy_multiplier = 2.0
	frozen_mat.roughness = 0.1

	if body_mesh:
		body_mesh.material_override = normal_mat

func _init_nodes() -> void:
	visual_model = get_node_or_null("VisualModel")
	body_mesh = get_node_or_null("VisualModel/CoreMesh")
	ring_orbit = get_node_or_null("VisualModel/OrbitShards")
	collision_shape = get_node_or_null("CollisionShape3D")
	hit_light = get_node_or_null("VisualModel/CoreLight")

func set_target(player: Player) -> void:
	target_player = player

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	# Orbiting defense shards animation
	if ring_orbit:
		orbit_angle += delta * (1.5 if is_frozen else 4.0)
		ring_orbit.rotation.y = orbit_angle
		ring_orbit.rotation.x = sin(orbit_angle * 0.5) * 0.3

	if is_frozen:
		freeze_timer -= delta
		if freeze_timer <= 0.0:
			is_frozen = false
			if body_mesh:
				body_mesh.material_override = normal_mat
		move_and_slide()
		return

	if target_player and is_instance_valid(target_player):
		var dir: Vector3 = (target_player.global_position - global_position)
		dir.y = 0.0
		if dir.length_squared() > 0.01:
			var move_dir: Vector3 = dir.normalized()
			velocity.x = move_dir.x * move_speed
			velocity.z = move_dir.z * move_speed

			var target_rot: float = atan2(-move_dir.x, -move_dir.z)
			rotation.y = lerp_angle(rotation.y, target_rot, 0.15)

		# Contact damage check
		if dir.length() < 1.2:
			target_player.take_damage(contact_damage * delta)

	move_and_slide()

func apply_damage(amount: float) -> void:
	if is_dead:
		return
	current_health -= amount
	_flash_hit()
	if current_health <= 0.0:
		die()

func apply_frost(damage_amount: float, duration: float) -> void:
	apply_damage(damage_amount)
	if not is_dead:
		is_frozen = true
		freeze_timer = duration
		if body_mesh:
			body_mesh.material_override = frozen_mat

func _flash_hit() -> void:
	if not body_mesh or not is_inside_tree():
		return
	SoundManager.play_sound(self, SoundManager.sfx_hit, -8.0)
	var tween: Tween = create_tween()
	tween.tween_property(body_mesh, "scale", Vector3(1.25, 1.25, 1.25), 0.06).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(body_mesh, "scale", Vector3(1.0, 1.0, 1.0), 0.08)
	if hit_light:
		hit_light.light_energy = 4.0
		tween.parallel().tween_property(hit_light, "light_energy", 1.5, 0.15)

func die() -> void:
	if is_dead:
		return
	is_dead = true
	enemy_died.emit()
	if collision_shape:
		collision_shape.set_deferred("disabled", true)

	if is_inside_tree():
		var tween: Tween = create_tween().set_parallel(true)
		tween.tween_property(self, "scale", Vector3(0.05, 0.05, 0.05), 0.22).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		if hit_light:
			tween.tween_property(hit_light, "light_energy", 0.0, 0.2)
		await tween.finished
	queue_free()
