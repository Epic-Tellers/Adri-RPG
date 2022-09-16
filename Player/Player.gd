extends KinematicBody2D

enum {
	MOVE,
	ROLL,
	ATTACK,
	SPIN_CHARGE,
	SPIN_HOLD,
	SPIN_RELEASE #spin = charged attack
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN #cause player default anim is idle left

export var MAX_SPEED = 100 #adjust manually
export var ACCELERATION = 500 #adjust manually
export var FRICTION = 500 #adjust manually
export var ROLL_SPEED = 140 #adjust manually
export var HITSTOP_POWER = 0.3 #adjust manually. closer to 0, the greatests the hitstop
export var HITSTOP_DURATION = 0.5 #adjust manually. this is in seconds.
export var INVINCIBILITY_DURATION = 0.6
export var SPIN_CHARGE_TIME = 1.5
export var SPIN_SPEED_MODIFIER = 0.45 

var stats = PlayerStats #since it is a singleton, you could skip this. However, this looks cleaner
var hitstop = Hitstop

const PlayerHurtSound = preload("res://Player/PlayerHurtSound.tscn")

onready var animationPlayer = $AnimationPlayer #this is called to play animations
onready var blinkAnimationPlayer = $BlinkAnimationPlayer
onready var animationTree = $AnimationTree #this is the tree with all the animations
onready var swordHitbox = $HitboxPivot/SwordHitbox
onready var hurtbox = $Hurtbox
onready var chargeTimer = $ChargeTimer
onready var chargeEffect = $ChargeEffect
onready var animationState = animationTree.get("parameters/playback") #this is used to travel() between nodes of the animation tree
																	#for example, animationState.travel("Attack") goes to the Attack node

func _ready():
	randomize()
	stats.connect("no_health",self,"queue_free")
	animationTree.active = true
	swordHitbox.knockback_vector = roll_vector

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
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	
	#from run ro attack state
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
	if Input.is_action_just_pressed("spin"):
		state = SPIN_CHARGE
		chargeTimer.start(SPIN_CHARGE_TIME)
	

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

func _on_Hurtbox_area_entered(area):
	stats.health -= area.damage
	hitstop.frame_freeze(HITSTOP_POWER, HITSTOP_DURATION)
	hurtbox.start_invincibility(INVINCIBILITY_DURATION)
	hurtbox.create_hit_effect()
	var playerHurtSoundInstance = PlayerHurtSound.instance()
	get_tree().current_scene.add_child(playerHurtSoundInstance)


func _on_Hurtbox_invincibility_started():
	blinkAnimationPlayer.play("Start")


func _on_Hurtbox_invincibility_ended():
	blinkAnimationPlayer.play("Stop")

func _on_ChargeTimer_timeout():
	if state == SPIN_CHARGE:
		state = SPIN_HOLD
		start_charge()
	
func get_input_vector():
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	input_vector = input_vector.normalized()
	return input_vector

func lost_charge():
	chargeEffect.visible = false;

func start_charge():
	chargeEffect.visible = true;

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
