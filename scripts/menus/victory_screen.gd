extends Control


func _on_exit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/menu.tscn")
