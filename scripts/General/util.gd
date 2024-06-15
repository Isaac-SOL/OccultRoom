class_name Util

static func decay(a, b, d: float):
	return b + (a - b) * exp(-d)

static func decayf(a: float, b: float, d: float) -> float:
	return b + (a - b) * exp(-d)

static func decayv2(a: Vector2, b: Vector2, d: float) -> Vector2:
	return b + (a - b) * exp(-d)

static func decayv3(a: Vector3, b: Vector3, d: float) -> Vector3:
	return b + (a - b) * exp(-d)

static func decayq(a: Quaternion, b: Quaternion, d: float) -> Quaternion:
	return b + (a - b) * exp(-d)

static func clamp_angle(angle: float, custom_center: float = 0) -> float:
	angle -= custom_center
	if angle > PI:
		angle = fmod(angle + PI, 2 * PI) - PI
	elif angle < -PI:
		angle = fmod(angle - PI, 2 * PI) + PI
	return angle + custom_center
