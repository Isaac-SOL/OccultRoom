class_name RebindButton
extends Control

@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button

@export var actionName : String = ""

func _ready():
	set_process_unhandled_key_input(false)
	set_action_name()
	set_key_text()
	
func set_action_name():
	label.text = "Unassigned"
	match actionName:
		"up":
			label.text ="Rotate Up"
		"down":
			label.text ="Rotate Down"
		"left":
			label.text ="Rotate Left"
		"right":
			label.text ="Rotate Right"
		"turn_left":
			label.text ="Rotate Left (on floor)"
		"turn_right":
			label.text ="Rotate Right (on floor)"
		"special":
			label.text ="Zoom"
		"pause":
			label.text ="Pause"

func set_key_text():
	var action_events = InputMap.action_get_events(actionName)
	var action_event = action_events[0]
	var action_keycode = OS.get_keycode_string(action_event.physical_keycode)
	
	
	button.text = "%s" % action_keycode


func _on_button_toggled(button_pressed):
	if button_pressed:
		button.text = "Press any key..."
		set_process_unhandled_key_input(button_pressed)
		for i in get_tree().get_nodes_in_group("RebindButtonGroup"):
			if i.actionName != self.actionName:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)
	else:
		for i in get_tree().get_nodes_in_group("RebindButtonGroup"):
			if i.actionName != self.actionName:
				i.button.toggle_mode = true
				i.set_process_unhandled_key_input(false)
		set_key_text()

func _unhandled_key_input(event):
	rebind_action_key(event)
	button.button_pressed = false
	
func rebind_action_key(event):
	InputMap.action_erase_events(actionName)
	InputMap.action_add_event(actionName, event)
	set_process_unhandled_key_input(false)
	set_key_text()
	set_action_name()
