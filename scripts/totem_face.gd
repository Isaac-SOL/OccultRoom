class_name TotemFace extends MouseDetector

signal turned(face: TotemFace)

@export var discrete_position: int = 0
@export var turn_speed: float = 15

@onready var target_rotation: Vector3 = global_rotation
@onready var raw_rotation: Vector3 = global_rotation

func _ready():
	super._ready()
	own_mouse.connect(_on_totem_own_mouse)
	disown_mouse.connect(_on_totem_disown_mouse)
	clicked.connect(_on_totem_click)

func _process(delta):
	raw_rotation = Util.decayv3(raw_rotation, target_rotation, turn_speed * delta)
	global_rotation = raw_rotation

func _on_totem_own_mouse():
	$Outline.visible = true

func _on_totem_disown_mouse():
	$Outline.visible = false

func _on_totem_click(event: InputEvent):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		target_rotation.y += PI / 2
		discrete_position = (discrete_position + 1) % 4
		turned.emit(self)

func deactivate():
	set_deferred("input_ray_pickable", false)
