extends AnimatedSprite

func _ready():
	if self.connect("animation_finished", self,"_on_AnimatedSprite_animation_finished") != OK:
		print("Error trying to connect signal!") #conect a signal to a listener in code
	frame = 0
	play("Animate")
	
func _on_AnimatedSprite_animation_finished():
	queue_free()
