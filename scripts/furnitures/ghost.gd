extends Node3D


@onready var animation_tree = get_node("AnimationTree")
@onready var playback = animation_tree.get("parameters/playback")

# in process or elsewhere:
var is_idle = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true
	is_idle = false
	


func anim_ghost():
	if is_idle:
		playback.travel("ghost_idle")
	else:
		playback.travel("ghost_move")
	is_idle = !is_idle
