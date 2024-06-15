class_name Main extends Node3D

@export var holding_object: Node3D

func _ready():
	Singletons.main = self

func _process(_delta):
	if Input.is_action_just_pressed("left"):
		CameraManager.rotate_left()
	elif Input.is_action_just_pressed("right"):
		CameraManager.rotate_right()
	elif Input.is_action_just_pressed("special"):
		CameraManager.toggle_ouija()
	elif Input.is_action_just_pressed("turn_left"):
		turn_object_left()
	elif Input.is_action_just_pressed("turn_right"):
		turn_object_right()

func ouija_clicked():
	CameraManager.toggle_ouija()

func turn_object_left():
	if holding_object:
		holding_object.rotate_y(PI / 4)

func turn_object_right():
	if holding_object:
		holding_object.rotate_y(-PI / 4)

func move_object_to(point: ObjectPlacementPoint):
	holding_object.global_position = point.get_hover_point()
