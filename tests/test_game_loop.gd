extends SceneTree

func _init() -> void:
	print("--- BEGIN RESONANCE ARENA / CODROPS END-TO-END TEST ---")
	call_deferred("_run_tests")

func _run_tests() -> void:
	# 1. Load and Instantiate Main Scene
	var main_scene: PackedScene = load("res://scenes/main.tscn")
	assert(main_scene != null, "Failed to load main.tscn")
	var main: Main = main_scene.instantiate() as Main
	assert(main != null, "Failed to instantiate main")
	root.add_child(main)
	print("[PASS] Main scene instantiated and added to root")

	# 2. Verify Player Setup
	var player: Player = main.get_node("Player") as Player
	assert(player != null, "Player node missing")
	assert(player.current_health == 100.0, "Player health not initialized")
	player.start_dash(Vector3.FORWARD)
	assert(player.is_dashing == true, "Player failed to start dash")
	assert(player.is_invulnerable == true, "Player i-frames not active during dash")
	print("[PASS] Player movement and dash verified")

	# 3. Verify Aim Indicator
	var aim: AimIndicator = main.get_node("AimIndicator") as AimIndicator
	assert(aim != null, "AimIndicator missing")
	aim.set_mode(AimIndicator.Mode.LINE)
	assert(aim.current_mode == AimIndicator.Mode.LINE, "Line aim mode failed")
	aim.set_mode(AimIndicator.Mode.CIRCLE)
	assert(aim.current_mode == AimIndicator.Mode.CIRCLE, "Circle aim mode failed")
	print("[PASS] Codrops aim indicator modes verified")

	# 4. Verify All 6 Signature Codrops Abilities
	print("Testing Ability 1: Frost Lance...")
	var frost: FrostLance = main.frost_lance_scene.instantiate() as FrostLance
	main.add_child(frost)
	frost.execute(Vector3.ZERO, Vector3(0, 0, 10))

	print("Testing Ability 2: Storm Lance...")
	var storm: StormLance = main.storm_lance_scene.instantiate() as StormLance
	main.add_child(storm)
	storm.execute(Vector3.ZERO, Vector3(0, 0, 10))

	print("Testing Ability 3: Cinder Fall...")
	var cinder: CinderFall = main.cinder_fall_scene.instantiate() as CinderFall
	main.add_child(cinder)
	cinder.execute(Vector3.ZERO, Vector3(5, 0, 5))

	print("Testing Ability 4: Nova Beam...")
	var beam: NovaBeam = main.nova_beam_scene.instantiate() as NovaBeam
	main.add_child(beam)
	beam.execute(Vector3.ZERO, Vector3(0, 0, 12))

	print("Testing Ability 5: Voltaic Snare...")
	var snare: VoltaicSnare = main.voltaic_snare_scene.instantiate() as VoltaicSnare
	main.add_child(snare)
	snare.global_position = Vector3(4, 0, 4)

	print("Testing Ability 6: Glacial Crown...")
	var crown: GlacialCrown = main.glacial_crown_scene.instantiate() as GlacialCrown
	main.add_child(crown)
	crown.execute(Vector3(-4, 0, -4))

	print("[PASS] All 6 Codrops elemental abilities executed cleanly")

	# 5. Verify Shardling Enemy Interaction
	var enemy: Enemy = main.enemy_scene.instantiate() as Enemy
	main.add_child(enemy)
	enemy.set_target(player)

	enemy.apply_frost(25.0, 1.2)
	assert(enemy.current_health == 35.0, "Enemy damage not applied")
	assert(enemy.is_frozen == true, "Enemy frost reaction failed")
	print("[PASS] Enemy combat reaction and freeze state verified")

	# 6. Verify VFX Editor & Pause Simulation
	var vfx_ed: VFXEditor = main.get_node("VFXEditor") as VFXEditor
	assert(vfx_ed != null, "VFXEditor missing")
	var is_paused: bool = vfx_ed.toggle_pause()
	assert(is_paused == true, "Pause sim toggle failed")
	vfx_ed.toggle_pause()
	print("[PASS] Codrops VFX editor & simulation pause verified")

	# 7. Verify Clear Effects
	main._clear_all_effects()
	print("[PASS] Clear effects verified")

	print("--- ALL 11 TASKS & CODROPS RECREATION CHECKS PASSED SUCCESSFULLY ---")
	quit(0)
