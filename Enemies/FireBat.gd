extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const FireballScene = preload("res://Overlap/Fireball.tscn")
const ExplosionEffect = preload("res://Effects/ExplosionEffect.tscn")

enum {
	IDLE,
	WANDER,
	CHASE,
	FLEE,
	EXPLODE
}
var state = IDLE
var velocity = Vector2.ZERO
var knockback = Vector2.ZERO
var canAttack = true
var fireballRounds = 0

export var KNOCKBACK_FORCE = 130 #how hard is pushed back upon getting hit
export var FLY_DRAG = 200 #fly acc
export var MAX_SPEED = 50 #max speed of bat
export var SOFT_COLLISION_FORCE = 400 #how aggresively it tries to stay away from other bats
export var INVINCIBILITY_DURATION = 0.3 #invul time after getting hit
export var ATTACK_RANGE = 800 #range at which it can shoot fireballs
export var ATTACK_CD = 1.5 #interval between fireballs at optimum speed
export var ATTACK_WAVES = 1 #how many rounds of fireballs it shoots on its attack round
export var ATTACK_INSTANCES = 1 #how many fireballs it shoots in a round
export var DEATH_DELAY = 0.6 #time that it waits before exploding
export var WAVE_DELAY = 0.3 #delay between shots in same round of attack
export var CR_VALUE = 3 #Challenge Rating of the enemy
export var FLEE_RANGE = 300 #Range at which it will flee player
export var CONE_OBERTURE = 25 #Oberture on the cone if shooting multiple fireballs

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer
onready var animationPlayerExplode = $AnimationPlayerExplode
onready var attackCD = $AttackCD
onready var fireballSpawnPoint = $FireballSpawnPoint
onready var deathDealy = $DeathDealy
onready var audioStreamPlayer = $AudioStreamPlayer

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
					try_to_avoid(player.global_position)
			else:
				state = WANDER
		
		FLEE:
			if canAttack:
				state = CHASE
			else:
				var player = playerDetectionZone.player
				if player != null:
					var fleeVector = Vector2(global_position - player.global_position)
					accelerate_towards_point(global_position + fleeVector, delta)
				else:
					state = WANDER
		EXPLODE:
			velocity = velocity.move_toward(Vector2.ZERO, FLY_DRAG * delta)
			
	if softCollision.is_colliding():
		velocity += softCollision.get_push_vector() * delta * SOFT_COLLISION_FORCE
	velocity = move_and_slide(velocity)

func try_to_attack(position):
	var attackRange = global_position.distance_to(position)
	if attackRange <= ATTACK_RANGE:
		fireball_attack(position, ATTACK_INSTANCES) #vector looking up from the bat's mouth to the player

func try_to_avoid(position):
	if global_position.distance_to(position) <= FLEE_RANGE:
		state = FLEE
	else:
		state = WANDER
	
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

func rounds_update():
	fireballRounds += 1
	if fireballRounds >= ATTACK_WAVES:
		attackCD.start(ATTACK_CD)
		fireballRounds = 0
	else:
		attackCD.start(WAVE_DELAY)

func fireball_attack(pos, times):
	if times == 1:
		instance_single_fireball(pos)
	else:
		instance_multiple_fireballs(pos,times) 
	canAttack = false;
	rounds_update()

func instance_single_fireball(pos):
	var fireball = FireballScene.instance()
	get_tree().root.add_child(fireball)
	fireball.set_origin_position(fireballSpawnPoint.global_position)
	fireball.direction_set(pos)

func instance_multiple_fireballs(pos, times):
	var auxOrigin = (pos - Vector2(CONE_OBERTURE*0.5,CONE_OBERTURE*0.5))
	var increment = CONE_OBERTURE / (times - 1)
	for n in times:
		var fireball = FireballScene.instance()
		get_tree().root.add_child(fireball)
		fireball.set_origin_position(fireballSpawnPoint.global_position)
		fireball.direction_set(auxOrigin)
		auxOrigin += Vector2(increment, increment)

#func fireball_attack(pos): 
#	var fireball = FireballScene.instance()
#	get_tree().root.add_child(fireball)
#	fireball.set_origin_position(fireballSpawnPoint.global_position)
#	fireball.direction_set(pos)
#	canAttack = false;
#	rounds_update()
#
#func double_fireball_attack(pos): 
#	var fireball1 = FireballScene.instance()
#	var fireball2 = FireballScene.instance()
#	get_tree().root.add_child(fireball1)
#	get_tree().root.add_child(fireball2)
#	fireball1.set_origin_position(fireballSpawnPoint.global_position)
#	fireball2.set_origin_position(fireballSpawnPoint.global_position)
#	fireball1.direction_set(pos + Vector2(CONE_OBERTURE*0.5,CONE_OBERTURE*0.5))
#	fireball2.direction_set(pos - Vector2(CONE_OBERTURE*0.5,CONE_OBERTURE*0.5))
#	canAttack = false;
#	rounds_update()
#
#func triple_fireball_attack(pos): #number = number of fireballs to shoot
#	var fireball1 = FireballScene.instance()
#	var fireball2 = FireballScene.instance()
#	var fireball3 = FireballScene.instance()
#	get_tree().root.add_child(fireball1)
#	get_tree().root.add_child(fireball2)
#	get_tree().root.add_child(fireball3)
#	fireball1.set_origin_position(fireballSpawnPoint.global_position)
#	fireball2.set_origin_position(fireballSpawnPoint.global_position)
#	fireball3.set_origin_position(fireballSpawnPoint.global_position)
#	fireball1.direction_set(pos + Vector2(CONE_OBERTURE*0.5,CONE_OBERTURE*0.5))
#	fireball2.direction_set(pos - Vector2(CONE_OBERTURE*0.5,CONE_OBERTURE*0.5))
#	fireball3.direction_set(pos)
#	canAttack = false;
#	rounds_update()

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	knockback = area.knockback_vector * KNOCKBACK_FORCE
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(INVINCIBILITY_DURATION)

func _on_Stats_no_health():
	state = EXPLODE
	deathDealy.start(DEATH_DELAY)
	animationPlayerExplode.play("Explode")
	audioStreamPlayer.play()

func death_explosion():
	queue_free()
	animationPlayer.play("Stop")
	var explosionEffect = ExplosionEffect.instance()
	get_parent().add_child(explosionEffect)
	explosionEffect.global_position = sprite.global_position


func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")


func _on_AttackCD_timeout():
	canAttack = true


func _on_DeathDealy_timeout():
	death_explosion()

func get_bigger():
	sprite.scale += Vector2(0.3,0.3)
	sprite.global_position -= Vector2(0,0.15)
