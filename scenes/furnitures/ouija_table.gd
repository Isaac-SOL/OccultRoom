extends Node3D

@export var dissolve_material: ShaderMaterial
@export var dissolve_material_candle: ShaderMaterial

@onready var animation_tree: AnimationTree
@onready var playback: AnimationNodeStateMachinePlayback

# Called when the node enters the scene tree for the first time.
func _ready():
	animation_tree = $AnimationTree
	playback = animation_tree.get("parameters/playback")
	animation_tree.active = true

func ouija_table_jump(): 
		playback.travel("ouija_table_jump")

func appear():
	$ouija_board.visible = true
	var tween: Tween = create_tween()
	tween.tween_method(func(val: float): dissolve_material.set_shader_parameter("offset", val), 1.0, 0.5, 1)
	tween.parallel().tween_method(func(val: float): dissolve_material_candle.set_shader_parameter("offset", val), 1.0, 0.5, 1)
	tween.tween_method(func(val: float): dissolve_material.set_shader_parameter("offset", val), 0.5, -0.2, 1)
	tween.parallel().tween_method(func(val: float): dissolve_material_candle.set_shader_parameter("offset", val), 0.5, -0.2, 1)
	tween.tween_callback(func(): $ouija_board.set_surface_override_material(4, null))
	tween.tween_callback(func(): $tapis_table.set_surface_override_material(1, null))
	%AppearAudio.play()
