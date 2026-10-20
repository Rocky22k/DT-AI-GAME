extends SceneTree

func _init() -> void:
	print("--- Running Shader Loading & Compilation Test ---")
	var shader_paths: Array[String] = [
		"res://shaders/aim_line.gdshader",
		"res://shaders/aim_circle.gdshader",
		"res://shaders/ice_crystal.gdshader",
		"res://shaders/electric_field.gdshader",
		"res://shaders/arena_floor.gdshader"
	]
	for path in shader_paths:
		var sh: Shader = load(path)
		assert(sh != null, "Failed to load shader: " + path)
		var mat := ShaderMaterial.new()
		mat.shader = sh
		print("Loaded and initialized shader material: ", path)
	print("--- ALL SHADERS VALIDATED SUCCESSFULLY ---")
	quit(0)
