extends SceneTree

func _init() -> void:
	print("--- Running Player Unit & Mechanics Test ---")
	var player_scene: PackedScene = load("res://scenes/player.tscn")
	assert(player_scene != null, "Failed to load player.tscn")
	var player: Player = player_scene.instantiate() as Player
	assert(player != null, "Failed to instantiate player")
	root.add_child(player)

	assert(player.current_health == 100.0, "Player should start with 100 health")

	var health_emitted: Array = []
	player.health_changed.connect(func(cur, max_hp): health_emitted.append([cur, max_hp]))
	player.take_damage(25.0)
	assert(player.current_health == 75.0, "Player should have 75 health after 25 damage")
	assert(health_emitted.size() > 0, "health_changed signal should be emitted")

	var dash_emitted: Array = []
	player.dash_used.connect(func(cd): dash_emitted.append(cd))
	player.start_dash(Vector3.FORWARD)
	assert(player.is_dashing == true, "Player should be dashing")
	assert(player.is_invulnerable == true, "Player should be invulnerable during dash")
	assert(dash_emitted.size() == 1, "dash_used signal should be emitted once")

	# Damage while invulnerable should be ignored
	player.take_damage(30.0)
	assert(player.current_health == 75.0, "Player should not take damage while invulnerable")

	print("--- PLAYER MECHANICS VERIFIED SUCCESSFULLY ---")
	quit(0)
