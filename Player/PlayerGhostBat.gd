extends KinematicBody2D

export var LIFETIME = 4
export var SPEED = 60

var targetBat = null
var velocity = Vector2.ZERO

onready var sprite = $AnimatedSprite
onready var enemySeeker = $EnemySeeker
onready var softCollision = $SoftCollision

func _ready():
	var TW = create_tween()
	TW.tween_interval(LIFETIME)
	TW.tween_property(self,"modulate", Color(1, 1, 1, 0),1.5)
	TW.tween_callback(self, "queue_free")

func _physics_process(delta):
	if targetBat != null:
		if is_instance_valid(targetBat):
			accelerate_towards_point(targetBat.global_position, delta)
		else:
			targetBat = null
	else:
		var enemies = enemySeeker.get_overlapping_bodies()
		for item in enemies:
			if item != null:
				targetBat = item
				break
	#-----------------------------------------------------------------------
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * 100
	velocity = move_and_slide(velocity)
#
#func _on_EnemySeeker_body_entered(body):
#	if targetBat == null:
#		targetBat = body

func accelerate_towards_point(position, delta):
	var direction = global_position.direction_to(position)
	velocity = velocity.move_toward(direction * SPEED, 250 * delta)
	sprite.flip_h = velocity.x < 0
