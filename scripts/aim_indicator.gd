extends Node3D
class_name AimIndicator

enum Mode { NONE, LINE, CIRCLE }

@export var max_line_range: float = 16.0
@export var min_line_range: float = 3.0
@export var max_circle_range: float = 14.0
@export var circle_radius: float = 4.0

var current_mode: Mode = Mode.NONE

var line_quad: MeshInstance3D
var circle_quad: MeshInstance3D

func _enter_tree() -> void:
	line_quad = get_node_or_null("LineQuad")
	circle_quad = get_node_or_null("CircleQuad")

func _ready() -> void:
	if not line_quad:
		line_quad = get_node_or_null("LineQuad")
	if not circle_quad:
		circle_quad = get_node_or_null("CircleQuad")
	set_mode(Mode.NONE)

func set_mode(new_mode: Mode) -> void:
	current_mode = new_mode
	if line_quad:
		line_quad.visible = (current_mode == Mode.LINE)
	if circle_quad:
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
	if not line_quad:
		return
	var delta: Vector3 = target_pos - player_pos
	delta.y = 0.0
	var dist: float = clampf(delta.length(), min_line_range, max_line_range)
	var dir: Vector3 = delta.normalized() if delta.length_squared() > 0.001 else Vector3.FORWARD

	global_position = Vector3(player_pos.x, 0.02, player_pos.z)
	var angle: float = atan2(dir.x, dir.z)
	rotation.y = angle

	line_quad.scale = Vector3(1.0, 1.0, dist)
	line_quad.position = Vector3(0.0, 0.0, dist * 0.5)

	var mat: ShaderMaterial = line_quad.get_active_material(0) as ShaderMaterial
	if mat:
		mat.set_shader_parameter("arrow_length", dist)

func _update_circle(player_pos: Vector3, target_pos: Vector3) -> void:
	if not circle_quad:
		return
	var delta: Vector3 = target_pos - player_pos
	delta.y = 0.0
	var dist: float = minf(delta.length(), max_circle_range)
	var dir: Vector3 = delta.normalized() if delta.length_squared() > 0.001 else Vector3.FORWARD
	var clamped_target: Vector3 = player_pos + dir * dist

	circle_quad.global_position = Vector3(clamped_target.x, 0.02, clamped_target.z)
	circle_quad.scale = Vector3(circle_radius * 2.0, 1.0, circle_radius * 2.0)
