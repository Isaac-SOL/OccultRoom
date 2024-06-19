extends Node3D

@onready var animation_tree = get_node("AnimationTree")
@onready var playback = animation_tree.get("parameters/playback")
var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true
	is_open = false


func anim_chest():
	if is_open:
		playback.travel("close_chest")
	else:
		playback.travel("open_chest")
	is_open = !is_open


func _on_area_3d_input_event(camera, event, position, normal, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed == true:
			anim_chest()
