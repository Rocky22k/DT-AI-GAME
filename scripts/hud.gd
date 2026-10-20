extends CanvasLayer
class_name HUD

var hp_bar: ProgressBar
var wave_label: Label
var frost_label: Label
var storm_label: Label
var cinder_label: Label
var beam_label: Label
var snare_label: Label
var crown_label: Label
var dash_label: Label
var overlay: PanelContainer
var overlay_title: Label

func _enter_tree() -> void:
	_init_nodes()

func _ready() -> void:
	_init_nodes()
	if overlay:
		overlay.visible = false

func _init_nodes() -> void:
	hp_bar = get_node_or_null("MarginContainer/VBoxContainer/TopRow/HealthBar")
	wave_label = get_node_or_null("MarginContainer/VBoxContainer/TopRow/WaveLabel")
	frost_label = get_node_or_null("BottomBar/HBox/FrostIcon/CDLabel")
	storm_label = get_node_or_null("BottomBar/HBox/StormIcon/CDLabel")
	cinder_label = get_node_or_null("BottomBar/HBox/CinderIcon/CDLabel")
	beam_label = get_node_or_null("BottomBar/HBox/BeamIcon/CDLabel")
	snare_label = get_node_or_null("BottomBar/HBox/SnareIcon/CDLabel")
	crown_label = get_node_or_null("BottomBar/HBox/CrownIcon/CDLabel")
	dash_label = get_node_or_null("BottomBar/HBox/DashIcon/CDLabel")
	overlay = get_node_or_null("Overlay")
	overlay_title = get_node_or_null("Overlay/VBox/TitleLabel")

func update_health(current: float, max_val: float) -> void:
	if hp_bar:
		hp_bar.max_value = max_val
		hp_bar.value = current

func update_wave(wave: int, remaining: int) -> void:
	if wave_label:
		wave_label.text = "WAVE %d — REMAINING: %d" % [wave, remaining]

func update_frost_cd(current: float, _max_cd: float) -> void:
	if frost_label:
		frost_label.text = "%.1f" % current if current > 0.05 else "READY"

func update_storm_cd(current: float, _max_cd: float) -> void:
	if storm_label:
		storm_label.text = "%.1f" % current if current > 0.05 else "READY"

func update_cinder_cd(current: float, _max_cd: float) -> void:
	if cinder_label:
		cinder_label.text = "%.1f" % current if current > 0.05 else "READY"

func update_beam_cd(current: float, _max_cd: float) -> void:
	if beam_label:
		beam_label.text = "%.1f" % current if current > 0.05 else "READY"

func update_snare_cd(current: float, _max_cd: float) -> void:
	if snare_label:
		snare_label.text = "%.1f" % current if current > 0.05 else "READY"

func update_crown_cd(current: float, _max_cd: float) -> void:
	if crown_label:
		crown_label.text = "%.1f" % current if current > 0.05 else "READY"

func update_dash_cd(cd_time: float) -> void:
	if not dash_label:
		return
	dash_label.text = "%.1f" % cd_time
	var tween: Tween = create_tween()
	tween.tween_method(func(val: float):
		if dash_label:
			dash_label.text = "%.1f" % val if val > 0.05 else "READY"
	, cd_time, 0.0, cd_time)

func show_game_over(is_victory: bool) -> void:
	if not overlay:
		return
	overlay.visible = true
	if is_victory:
		if overlay_title:
			overlay_title.text = "VICTORY ACHIEVED"
			overlay_title.modulate = Color(0.2, 1.0, 0.6)
	else:
		if overlay_title:
			overlay_title.text = "RESONANCE COLLAPSE"
			overlay_title.modulate = Color(1.0, 0.2, 0.3)
