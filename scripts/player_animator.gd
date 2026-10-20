extends Node3D
class_name PlayerAnimator

# Node references
var torso: Node3D
var head: Node3D
var left_arm: Node3D
var right_arm: Node3D
var left_leg: Node3D
var right_leg: Node3D
var cape: Node3D
var runic_ring_1: Node3D
var runic_ring_2: Node3D
var focus_orb: Node3D
var core_light: OmniLight3D

var walk_cycle: float = 0.0
var idle_cycle: float = 0.0
var cast_recoil: float = 0.0
var is_moving: bool = false
var move_speed_ratio: float = 0.0

func _enter_tree() -> void:
	_resolve_nodes()

func _ready() -> void:
	_resolve_nodes()

func _resolve_nodes() -> void:
	torso = get_node_or_null("Torso")
	head = get_node_or_null("Torso/Head")
	left_arm = get_node_or_null("Torso/LeftArmPivot")
	right_arm = get_node_or_null("Torso/RightArmPivot")
	left_leg = get_node_or_null("LeftLegPivot")
	right_leg = get_node_or_null("RightLegPivot")
	cape = get_node_or_null("Torso/Cape")
	runic_ring_1 = get_node_or_null("Torso/RunicRing1")
	runic_ring_2 = get_node_or_null("Torso/RunicRing2")
	focus_orb = get_node_or_null("Torso/LeftArmPivot/FocusOrb")
	core_light = get_node_or_null("Torso/CoreLight")

func update_animation(delta: float, velocity: Vector3, is_dashing: bool, aim_dir: Vector3) -> void:
	var horiz_vel := Vector2(velocity.x, velocity.z)
	var speed: float = horiz_vel.length()
	is_moving = speed > 0.5
	move_speed_ratio = clampf(speed / 8.0, 0.0, 1.5)

	# Orbiting runic rings (always rotating)
	var ring_speed: float = 3.0 if not is_dashing else 12.0
	if runic_ring_1:
		runic_ring_1.rotate_y(delta * ring_speed)
		runic_ring_1.rotate_x(delta * 0.7)
	if runic_ring_2:
		runic_ring_2.rotate_y(-delta * (ring_speed * 1.3))
		runic_ring_2.rotate_z(delta * 0.5)

	# Floating focus orb bob
	if focus_orb:
		focus_orb.rotate_y(delta * 4.0)
		focus_orb.position.y = sin(idle_cycle * 3.0) * 0.05 - 0.4

	# Recovery from cast recoil
	if cast_recoil > 0.0:
		cast_recoil = maxf(cast_recoil - delta * 3.0, 0.0)

	if is_dashing:
		_animate_dash(delta, velocity)
	elif is_moving:
		_animate_run(delta, speed)
	else:
		_animate_idle(delta)

	# Aim orientation on upper torso/arms
	if right_arm and aim_dir.length_squared() > 0.01:
		right_arm.rotation.x = lerp_angle(right_arm.rotation.x, -0.7 - cast_recoil * 0.8, 0.2)

func _animate_run(delta: float, speed: float) -> void:
	walk_cycle += delta * speed * 1.8
	var stride: float = sin(walk_cycle)
	var bob: float = absf(sin(walk_cycle))

	# Torso bob
	if torso:
		torso.position.y = 0.9 + bob * 0.08
		torso.rotation.x = 0.15 # Lean forward into run
		torso.rotation.y = sin(walk_cycle) * 0.08

	# Alternating leg swings with knee bend
	if left_leg:
		left_leg.rotation.x = stride * 0.7
	if right_leg:
		right_leg.rotation.x = -stride * 0.7

	# Arm swinging in opposition to legs
	if left_arm:
		left_arm.rotation.x = -stride * 0.5
	if right_arm and cast_recoil <= 0.01:
		right_arm.rotation.x = stride * 0.3 - 0.4

	# Cape billows backward
	if cape:
		cape.rotation.x = lerp_angle(cape.rotation.x, -0.6 - bob * 0.15, 0.15)

func _animate_idle(delta: float) -> void:
	idle_cycle += delta * 2.0
	var breath: float = sin(idle_cycle)

	# Torso slow breathing hover
	if torso:
		torso.position.y = lerpf(torso.position.y, 0.9 + breath * 0.04, 0.1)
		torso.rotation.x = lerp_angle(torso.rotation.x, 0.0, 0.1)
		torso.rotation.y = lerp_angle(torso.rotation.y, 0.0, 0.1)

	# Return legs to neutral
	if left_leg:
		left_leg.rotation.x = lerp_angle(left_leg.rotation.x, 0.0, 0.15)
	if right_leg:
		right_leg.rotation.x = lerp_angle(right_leg.rotation.x, 0.0, 0.15)

	# Arms settle
	if left_arm:
		left_arm.rotation.x = lerp_angle(left_arm.rotation.x, breath * 0.05 - 0.2, 0.1)
	if right_arm and cast_recoil <= 0.01:
		right_arm.rotation.x = lerp_angle(right_arm.rotation.x, -0.3, 0.1)

	# Cape hangs down with gentle breathing sway
	if cape:
		cape.rotation.x = lerp_angle(cape.rotation.x, 0.05 + breath * 0.05, 0.1)

func _animate_dash(_delta: float, _velocity: Vector3) -> void:
	# Aggressive aerodynamic forward lunge
	if torso:
		torso.position.y = 0.75
		torso.rotation.x = 0.45
	if cape:
		cape.rotation.x = -1.1
	if left_leg:
		left_leg.rotation.x = -0.5
	if right_leg:
		right_leg.rotation.x = 0.6
	if right_arm:
		right_arm.rotation.x = -1.2

func trigger_cast_recoil() -> void:
	cast_recoil = 1.0
	if core_light:
		core_light.light_energy = 5.0
		var tween := create_tween()
		tween.tween_property(core_light, "light_energy", 1.8, 0.3)
