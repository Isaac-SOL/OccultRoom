extends AudioStreamPlayer


const audioGame = preload("res://assets/audio/ambiant/occult_room_ambiant.ogg")
#const audioMenu = preload("res://assets/sounds/infected_vibes_low.mp3")

func playMusic(music: AudioStream):
	if stream == music:
		if playing == false:
			play()
		return
	stream = music
	play()
	
func playAudio(audio):
	playMusic(audio)

