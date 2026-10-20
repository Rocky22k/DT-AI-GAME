extends Area3D
class_name FrostCrystal

@export var damage: float = 35.0
@export var freeze_time: float = 1.5

var mesh: MeshInstance3D
var light: OmniLight3D

func _enter_tree() -> void:
	mesh = get_node_or_null("MeshInstance3D")
	light = get_node_or_null("OmniLight3D")

func _ready() -> void:
	if not mesh:
		mesh = get_node_or_null("MeshInstance3D")
	if not light:
		light = get_node_or_null("OmniLight3D")
	body_entered.connect(_on_body_entered)
	_animate_eruption()

func _animate_eruption() -> void:
	scale = Vector3(0.1, 0.1, 0.1)
	var target_h: float = randf_range(2.0, 3.5)
	var target_w: float = randf_range(0.4, 0.7)

	var tween: Tween = create_tween().set_parallel(true)
	tween.tween_property(self, "scale", Vector3(target_w, target_h, target_w), 0.15).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	if light:
		tween.tween_property(light, "light_energy", 2.0, 0.1)

	# Hold then shatter
	await get_tree().create_timer(1.0).timeout
	if is_inside_tree():
		var fade_tween: Tween = create_tween()
		fade_tween.tween_property(self, "scale", Vector3(target_w * 0.2, 0.05, target_w * 0.2), 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		fade_tween.tween_callback(queue_free)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("enemy") and body.has_method("apply_frost"):
		body.apply_frost(damage, freeze_time)
