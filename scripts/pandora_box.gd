class_name PandoraBox extends PlaceableObject

var opened = false

func _ready():
	super._ready()
	clicked_with.connect(_on_pandora_clicked_with)

func _on_pandora_clicked_with(object: PlaceableObject):
	if not opened and object.special_name == "PandoraKey":
		object.destroy()
		$pandora_box.anim_chest()
		%OpenAudio.play()
		hints = [OuijaSystem.Pos.FLATWOODS, OuijaSystem.Pos.CLOSE]
		needs_valid_placement = true
		var new_condition := ObjectCondition.new()
		new_condition.base_condition = OuijaSystem.Pos.FLATWOODS
		new_condition.close = true
		conditions = [new_condition]
		$Outline/OutlineChest1.visible = false
		$Outline/OutlineChest2.visible = false
		$Outline/OutlineCompass.visible = true
		$Compass.visible = true
		opened = true
		
		await $pandora_box.opened
		$pandora_box.visible = false
