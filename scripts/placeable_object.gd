class_name PlaceableObject extends Area3D

signal object_placed(object: PlaceableObject)
signal start_inspecting
signal stop_inspecting
signal touched

@export var special_name: String = ""
@export var move_speed: float = 25
@export var hints: Array[OuijaSystem.Pos]
@export var holder: ObjectPlacementPoint = null
@export_range(0, 7) var rotation_discrete: int = 0
@export var small: bool = false
@export var conditions: Array[ObjectCondition]
@export var needs_valid_placement: bool = false

var inspecting: bool = false
@onready var target_position: Vector3 = global_position
@onready var target_rotation: Vector3 = global_rotation
@onready var target_scale: Vector3 = scale
var saved_position: Vector3
var saved_rotation: Vector3
var saved_scale: Vector3
@onready var raw_rotation: Vector3 = global_rotation
var unclickable_timer: float = 0
var hovering: ObjectPlacementPoint
var rotation_addition: Vector3 = Vector3.ZERO

func _ready():
	if holder:
		hovering = holder
	collision_layer = 1 << 2
	if not is_in_group("PlaceableObject"):
		add_to_group("PlaceableObject")
	if needs_valid_placement and not is_in_group("ValidationObject"):
		add_to_group("ValidationObject")
	mouse_entered.connect(_on_object_mouse_entered)
	mouse_exited.connect(_on_object_mouse_exited)
	input_event.connect(_on_object_input_event)

func _process(delta):
	if inspecting:
		target_position = Singletons.main.inspect_position.global_position
		target_rotation = Singletons.main.inspect_position.global_rotation + rotation_addition
	if unclickable_timer > 0:
		unclickable_timer -= delta
	global_position = Util.decayv3(global_position, target_position, delta * move_speed)
	raw_rotation = Util.decayv3(raw_rotation, target_rotation, delta * move_speed)
	global_rotation = raw_rotation
	scale = Util.decayv3(scale, target_scale, delta * move_speed)

func set_holder(new_holder: ObjectPlacementPoint):
	holder = new_holder
	#set_collision_active(holder != null)

func set_hovering(point: ObjectPlacementPoint):
	hovering = point

func set_collision_active(active: bool):
	set_deferred("input_ray_pickable", active)

func place_at(pos: Vector3):
	target_position = pos
	global_position = pos
	global_rotation = target_rotation
	target_rotation = global_rotation  # Recalibrate angle
	raw_rotation = global_rotation
	unclickable_timer = 0
	%ImpactAudio.play()
	if needs_valid_placement:
		if check_valid():
			%ParticlesValid.emitting = true
		else:
			%ParticlesInvalid.emitting = true
	object_placed.emit(self)

func save_transform():
	saved_position = target_position
	saved_rotation = target_rotation
	saved_scale = target_scale

func rotate_left():
	rotation_discrete += 1
	rotation_discrete %= 8
	target_rotation.y += PI / 4

func rotate_right():
	rotation_discrete -= 1
	rotation_discrete %= 8
	target_rotation.y -= PI / 4

func inspect_rotate_left():
	target_rotation.y += PI / 4
	rotation_addition.y += PI / 4

func inspect_rotate_right():
	target_rotation.y -= PI / 4
	rotation_addition.y -= PI / 4

func inspect_rotate_up():
	target_rotation.z += PI / 4
	rotation_addition.z += PI / 4

func inspect_rotate_down():
	target_rotation.z -= PI / 4
	rotation_addition.z -= PI / 4

func move_to_smooth(pos: Vector3, rot: Vector3, sca: Vector3 = Vector3(-1, 0, 0), _reverse: bool = false):
	target_position = pos
	target_rotation = rot
	if sca.x != -1:
		target_scale = sca
	unclickable_timer = 0.2

func move_back():
	move_to_smooth(saved_position, saved_rotation, saved_scale, true)

func inspect():
	if not inspecting:
		if in_light() or Singletons.main.holding_object:
			inspecting = true
			save_transform()
			Singletons.main.inspect_object(self)
			start_inspecting.emit()
			%Outline.visible = false
	else:
		inspecting = false
		rotation_addition = Vector3.ZERO
		raw_rotation = global_rotation
		Singletons.main.stop_inspect_object(self)
		stop_inspecting.emit()

func in_light() -> bool:
	for area: Node in get_tree().get_nodes_in_group("LightArea"):
		if area is Area3D and area.overlaps_area(self):
			return true
	return false

func check_valid() -> bool:
	for condition: ObjectCondition in conditions:
		if not check_condition_valid(condition):
			return false
	return true

func check_condition_valid(condition: ObjectCondition) -> bool:
	match condition.base_condition:
		OuijaSystem.Pos.LIGHT:
			return condition.close == in_light()
		_:
			var target: Vector3 = Singletons.main.position_from_symbol(condition.base_condition)
			if condition.close and (global_position - target).length() < 4.5:
				return true
			if not condition.close and (global_position - target).length() > 9:
				return true
	return false

func _on_object_mouse_entered():
	if not Singletons.main.holding_object and not Singletons.main.inspecting and in_light():
		%Outline.visible = true

func _on_object_mouse_exited():
	%Outline.visible = false

func _on_object_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int):
	if unclickable_timer <= 0 and event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not inspecting and not holder:
				hovering._on_placement_clicked(event)
			elif not inspecting and holder:
				holder._on_placement_clicked(event)
			elif inspecting:
				%ImpactAudio.play()
				add_random_rotation()
				touched.emit()
		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			if CameraManager.ouija:
				Singletons.main.ouija_clicked()
			inspect()

func add_random_rotation():
	raw_rotation += Vector3(randf_range(-0.05, 0.05), randf_range(-0.05, 0.05), randf_range(-0.05, 0.05))
	global_rotation = raw_rotation

func set_clickable(clickable: bool):
	set_deferred("input_ray_pickable", clickable)
