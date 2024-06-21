extends Control


@export var busName: String
var busIndex : int
var slideValue = 0.0
@onready var hslider = $HBoxContainer/HSlider as HSlider
@onready var label = $HBoxContainer/Label as Label

func _ready():
	label.text = busName
	busIndex = AudioServer.get_bus_index(busName)
	hslider.value_changed.connect(_on_h_slider_value_changed)
	
	hslider.value = db_to_linear(
		AudioServer.get_bus_volume_db(busIndex)
	)
	
func _on_h_slider_value_changed(value: float):
	AudioServer.set_bus_volume_db(
		busIndex,
		linear_to_db(value)
	)
