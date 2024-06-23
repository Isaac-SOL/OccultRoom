extends Node3D

signal opened

@onready var animation_tree = get_node("AnimationTree")
@onready var playback = animation_tree.get("parameters/playback")
var is_open = false

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree.active = true
	is_open = false
	$GPUParticles3D_pandora.emitting = false

func anim_chest():
	if is_open:
		playback.travel("close_pandora")
	else:
		playback.travel("open_pandora")
	$GPUParticles3D_pandora.emitting = !$GPUParticles3D_pandora.emitting
	is_open = !is_open

func _on_animation_tree_animation_finished(_anim_name):
	opened.emit()
