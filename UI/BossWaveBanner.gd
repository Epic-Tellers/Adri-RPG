extends Control

onready var sword = $Sword1
onready var sword2 = $Sword2
onready var label = $BossWaveLabel
onready var sound = $SwordClash
const time = 0.6

func _ready():
	var TW = create_tween()
	TW.tween_interval(0.5)
	TW.tween_property(sword2,"rotation_degrees",-180.0,time).set_trans(Tween.TRANS_BOUNCE)
	TW.parallel().tween_property(sword,"rotation_degrees",180.0,time).set_trans(Tween.TRANS_BOUNCE)
	TW.parallel().tween_property(label,"rect_scale",Vector2(4,4),time)
	TW.parallel().tween_property(label,"modulate",Color(1,0,0,1),time).set_trans(Tween.TRANS_EXPO)
	TW.parallel().tween_callback(sound,"play")
	TW.tween_interval(0.8)
	TW.tween_property(self,"modulate",Color(1,1,1,0),time/2)
	yield(TW,"finished")
	queue_free()
