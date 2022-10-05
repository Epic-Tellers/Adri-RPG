extends "res://Overlap/Hitbox.gd"
var FireGone = preload("res://Effects/FireGone.tscn")

export var FIREBALL_SPEED = 200
var direction setget direction_set, direction_get
var origin_position = Vector2.ZERO

func _ready():
	set_process(true)
	var TW = create_tween()
	TW.tween_interval(0.25)
	TW.tween_callback(self, "activate_world_collide")

func _process(delta):
	var motion =  (direction).normalized() * FIREBALL_SPEED
	self.position += motion * delta
	
func _on_Hitbox_area_entered(_area):
	queue_free()

func activate_world_collide():
	$WorldArea.monitoring = true

func direction_set(value):
	direction = value
	self.look_at(self.position + direction)

func direction_get():
	return direction

func set_origin_position(value):
	origin_position = value
	global_position = value

func set_damage(value):
	self.damage = value

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_WorldArea_body_entered(_body):
	var fireGone = FireGone.instance()
	fireGone.global_position = global_position
	fireGone.rotation = rotation
	fireGone.rotate(-PI/2)
	get_tree().current_scene.add_child(fireGone)
	queue_free()


func _on_WorldArea_area_entered(_area):
	var fireGone = FireGone.instance()
	fireGone.global_position = global_position
	fireGone.rotation = rotation
	fireGone.rotate(-PI/2)
	get_tree().current_scene.add_child(fireGone)
	queue_free()
