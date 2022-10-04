extends Control

onready var label = $RegularWaveLabel
const time = 0.6

func _ready():
	if CrManager.CR_INCREMENT != 0: #just in case...
		label.text = "WAVE "+ str(CrManager.get_wave_number())

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
	var TW = create_tween()
	TW.tween_interval(0.5)
	TW.tween_interval(0.1) #the 2 paralel below take this into the same call
	TW.parallel().tween_property(label,"rect_scale",Vector2(4,4),time)
	TW.parallel().tween_property(label,"modulate",Color(1,0,0,1),time).set_trans(Tween.TRANS_EXPO)
	TW.parallel().tween_callback($AudioStreamPlayer,"play")
	TW.tween_property(self,"modulate",Color(1,1,1,0),time*0.7)
	yield(TW,"finished")
	queue_free()
