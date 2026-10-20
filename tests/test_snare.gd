extends SceneTree

func _init() -> void:
	print("--- Running Voltaic Snare Unit Test ---")
	call_deferred("_run_tests")

func _run_tests() -> void:
	var snare_scene: PackedScene = load("res://scenes/vfx/voltaic_snare.tscn")
	assert(snare_scene != null, "Failed to load voltaic_snare.tscn")

	var snare = snare_scene.instantiate()
	assert(snare != null, "Failed to instantiate snare")
	root.add_child(snare)

	assert(snare.collision_mask == 4, "Snare should detect layer 4 (enemies)")
	assert(snare.field_mesh != null, "Snare should have field mesh")

	print("--- VOLTAIC SNARE VERIFIED SUCCESSFULLY ---")
	quit(0)
