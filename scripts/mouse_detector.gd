class_name MouseDetector extends Area3D

signal clicked(event: InputEvent)
signal own_mouse
signal disown_mouse

func _ready():
	mouse_entered.connect(_on_detector_mouse_entered)
	mouse_exited.connect(_on_detector_mouse_exited)
	input_event.connect(_on_detector_input_event)

func _on_detector_mouse_entered():
	own_mouse.emit()

func _on_detector_mouse_exited():
	disown_mouse.emit()

func _on_detector_input_event(_camera: Node, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int):
	if event is InputEventMouseButton:
		clicked.emit(event)
