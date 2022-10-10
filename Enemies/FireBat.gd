extends KinematicBody2D

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")
const FireballScene = preload("res://Overlap/Fireball.tscn")
const ExplosionEffect = preload("res://Effects/ExplosionEffect.tscn")
const ChargeFireballEffect = preload("res://Enemies/FireballCharge.tscn")
const Soul = preload("res://Enemies/BatSoul.tscn")

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

signal died(position)
signal requestTeleport(position)

export var EXPLODE_ON_DEATH = true
export var KNOCKBACK_FORCE = 30 #how hard is pushed back upon getting hit
export var FLY_DRAG = 170 #fly acc
export var MAX_SPEED = 35 #max speed of bat
export var SOFT_COLLISION_FORCE = 400 #how aggresively it tries to stay away from other bats
export var INVINCIBILITY_DURATION = 0.3 #invul time after getting hit
export var ATTACK_RANGE = 300 #range at which it can shoot fireballs
export var ATTACK_CD = 1.5 #interval between fireballs at optimum speed
export var ATTACK_WAVES = 1 #how many rounds of fireballs it shoots on its attack round
export var ATTACK_INSTANCES = 1 #how many fireballs it shoots in a round
export var DEATH_DELAY = 0.6 #time that it waits before exploding
export var WAVE_DELAY = 0.3 #delay between shots in same round of attack
export var CR_VALUE = 3 #Challenge Rating of the enemy
export var FLEE_RANGE = 100 #Range at which it will flee player
export var CONE_OBERTURE = 20 #Oberture on the cone if shooting multiple fireballs
export var mySoulSprite = 0

onready var stats = $Stats
onready var playerDetectionZone = $PlayerDetectionZone
onready var sprite = $AnimatedSprite
onready var hurtbox = $Hurtbox
onready var enemyGroupZone = $EnemyGroupZone
onready var softCollision = $SoftCollision
onready var wanderController = $WanderController
onready var animationPlayer = $AnimationPlayer
onready var animationPlayerExplode = $AnimationPlayerExplode
onready var attackCD = $AttackCD
onready var fireballSpawnPoint = $FireballSpawnPoint
onready var deathDealy = $DeathDealy
onready var audioStreamPlayer = $AudioStreamPlayer
onready var stuckChecker = $StuckChecker

func _ready():
	state = pick_random_new_state([IDLE, WANDER])
	sprite.frame = rand_range(0, 4)
	if PlayerStats.connect("no_health",self,"set_player_null") != OK:
		print("Error in a bat trying to connect player's no_health signal to bat's set_player_null method")
	
	if stuckChecker.connect("stucked",self,"_on_stucked") != OK:
		print("Error in bat.gd trying to connect StuckChecker's stuck signal to self _on_stucked method")
	
	
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
			if canAttack and check_safety():
				state = CHASE
			else:
				if playerDetectionZone.player != null:
					var fleeVector = Vector2(global_position - playerDetectionZone.player.global_position)
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
		canAttack = false;
		var chargeFireball = ChargeFireballEffect.instance()
		sprite.add_child(chargeFireball)
		chargeFireball.connect("animation_finished",self,"_on_charge_completed")
		
func _on_charge_completed():
	var player = playerDetectionZone.player
	if player != null:
		fireball_attack(player.global_position, ATTACK_INSTANCES) #vector looking up from the bat's mouth to the player

func try_to_avoid(position):
	if playerDetectionZone.player != null:
		if global_position.distance_to(position) <= FLEE_RANGE:
			state = FLEE
		else:
			state = WANDER

func check_safety():
	if global_position.distance_to(playerDetectionZone.player.global_position) <= FLEE_RANGE:
		return false
	else:
		return true
	
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
	rounds_update()

func instance_single_fireball(pos):
	var direction = (pos - fireballSpawnPoint.global_position).normalized() 
	var fireball = FireballScene.instance()
	get_tree().root.add_child(fireball)
	fireball.set_origin_position(fireballSpawnPoint.global_position)
	fireball.direction_set(direction)

#func instance_multiple_fireballs(posSpawn, direction, times):
#	var actualCone = deg2rad(CONE_OBERTURE * times)
#	var auxDirection = direction.rotated(-actualCone/2)
#	var increment = actualCone / (times - 1)
#	for n in times:
#		var fireball = FireballScene.instance()
#		fireball.set_damage(stats.berserkerModifier +1)
#		get_tree().current_scene.add_child(fireball)
#		fireball.set_origin_position(posSpawn)
#		fireball.direction_set(posSpawn + auxDirection)
#		auxDirection = auxDirection.rotated(increment)

func instance_multiple_fireballs(pos, times):
	var actualCone = deg2rad(CONE_OBERTURE * times)
	var direction = (pos - fireballSpawnPoint.global_position).normalized()
	var auxDirection = direction.rotated(-actualCone/2)
	var increment = actualCone / (times - 1)
	for n in times:
		var fireball = FireballScene.instance()
		get_tree().current_scene.add_child(fireball)
		fireball.set_origin_position(fireballSpawnPoint.global_position)
		fireball.direction_set(auxDirection)
		auxDirection = auxDirection.rotated(increment)

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	if area.knockback_vector != Vector2.ZERO:
		knockback = area.knockback_vector * (KNOCKBACK_FORCE + area.KNOCKBACK_FORCE)
	hurtbox.create_hit_effect()
	hurtbox.start_invincibility(INVINCIBILITY_DURATION)

func _on_Stats_no_health():
	if (EXPLODE_ON_DEATH):
		state = EXPLODE
		deathDealy.start(DEATH_DELAY)
		animationPlayerExplode.play("Explode")
		audioStreamPlayer.play()
	else:
		emit_signal("died",global_position)
		print("I fired a DIED signal")
		var enemyDeathEffect = EnemyDeathEffect.instance()
		get_parent().add_child(enemyDeathEffect)
		enemyDeathEffect.global_position = global_position
		enemyDeathEffect.scale = self.scale
		drop_souls()
		queue_free()

func drop_souls():
	for i in CR_VALUE * 2:
		var soulDrop = Soul.instance()
		soulDrop.myFrame = mySoulSprite
		var randVec = Vector2(randi() % 50 -25 , randi() % 50 - 25)
		soulDrop.targetPos = global_position + randVec
		get_tree().current_scene.call_deferred("add_child", soulDrop)
		soulDrop.global_position = self.global_position

func death_explosion():
	queue_free()
	drop_souls()
	emit_signal("died",global_position)
	print("I fired a DIED signal")
	animationPlayer.play("Stop")
	var explosionEffect = ExplosionEffect.instance()
	get_parent().add_child(explosionEffect)
	explosionEffect.global_position = sprite.global_position


func _on_Hurtbox_invincibility_started():
	animationPlayer.play("Start")
	canAttack = false
	attackCD.start(ATTACK_CD)
	

func _on_Hurtbox_invincibility_ended():
	animationPlayer.play("Stop")


func _on_AttackCD_timeout():
	canAttack = true


func _on_DeathDealy_timeout():
	death_explosion()

func get_bigger():
	sprite.scale += Vector2(0.3,0.3)
	sprite.global_position -= Vector2(0,0.15)

func _on_player_detected(body):
	enemyGroupZone.call_all_allies(body)

func asign_player(body):
	if body != null:
		playerDetectionZone.player = body

func set_player_null():
	playerDetectionZone.player = null
	state = WANDER

func _on_stucked():
	emit_signal("requestTeleport", self.global_position)
