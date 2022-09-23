extends AudioStreamPlayer

export (Array, AudioStream) var sound_list
export var min_pitch := 1.0
export var max_pitch := 1.0
var sound_index := 0

func play_random_batcry():
	pitch_scale = rand_range(min_pitch, max_pitch)
	sound_index = sound_index + int(rand_range(0.0, sound_list.size()))
	sound_index %= sound_list.size()
	stream = sound_list[sound_index]
	self.play()
