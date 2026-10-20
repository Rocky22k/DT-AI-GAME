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
		var dir := direction if direction != Vector3.ZERO else -model.global_transform.basis.z
		start_dash(dir)

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
