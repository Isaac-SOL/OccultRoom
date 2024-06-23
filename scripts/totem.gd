class_name Totem extends Node3D

var faces: Array[TotemFace] = []

func _ready():
	for child: Node in get_children():
		if child is TotemFace:
			faces.append(child)
			child.turned.connect(_on_face_turned)

func _on_face_turned(_face: TotemFace):
	%MoveAudio.play()
	if faces[0].discrete_position == 2 and faces[1].discrete_position == 0 \
	   and faces[2].discrete_position == 1 and faces[3].discrete_position == 3:
		for face: TotemFace in faces:
			face.deactivate()
		Singletons.shaker.shake(0.5, 3)
		Singletons.room.set_arrow_animated(false)
		%BigMoveAudio.play()
		var tween: Tween = get_tree().create_tween().set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
		tween.tween_property(self, "position", position - Vector3(0, 10, 0), 4)
		await tween.finished
		%BigMoveAudio.stop()
