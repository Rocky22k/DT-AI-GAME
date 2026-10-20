extends SceneTree

func _init() -> void:
	print("--- Running Arena Verification Test ---")
	var arena_scene: PackedScene = load("res://scenes/arena.tscn")
	assert(arena_scene != null, "Failed to load arena.tscn")
	var arena = arena_scene.instantiate()
	assert(arena != null, "Failed to instantiate arena")
	root.add_child(arena)

	assert(arena.is_within_bounds(Vector3(0, 0, 0)) == true, "Center should be in bounds")
	assert(arena.is_within_bounds(Vector3(20, 0, 0)) == true, "20m should be in bounds")
	assert(arena.is_within_bounds(Vector3(30, 0, 0)) == false, "30m should be out of bounds")

	var clamped: Vector3 = arena.clamp_to_bounds(Vector3(30, 0, 0))
	assert(abs(clamped.x - 24.0) < 0.01, "Clamped point should be at radius 24.0")
	print("--- ARENA VERIFIED SUCCESSFULLY ---")
	quit(0)
