class_name AnimatableSprite extends Sprite3D

@export var base_color: Color = Color.BLACK
@export var animated_gradient: Gradient
@export var gradient_length: float = 1
@export var animated: bool = false

var gradient_progress: float = 0

func _process(delta):
	if animated:
		gradient_progress = fmod(gradient_progress + delta, gradient_length)
		modulate = animated_gradient.sample(gradient_progress / gradient_length)

func set_animated(val: bool):
	animated = val
	if not animated:
		modulate = base_color
