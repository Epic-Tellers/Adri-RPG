extends "res://Overlap/Hitbox.gd"

export var FIREBALL_SPEED = 200
var direction = Vector2.ONE #direction to player, feeded to this on creation

func _ready():
	set_process(true)

func _process(delta):
	var motion =  direction * FIREBALL_SPEED
	self.position += motion * delta
	
func _on_Hitbox_area_entered(area):
	queue_free()
