extends PlaceableObject

var opened = false

func _ready():
	super._ready()
	await get_tree().process_frame
	Singletons.room.object_placed.connect(_on_chest_placed)

func _on_chest_placed(_object: PlaceableObject):
	print(check_valid())
	if not opened and check_valid():
		open_chest()
		opened = true

func open_chest():
	%Content.visible = true
	%OpenAudio.play()
	$Outline/ChestOutline.visible = false
	$Outline/Outline2.visible = true
	$large_chest.anim_chest()
	
	await $large_chest.opened
	$large_chest.visible = false
	opened = true
	Singletons.room.set_arrow_animated(true)
