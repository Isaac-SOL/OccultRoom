class_name PlaceableStool extends PlaceableObject

func placed():
	$EyeSprite.set_animated(false)
	$StarSprite.visible = true
