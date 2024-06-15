class_name OuijaDetector extends MouseDetector

func _ready():
	super._ready()
	Singletons.ouija = self
	clicked.connect(_on_ouija_clicked)
	await get_tree().process_frame
	Singletons.main.grabbed_object.connect(_on_main_grabbed_object)
	Singletons.main.released_object.connect(_on_main_released_object)

func _on_ouija_clicked(event: InputEventMouseButton):
	if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		Singletons.main.ouija_clicked()

func set_detecting(detecting: bool):
	set_deferred("collision_layer", 1 if detecting else 0)
	set_deferred("collision_mask", 1 if detecting else 0)

func _on_main_grabbed_object(_object: Node3D):
	set_detecting(false)

func _on_main_released_object(_object: Node3D, _point: ObjectPlacementPoint):
	set_detecting(true)
