extends Node3D


func _ready():
	%GPUParticles3D_presentoire.emitting = false

func set_active(active: bool):
	%GPUParticles3D_presentoire.emitting = active
