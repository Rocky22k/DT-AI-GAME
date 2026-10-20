extends Node3D
class_name CinderFall

@export var damage: float = 85.0
@export var blast_radius: float = 4.5
var start_pos: Vector3
var target_pos: Vector3
var progress: float = 0.0
var apex_height: float = 7.0
var flight_time: float = 0.65

var meteor_mesh: MeshInstance3D
var light: OmniLight3D

func execute(origin: Vector3, target: Vector3) -> void:
	start_pos = origin + Vector3.UP * 1.5
	var delta: Vector3 = target - origin
	delta.y = 0.0
	var dist: float = clampf(delta.length(), 4.0, 16.0)
	var dir: Vector3 = delta.normalized() if delta.length_squared() > 0.001 else Vector3.FORWARD
	target_pos = origin + dir * dist

	meteor_mesh = get_node_or_null("MeteorMesh")
	light = get_node_or_null("OmniLight3D")
	global_position = start_pos

	var tween: Tween = create_tween()
	tween.tween_method(_update_flight, 0.0, 1.0, flight_time).set_trans(Tween.TRANS_LINEAR)
	tween.tween_callback(_impact)

func _update_flight(t: float) -> void:
	var horiz: Vector3 = start_pos.lerp(target_pos, t)
	var arc: float = sin(t * PI) * apex_height
	global_position = Vector3(horiz.x, horiz.y + arc, horiz.z)

func _impact() -> void:
	global_position = target_pos
	var player := get_tree().get_first_node_in_group("player") as Player
	if player:
		player.add_camera_shake(0.7)
	if light:
		light.light_energy = 8.0
		light.omni_range = 10.0
		light.light_color = Color(1.0, 0.4, 0.1)

	# Damage in crater radius
	for node in get_tree().get_nodes_in_group("enemy"):
		if node is CharacterBody3D and is_instance_valid(node):
			var dist: float = (node.global_position - target_pos).length()
			if dist <= blast_radius and node.has_method("apply_damage"):
				var falloff: float = 1.0 - (dist / blast_radius) * 0.5
				node.apply_damage(damage * falloff)

	if meteor_mesh:
		var explode_tween: Tween = create_tween().set_parallel(true)
		explode_tween.tween_property(meteor_mesh, "scale", Vector3(3.0, 0.1, 3.0), 0.2)
		if light:
			explode_tween.tween_property(light, "light_energy", 0.0, 0.4)
		await explode_tween.finished
	queue_free()
