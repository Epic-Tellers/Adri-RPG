extends Particles2D

func _ready():
	var TW = create_tween()
	TW.tween_interval(self.lifetime)
	TW.tween_callback(self,"queue_free")
