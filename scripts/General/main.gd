class_name Main extends Node3D

signal grabbed_object(object: Node3D)
signal released_object(object: Node3D, point: ObjectPlacementPoint)

@export var holding_object: Node3D

var object_list: Array[PlaceableObject] = []
var inspecting: PlaceableObject = null
@onready var crystal_viewport: SubViewport = %CrystalViewport
var targeting_stool: bool = true

func _ready():
	Singletons.main = self
	await get_tree().process_frame
	check_valid_objects()
	%CrystalTargetPosition.target = get_tree().get_first_node_in_group("Stool")

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
	%HighlightSprite.speed = 1
	%HighlightSprite.target_scale = Vector3.ONE * 5
	%LabelLeft.set_inspect(true)
	%LabelRight.set_inspect(true)

func stop_inspect_object(object:PlaceableObject):
	object.move_back()
	%BlockerArea.set_deferred("input_ray_pickable", false)
	%HighlightSprite.speed = 25
	%HighlightSprite.target_scale = Vector3.ZERO
	%LabelLeft.set_inspect(false)
	%LabelRight.set_inspect(false)
	inspecting = null

func position_from_symbol(symbol: OuijaSystem.Pos) -> Vector3:
	return %Room.position_from_symbol(symbol)

func check_valid_objects():
	print("----- Check valid objects -----")
	var total_left: int = 0
	for node: Node in get_tree().get_nodes_in_group("ValidationObject"):
		if node is PlaceableObject and node.needs_valid_placement:
			print(node.name + " - " + str(node.check_valid()))
			if not node.check_valid():
				total_left += 1
	%LabelTopLeft.text = "Objects left: " + str(total_left)
	if total_left == 0:
		%LabelTopLeft.text += "\nCongratulations!"

func _on_room_stool_just_placed():
	%LabelTopLeft.visible = true
	targeting_stool = false
	%MagicAudio.play()
	_on_change_vision_timer_timeout()

func _on_room_object_placed(_object):
	check_valid_objects()

func _on_change_vision_timer_timeout():
	if not targeting_stool:
		var valid_objects: Array = get_tree().get_nodes_in_group("ValidationObject")
		%CrystalTargetPosition.target = valid_objects.pick_random()
