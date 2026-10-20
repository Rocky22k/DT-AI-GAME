extends Node3D
class_name Arena

const RADIUS: float = 24.0

func is_within_bounds(pos: Vector3) -> bool:
	return Vector2(pos.x, pos.z).length() <= RADIUS

func clamp_to_bounds(pos: Vector3) -> Vector3:
	var v2 := Vector2(pos.x, pos.z)
	if v2.length() > RADIUS:
		v2 = v2.normalized() * RADIUS
	return Vector3(v2.x, pos.y, v2.y)
