class_name RoomCamera extends Camera3D

@export var room_size: float = 9
@export var ouija_size: float = 1
@export var zoom_speed: float = 8

@onready var target_size: float = room_size

const base_rotation: float = -30

func _ready():
	CameraManager.camera = self

func _process(delta):
	size = Util.decayf(size, target_size, delta * zoom_speed)

func set_ouija(ouija: bool):
	target_size = ouija_size if ouija else room_size
