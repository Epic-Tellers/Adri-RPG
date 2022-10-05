extends Node2D

onready var portal1 = $Portal1
onready var portal2 = $Portal2
onready var arrow1 = $Portal1/Arrow
onready var arrow2 = $Portal2/Arrow
onready var sprite1 = $Portal1/Sprite
onready var sprite2 = $Portal2/Sprite
onready var timer = $Cooldown
onready var sound = $TPSound

export var COOLDOWN = 5.0

var operative = true

func _ready():
	sprite1.play("Animate")
	sprite2.play("Animate")
	set_arrows()


func _on_PortalDoor1_body_entered(body):
	if operative:
		sound.play()
		body.global_position = portal2.global_position + Vector2 (0,10)
		deactivate_portals()

func _on_PortalDoor2_body_entered(body):
	if operative:
		sound.play()
		body.global_position = portal1.global_position + Vector2 (0,10)
		deactivate_portals()
	
func _on_Cooldown_timeout():
	operative = true
	sprite1.play("Animate")
	sprite2.play("Animate")

func deactivate_portals():
	operative = false
	sprite1.play("Cooldown")
	sprite2.play("Cooldown")
	timer.start(COOLDOWN)

func set_arrows():
	arrow1.look_at(arrow2.global_position)
	arrow2.look_at(arrow1.global_position)
	arrow1.rotate(PI/2)
	arrow2.rotate(PI/2)
	var scale = arrow1.scale
	var TW = create_tween().set_loops()
	TW.tween_property(arrow1,"scale",scale*1.3,0.5).set_trans(Tween.TRANS_BACK)
	TW.parallel().tween_property(arrow2,"scale",scale*1.3,0.5).set_trans(Tween.TRANS_BACK)
	TW.tween_interval(0.3)
	TW.tween_property(arrow1,"scale",scale,0.5).set_trans(Tween.TRANS_BACK)
	TW.parallel().tween_property(arrow2,"scale",scale,0.5).set_trans(Tween.TRANS_BACK)
