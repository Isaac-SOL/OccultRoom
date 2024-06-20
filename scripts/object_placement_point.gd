class_name ObjectPlacementPoint extends MouseDetector

signal object_placed(object: PlaceableObject, point: ObjectPlacementPoint)
signal object_removed(object: PlaceableObject, point: ObjectPlacementPoint)

@export var holding_object: PlaceableObject
@export var small: bool = false

func _ready():
	super._ready()
	own_mouse.connect(_on_own_mouse)
	disown_mouse.connect(_on_disown_mouse)
	clicked.connect(_on_placement_clicked)

func get_hover_point() -> Vector3:
	return %ObjectPositionHover.global_position

func get_ground_point() -> Vector3:
	return %ObjectPositionGround.global_position

func _on_own_mouse():
	if Singletons.main.holding_object and not holding_object and not (small and not Singletons.main.holding_object.small):
		Singletons.main.move_object_to(self)

func _on_disown_mouse():
	pass

func _on_placement_clicked(event: InputEventMouseButton):
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if holding_object and not Singletons.main.holding_object and holding_object.in_light():
			release_object()
		elif Singletons.main.holding_object and not holding_object and not (small and not Singletons.main.holding_object.small):
			grab_object()

func release_object():
	holding_object.set_holder(null)
	holding_object.move_to_smooth(get_hover_point(), holding_object.target_rotation)
	Singletons.main.grab_object(holding_object)
	var temp_object = holding_object
	holding_object = null
	object_removed.emit(temp_object, self)

func grab_object():
	holding_object = Singletons.main.release_object(self)
	holding_object.set_holder(self)
	holding_object.place_at(get_ground_point())
	object_placed.emit(holding_object, self)
