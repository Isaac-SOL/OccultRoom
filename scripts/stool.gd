class_name PlaceableStool extends PlaceableObject

func _ready():
	super._ready()
	Singletons.stool = self

func placed():
	$EyeSprite.set_animated(false)
	$StarSprite.visible = true

func set_active(active: bool):
	%presentoire.set_active(active)
