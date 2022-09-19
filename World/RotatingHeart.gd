extends Node2D

onready var audioStreamPlayer = $AudioStreamPlayer

func _on_Area2D_body_entered(body):
	PlayerStats.heal(1)
	audioStreamPlayer.play()

func _on_AudioStreamPlayer_finished():
	queue_free()
