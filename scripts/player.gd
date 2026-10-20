extends CharacterBody3D
class_name Player

signal health_changed(current_hp: float, max_hp: float)
signal dash_used(cooldown_time: float)
signal ability_cast(ability_name: String, origin: Vector3, target: Vector3)

@export var move_speed: float = 8.5
@export var dash_speed: float = 24.0
@export var dash_duration: float = 0.2
@export var dash_cooldown: float = 1.2
@export var max_health: float = 100.0

var current_health: float = 100.0
var is_dashing: bool = false
var dash_timer: float = 0.0
var dash_cd_timer: float = 0.0
var dash_direction: Vector3 = Vector3.FORWARD
var ground_aim_point: Vector3 = Vector3.ZERO
var is_invulnerable: bool = false

var camera_mount: Node3D
var camera: Camera3D
var model: Node3D
var animator: PlayerAnimator

# Camera Zoom & Feel
var target_zoom: float = 55.0
var current_zoom: float = 55.0
var camera_shake_trauma: float = 0.0

func add_camera_shake(amount: float) -> void:
	camera_shake_trauma = clampf(camera_shake_trauma + amount, 0.0, 1.0)

func _enter_tree() -> void:
	_resolve_nodes()

func _ready() -> void:
	_resolve_nodes()
	current_health = max_health
	health_changed.emit(current_health, max_health)

func _resolve_nodes() -> void:
	camera_mount = get_node_or_null("CameraMount")
	camera = get_node_or_null("CameraMount/Camera3D") as Camera3D
	model = get_node_or_null("VisualModel")
	animator = get_node_or_null("VisualModel") as PlayerAnimator

func _unhandled_input(event: InputEvent) -> void:
	# Camera zoom with mouse scroll wheel (Codrops feature)
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			target_zoom = clampf(target_zoom - 3.0, 35.0, 70.0)
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			target_zoom = clampf(target_zoom + 3.0, 35.0, 70.0)

func _physics_process(delta: float) -> void:
	_update_timers(delta)
	_update_mouse_aim()

	if is_dashing:
		_process_dash(delta)
	else:
		_process_movement(delta)

	move_and_slide()

	# Update camera rig position smoothly with subtle cursor look-ahead
	if camera_mount:
		var look_ahead: Vector3 = (ground_aim_point - global_position) * 0.15
		look_ahead.y = 0.0
		camera_mount.global_position = camera_mount.global_position.lerp(global_position + look_ahead, 0.1)

	# Smooth camera FOV zoom & trauma shake
	if camera:
		current_zoom = lerpf(current_zoom, target_zoom, 0.1)
		camera.fov = current_zoom

		if camera_shake_trauma > 0.0:
			camera_shake_trauma = maxf(camera_shake_trauma - delta * 1.8, 0.0)
			var shake: float = camera_shake_trauma * camera_shake_trauma
			camera.h_offset = (randf() * 2.0 - 1.0) * 0.5 * shake
			camera.v_offset = (randf() * 2.0 - 1.0) * 0.5 * shake
		else:
			camera.h_offset = 0.0
			camera.v_offset = 0.0

	# Update majestic physical procedural character animations
	if animator:
		var look_dir: Vector3 = ground_aim_point - global_position
		look_dir.y = 0.0
		animator.update_animation(delta, velocity, is_dashing, look_dir.normalized())

func _update_timers(delta: float) -> void:
	if dash_cd_timer > 0.0:
		dash_cd_timer -= delta
	if is_dashing:
		dash_timer -= delta
		if dash_timer <= 0.0:
			is_dashing = false
			is_invulnerable = false

func _process_movement(_delta: float) -> void:
	var input_dir: Vector2 = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction := Vector3(input_dir.x, 0.0, input_dir.y).normalized()

	if direction.length_squared() > 0.01:
		velocity.x = direction.x * move_speed
		velocity.z = direction.z * move_speed
	else:
		velocity.x = move_toward(velocity.x, 0.0, move_speed * 0.4)
		velocity.z = move_toward(velocity.z, 0.0, move_speed * 0.4)

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
	SoundManager.play_sound(self, SoundManager.sfx_dash, -3.0)

func _process_dash(_delta: float) -> void:
	velocity = dash_direction * dash_speed

func _update_mouse_aim() -> void:
	if not camera:
		return
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var ray_origin: Vector3 = camera.project_ray_origin(mouse_pos)
	var ray_dir: Vector3 = camera.project_ray_normal(mouse_pos)

	# Raycast onto ground plane Y = 0
	if abs(ray_dir.y) > 0.0001:
		var t: float = -ray_origin.y / ray_dir.y
		if t > 0.0:
			ground_aim_point = ray_origin + ray_dir * t
		else:
			ground_aim_point = global_position + Vector3.FORWARD * 5.0
	else:
		ground_aim_point = global_position + Vector3.FORWARD * 5.0

	# Smoothly rotate visual model to face mouse aim point
	if model:
		var look_dir := (ground_aim_point - global_position)
		look_dir.y = 0.0
		if look_dir.length_squared() > 0.1:
			var target_rot: float = atan2(-look_dir.x, -look_dir.z)
			model.rotation.y = lerp_angle(model.rotation.y, target_rot, 0.25)

func notify_cast_fired() -> void:
	if animator:
		animator.trigger_cast_recoil()

func take_damage(amount: float) -> void:
	if is_invulnerable:
		return
	current_health = clampf(current_health - amount, 0.0, max_health)
	health_changed.emit(current_health, max_health)
