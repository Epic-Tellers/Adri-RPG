extends KinematicBody2D

enum {
	MOVE,
	ROLL,
	ATTACK,
	SPIN_CHARGE,
	SPIN_HOLD,
	SPIN_RELEASE, #spin = charged attack
	NONE
}

signal playerSpawned

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN #cause player default anim is idle left

export var MAX_SPEED_ORIGINAL = 100 #adjust manually
onready var MAX_SPEED = MAX_SPEED_ORIGINAL
export var ACCELERATION_ORIGINAL = 500 #adjust manually
onready var ACCELERATION = ACCELERATION_ORIGINAL
export var FRICTION = 500 #adjust manually
export var ROLL_SPEED_MODIFIER = 1.35 #adjust manually
onready var ROLL_SPEED = MAX_SPEED * ROLL_SPEED_MODIFIER
export var HITSTOP_POWER = 0.3 #adjust manually. closer to 0, the greatests the hitstop
export var HITSTOP_DURATION = 0.5 #adjust manually. this is in seconds.
export var ROLL_INVINCIBILITY = 0.25
export var INVINCIBILITY_DURATION = 1.1
export var SPIN_CHARGE_TIME = 1.5
export var SPIN_SPEED_MODIFIER = 0.45
export var CONE_OBERTURE = 10 #(degrees, gets multipled by n of fireballs)
export var DANCER_REDUCTION = 0.2
export var BABE_RUTH_AUGMENT = 15 #in raw units, so stack this scales linearly
export var DELAY_BETWEEN_HALOS = 0.6
var dancerBuffed = false

var stats = PlayerStats #since it is a singleton, you could skip this. However, this looks cleaner
var hitstop = Hitstop

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")
const PlayerGhost = preload("res://Player/Ghost.tscn")
const FireballScene = preload("res://Player/PlayerFireball.tscn")
const HaloScene = preload("res://Player/HaloEffect.tscn")
const AllyGhostBatScene = preload("res://Player/PlayerGhostBat.tscn")

onready var animationPlayer = $AnimationPlayer #this is called to play animations
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var animationTree = $AnimationTree #this is the tree with all the animations
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var chargeTimer = $ChargeTimer
onready var chargeEffect = $ChargeEffect
onready var chargeIndicator = $ChargeIndicator
onready var chargeOngoingSound = $ChargeAttack
onready var dancerAura = $DancerAura/circle_fade
onready var chargeCompletedSound = $ChargeCompleted
onready var ChargeTW
onready var animationState = animationTree.get("parameters/playback") #this is used to travel() between nodes of the animation tree
																	#for example, animationState.travel("Attack") goes to the Attack node

func _ready():
	randomize()
	if (stats.connect("no_health",self,"player_death")) != OK:
		print("Error in player trying to connect playerstats's no_health signal to player's player_death method")
	stats.connect("upgrades_change",self,"set_upgrades")
	animationTree.active = true
	dancerAura.visible = false
	swordHitbox.knockback_vector = roll_vector
	set_upgrades(stats.upgradeArrayStats)
	var world = get_tree().current_scene
	if (self.connect("playerSpawned",world,"_on_player_spawn")) != OK:
		print("Error in World trying to connect to player")
	else:
		emit_signal("playerSpawned",self)
# _process = update. Happens each frase AS FAST AS POSSIBLE -> delta is not constant
# _physics_process. Framerate is sinked to the physics. It waits until phys have already been processed. "stable" delta.



func _process(delta):
	# state machine incoming
	match state: #switch, but that you are matching CAN be a variable
		MOVE: 
			move_state(delta)
		ROLL: 
			roll_state(delta)
		ATTACK: 
			attack_state(delta)
		SPIN_CHARGE:
			spin_charge_state(delta)
		SPIN_HOLD:
			spin_hold_state(delta)
		SPIN_RELEASE:
			spin_release_state(delta)
		NONE:
			pass
	
func move_state(delta):
	var input_vector = get_input_vector()
	if input_vector != Vector2.ZERO:
		player_set_direction(input_vector)
		animationState.travel("Run")
		velocity = velocity.move_toward(input_vector * MAX_SPEED, ACCELERATION * delta) #moving towards FIRST arguemnt. By how much? SECOND argument
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move()
	
	if Input.is_action_just_pressed("Invul"):
		stats.invincible = !stats.invincible
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	
	#from run ro attack state
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
	if Input.is_action_just_pressed("spin"):
		state = SPIN_CHARGE
		chargeOngoingSound.play()
		if dancerBuffed:
			var time = SPIN_CHARGE_TIME - stats.upgradeArrayStats[3] * DANCER_REDUCTION
			chargeTimer.start(time)
			start_charge_indicator(time)
		else:
			chargeTimer.start(SPIN_CHARGE_TIME)
			start_charge_indicator(SPIN_CHARGE_TIME)

func attack_state(_delta):
	velocity = velocity / 2
	animationState.travel("Attack")


func spin_charge_state(delta):
	animationState.travel("SpinCharge")
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
		lost_charge()
	#from run ro attack state
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		lost_charge()
	if !Input.is_action_pressed("spin"):
		state = MOVE
		lost_charge()
	
	var input_vector = get_input_vector()
	if input_vector != Vector2.ZERO:
		animationState.travel("SpinRun")
		player_set_direction(input_vector)
		velocity = velocity.move_toward(input_vector * MAX_SPEED* SPIN_SPEED_MODIFIER, ACCELERATION * delta) #moving towards FIRST arguemnt. By how much? SECOND argument
		move()
	
func spin_hold_state(delta):
	animationState.travel("SpinHold")
	if Input.is_action_just_released("spin"):
			state = SPIN_RELEASE
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
		lost_charge()
	#from run ro attack state
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
		lost_charge()
		
	var input_vector = get_input_vector()
	if input_vector != Vector2.ZERO:
		animationState.travel("SpinRun")
		player_set_direction(input_vector)
		velocity = velocity.move_toward(input_vector * MAX_SPEED * SPIN_SPEED_MODIFIER, ACCELERATION * delta) #moving towards FIRST arguemnt. By how much? SECOND argument
		move()

func spin_release_state(_delta):
	animationState.travel("SpinRelease")
	lost_charge()

func roll_state(_delta):
	velocity = roll_vector * ROLL_SPEED 
	animationState.travel("Roll")
	move()

func move():
	velocity = move_and_slide(velocity) #move and slide -> not * delta. Move and collide? Yes * delta

func attack_animation_finished():
	state = MOVE

func roll_animation_fisnished():
	velocity = velocity * 0.8 #just having it slide a lot after roll is weird. But sliding a bit is nice.
	state = MOVE

func spin_animation_finished():
	state = MOVE
	#spawn_echo_halo() -> called directly from animation player

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hitstop.frame_freeze(HITSTOP_POWER, HITSTOP_DURATION)
	hurtbox.start_invincibility(INVINCIBILITY_DURATION)
	hurtbox.create_hit_effect()
	var playerHurtSoundInstance = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSoundInstance)

func roll_start_invincibility():
	hurtbox.start_invincibility_no_blink(ROLL_INVINCIBILITY)

func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")

func _on_ChargeTimer_timeout():
	if state == SPIN_CHARGE:
		state = SPIN_HOLD
		chargeOngoingSound.stop()
		chargeCompletedSound.play()
		start_charge()
	
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	return input_vector

func lost_charge():
	chargeOngoingSound.stop()
	stop_charge_indicator()
	chargeEffect.visible = false;

func start_charge():
	chargeEffect.visible = true;

func player_death():
	var ghost = PlayerGhost.instance()
	get_tree().current_scene.add_child(ghost)
	ghost.global_position = global_position
	queue_free()

func player_set_direction(input_vector):
	roll_vector = input_vector
	swordHitbox.knockback_vector = input_vector
	animationTree.set("parameters/Idle/blend_position", input_vector)
	animationTree.set("parameters/Run/blend_position", input_vector)
	animationTree.set("parameters/Attack/blend_position", input_vector)
	animationTree.set("parameters/Roll/blend_position", input_vector)
	animationTree.set("parameters/SpinCharge/blend_position", input_vector)
	animationTree.set("parameters/SpinHold/blend_position", input_vector)
	animationTree.set("parameters/SpinRelease/blend_position", input_vector)
	animationTree.set("parameters/SpinRun/blend_position", input_vector)

func set_upgrades(newArray):
	print(newArray)
	apply_berserker(newArray[0])
	apply_resilient(newArray[1])
	apply_sorcerer(newArray[2])
	apply_dancer(newArray[3])
	apply_babe_ruth(newArray[4])
	apply_echo(newArray[5])
	apply_resonant(newArray[6])
	apply_archmage(newArray[7])
	apply_herculean(newArray[8])

#func upgrade_array_got_changed(_value):
#	upgradeArray = stats.upgradeArrayStats
func apply_berserker(times):
	swordHitbox.damage = 1 + times
	stats.set_berskerker_modifier(times)
	
func apply_resilient(times):
	var nowMaxHealth = stats.max_health
	stats.max_health = stats.initialMaxHealth + times
	if stats.max_health > nowMaxHealth:
		stats.heal(stats.max_health)
	
func apply_sorcerer(_times):
	pass #when shooting fireball, we just access the array and see what number is there

func apply_dancer(_times):
	pass #when charging the attack, we just access the awwaya nd see what number is there

func apply_babe_ruth(times):
	swordHitbox.augment_knockback(1 + 0.25*times)
	ACCELERATION = ACCELERATION_ORIGINAL + BABE_RUTH_AUGMENT * times
	MAX_SPEED = MAX_SPEED_ORIGINAL + BABE_RUTH_AUGMENT * times
	update_roll_speed()

func apply_echo(_times):
	pass
func apply_resonant(times):
	print("Applied RESONANT atacks: " + str(times))
func apply_archmage(times):
	print("Applied ARCHMAGE atacks: " + str(times))
func apply_herculean(times):
	print("Applied HERCULEAN atacks: " + str(times))

func update_roll_speed():
	ROLL_SPEED = MAX_SPEED * ROLL_SPEED_MODIFIER 

func buff_dancer():
	if stats.upgradeArrayStats[3] > 0:
		dancerAura.visible = true
		dancerBuffed = true

func spend_buff_dancer():
	dancerBuffed = false
	dancerAura.visible = false

func on_fireball_check():
	var aux = stats.upgradeArrayStats[2]
	if aux > 0:
		fireball_attack(swordHitbox.global_position, roll_vector.normalized(), aux)

func fireball_attack(posSpawn, direction, times):
	if times == 1:
		instance_single_fireball(posSpawn, direction)
	else:
		instance_multiple_fireballs(posSpawn, direction, times)

func instance_single_fireball(posSpawn, direction):
	var fireball = FireballScene.instance()
	get_tree().current_scene.add_child(fireball)
	fireball.set_origin_position(posSpawn)
	fireball.direction_set(posSpawn + direction)
	fireball.set_damage(stats.berserkerModifier +1)

func instance_multiple_fireballs(posSpawn, direction, times):
	var actualCone = deg2rad(CONE_OBERTURE * times)
	var auxDirection = direction.rotated(-actualCone/2)
	var increment = actualCone / (times - 1)
	for n in times:
		var fireball = FireballScene.instance()
		fireball.set_damage(stats.berserkerModifier +1)
		get_tree().current_scene.add_child(fireball)
		fireball.set_origin_position(posSpawn)
		fireball.direction_set(posSpawn + auxDirection)
		auxDirection = auxDirection.rotated(increment)

func spawnAllyBat(pos): #from the necromancer / archmage upgrade
	#AllyGhostBatScene
	var spawns = stats.upgradeArrayStats[7]
	for times in spawns:
		var ally = AllyGhostBatScene.instance()
		ally.set_damage(stats.berserkerModifier +1)
		get_tree().current_scene.call_deferred("add_child", ally)
		var auxVec = Vector2(randi()%20 - 10, randi()%20 -10)
		ally.global_position = pos + auxVec

func resonant_spawn_halo(pos):
	var spawns = stats.upgradeArrayStats[6]
	if spawns > 0:
		var TW = create_tween().set_loops(spawns)
		TW.tween_callback(self, "spawn_one_halo",[pos])
		TW.tween_interval(DELAY_BETWEEN_HALOS)
		
func spawn_one_halo(pos):
	var halo = HaloScene.instance()
	halo.set_damage(stats.berserkerModifier +1)
	get_tree().current_scene.add_child(halo)
	halo.global_position = pos

func spawn_echo_halo():
	var spawns = stats.upgradeArrayStats[5] + 1
	print("got to check for spawns. Spawns: " +String(spawns))
	if spawns > 0:
		var TW = create_tween().set_loops(spawns)
		TW.tween_callback(self, "spawn_one_halo",[global_position])
		TW.tween_interval(DELAY_BETWEEN_HALOS)

func start_charge_indicator(time):
	chargeIndicator.visible = true
	ChargeTW = create_tween()
	ChargeTW.tween_property(chargeIndicator,"value",float(100),time)
	ChargeTW.tween_callback(self, "stop_charge_indicator")
	
func stop_charge_indicator():
	if ChargeTW.is_running():
		ChargeTW.stop()
	chargeIndicator.visible = false
	chargeIndicator.value = 0

func turn_white(): #called by next level collider on colision
	blinkAnimationPlayer.play("TurnWhite")

func set_state_none():
	state = NONE
	animationState.travel("Idle")
