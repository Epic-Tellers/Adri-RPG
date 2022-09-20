extends Control

onready var startButton = $VBoxContainer/StartButton

func _ready():
	startButton.grab_focus()

func _on_StartButton_pressed():
	var scene = "res://World2.tscn"
	if get_tree().change_scene(scene) != OK:
		print("An unexpected error occured when trying to switch to the scene: " + scene)


func _on_OptionsButton_pressed():
	var scene = "res://OptionsMenu.tscn"
	if get_tree().change_scene(scene) != OK:
		print("An unexpected error occured when trying to switch to the scene: " + scene)


func _on_QuitButton_pressed():
	get_tree().quit()
