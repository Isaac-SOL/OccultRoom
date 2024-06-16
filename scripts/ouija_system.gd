class_name OuijaSystem extends Node3D

signal position_reached
signal stopped_moving

@export var rock_speed: float = 1
@export var rock_wait: float = 1

@onready var last_move_pos: Vector3 = $Positions/None.position
@onready var target_move_pos: Vector3 = $Positions/None.position
var move_progress: float = 0
var cancel_move: bool = false
var moving: bool = false
var waiting_move: bool = false
var current_sequence: Array[Pos] = []

enum Pos {
	NONE = 0,
	DOOR, MOON,
	NORTH, EAST, SOUTH, WEST,
	NORTH_WEST, NORTH_EAST, SOUTH_EAST, SOUTH_WEST,
	CONTACT, CLOSE, MID, FAR
}
var positions: Dictionary = {}

func _ready():
	Singletons.ouija_system = self
	positions[Pos.NONE] = $Positions/None
	positions[Pos.DOOR] = $Positions/Door
	positions[Pos.MOON] = $Positions/Moon
	positions[Pos.NORTH] = $Positions/North
	positions[Pos.EAST] = $Positions/East
	positions[Pos.SOUTH] = $Positions/South
	positions[Pos.WEST] = $Positions/West
	positions[Pos.NORTH_WEST] = $Positions/NorthWest
	positions[Pos.NORTH_EAST] = $Positions/NorthEast
	positions[Pos.SOUTH_EAST] = $Positions/SouthEast
	positions[Pos.SOUTH_WEST] = $Positions/SouthWest
	positions[Pos.CONTACT] = $Positions/Contact
	positions[Pos.CLOSE] = $Positions/Close
	positions[Pos.MID] = $Positions/Mid
	positions[Pos.FAR] = $Positions/Far

func _process(delta):
	if moving:
		var prog_distance := (target_move_pos - last_move_pos).length()
		if move_progress < prog_distance:
			move_progress += delta * rock_speed
			var prog_clamped := clampf(move_progress, 0, (target_move_pos - last_move_pos).length())
			%Rock.position = lerp(last_move_pos, target_move_pos, prog_clamped / (prog_distance + 1e-5))
			if move_progress >= prog_distance:
				position_reached.emit()

func get_pos(pos: Pos) -> Vector3:
	return positions[pos].position

func move_rock_sequence(sequence: Array[Pos]):
	current_sequence = sequence  # Anytime an object is placed it overrides previous sequence
	if moving and not waiting_move:
		waiting_move = true
		await stopped_moving
		waiting_move = false
	moving = true
	last_move_pos = get_pos(Pos.NONE)
	await get_tree().create_timer(rock_wait).timeout
	for pos: Pos in current_sequence:
		move_to_pos(pos)
		if cancel_move:
			break
	if last_move_pos != get_pos(Pos.NONE):
		move_to_pos(Pos.NONE)
	moving = false
	cancel_move = false
	stopped_moving.emit()

func move_to_pos(pos: Pos):
	target_move_pos = get_pos(pos)
	await position_reached
	last_move_pos = target_move_pos
	await get_tree().create_timer(rock_wait).timeout
	move_progress = 0

func cancel_current_movement():
	cancel_move = true
