extends CanvasLayer
class_name VFXEditor

var panel: PanelContainer
var time_scale_slider: HSlider
var bloom_slider: HSlider
var freeze_label: Label
var world_env: WorldEnvironment

func _enter_tree() -> void:
	panel = get_node_or_null("PanelContainer")
	time_scale_slider = get_node_or_null("PanelContainer/Margin/VBox/TimeScaleRow/HSlider")
	bloom_slider = get_node_or_null("PanelContainer/Margin/VBox/BloomRow/HSlider")
	freeze_label = get_node_or_null("PauseIndicator")

func _ready() -> void:
	if not panel:
		panel = get_node_or_null("PanelContainer")
	if not time_scale_slider:
		time_scale_slider = get_node_or_null("PanelContainer/Margin/VBox/TimeScaleRow/HSlider")
	if not bloom_slider:
		bloom_slider = get_node_or_null("PanelContainer/Margin/VBox/BloomRow/HSlider")
	if not freeze_label:
		freeze_label = get_node_or_null("PauseIndicator")

	if panel:
		panel.visible = false
	if freeze_label:
		freeze_label.visible = false

	if time_scale_slider:
		time_scale_slider.value_changed.connect(_on_time_scale_changed)
	if bloom_slider:
		bloom_slider.value_changed.connect(_on_bloom_changed)

func toggle_panel() -> void:
	if panel:
		panel.visible = not panel.visible

func toggle_pause() -> bool:
	var paused: bool = get_tree().paused
	get_tree().paused = not paused
	if freeze_label:
		freeze_label.visible = not paused
	return not paused

func _on_time_scale_changed(val: float) -> void:
	Engine.time_scale = val

func _on_bloom_changed(val: float) -> void:
	if not world_env:
		world_env = get_tree().root.find_child("WorldEnvironment", true, false) as WorldEnvironment
	if world_env and world_env.environment:
		world_env.environment.glow_intensity = val
