class_name OuijaPlacementPoint extends ObjectPlacementPoint

func _ready():
	super._ready()
	object_placed.connect(_on_ouija_object_placed)
	object_removed.connect(_on_ouija_object_removed)

func _on_ouija_object_placed(object: PlaceableObject, point: ObjectPlacementPoint):
	Singletons.main.ouija_object_placed(object, point)

func _on_ouija_object_removed(object: PlaceableObject, point: ObjectPlacementPoint):
	Singletons.main.ouija_object_removed(object, point)
