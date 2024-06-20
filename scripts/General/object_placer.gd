@tool 
extends Node

@export var object: PlaceableObject
@export var point: ObjectPlacementPoint
@export var click_to_place_object: bool : set = _click
@export_multiline var info: String = "Assign the object and point you want to link then click the box."

func _click(_new_state: bool):
	if object and point:
		if object.holder:
			object.holder.holding_object = null
		if point.holding_object:
			point.holding_object.holder = null
		object.holder = point
		point.holding_object = object
		object.global_position = point.global_position
		point = null
		info = "Object linked to placement point!"
	else:
		info = "Assign the object and point you want to link then click the box."
