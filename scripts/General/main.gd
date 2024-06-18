class_name Main extends Node3D

signal grabbed_object(object: Node3D)
signal released_object(object: Node3D, point: ObjectPlacementPoint)

@export var holding_object: Node3D

var object_list: Array[PlaceableObject] = []
var inspecting: PlaceableObject = null

func _ready():
	Singletons.main = self

func _process(_delta):
	if Input.is_action_just_pressed("left"):
		if not inspecting: CameraManager.rotate_left()
		else: inspecting.inspect_rotate_left()
	elif Input.is_action_just_pressed("right"):
		if not inspecting: CameraManager.rotate_right()
		else: inspecting.inspect_rotate_right()
	elif Input.is_action_just_pressed("up"):
		if inspecting: inspecting.inspect_rotate_up()
	elif Input.is_action_just_pressed("down"):
		if inspecting: inspecting.inspect_rotate_down()
	elif Input.is_action_just_pressed("special"):
		if not inspecting: CameraManager.toggle_ouija()
	elif Input.is_action_just_pressed("turn_left"):
		if not inspecting: turn_object_left()
	elif Input.is_action_just_pressed("turn_right"):
		if not inspecting: turn_object_right()

func ouija_clicked():
	CameraManager.toggle_ouija()

func turn_object_left():
	if holding_object:
		holding_object.rotate_left()

func turn_object_right():
	if holding_object:
		holding_object.rotate_right()

func move_object_to(point: ObjectPlacementPoint):
	holding_object.move_to_smooth(point.get_hover_point(), holding_object.target_rotation)

func grab_object(object: Node3D):
	holding_object = object
	grabbed_object.emit(holding_object)

func release_object(point: ObjectPlacementPoint) -> Node3D:
	var temp_object := holding_object
	holding_object = null
	released_object.emit(temp_object, point)
	return temp_object

func ouija_object_placed(object: PlaceableObject, _point: OuijaPlacementPoint):
	Singletons.ouija_system._on_object_placed(object)

func ouija_object_removed(_object: PlaceableObject, _point: OuijaPlacementPoint):
	Singletons.ouija_system._on_object_removed()

func inspect_object(object: PlaceableObject):
	inspecting = object
	%BlockerArea.set_deferred("input_ray_pickable", true)
	object.move_to_smooth(%InspectPosition.global_position, %InspectPosition.global_rotation, %InspectPosition.scale)

func stop_inspect_object(object:PlaceableObject):
	object.move_back()
	%BlockerArea.set_deferred("input_ray_pickable", false)
	inspecting = null
