class_name OuijaDetector extends MouseDetector

func _ready():
	super._ready()
	Singletons.ouija = self
	clicked.connect(_on_ouija_clicked)
	own_mouse.connect(_on_ouija_own_mouse)
	disown_mouse.connect(_on_ouija_disown_mouse)
	await get_tree().process_frame
	Singletons.main.grabbed_object.connect(_on_main_grabbed_object)
	Singletons.main.released_object.connect(_on_main_released_object)
	set_detecting(true)

func _on_ouija_clicked(event: InputEventMouseButton):
	if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_RIGHT:
		if event.pressed:
			Singletons.main.ouija_clicked()

func set_detecting(detecting: bool):
	set_deferred("collision_layer", 1)
	set_deferred("collision_mask", 1)

func _on_main_grabbed_object(_object: Node3D):
	set_detecting(false)

func _on_main_released_object(_object: Node3D, _point: ObjectPlacementPoint):
	set_detecting(true)

func _on_ouija_own_mouse():
	%Outline.visible = true

func _on_ouija_disown_mouse():
	%Outline.visible = false

func appear():
	await get_tree().create_timer(1).timeout
	%Rock.visible = true
