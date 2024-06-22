extends Node3D


@onready var animation_tree = get_node("AnimationTree")
@onready var playback = animation_tree.get("parameters/playback")


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true


func pyramid_jump(): 
		playback.travel("pyramid_jump")
		
func pyramid_rotate(): 
		playback.travel("pyramid_rotate")
		
