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
	%OpenAudio.play()
	$Area3D.set_deferred("input_ray_pickable", false)
