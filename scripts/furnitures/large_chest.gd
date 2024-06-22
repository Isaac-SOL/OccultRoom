extends Node3D

@onready var animation_tree = get_node("AnimationTree")
@onready var playback = animation_tree.get("parameters/playback")

# in process or elsewhere:
var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true
	is_open = false
	
func _process(delta):
	if playback.get_current_node() == "large_chest_open":
		self.hide()


func anim_chest():
	if is_open:
		playback.travel("close_large_chest")
	else:
		playback.travel("open_large_chest")
	is_open = !is_open
