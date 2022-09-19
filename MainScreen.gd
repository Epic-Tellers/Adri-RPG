extends Control

onready var startButton = $VBoxContainer/StartButton

func _ready():
	startButton.grab_focus()

func _on_StartButton_pressed():
	get_tree().change_scene("res://World2.tscn")


func _on_OptionsButton_pressed():
	get_tree().change_scene("res://OptionsMenu.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
