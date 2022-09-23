extends Node2D

onready var portal1 = $Portal1
onready var portal2 = $Portal2
onready var sprite1 = $Portal1/Sprite
onready var sprite2 = $Portal2/Sprite
onready var timer = $Cooldown
onready var sound = $TPSound

export var COOLDOWN = 5.0

var operative = true

func _ready():
	sprite1.play("Animate")
	sprite2.play("Animate")


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
