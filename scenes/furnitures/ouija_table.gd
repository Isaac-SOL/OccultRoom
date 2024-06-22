extends Node3D


@onready var animation_tree = get_node("AnimationTree")
@onready var playback = animation_tree.get("parameters/playback")


# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true


func ouija_table_jump(): 
		playback.travel("ouija_table_jump")
		
