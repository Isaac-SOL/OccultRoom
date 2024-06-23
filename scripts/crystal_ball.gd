class_name CrystalBall extends PlaceableObject

func _ready():
	super._ready()
	await get_tree().process_frame
	touched.connect(Singletons.main._on_crystal_touched)
	clicked_with.connect(_on_ball_clicked_with)

func _on_ball_clicked_with(object: PlaceableObject):
	if object.special_name == "ThorHammer" and not can_pickup:
		await get_tree().create_timer(0.2).timeout
		%BreakAudio.play()
		Singletons.shaker.shake(1.5, 1)
		$crystal_ball.hide_ball()
		$GPUParticles3D.emitting = true
		Singletons.main.end_sequence_2()
