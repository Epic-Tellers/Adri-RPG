extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const Soul = preload("res://Enemies/BatSoul.tscn")

signal died(position)

enum {
	IDLE,
	WANDER,
	CHASE
}
var state = IDLE
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
export var KNOCKBACK_FORCE = 30
export var FLY_DRAG = 200
export var MAX_SPEED = 50
export var SOFT_COLLISION_FORCE = 400
export var INVINCIBILITY_DURATION = 0.3
export var CR_VALUE = 1
export var mySoulSprite = 0

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var enemyGroupZone = $EnemyGroupZone
onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer

func _ready():
	state = pick_random_new_state([IDLE, WANDER])
	sprite.frame = rand_range(0, 4)
	if PlayerStats.connect("no_health",self,"set_player_null") != OK:
		print("Error in a bat trying to connect player's no_health signal to bat's set_player_null method")
	
	
	
func _physics_process(delta):
	knockback = knockback.move_toward(Vector2.ZERO, FLY_DRAG * delta)
	knockback = move_and_slide(knockback)
	
	match state:
		IDLE:
			velocity = velocity.move_toward(Vector2.ZERO, FLY_DRAG * delta)
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
				
		WANDER:
			seek_player()
			if wanderController.get_time_left() == 0:
				update_wander()
			accelerate_towards_point(wanderController.target_position, delta)
			if global_position.distance_to(wanderController.target_position) <= MAX_SPEED * delta:
				update_wander()
				
		CHASE:
			var player = playerDetectionZone.player
			if player != null:
				accelerate_towards_point(player.global_position, delta)
			else:
				state = WANDER
				
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * SOFT_COLLISION_FORCE
	velocity = move_and_slide(velocity)

func update_wander():
	state = pick_random_new_state([IDLE, WANDER])
	wanderController.start_wander_timer(rand_range(1,3))

func accelerate_towards_point(position, delta):
	var direction = global_position.direction_to(position)
	velocity = velocity.move_toward(direction * MAX_SPEED, FLY_DRAG * delta)
	sprite.flip_h = velocity.x < 0
	
func seek_player():
	if playerDetectionZone.can_see_player():
		state = CHASE

func pick_random_new_state(state_list):
	state_list.shuffle()
	return state_list.pop_front()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	if area.knockback_vector != Vector2.ZERO:
		knockback = area.knockback_vector * (KNOCKBACK_FORCE + area.KNOCKBACK_FORCE)
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(INVINCIBILITY_DURATION)

func _on_Stats_no_health():
	emit_signal("died",global_position)
	print("I fired a DIED signal")
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position
	drop_souls()
	queue_free()

func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")

func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")

func _on_player_detected(body):
	if body != null:
		enemyGroupZone.call_all_allies(body)

func asign_player(body):
	playerDetectionZone.player = body

func set_player_null():
	playerDetectionZone.player = null
	state = WANDER

func drop_souls():
	for i in CR_VALUE * 2:
		var soulDrop = Soul.instance()
		soulDrop.myFrame = mySoulSprite
		var randVec = Vector2(randi() % 50 -25 , randi() % 50 - 25)
		soulDrop.targetPos = global_position + randVec
		get_tree().current_scene.call_deferred("add_child", soulDrop)
		soulDrop.global_position = self.global_position
