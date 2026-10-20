extends SceneTree

func _init() -> void:
	print("--- Running Shardling Enemy Unit Test ---")
	call_deferred("_run_tests")

func _run_tests() -> void:
	var enemy_scene: PackedScene = load("res://scenes/enemy.tscn")
	assert(enemy_scene != null, "Failed to load enemy.tscn")

	var enemy = enemy_scene.instantiate()
	assert(enemy != null, "Failed to instantiate enemy")
	root.add_child(enemy)

	assert(enemy.is_in_group("enemy"), "Enemy must be in 'enemy' group")
	assert(enemy.current_health == 60.0, "Enemy should have 60 initial health")

	# Test Damage
	enemy.apply_damage(20.0)
	assert(enemy.current_health == 40.0, "Enemy should take 20 damage")

	# Test Frost
	enemy.apply_frost(10.0, 1.5)
	assert(enemy.current_health == 30.0, "Enemy should take 10 frost damage")
	assert(enemy.is_frozen == true, "Enemy should be frozen")

	# Test Death signal
	var died_emitted: Array = []
	enemy.enemy_died.connect(func(): died_emitted.append(true))
	enemy.apply_damage(50.0)
	assert(died_emitted.size() == 1, "Enemy died signal should emit on lethal damage")

	print("--- SHARDLING ENEMY VERIFIED SUCCESSFULLY ---")
	quit(0)
