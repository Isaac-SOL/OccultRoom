extends Node3D


func _ready():
	$GPUParticles3D_presentoire.emitting = false

func activ_presentoire():
	$GPUParticles3D_pandora.emitting = !$GPUParticles3D_pandora.emitting
