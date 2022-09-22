extends Control

onready var startButton = $VBoxContainer/StartButton
onready var world1 = "res://World1.tscn"
onready var world2 = "res://World2.tscn"
onready var options = "res://OptionsMenu.tscn"
onready var worlds = [world1, world2]

func _ready():
	randomize()
	startButton.grab_focus()

func _on_StartButton_pressed():
	worlds.shuffle()
	var scene = worlds.back()
	if get_tree().change_scene(scene) != OK:
		print("Error in MainScene trying to change scene to: " +String(scene))

func _on_OptionsButton_pressed():
	if get_tree().change_scene(options) != OK:
		print("Error in MainScene trying to change scene to: " +String(options))
	pass


func _on_QuitButton_pressed():
	get_tree().quit()
