class_name Room extends Node3D

signal stool_just_placed
signal object_placed(object: PlaceableObject)

var symbol_to_position: Dictionary = {}
var all_placement_points: Array[ObjectPlacementPoint] = []

func _ready():
	Singletons.room = self
	symbol_to_position[OuijaSystem.Pos.MOON] = $SymbolPositions/MoonPosition.global_position
	symbol_to_position[OuijaSystem.Pos.TRISKELE] = $Walls/Triskele.global_position
	symbol_to_position[OuijaSystem.Pos.FLATWOODS] = $Walls/Flatwoods.global_position
	symbol_to_position[OuijaSystem.Pos.NORTH] = $SymbolPositions/North.global_position
	symbol_to_position[OuijaSystem.Pos.NORTH_EAST] = $SymbolPositions/NorthEast.global_position
	symbol_to_position[OuijaSystem.Pos.EAST] = $SymbolPositions/East.global_position
	symbol_to_position[OuijaSystem.Pos.SOUTH_EAST] = $SymbolPositions/SouthEast.global_position
	symbol_to_position[OuijaSystem.Pos.SOUTH] = $SymbolPositions/South.global_position
	symbol_to_position[OuijaSystem.Pos.SOUTH_WEST] = $SymbolPositions/SouthWest.global_position
	symbol_to_position[OuijaSystem.Pos.WEST] = $SymbolPositions/West.global_position
	symbol_to_position[OuijaSystem.Pos.NORTH_WEST] = $SymbolPositions/NorthWest.global_position
	for child: Node in find_children("*", "PlaceableObject", true):
		if child is PlaceableObject:
			child.object_placed.connect(_on_object_placed)
	for child: Node in find_children("*", "ObjectPlacementPoint", true):
		if child is ObjectPlacementPoint:
			all_placement_points.append(child)

func stool_placed():
	%OuijaPlacementPoint.process_mode = Node.PROCESS_MODE_INHERIT
	%StoolPlacementPoint.process_mode = Node.PROCESS_MODE_DISABLED
	%StoolBottom.set_animated(false)
	%StoolPlacementPoint.holding_object.placed()
	stool_just_placed.emit()

func position_from_symbol(symbol: OuijaSystem.Pos) -> Vector3:
	match symbol:
		OuijaSystem.Pos.DEVIL:
			return %Book.global_position
		OuijaSystem.Pos.ANKH:
			return %bougeoir_p.global_position
		_:
			return symbol_to_position[symbol]

func _on_object_placed(object: PlaceableObject):
	object_placed.emit(object)

func set_eye_animated(animated: bool):
	%StoolBottom.set_animated(animated)

func open_box():
	if not %box.is_open:
		%box.anim_chest()

func ouija_appear():
	%OuijaDetector.appear()
	%ouija_table.appear()
	%bougie.appear()
	%bougie2.appear()
	%bougie3.appear()

func shake_ouija():
	%ouija_table.ouija_table_jump()

func set_arrow_animated(animated: bool):
	%TotemArrow.set_animated(animated)

func move_ghost():
	var pos: Vector3 = all_placement_points.pick_random().position
	%MoveGhost.position = pos
	%MoveGhost.squish()
	await get_tree().process_frame
	if not %MoveGhost.in_light():
		%MoveGhost.appear()

