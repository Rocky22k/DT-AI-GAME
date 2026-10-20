extends SceneTree

func _init() -> void:
	print("--- Headless Verification Test Running ---")
	var required_actions: Array[String] = [
		"move_forward", "move_backward", "move_left", "move_right",
		"dash", "cast_frost", "cast_snare", "restart"
	]
	for action in required_actions:
		assert(InputMap.has_action(action), "Missing action in InputMap: " + action)
		print("Validated action: ", action)
	print("--- Project config verified successfully ---")
	quit(0)
