extends Control


func _ready():
	$MarginContainer/VBoxContainer2/HBoxContainer/VBoxContainer/Label2.text = " "+getTimePlayedMinute(Global.time_played)+"min"

func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/menu.tscn")

func getTimePlayedMinute(time:int):
	return str(time/60)
