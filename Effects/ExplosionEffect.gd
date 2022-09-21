extends Sprite

onready var ExplosionEffect = $ExplosionEffect

func _ready():
	ExplosionEffect.play("Explosion")


func _on_MySound_finished():
	queue_free()
