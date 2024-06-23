extends AudioStreamPlayer


const audioGame = preload("res://assets/audio/ambiant/occult_room_ambiant.ogg")
const audioMenu = preload("res://assets/audio/ambiant/occultroom_mainMenu.ogg")
const audioTransit = preload("res://assets/audio/ambiant/occultroom_transit.ogg")

func playMusic(music: AudioStream):
	if stream == music:
		if playing == false:
			play()
		return
	stream = music
	play()
	
func playAudio(audio):
	playMusic(audio)

