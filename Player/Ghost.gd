extends AnimatedSprite

func _ready():
	frame = 0
	play("Animate")
	var TW = create_tween()
	TW.tween_property(self,"modulate", Color(1,1,1,0), 1.9)
	yield(TW,"finished")
	queue_free()
