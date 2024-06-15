class_name Main extends Node3D

signal grabbed_object(object: Node3D)
signal released_object(object: Node3D, point: ObjectPlacementPoint)

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

func grab_object(object: Node3D):
	holding_object = object
	grabbed_object.emit(holding_object)

func release_object(point: ObjectPlacementPoint) -> Node3D:
	var temp_object := holding_object
	holding_object = null
	released_object.emit(temp_object, point)
	return temp_object

func ouija_object_placed(object: PlaceableObject, _point: OuijaPlacementPoint):
	Singletons.ouija_system.move_rock_sequence(object.hints)

func ouija_object_removed(_object: PlaceableObject, _point: OuijaPlacementPoint):
	Singletons.ouija_system.cancel_current_movement()
