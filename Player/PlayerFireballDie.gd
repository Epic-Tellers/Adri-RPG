extends AnimatedSprite
var motion

func _ready():
	frame = 0
	play("Animate")

func _process(delta):
	self.position += motion * delta *0.85

func _on_PlayerFireballDie_animation_finished():
	queue_free()
