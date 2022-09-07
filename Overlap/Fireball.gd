extends "res://Overlap/Hitbox.gd"

export var FIREBALL_SPEED = 200
var direction setget direction_set, direction_get
var origin_position = Vector2.ZERO

func _ready():
	set_process(true)

func _process(delta):
	var motion =  (direction - origin_position).normalized() * FIREBALL_SPEED
	self.position += motion * delta
	
func _on_Hitbox_area_entered(area):
	queue_free()

func direction_set(value):
	direction = value
	self.look_at(direction)

func direction_get():
	return direction

func set_origin_position(value):
	origin_position = value
	global_position = value
	
