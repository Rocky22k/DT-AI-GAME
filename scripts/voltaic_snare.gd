extends Area3D
class_name VoltaicSnare

@export var duration: float = 2.0
@export var pull_strength: float = 8.0
@export var dps: float = 15.0
@export var detonation_damage: float = 50.0

var elapsed: bool = false
var field_mesh: MeshInstance3D
var light: OmniLight3D
var collision_shape: CollisionShape3D

func _enter_tree() -> void:
	field_mesh = get_node_or_null("FieldMesh")
	light = get_node_or_null("OmniLight3D")
	collision_shape = get_node_or_null("CollisionShape3D")

func _ready() -> void:
	if not field_mesh:
		field_mesh = get_node_or_null("FieldMesh")
	if not light:
		light = get_node_or_null("OmniLight3D")
	if not collision_shape:
		collision_shape = get_node_or_null("CollisionShape3D")
	_activate_snare()

func _activate_snare() -> void:
	if not field_mesh:
		return
	# Overshoot snap animation (Codrops style)
	field_mesh.scale = Vector3(0.1, 1.0, 0.1)
	var tween: Tween = create_tween()
	tween.tween_property(field_mesh, "scale", Vector3(9.0, 1.0, 9.0), 0.18).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(field_mesh, "scale", Vector3(8.0, 1.0, 8.0), 0.1)

	await get_tree().create_timer(duration).timeout
	if is_inside_tree():
		_detonate()

func _physics_process(delta: float) -> void:
	if elapsed:
		return

	for body in get_overlapping_bodies():
		if body.is_in_group("enemy"):
			var to_center: Vector3 = global_position - body.global_position
			to_center.y = 0.0
			var dist: float = to_center.length()
			if dist > 0.3:
				body.velocity += to_center.normalized() * pull_strength * delta * 60.0
			if body.has_method("apply_damage"):
				body.apply_damage(dps * delta)

func _detonate() -> void:
	elapsed = true
	if light:
		light.light_energy = 5.0
		light.light_color = Color(1.0, 0.8, 1.0)

	for body in get_overlapping_bodies():
		if body.is_in_group("enemy") and body.has_method("apply_damage"):
			body.apply_damage(detonation_damage)

	if field_mesh and light:
		var tween: Tween = create_tween().set_parallel(true)
		tween.tween_property(field_mesh, "scale", Vector3(12.0, 1.0, 12.0), 0.15)
		tween.tween_property(light, "light_energy", 0.0, 0.25)
		await tween.finished
	queue_free()
