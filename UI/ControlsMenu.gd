extends Control

var listeningForInputs = false
var actionToChange
var remap
onready var waitingPanel = $PanelPress

func _ready():
	remap = ControlsRemap.new()
	waitingPanel.visible = false

#func change_action_key(action_name, key_scancode):
#	erase_action_events(action_name)
#	var new_event = InputEventKey.new()
#	new_event.set_scancode(key_scancode)
#	InputMap.action_add_event(action_name, new_event)
#
#func erase_action_events(action_name):
#	var input_events = InputMap.get_action_list(action_name)
#	for event in input_events:
#		InputMap.action_erase_event(action_name, event)
#		

func _input(event):
	if listeningForInputs and event is InputEventKey:
		remap.set_action_key(actionToChange,event)
		clean_actions()
	if listeningForInputs and event is InputEventJoypadButton:
		remap.set_action_button(actionToChange,event)
		clean_actions()

func clean_actions():
	listeningForInputs = false
	waitingPanel.visible = false
	actionToChange = ""

func listen_for_inputs():
	listeningForInputs = true
	waitingPanel.visible = true

func _on_UpChange_pressed():
	listen_for_inputs()
	actionToChange = "ui_up"


func _on_DownChange_pressed():
	listen_for_inputs()
	actionToChange = "ui_down"


func _on_RightChange_pressed():
	listen_for_inputs()
	actionToChange = "ui_right"


func _on_LeftChange_pressed():
	listen_for_inputs()
	actionToChange = "ui_left"


func _on_AttackChange_pressed():
	listen_for_inputs()
	actionToChange = "attack"


func _on_ChargeChange_pressed():
	listen_for_inputs()
	actionToChange = "spin"


func _on_RollChange_pressed():
	listen_for_inputs()
	actionToChange = "Roll"


func _on_ControlsBackButton_pressed():
	remap.create_remap()
	if ResourceSaver.save("user://my_remap.tres", remap) != OK:
		print("Error trying to save the input remap file")
