class_name CodePart extends Area3D

signal clicked(part: CodePart)

@export var number: int = 0

func set_number(nb: int):
	number = nb
	%Text.text = str(nb)

func set_active(active: bool):
	set_deferred("input_ray_pickable", active)

func _on_input_event(_camera: Camera3D, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			clicked.emit(self)
