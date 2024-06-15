class_name Main extends Node3D

func _ready():
	Singletons.main = self

func _process(_delta):
	if Input.is_action_just_pressed("left"):
		CameraManager.rotate_left()
	elif Input.is_action_just_pressed("right"):
		CameraManager.rotate_right()
	elif Input.is_action_just_pressed("special"):
		CameraManager.toggle_ouija()

func ouija_clicked():
	CameraManager.toggle_ouija()
