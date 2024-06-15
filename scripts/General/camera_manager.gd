extends Node

var camera: RoomCamera
var camera_rotation: CameraRotation
var ouija: bool = false

func rotate_left():
	if not ouija:
		camera_rotation.rotate_left()

func rotate_right():
	if not ouija:
		camera_rotation.rotate_right()

func set_ouija(o: bool):
	ouija = o
	camera.set_ouija(ouija)
	if ouija:
		camera_rotation.realign_rotation()

func toggle_ouija():
	ouija = not ouija
	set_ouija(ouija)
