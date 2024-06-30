class_name MoveGhost extends Area3D

var unsquished: bool = false

func _process(_delta):
	look_at(CameraManager.camera.global_position)
	rotation.x = 0
	rotation.z = 0
	if in_light() and unsquished:
		disappear()

func appear():
	unsquished = true
	%ghost.position = Vector3(0, -4, 0)
	%ghost.scale = Vector3(1, 0.1, 1)
	var tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(%ghost, "position", Vector3.ZERO, 0.2)
	tween.parallel().tween_property(%ghost, "scale", Vector3.ONE, 0.2)

func disappear():
	unsquished = false
	await get_tree().create_timer(3.0).timeout
	%ghost.position = Vector3.ZERO
	%ghost.scale = Vector3.ONE
	var tween: Tween = get_tree().create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(%ghost, "position", Vector3(0, -4, 0), 0.5)
	tween.parallel().tween_property(%ghost, "scale", Vector3(1, 0.1, 1), 0.5)
	NodeAudio.pauseAudio()
	$Audio_scary_blow.play()
	get_tree().call_group("light_source_group", "switch_light", true)
	await get_tree().create_timer(4.0).timeout
	Singletons.shaker.shake(0.5, 2.0)
	await get_tree().create_timer(3.0).timeout
	NodeAudio.pauseAudio()
	get_tree().call_group("light_source_group", "switch_light", false)
	

func squish():
	%ghost.position = Vector3(0, -4, 0)
	%ghost.scale = Vector3(1, 0.1, 1)
	unsquished = false

func in_light() -> bool:
	for area: Node in get_tree().get_nodes_in_group("LightArea"):
		if area is Area3D and area.overlaps_area(self):
			return true
	return false
