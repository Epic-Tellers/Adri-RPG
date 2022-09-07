extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const FireballScene = preload("res://Overlap/Fireball.tscn")

enum {
	IDLE,
	WANDER,
	CHASE
}
var state = IDLE
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var canAttack = true

export var KNOCKBACK_FORCE = 130
export var FLY_DRAG = 200
export var MAX_SPEED = 50
export var SOFT_COLLISION_FORCE = 400
export var INVINCIBILITY_DURATION = 0.3
export var ATTACK_RANGE = 700
export var ATTACK_CD = 1.5

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer
onready var attackCD = $AttackCD
onready var fireballSpawnPoint = $FireballSpawnPoint
func _ready():
	state = pick_random_new_state([IDLE, WANDER])
	sprite.frame = rand_range(0, 4)
	
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
				if canAttack:
					try_to_attack(player.global_position)
			else:
				state = WANDER
				
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * SOFT_COLLISION_FORCE
	velocity = move_and_slide(velocity)

func try_to_attack(position):
	var attackRange = global_position.distance_to(position)
	if attackRange <= ATTACK_RANGE:
		fireball_attack(position) #vector looking up from the bat's mouth to the player

func fireball_attack(pos):
	var fireball = FireballScene.instance()
	get_tree().root.add_child(fireball)
	fireball.set_origin_position(fireballSpawnPoint.global_position)
	fireball.direction_set(pos)
	canAttack = false;
	attackCD.start(ATTACK_CD)
	
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
	knockback = area.knockback_vector * KNOCKBACK_FORCE
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(INVINCIBILITY_DURATION)

func _on_Stats_no_health():
	queue_free()
	var enemyDeathEffect = EnemyDeathEffect.instance()
	get_parent().add_child(enemyDeathEffect)
	enemyDeathEffect.global_position = global_position


func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")


func _on_AttackCD_timeout():
	canAttack = true
