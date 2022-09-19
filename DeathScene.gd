extends Control

onready var world = "res://World2.tscn"
onready var retry = $VBoxContainer/Button

func _ready():
	retry.grab_focus()

func _on_Button_pressed():
	PlayerStats.health = PlayerStats.max_health
	CrManager.reset_CR()
	get_tree().change_scene(world)

func _on_Button2_pressed():
	get_tree().quit()
