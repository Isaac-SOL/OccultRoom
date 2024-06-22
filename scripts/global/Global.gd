extends Node


var barMargin = 50
var ballSpeed = 650
var screenSize =  Vector2(640,360) #Vector2(1920,1080)
var playerSpeed = 550
var botDifficulty = 1
var botSpeed = 450
var viewport_size = DisplayServer.window_get_size()
var prevscene = null

func _process(delta):
	#setBotSpeed(botDifficulty)
	#get_viewport().size = viewport_size
	#calculScreensize()
	pass
	

func calculScreensize():
	screenSize = Vector2(1152,648) #DisplayServer.window_get_size()

func setBallSpeed(speed):
	ballSpeed = speed
	
func setPlayerSpeed(speed):
	playerSpeed = speed
	
func setBotSpeed(speed):
	if botDifficulty == 0:
		botSpeed = 300
	elif botDifficulty == 1:
		botSpeed = 450
	elif botDifficulty == 2:
		botSpeed = 700
	elif botDifficulty == 3:
		botSpeed = 900
	else:
		botSpeed = botSpeed
		
func setDisplayMode(index):
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
	elif index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
		
func setResolution(index):
	if index == 0:
		viewport_size = DisplayServer.screen_get_size()
	if index == 1:
		viewport_size = (Vector2i(1152,648))
	elif index == 2:
		viewport_size = (Vector2i(1920,1080))
	elif index == 3:
		viewport_size = (Vector2i(3840,2160))
	
func setBotDifficulty(difficulty):
	botDifficulty = difficulty
	
