extends SceneTree

func _init() -> void:
	print("--- Running HUD System Unit Test ---")
	call_deferred("_run_tests")

func _run_tests() -> void:
	var hud_scene: PackedScene = load("res://scenes/ui/hud.tscn")
	assert(hud_scene != null, "Failed to load hud.tscn")

	var hud = hud_scene.instantiate()
	assert(hud != null, "Failed to instantiate hud")
	root.add_child(hud)

	hud.update_health(75.0, 100.0)
	assert(hud.hp_bar.value == 75.0, "HUD HP bar value should be 75")

	hud.update_wave(2, 8)
	assert("WAVE 2" in hud.wave_label.text, "HUD wave label should display wave 2")

	hud.show_game_over(true)
	assert(hud.overlay.visible == true, "HUD overlay should be visible on game over")
	assert("VICTORY" in hud.overlay_title.text, "HUD should show victory text")

	print("--- HUD SYSTEM VERIFIED SUCCESSFULLY ---")
	quit(0)
