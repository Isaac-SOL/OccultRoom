extends AudioStreamPlayer

var pause = false

const audioGame = preload("res://assets/audio/ambiant/occult_room_ambiant.ogg")
const audioMenu = preload("res://assets/audio/ambiant/occultroom_mainMenu.ogg")
const audioTransit = preload("res://assets/audio/ambiant/occultroom_transit.ogg")

func playAudio(music: AudioStream):
	if !pause:
		if stream == music:
			if playing == false:
				play()
			return
		stream = music
		play()

func pauseAudio():
	if playing == true:
		stop()
	pause = !pause
		
