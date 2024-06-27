extends Control

var screensize = Global.screenSize

func _ready():
	screensize = Global.screenSize
	get_viewport().size = Global.viewport_size
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$MarginContainer2/MarginContainer/VBoxContainer/NewGameButton.grab_focus()

func _process(delta):
	screensize = Global.screenSize
	NodeAudio.playAudio(NodeAudio.audioMenu)
	
func _on_new_game_button_pressed():
	$AudioTransitEffect.play()
	#await $AudioTransitEffect.finished
	NodeAudio.playAudio(NodeAudio.audioTransit)
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_quit_button_pressed():
	get_tree().quit()

func _on_option_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/options.tscn")

func _on_credit_button_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/credits.tscn")

func _on_check_button_toggled(toggled_on):
	Global.french = toggled_on

func _on_dither_button_toggled(toggled_on):
	Global.dithering = toggled_on
