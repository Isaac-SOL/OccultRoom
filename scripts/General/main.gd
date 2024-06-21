class_name Main extends Node3D

signal grabbed_object(object: Node3D)
signal released_object(object: Node3D, point: ObjectPlacementPoint)
signal dialog_clicked

@export var holding_object: Node3D
@onready var crystal_viewport: SubViewport = %CrystalViewport
var targeting_stool: bool = true
var object_list: Array[PlaceableObject] = []
var inspecting: PlaceableObject = null
var pause = false
@onready var noise_mat: ShaderMaterial = %NoiseRect.material
var noise_tween: Tween
var dialog_unclickable_time: float = 0
var dialog: bool = false

# Dialog elements
var ouija_message_next: bool = false
var crystal_message_next: bool = false
var ouija_explanation_next: bool = false
var already_inspected: bool = true
@export var intro: bool = true


func _ready():
	Singletons.main = self
	await get_tree().process_frame
	check_valid_objects()
	%CrystalTargetPosition.target = get_tree().get_first_node_in_group("Stool")
	%PauseMenu.hide()
	Global.prevscene = get_tree().current_scene.scene_file_path
	
	%LookHint.visible = true
	if not intro:
		return
	
	await get_tree().create_timer(5).timeout
	await start_multi_dialog([0.5, 0.5, 0.5,
		"There is a spirit in this room.",
		"I know this kind of spirit well.",
		"I will play its little game for the time being."
	])
	%Room.set_eye_animated(true)
	ouija_message_next = true
	crystal_message_next = true
	%PickupHint.visible = true
	%FreeTurnHint.visible = true
	%TableHint.visible = true
	already_inspected = false

func _process(delta):
	# Play game song
	#NodeAudio.playAudio(NodeAudio.audioGame)
	
	# Pause menus
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	
	# Input
	if not dialog:
		if Input.is_action_just_pressed("left"):
			if not inspecting:
				CameraManager.rotate_left()
				%LookHint.visible = false
			else:
				inspecting.inspect_rotate_left()
		elif Input.is_action_just_pressed("right"):
			if not inspecting:
				CameraManager.rotate_right()
				%LookHint.visible = false
			else:
				inspecting.inspect_rotate_right()
		elif Input.is_action_just_pressed("up"):
			if inspecting:
				inspecting.inspect_rotate_up()
				%TurnHint.visible = false
		elif Input.is_action_just_pressed("down"):
			if inspecting:
				inspecting.inspect_rotate_down()
				%TurnHint.visible = false
		elif Input.is_action_just_pressed("special"):
			if not inspecting:
				CameraManager.toggle_ouija()
				if not CameraManager.ouija:
					%TableHint.visible = false
		elif Input.is_action_just_pressed("turn_left"):
			if not inspecting:
				turn_object_left()
				%FreeTurnHint.visible = false
		elif Input.is_action_just_pressed("turn_right"):
			if not inspecting:
				turn_object_right()
				%FreeTurnHint.visible = false
	
	# Scene management
	if dialog_unclickable_time > 0:
		dialog_unclickable_time -= delta

func ouija_clicked():
	CameraManager.toggle_ouija()
	if CameraManager.ouija:
		if ouija_message_next:
			await get_tree().create_timer(0.3).timeout
			start_dialog("The glowing Eye... yes... now where could its twin be...?")
			ouija_message_next = false
		elif ouija_explanation_next:
			await get_tree().create_timer(0.3).timeout
			start_dialog("This table should help me figure out where it wants things to go.")
			ouija_explanation_next = false

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
	if crystal_message_next and object.special_name == "CrystalBall":
		await get_tree().create_timer(0.3).timeout
		start_multi_dialog(["Visions of the future...", "Or hints, maybe?"])
		crystal_message_next = false
	if not already_inspected:
		%TurnHint.visible = true

func stop_inspect_object(object:PlaceableObject):
	object.move_back()
	%BlockerArea.set_deferred("input_ray_pickable", false)
	%HighlightSprite.speed = 25
	%HighlightSprite.target_scale = Vector3.ZERO
	%LabelLeft.set_inspect(false)
	%LabelRight.set_inspect(false)
	%InspectHint.visible = false
	inspecting = null
	already_inspected = true
		
func pauseMenu():
	if pause:
		%PauseMenu.hide()
		Engine.time_scale = 1
	else:
		%PauseMenu.show()
		Engine.time_scale = 0
	pause = !pause

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
	
	await get_tree().create_timer(1).timeout
	await start_multi_dialog([1.0, 1.0, "It does as it pleases!",
							  1.0, 1.0, "It would be safer if I tidied up the room myself."])
	ouija_message_next = false
	ouija_explanation_next = true

func _on_room_object_placed(_object):
	check_valid_objects()
	%PickupHint.visible = false
	if not already_inspected:
		%InspectHint.visible = true

func _on_change_vision_timer_timeout():
	if not targeting_stool:
		var valid_objects: Array = get_tree().get_nodes_in_group("ValidationObject")
		%CrystalTargetPosition.target = valid_objects.pick_random()

func tween_noise_to(final_val: float):
	if noise_tween:
		noise_tween.kill()
	noise_tween = get_tree().create_tween()
	var curr_val: float = noise_mat.get_shader_parameter("Strength")
	noise_tween.tween_method(func(val: float): noise_mat.set_shader_parameter("Strength", val),
							 curr_val, final_val, 0.5)

func start_dialog(text: String):
	tween_noise_to(0.04)
	%DialogText.text = text
	dialog_unclickable_time = 1
	dialog = true
	%DialogControl.visible = true

func _on_dialog_control_gui_input(event: InputEvent):
	if dialog_unclickable_time <= 0:
		if event is InputEventMouseButton and event.pressed:
			tween_noise_to(0)
			dialog = false
			%DialogControl.visible = false
			dialog_clicked.emit()

func start_multi_dialog(texts_and_effects: Array):
	for text_effect in texts_and_effects:
		if text_effect is String:
			start_dialog(text_effect)
			await dialog_clicked
			await get_tree().create_timer(0.2).timeout
		elif text_effect is float:
			%Shaker.shake(text_effect, 0.5)
			%ShakeAudio.play()
			await get_tree().create_timer(1).timeout
