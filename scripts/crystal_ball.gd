class_name CrystalBall extends PlaceableObject

func _ready():
	super._ready()
	await get_tree().process_frame
	touched.connect(Singletons.main._on_crystal_touched)
