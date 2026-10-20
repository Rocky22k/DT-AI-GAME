extends Node3D
class_name NovaBeam

@export var dps: float = 80.0
@export var beam_duration: float = 1.2
var beam_mesh: MeshInstance3D
var light: OmniLight3D
var is_active: bool = false
var beam_dir: Vector3
var beam_origin: Vector3
var beam_dist: float

func execute(origin: Vector3, target: Vector3) -> void:
	beam_origin = origin + Vector3.UP * 1.0
	var delta: Vector3 = target - origin
	delta.y = 0.0
	beam_dist = clampf(delta.length(), 4.0, 18.0)
	beam_dir = delta.normalized() if delta.length_squared() > 0.001 else Vector3.FORWARD

	global_position = beam_origin
	rotation.y = atan2(beam_dir.x, beam_dir.z)

	beam_mesh = get_node_or_null("BeamMesh")
	light = get_node_or_null("OmniLight3D")

	if beam_mesh:
		beam_mesh.scale = Vector3(1.6, 1.0, beam_dist)
		beam_mesh.position = Vector3(0.0, 0.0, beam_dist * 0.5)

	is_active = true
	var player := get_tree().get_first_node_in_group("player") as Player
	if player:
		player.add_camera_shake(0.4)
	var timer := get_tree().create_timer(beam_duration)
	await timer.timeout
	is_active = false

	if beam_mesh:
		var fade_tween: Tween = create_tween()
		fade_tween.tween_property(beam_mesh, "scale:x", 0.05, 0.2)
		if light:
			fade_tween.parallel().tween_property(light, "light_energy", 0.0, 0.2)
		await fade_tween.finished
	queue_free()

func _physics_process(delta: float) -> void:
	if not is_active:
		return

	# Damage all enemies within beam cylinder
	for node in get_tree().get_nodes_in_group("enemy"):
		if node is CharacterBody3D and is_instance_valid(node):
			var to_enemy: Vector3 = node.global_position - beam_origin
			var proj_dist: float = to_enemy.dot(beam_dir)
			if proj_dist > 0.0 and proj_dist < beam_dist:
				var lateral: float = (to_enemy - beam_dir * proj_dist).length()
				if lateral < 1.2 and node.has_method("apply_damage"):
					node.apply_damage(dps * delta)
