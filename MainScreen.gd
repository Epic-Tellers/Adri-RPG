extends Control

onready var startButton = $VBoxContainer/StartButton
onready var world1 = "res://World1.tscn"
onready var world2 = "res://World2.tscn"
onready var options = "res://OptionsMenu.tscn"
onready var worlds = [world1, world2]

var OptionsMenuScene = preload("res://OptionsMenu.tscn")
var optionsMenuScene = null

func _ready():
	randomize()
	startButton.grab_focus()

func _on_StartButton_pressed():
	worlds.shuffle()
	var scene = worlds.back()
	if get_tree().change_scene(scene) != OK:
		print("Error in MainScene trying to change scene to: " +String(scene))

func _on_OptionsButton_pressed():
	optionsMenuScene = OptionsMenuScene.instance()
	add_child(optionsMenuScene)
	optionsMenuScene.connect("back_pressed",self,"_on_options_back_pressed")
	toggle_hide()

func _on_options_back_pressed():
		if optionsMenuScene != null:
			optionsMenuScene.queue_free()
			toggle_hide()
			startButton.grab_focus()

func _on_QuitButton_pressed():
	get_tree().quit()
	

func toggle_hide():
	$VBoxContainer.set_visible(!$VBoxContainer.visible)
	$Control.set_visible(!$Control.visible)
	$Label.set_visible(!$Label.visible)
