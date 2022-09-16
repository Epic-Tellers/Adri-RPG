extends Control

onready var world = "res://World2.tscn"

func _on_Button_pressed():
	PlayerStats.health = PlayerStats.max_health
	get_tree().change_scene(world)
