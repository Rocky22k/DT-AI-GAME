extends SceneTree

func _init() -> void:
	print("--- Running Frost Ability Unit Test ---")
	call_deferred("_run_tests")

func _run_tests() -> void:
	var crystal_scene: PackedScene = load("res://scenes/vfx/frost_crystal.tscn")
	assert(crystal_scene != null, "Failed to load frost_crystal.tscn")

	var lance_scene: PackedScene = load("res://scenes/vfx/frost_lance.tscn")
	assert(lance_scene != null, "Failed to load frost_lance.tscn")

	var lance = lance_scene.instantiate()
	root.add_child(lance)
	lance.execute(Vector3(0, 0, 0), Vector3(0, 0, 10))

	# Wait for first crystal to spawn
	await create_timer(0.1).timeout
	assert(lance.get_child_count() > 0, "Frost lance should spawn crystal nodes")

	print("--- FROST ABILITY VERIFIED SUCCESSFULLY ---")
	quit(0)
