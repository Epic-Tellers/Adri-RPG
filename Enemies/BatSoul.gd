extends Node2D

var myFrame = 0
var player = null
export var TARGET_SPEED = 300
var speed = 0
const SoundScene = preload("res://Overlap/PickUpSound.tscn")

func _ready():
	$BatSoul.frame = myFrame
	var TW = create_tween()
	TW.tween_property(self,"speed",TARGET_SPEED,1.0)

func _physics_process(delta):
	if player != null:
		move_towards_player(delta)

func move_towards_player(delta):
	if player != null:
		var motion =  (player.global_position - self.global_position).normalized() * speed
		self.position += motion * delta

func _on_PlayerDetectZone_body_entered(body):
	player = body

func _on_PlayerCollectZone_body_entered(_body):
	PlayerSaveInfo.addBatSoul()
	PlayerStats.batSoulsThisRun += 1
	var sound = SoundScene.instance()
	get_tree().current_scene.add_child(sound)
	queue_free()
