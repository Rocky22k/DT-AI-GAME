extends Node3D
class_name Main

enum GameState { PLAYING, WAVE_CLEARED, GAME_OVER, VICTORY }
enum ArmedSlot { NONE, FROST, STORM, CINDER, BEAM, SNARE, CROWN }

@export var enemy_scene: PackedScene = preload("res://scenes/enemy.tscn")
@export var frost_lance_scene: PackedScene = preload("res://scenes/vfx/frost_lance.tscn")
@export var storm_lance_scene: PackedScene = preload("res://scenes/vfx/storm_lance.tscn")
@export var cinder_fall_scene: PackedScene = preload("res://scenes/vfx/cinder_fall.tscn")
@export var nova_beam_scene: PackedScene = preload("res://scenes/vfx/nova_beam.tscn")
@export var voltaic_snare_scene: PackedScene = preload("res://scenes/vfx/voltaic_snare.tscn")
@export var glacial_crown_scene: PackedScene = preload("res://scenes/vfx/glacial_crown.tscn")

var current_state: GameState = GameState.PLAYING
var armed_slot: ArmedSlot = ArmedSlot.NONE

var current_wave: int = 1
var max_waves: int = 3
var enemies_remaining: int = 0

var frost_cd: float = 0.0
var storm_cd: float = 0.0
var cinder_cd: float = 0.0
var beam_cd: float = 0.0
var snare_cd: float = 0.0
var crown_cd: float = 0.0

const FROST_MAX_CD: float = 2.0
const STORM_MAX_CD: float = 2.5
const CINDER_MAX_CD: float = 4.0
const BEAM_MAX_CD: float = 5.0
const SNARE_MAX_CD: float = 4.5
const CROWN_MAX_CD: float = 4.5

var player: Player
var arena: Arena
var aim_indicator: AimIndicator
var hud: HUD
var vfx_editor: VFXEditor
var effects_root: Node3D

func _enter_tree() -> void:
	_resolve_nodes()

func _ready() -> void:
	_resolve_nodes()
	SoundManager.init_audio()
	if player:
		player.health_changed.connect(_on_player_health_changed)
		player.dash_used.connect(func(cd: float):
			if hud:
				hud.update_dash_cd(cd)
		)
	_start_wave(current_wave)

func _resolve_nodes() -> void:
	player = get_node_or_null("Player") as Player
	arena = get_node_or_null("Arena") as Arena
	aim_indicator = get_node_or_null("AimIndicator") as AimIndicator
	hud = get_node_or_null("HUD") as HUD
	vfx_editor = get_node_or_null("VFXEditor") as VFXEditor
	effects_root = get_node_or_null("ActiveEffects") as Node3D

func _process(delta: float) -> void:
	_update_cooldowns(delta)

	# Global Codrops shortcuts
	if Input.is_action_just_pressed("pause_sim"):
		if vfx_editor:
			vfx_editor.toggle_pause()
	if Input.is_action_just_pressed("toggle_editor"):
		if vfx_editor:
			vfx_editor.toggle_panel()
	if Input.is_action_just_pressed("clear_effects"):
		_clear_all_effects()

	if current_state == GameState.GAME_OVER or current_state == GameState.VICTORY:
		if Input.is_action_just_pressed("restart"):
			get_tree().reload_current_scene()
		return

	_handle_arming_inputs()

	if player and aim_indicator:
		aim_indicator.update_indicators(player.global_position, player.ground_aim_point)

func _update_cooldowns(delta: float) -> void:
	if frost_cd > 0.0:
		frost_cd -= delta
		if hud:
			hud.update_frost_cd(frost_cd, FROST_MAX_CD)
	if storm_cd > 0.0:
		storm_cd -= delta
		if hud:
			hud.update_storm_cd(storm_cd, STORM_MAX_CD)
	if cinder_cd > 0.0:
		cinder_cd -= delta
		if hud:
			hud.update_cinder_cd(cinder_cd, CINDER_MAX_CD)
	if beam_cd > 0.0:
		beam_cd -= delta
		if hud:
			hud.update_beam_cd(beam_cd, BEAM_MAX_CD)
	if snare_cd > 0.0:
		snare_cd -= delta
		if hud:
			hud.update_snare_cd(snare_cd, SNARE_MAX_CD)
	if crown_cd > 0.0:
		crown_cd -= delta
		if hud:
			hud.update_crown_cd(crown_cd, CROWN_MAX_CD)

func _handle_arming_inputs() -> void:
	# Arm / Disarm Toggle (Codrops workflow)
	if Input.is_action_just_pressed("slot_1") and frost_cd <= 0.0:
		_toggle_arm(ArmedSlot.FROST, AimIndicator.Mode.LINE)
	elif Input.is_action_just_pressed("slot_2") and storm_cd <= 0.0:
		_toggle_arm(ArmedSlot.STORM, AimIndicator.Mode.LINE)
	elif Input.is_action_just_pressed("slot_3") and cinder_cd <= 0.0:
		_toggle_arm(ArmedSlot.CINDER, AimIndicator.Mode.LINE)
	elif Input.is_action_just_pressed("slot_4") and beam_cd <= 0.0:
		_toggle_arm(ArmedSlot.BEAM, AimIndicator.Mode.LINE)
	elif Input.is_action_just_pressed("slot_5") and snare_cd <= 0.0:
		_toggle_arm(ArmedSlot.SNARE, AimIndicator.Mode.CIRCLE)
	elif Input.is_action_just_pressed("slot_6") and crown_cd <= 0.0:
		_toggle_arm(ArmedSlot.CROWN, AimIndicator.Mode.CIRCLE)

	# Cancel Armed
	if Input.is_action_just_pressed("cancel"):
		_disarm()

	# Fire Armed
	if Input.is_action_just_pressed("fire") and armed_slot != ArmedSlot.NONE:
		_fire_armed_ability()

func _toggle_arm(slot: ArmedSlot, aim_mode: AimIndicator.Mode) -> void:
	if armed_slot == slot:
		_disarm()
	else:
		armed_slot = slot
		if aim_indicator:
			aim_indicator.set_mode(aim_mode)

func _disarm() -> void:
	armed_slot = ArmedSlot.NONE
	if aim_indicator:
		aim_indicator.set_mode(AimIndicator.Mode.NONE)

func _fire_armed_ability() -> void:
	if not player:
		return
	player.notify_cast_fired()
	var origin: Vector3 = player.global_position
	var target: Vector3 = player.ground_aim_point

	match armed_slot:
		ArmedSlot.FROST:
			frost_cd = FROST_MAX_CD
			SoundManager.play_sound(self, SoundManager.sfx_frost, -2.0)
			var lance := frost_lance_scene.instantiate() as FrostLance
			_add_effect(lance)
			lance.execute(origin, target)
		ArmedSlot.STORM:
			storm_cd = STORM_MAX_CD
			SoundManager.play_sound(self, SoundManager.sfx_storm, -1.0)
			var storm := storm_lance_scene.instantiate() as StormLance
			_add_effect(storm)
			storm.execute(origin, target)
		ArmedSlot.CINDER:
			cinder_cd = CINDER_MAX_CD
			SoundManager.play_sound(self, SoundManager.sfx_cinder, 2.0)
			var cinder := cinder_fall_scene.instantiate() as CinderFall
			_add_effect(cinder)
			cinder.execute(origin, target)
		ArmedSlot.BEAM:
			beam_cd = BEAM_MAX_CD
			SoundManager.play_sound(self, SoundManager.sfx_beam, 0.0)
			var beam := nova_beam_scene.instantiate() as NovaBeam
			_add_effect(beam)
			beam.execute(origin, target)
		ArmedSlot.SNARE:
			snare_cd = SNARE_MAX_CD
			SoundManager.play_sound(self, SoundManager.sfx_snare, 1.0)
			var snare := voltaic_snare_scene.instantiate() as VoltaicSnare
			_add_effect(snare)
			var delta := target - origin
			delta.y = 0.0
			var dist := minf(delta.length(), 14.0)
			var dir := delta.normalized() if delta.length_squared() > 0.001 else Vector3.FORWARD
			snare.global_position = origin + dir * dist
		ArmedSlot.CROWN:
			crown_cd = CROWN_MAX_CD
			SoundManager.play_sound(self, SoundManager.sfx_frost, 1.0)
			var crown := glacial_crown_scene.instantiate() as GlacialCrown
			_add_effect(crown)
			var delta := target - origin
			delta.y = 0.0
			var dist := minf(delta.length(), 14.0)
			var dir := delta.normalized() if delta.length_squared() > 0.001 else Vector3.FORWARD
			crown.execute(origin + dir * dist)

	_disarm()

func _add_effect(node: Node) -> void:
	if effects_root:
		effects_root.add_child(node)
	else:
		add_child(node)

func _clear_all_effects() -> void:
	if effects_root:
		for child in effects_root.get_children():
			child.queue_free()

func _start_wave(wave_num: int) -> void:
	current_state = GameState.PLAYING
	var enemy_counts: Array[int] = [6, 12, 20]
	var count: int = enemy_counts[clamp(wave_num - 1, 0, enemy_counts.size() - 1)]
	enemies_remaining = count
	if hud:
		hud.update_wave(current_wave, enemies_remaining)

	for i in range(count):
		var angle: float = (float(i) / float(count)) * TAU + randf_range(-0.1, 0.1)
		var spawn_pos := Vector3(cos(angle), 0.0, sin(angle)) * 22.0
		var enemy := enemy_scene.instantiate() as Enemy
		add_child(enemy)
		enemy.global_position = spawn_pos
		enemy.set_target(player)
		enemy.enemy_died.connect(_on_enemy_killed)

func _on_enemy_killed() -> void:
	enemies_remaining -= 1
	if hud:
		hud.update_wave(current_wave, enemies_remaining)
	if enemies_remaining <= 0:
		_on_wave_cleared()

func _on_wave_cleared() -> void:
	if current_wave >= max_waves:
		current_state = GameState.VICTORY
		if hud:
			hud.show_game_over(true)
	else:
		current_state = GameState.WAVE_CLEARED
		current_wave += 1
		await get_tree().create_timer(2.0).timeout
		if is_inside_tree() and current_state == GameState.WAVE_CLEARED:
			_start_wave(current_wave)

func _on_player_health_changed(hp: float, max_hp: float) -> void:
	if hud:
		hud.update_health(hp, max_hp)
	if hp <= 0.0 and current_state != GameState.GAME_OVER:
		current_state = GameState.GAME_OVER
		if hud:
			hud.show_game_over(false)
