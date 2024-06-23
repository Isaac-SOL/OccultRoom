class_name Chandelier extends PlaceableObject

var bougies: int = 0

func _on_clicked_with(object: PlaceableObject):
	if object.special_name == "BougieChandelier":
		object.destroy()
		bougies += 1
		$chandelier.add_bougie()
		if bougies < 3:
			%ImpactAudio.play()
		if bougies == 3:
			$chandelier.light()
			$LightArea.process_mode = Node.PROCESS_MODE_INHERIT
			hints = [OuijaSystem.Pos.ANKH, OuijaSystem.Pos.FAR,
					 OuijaSystem.Pos.MOON, OuijaSystem.Pos.FAR,
					 OuijaSystem.Pos.DEVIL, OuijaSystem.Pos.CLOSE]
			var condition1 := ObjectCondition.new()
			condition1.base_condition = OuijaSystem.Pos.ANKH
			condition1.close = false
			var condition2 := ObjectCondition.new()
			condition2.base_condition = OuijaSystem.Pos.MOON
			condition2.close = false
			var condition3 := ObjectCondition.new()
			condition3.base_condition = OuijaSystem.Pos.DEVIL
			condition3.close = true
			conditions = [condition1, condition2, condition3]
