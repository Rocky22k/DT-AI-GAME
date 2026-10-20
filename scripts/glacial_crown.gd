extends Node3D
class_name GlacialCrown

@export var crystal_scene: PackedScene = preload("res://scenes/vfx/frost_crystal.tscn")
@export var radius: float = 4.0
@export var crystal_count: int = 14

func execute(center: Vector3) -> void:
	global_position = center

	# Erupt ring around the boundary
	for i in range(crystal_count):
		var angle: float = (float(i) / float(crystal_count)) * TAU
		var delay: float = (float(i) / float(crystal_count)) * 0.25 # wave running round both sides
		get_tree().create_timer(delay).timeout.connect(func():
			if not is_inside_tree():
				return
			var crystal: Node3D = crystal_scene.instantiate() as Node3D
			add_child(crystal)
			var offset := Vector3(cos(angle), 0.0, sin(angle)) * radius
			crystal.global_position = center + offset
			crystal.global_rotation.y = angle + PI * 0.5
		)

	get_tree().create_timer(2.5).timeout.connect(func():
		if is_inside_tree():
			queue_free()
	)
