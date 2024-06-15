class_name Candle extends Node3D

@export var min_size: float = 3
@export var max_size: float = 4
@export var pos_randomization: float = 0.2
@export var flicker_interval: float = 0.1

var target_size: float = (max_size + min_size) / 2
var target_pos: Vector3 = Vector3.ZERO
@onready var offset_pos: Vector3 = %Light.position
var next_flicker: float = flicker_interval
var last_size: float = target_size
var last_pos: Vector3 = target_pos

func _process(delta):
	next_flicker -= delta
	if next_flicker <= 0:
		last_size = target_size
		last_pos = target_pos
		target_size = randf_range(min_size, max_size)
		target_pos = Vector3(randf() * pos_randomization, randf() * pos_randomization, randf() * pos_randomization)
		target_pos -= Vector3.ONE * pos_randomization
		next_flicker += flicker_interval
	var t: float = next_flicker / flicker_interval
	%Light.position = offset_pos + lerp(target_pos, last_pos, t)
	%Light.omni_range = lerp(target_size, last_size, t)
