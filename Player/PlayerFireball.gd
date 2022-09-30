extends "res://Overlap/Hitbox.gd"

const DieEffect = preload("res://Player/PlayerFireballDie.tscn")

export var FIREBALL_SPEED = 200
export var LIFE_TIME = 0.25
var direction setget direction_set, direction_get
var origin_position = Vector2.ZERO
var motion
onready var timer = $Timer
onready var sprite = $AnimatedSprite

func _ready():	
	set_process(true)
	timer.start(LIFE_TIME)
	
func _process(delta):
	motion =  (direction - origin_position).normalized() * FIREBALL_SPEED
	self.position += motion * delta
	knockback_vector = motion.normalized() * KNOCKBACK_FORCE
	
func _on_Hitbox_area_entered(_area):
	queue_free()

func direction_set(value):
	direction = value
	self.look_at(direction)
	self.rotate(-PI/2) #comepnsate for takeing roll vector as reference of direction
	

func direction_get():
	return direction

func set_origin_position(value):
	origin_position = value
	global_position = value

func set_damage(value):
	self.damage = value

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Timer_timeout():
	queue_free()
	var dieEffect = DieEffect.instance()
	get_tree().current_scene.add_child(dieEffect)
	dieEffect.global_position = global_position
	dieEffect.rotation = rotation
	dieEffect.motion = motion


func _on_WorldCollider_body_entered(body):
	queue_free()
	var dieEffect = DieEffect.instance()
	get_tree().current_scene.add_child(dieEffect)
	dieEffect.global_position = global_position
	dieEffect.rotation = rotation
	dieEffect.motion = motion/5

