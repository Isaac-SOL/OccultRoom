class_name CodeChest extends PlaceableObject

@export var code: String = "0000"

var code_parts: Array[CodePart]
var opened: bool = false

func _ready():
	super._ready()
	for child: Node in get_children():
		if child is CodePart:
			code_parts.append(child)
			child.clicked.connect(_on_code_part_clicked)
	start_inspecting.connect(_on_code_chest_start_inspecting)
	stop_inspecting.connect(_on_code_chest_stop_inspecting)

func _on_code_chest_start_inspecting():
	if not opened:
		for code_part: CodePart in code_parts:
			code_part.set_active(true)

func _on_code_chest_stop_inspecting():
	if not opened:
		for code_part: CodePart in code_parts:
			code_part.set_active(false)

func _on_code_part_clicked(part: CodePart):
	part.set_number((part.number + 1) % 10)
	if check_code():
		open_chest()

func check_code() -> bool:
	for i: int in range(code.length()):
		if code[i] != str(code_parts[i].number):
			return false
	return true

func open_chest():
	%MeshInstance3D.visible = false
	for code_part: CodePart in code_parts:
		code_part.visible = false
		code_part.set_active(false)
	%Content.visible = true
	var light_area = find_child("LightArea")
	if light_area:
		light_area.set_deferred("monitoring", true)
		light_area.set_deferred("monitorable", true)
	hints = [OuijaSystem.Pos.FLATWOODS, OuijaSystem.Pos.FAR,
			 OuijaSystem.Pos.MOON, OuijaSystem.Pos.FAR]
	$code_chest.anim_chest()
	%OpenAudio.play()
	$Outline/ChestOutline1.visible = false
	$Outline/ChestOutline2.visible = false
	$Outline/Outline.visible = true
	special_name = "BougieChandelier"
