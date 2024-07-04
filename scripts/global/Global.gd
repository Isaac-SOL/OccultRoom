extends Node

var screenSize =  Vector2(640,360) #Vector2(1920,1080)
var viewport_size = DisplayServer.window_get_size()
var prevscene = null
var french: bool = false
var dithering: bool = true
var displayMode = 0
var langage = getLangage()
var time_played: int = 0
		
func setDisplayMode(index):
	if index == 0:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 
	elif index == 1:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_MAXIMIZED)
	displayMode = index
		
func setLangage(index):
	if index == 0:
		TranslationServer.set_locale("en")
	elif index == 1:
		TranslationServer.set_locale("fr")
	elif index == 2:
		TranslationServer.set_locale("pt")
	langage = index
	
func getLangage():
	if TranslationServer.get_locale() == "en_EN":
		return 0
	if TranslationServer.get_locale() == "fr_FR":
		return 1
	if TranslationServer.get_locale() == "pt_BR" or TranslationServer.get_locale() == "pt_PT":
		return 2
	else:
		return 0	
		


	
