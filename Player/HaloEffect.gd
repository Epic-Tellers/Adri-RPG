extends "res://Overlap/Hitbox.gd"

export var TIME_TO_EXPAND = 0.25
export var SCALE_TO_EXPAND = 6

func _ready():
	var TW = create_tween()
	TW.tween_property(self,"scale",Vector2(SCALE_TO_EXPAND,SCALE_TO_EXPAND),TIME_TO_EXPAND)
	yield(TW,"finished")
	queue_free()
