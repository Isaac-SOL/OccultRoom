class_name ObjectPlacementPoint extends MouseDetector

@export var holding_object: Node3D

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
	if Singletons.main.holding_object:
		Singletons.main.move_object_to(self)

func _on_disown_mouse():
	pass

func _on_placement_clicked(event: InputEventMouseButton):
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if holding_object and not Singletons.main.holding_object:
			release_object()
		elif Singletons.main.holding_object:
			grab_object()

func release_object():
	holding_object.global_position = get_hover_point()
	Singletons.main.holding_object = holding_object
	holding_object = null

func grab_object():
	holding_object = Singletons.main.holding_object
	Singletons.main.holding_object = null
	holding_object.global_position = get_ground_point()
