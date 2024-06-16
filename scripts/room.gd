class_name Room extends Node3D

func _ready():
	Singletons.room = self

func stool_placed():
	%OuijaPlacementPoint.process_mode = Node.PROCESS_MODE_INHERIT
	%StoolPlacementPoint.process_mode = Node.PROCESS_MODE_DISABLED
