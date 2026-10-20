extends Node3D
class_name StormLance

@export var damage: float = 65.0
var bolt_mesh: MeshInstance3D
var light: OmniLight3D

func execute(origin: Vector3, target: Vector3) -> void:
	var delta: Vector3 = target - origin
	delta.y = 0.0
	var dist: float = clampf(delta.length(), 3.0, 18.0)
	var dir: Vector3 = delta.normalized() if delta.length_squared() > 0.001 else Vector3.FORWARD

	global_position = origin + Vector3.UP * 1.0
	var angle: float = atan2(dir.x, dir.z)
	rotation.y = angle

	bolt_mesh = get_node_or_null("BoltMesh")
	light = get_node_or_null("OmniLight3D")

	if bolt_mesh:
		bolt_mesh.scale = Vector3(1.5, 1.0, dist)
		bolt_mesh.position = Vector3(0.0, 0.0, dist * 0.5)

	# Raycast / Area check for enemies along line
	var space_state := get_world_3d().direct_space_state
	var query := PhysicsRayQueryParameters3D.create(origin + Vector3.UP * 0.5, origin + dir * dist + Vector3.UP * 0.5)
	query.collision_mask = 4
	query.collide_with_areas = false
	query.collide_with_bodies = true

	# Hit all enemies within width of bolt
	for node in get_tree().get_nodes_in_group("enemy"):
		if node is CharacterBody3D and is_instance_valid(node):
			var to_enemy: Vector3 = node.global_position - origin
			var proj_dist: float = to_enemy.dot(dir)
			if proj_dist > 0.0 and proj_dist < dist:
				var lateral: float = (to_enemy - dir * proj_dist).length()
				if lateral < 1.4 and node.has_method("apply_damage"):
					node.apply_damage(damage)

	# Jitter & fade out
	var tween: Tween = create_tween()
	if light:
		light.light_energy = 4.0
		tween.tween_property(light, "light_energy", 0.0, 0.35)
	if bolt_mesh:
		tween.parallel().tween_property(bolt_mesh, "scale:x", 0.1, 0.35)
	await tween.finished
	queue_free()
