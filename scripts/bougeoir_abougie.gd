extends Node3D

var light_on = true


func switch_light(light_on : bool):
	if light_on:
		$Candle_light.visible = false
		$GPUParticles3D_fire.emitting = false
	else:
		$Candle_light.visible = true
		$GPUParticles3D_fire.emitting = true
