extends Node2D

var myFrame = 0
var player = null
export var TARGET_SPEED = 300
const SoundScene = preload("res://Overlap/PickUpSound.tscn")
var targetPos = null
var ableToMove = false


func _ready():
	$BatSoul.frame = myFrame
	var TW = create_tween()
	TW.tween_property(self,"global_position",targetPos, 0.5)
	yield(TW,"finished")
	ableToMove = true
	

func _physics_process(delta):
		move_towards_player(delta)

func move_towards_player(delta):
	if player != null: #and player.is_instance_valid():
		if is_instance_valid(player) and ableToMove: 
			var motion =  (player.global_position - self.global_position).normalized() * 300
			self.position += motion * delta

func _on_PlayerDetectZone_body_entered(body):
	player = body
	
func _on_PlayerCollectZone_body_entered(_body):
	PlayerSaveInfo.addBatSoul()
	PlayerStats.batSoulsThisRun += 1
	var sound = SoundScene.instance()
	get_tree().current_scene.add_child(sound)
	queue_free()
