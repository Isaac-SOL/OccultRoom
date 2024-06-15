class_name CameraRotation extends Node3D

@export var camera_speed: float = 8

@onready var target_rotation: float = rotation.y

const ouija_rotation := Vector3(-0.8, PI, 0)
const ouija_position := Vector3(-0.5, 0, -0.3)

func _ready():
	CameraManager.camera_rotation = self

func _process(delta):
	var eff_target: Vector3 = ouija_rotation if CameraManager.ouija else Vector3(0, target_rotation, 0)
	rotation = Util.decayv3(rotation, eff_target, delta * camera_speed)
	var eff_pos_target: Vector3 = ouija_position if CameraManager.ouija else Vector3.ZERO
	position = Util.decayv3(position, eff_pos_target, delta * camera_speed)

func rotate_left():
	target_rotation -= PI / 2

func rotate_right():
	target_rotation +=  PI / 2

func realign_rotation():
	rotation.y = Util.clamp_angle(rotation.y, PI)
	target_rotation = Util.clamp_angle(target_rotation, PI)
