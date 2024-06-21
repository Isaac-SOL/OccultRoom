extends AudioStreamPlayer


#const audioGame = preload("res://assets/sounds/mixkit-infected-vibes-157.mp3")
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

