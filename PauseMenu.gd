extends CanvasLayer

onready var continueButton = $MarginContainer/Panel/MarginContainer/VBoxContainer/ContinueButton
onready var optionsButton = $MarginContainer/Panel/MarginContainer/VBoxContainer/OptionsButton
onready var mainMenuButton = $MarginContainer/Panel/MarginContainer/VBoxContainer/MainMenuButton

var mainMenuPath = "res://MainScreen.tscn"

const OptionsMenuScene = preload("res://OptionsMenu.tscn")
var optionsMenuInstance = null

func _ready():
	continueButton.grab_focus()
	get_tree().paused = true

func unpause():
	queue_free()
	get_tree().paused = false

func _on_ContinueButton_pressed():
	unpause()

func _on_OptionsButton_pressed():
	optionsMenuInstance = OptionsMenuScene.instance()
	add_child(optionsMenuInstance)
	optionsMenuInstance.connect("back_pressed",self,"_on_options_back_pressed")
	$MarginContainer.visible = false

func _on_options_back_pressed():
	continueButton.grab_focus()
	optionsMenuInstance.queue_free()
	$MarginContainer.visible = true

func _on_MainMenuButton_pressed():
#	if get_tree().change_scene(mainMenuPath) != OK:
#		print("Error in Pause Menu trying to change scene to: " +String(mainMenuPath))
	unpause()
	ScreenTransitionManager.transition_to_scene(mainMenuPath)

func _unhandled_input(event):
	if (event.is_action_pressed("pause")):
		unpause()
		get_tree().set_input_as_handled()
