extends SceneTree

func _init() -> void:
	print("--- Running Aim Indicator System Test ---")
	call_deferred("_run_tests")

func _run_tests() -> void:
	var aim_scene: PackedScene = load("res://scenes/aim_indicator.tscn")
	assert(aim_scene != null, "Failed to load aim_indicator.tscn")
	var aim: AimIndicator = aim_scene.instantiate() as AimIndicator
	assert(aim != null, "Failed to instantiate aim indicator")
	root.add_child(aim)

	# Verify default
	assert(aim.current_mode == AimIndicator.Mode.NONE, "Default mode should be NONE")
	assert(aim.line_quad.visible == false, "Line should be hidden in NONE mode")
	assert(aim.circle_quad.visible == false, "Circle should be hidden in NONE mode")

	# Verify LINE mode
	aim.set_mode(AimIndicator.Mode.LINE)
	assert(aim.current_mode == AimIndicator.Mode.LINE, "Mode should be LINE")
	assert(aim.line_quad.visible == true, "Line quad should be visible")
	assert(aim.circle_quad.visible == false, "Circle quad should be hidden")

	aim.update_indicators(Vector3(0, 0, 0), Vector3(0, 0, 10))
	assert(aim.global_position.y >= 0.01, "Indicator should hover just above ground")

	# Verify CIRCLE mode
	aim.set_mode(AimIndicator.Mode.CIRCLE)
	assert(aim.current_mode == AimIndicator.Mode.CIRCLE, "Mode should be CIRCLE")
	assert(aim.circle_quad.visible == true, "Circle quad should be visible")
	assert(aim.line_quad.visible == false, "Line quad should be hidden")

	aim.update_indicators(Vector3(0, 0, 0), Vector3(5, 0, 5))
	assert(aim.circle_quad.scale.x > 0.0, "Circle quad should be scaled")

	print("--- AIM INDICATOR SYSTEM VERIFIED SUCCESSFULLY ---")
	quit(0)
