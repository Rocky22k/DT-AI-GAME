extends Node3D
class_name FrostLance

@export var crystal_scene: PackedScene = preload("res://scenes/vfx/frost_crystal.tscn")
@export var eruption_speed: float = 35.0

func execute(origin: Vector3, target: Vector3, max_range: float = 16.0) -> void:
	var delta: Vector3 = target - origin
	delta.y = 0.0
	var distance: float = clampf(delta.length(), 3.0, max_range)
	var dir: Vector3 = delta.normalized() if delta.length_squared() > 0.001 else Vector3.FORWARD

	var crystal_spacing: float = 1.2
	var count: int = int(distance / crystal_spacing)

	for i in range(count):
		var fraction: float = float(i) / float(max(count, 1))
		var delay: float = (fraction * distance) / eruption_speed
		get_tree().create_timer(delay).timeout.connect(func():
			if not is_inside_tree():
				return
			var crystal: Node3D = crystal_scene.instantiate() as Node3D
			add_child(crystal)
			var lateral_offset: Vector3 = (Vector3.UP.cross(dir)) * randf_range(-0.4, 0.4)
			crystal.global_position = origin + dir * (i * crystal_spacing) + lateral_offset
			crystal.global_rotation.y = randf_range(0.0, TAU)
		)

	# Clean up after all crystals shatter
	get_tree().create_timer((distance / eruption_speed) + 2.0).timeout.connect(func():
		if is_inside_tree():
			queue_free()
	)
