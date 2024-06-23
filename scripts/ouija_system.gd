class_name OuijaSystem extends Node3D

enum Pos {
	NONE = 0,
	SHAKE,
	MOON, FLATWOODS, LIGHT,
	NORTH, EAST, SOUTH, WEST,
	NORTH_WEST, NORTH_EAST, SOUTH_EAST, SOUTH_WEST,
	TRISKELE,
	CLOSE, FAR,
	CRYSTAL_HINT,
	DEVIL, ANKH
}
enum State {IDLE, PAUSING, MOVING, FAKE_MOVING}

signal position_reached
signal pause_finished
signal stopped_moving

@export var rock_speed: float = 1
@export var rock_wait: float = 1
@export var valid_flame: ParticleProcessMaterial
@export var invalid_flame: ParticleProcessMaterial

@onready var last_move_pos: Vector3 = $Positions/None.position
@onready var target_move_pos: Vector3 = $Positions/None.position
var move_progress: float = 0
var replaced: bool = false
var current_sequence: Array[Pos] = []
var idx_in_sequence: int = 0
var state: State = State.IDLE
var positions: Dictionary = {}

func _ready():
	Singletons.ouija_system = self
	positions[Pos.NONE] = $Positions/None
	positions[Pos.MOON] = $Positions/Moon
	positions[Pos.FLATWOODS] = $Positions/Flatwoods
	positions[Pos.LIGHT] = $Positions/Light
	positions[Pos.NORTH] = $Positions/North
	positions[Pos.EAST] = $Positions/East
	positions[Pos.SOUTH] = $Positions/South
	positions[Pos.WEST] = $Positions/West
	positions[Pos.NORTH_WEST] = $Positions/NorthWest
	positions[Pos.NORTH_EAST] = $Positions/NorthEast
	positions[Pos.SOUTH_EAST] = $Positions/SouthEast
	positions[Pos.SOUTH_WEST] = $Positions/SouthWest
	positions[Pos.TRISKELE] = $Positions/Triskele
	positions[Pos.CLOSE] = $Positions/Close
	positions[Pos.FAR] = $Positions/Far
	positions[Pos.DEVIL] = $Positions/Devil
	positions[Pos.ANKH] = $Positions/Ankh
	position_reached.connect(_on_position_reached)
	pause_finished.connect(_on_pause_finished)

func _process(delta):
	if state == State.MOVING:
		var prog_distance := (target_move_pos - last_move_pos).length()
		if move_progress < prog_distance:
			move_progress += delta * rock_speed
			var prog_clamped := clampf(move_progress, 0, (target_move_pos - last_move_pos).length())
			%Rock.position = lerp(last_move_pos, target_move_pos, prog_clamped / (prog_distance + 1e-5))
		if move_progress >= prog_distance:
			position_reached.emit()

func get_pos(pos: Pos) -> Vector3:
	return positions[pos].position

func _on_object_placed(object: PlaceableObject):
	current_sequence = object.hints
	if not current_sequence.is_empty():
		%MagicAudio.play()
		Singletons.stool.set_active(true)
	match state:
		State.IDLE:
			idx_in_sequence = 0
			if not current_sequence.is_empty():
				%pyramid_cursor.pyramid_rotate()
			state = State.PAUSING
			await get_tree().create_timer(1).timeout
			pause_finished.emit()
		_:
			# If the system is running, then previous object has been removed
			# and this object is a replacement
			replaced = true

func _on_object_removed():
	current_sequence = []
	match state:
		State.PAUSING, State.MOVING, State.FAKE_MOVING:
			replaced = false
	Singletons.stool.set_active(false)

func _on_position_reached():
	assert(state == State.MOVING or state == State.FAKE_MOVING)
	last_move_pos = target_move_pos
	idx_in_sequence += 1
	%MoveAudio.stop()
	state = State.PAUSING
	await get_tree().create_timer(1).timeout
	pause_finished.emit()

func _on_pause_finished():
	assert(state == State.PAUSING)
	if last_move_pos == get_pos(Pos.NONE) and idx_in_sequence >= current_sequence.size():
		if replaced and not current_sequence.is_empty():
			# End reached, starting replacement sequence
			replaced = false
			idx_in_sequence = 0
			move_progress = 0
			%pyramid_cursor.pyramid_rotate()
			start_next_move()
		else:
			# End reached, no next move scheduled
			state = State.IDLE
			Singletons.stool.set_active(false)
	else:
		if idx_in_sequence >= current_sequence.size() or replaced:
			# Current movement has finished or been cancelled, must return to base position
			move_progress = 0
			target_move_pos = get_pos(Pos.NONE)
			%MoveAudio.play()
			state = State.MOVING
		else:
			# Current movement is in progress and going fine
			move_progress = 0
			start_next_move()

func start_next_move():
	if current_sequence[idx_in_sequence] == Pos.SHAKE:
		shake()
		state = State.FAKE_MOVING
		_on_position_reached()
	elif current_sequence[idx_in_sequence] == Pos.CRYSTAL_HINT:
		state = State.FAKE_MOVING
		flames_sequence()
	else:
		target_move_pos = get_pos(current_sequence[idx_in_sequence])
		%MoveAudio.play()
		state = State.MOVING

func flames_sequence():
	var flames: Array[Node] = %Flames.get_children()
	var i: int = 0
	for object: PlaceableObject in get_tree().get_nodes_in_group("ValidationObject"):
		Singletons.main.set_crystal_target(object)
		if object.check_valid():
			flames[i].process_material = valid_flame
		else:
			flames[i].process_material = invalid_flame
			shake()
		flames[i].emitting = true
		i += 1
		if replaced:
			break
		await get_tree().create_timer(1).timeout
	
	if true:
		Singletons.main.end_sequence()
	else:
		Singletons.main._on_crystal_touched()
		await get_tree().create_timer(4).timeout
		for flame: Node in flames:
			flame.emitting = false
		_on_position_reached()

func shake():
	Singletons.room.shake_ouija()
	%pyramid_cursor.pyramid_jump()
	%ShakeAudio.play()
	Singletons.shaker.shake(0.1, 0.5)
