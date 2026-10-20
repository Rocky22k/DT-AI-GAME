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

var mesh: MeshInstance3D
var collision_shape: CollisionShape3D

func _enter_tree() -> void:
	mesh = get_node_or_null("VisualModel/BodyMesh")
	collision_shape = get_node_or_null("CollisionShape3D")

func _ready() -> void:
	if not mesh:
		mesh = get_node_or_null("VisualModel/BodyMesh")
	if not collision_shape:
		collision_shape = get_node_or_null("CollisionShape3D")
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
			if mesh:
				mesh.modulate = Color(1, 1, 1, 1)
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

func apply_frost(damage_amount: float, duration: float) -> void:
	apply_damage(damage_amount)
	if not is_dead:
		is_frozen = true
		freeze_timer = duration

func _flash_hit() -> void:
	if not mesh or not is_inside_tree():
		return
	var tween: Tween = create_tween()
	tween.tween_property(mesh, "scale", Vector3(1.2, 1.2, 1.2), 0.05)
	tween.tween_property(mesh, "scale", Vector3(1.0, 1.0, 1.0), 0.05)

func die() -> void:
	if is_dead:
		return
	is_dead = true
	enemy_died.emit()
	if collision_shape:
		collision_shape.set_deferred("disabled", true)

	if is_inside_tree():
		var tween: Tween = create_tween().set_parallel(true)
		tween.tween_property(self, "scale", Vector3(0.01, 0.01, 0.01), 0.25).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
		await tween.finished
	queue_free()
