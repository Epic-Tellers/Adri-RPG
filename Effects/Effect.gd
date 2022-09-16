extends AnimatedSprite

func _ready():
	self.connect("animation_finished", self,"_on_AnimatedSprite_animation_finished") #conect a signal to a listener in code
	frame = 0
	play("Animate")
	
func _on_AnimatedSprite_animation_finished():
	queue_free()
