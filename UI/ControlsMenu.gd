extends Control

var listeningForInputs = false
var actionToChange
var remap
onready var waitingPanel = $PanelPress

onready var up = $HBoxContainer/Holder/HBoxContainer/UpChange
onready var down = $HBoxContainer/Holder/HBoxContainer2/DownChange
onready var left = $HBoxContainer/Holder/HBoxContainer4/LeftChange
onready var right = $HBoxContainer/Holder/HBoxContainer3/RightChange
onready var attack = $HBoxContainer/Holder2/HBoxContainer/AttackChange
onready var roll = $HBoxContainer/Holder2/HBoxContainer3/RollChange
onready var spin = $HBoxContainer/Holder2/HBoxContainer2/ChargeChange

func _ready():
	remap = ControlsRemap.new()
	waitingPanel.visible = false
	update_names_display()
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
func update_names_display():
	up.text = ""
	for action in InputMap.get_action_list("ui_up"):
		up.text = (InputMap.get_action_list("ui_up")[0].as_text())
	
	down.text = ""
	for action in InputMap.get_action_list("ui_down"):
		down.text = (InputMap.get_action_list("ui_down")[0].as_text())
	
	left.text = ""
	for action in InputMap.get_action_list("ui_left"):
		left.text = (InputMap.get_action_list("ui_left")[0].as_text())

	right.text = ""
	for action in InputMap.get_action_list("ui_right"):
		right.text = (InputMap.get_action_list("ui_right")[0].as_text())
	
	attack.text = ""
	for action in InputMap.get_action_list("attack"):
		attack.text = (InputMap.get_action_list("attack")[0].as_text())
	
	spin.text = ""
	for action in InputMap.get_action_list("spin"):
		spin.text = (InputMap.get_action_list("spin")[0].as_text())
	
	roll.text = ""
	for action in InputMap.get_action_list("Roll"):
		roll.text = (InputMap.get_action_list("Roll")[0].as_text())
		
#	aux = InputMap.get_action_list("ui_down")
#	down.text = str(InputMap.get_action_list("ui_down"))
#
#	aux = InputMap.get_action_list("ui_right")
#	right.text = str(InputMap.get_action_list("ui_right"))
#
#	aux = InputMap.get_action_list("ui_left")
#	left.text = str(InputMap.get_action_list("ui_left"))
#
#	aux = InputMap.get_action_list("attack")
#	attack.text = str(InputMap.get_action_list("attack"))
#
#	aux = InputMap.get_action_list("Roll")
#	roll.text = str(InputMap.get_action_list("Roll"))
#
#	aux = InputMap.get_action_list("spin")
#	spin.text = str(InputMap.get_action_list("spin"))


func _input(event):
	if listeningForInputs and event is InputEventKey:
		remap.set_action_key(actionToChange,event)
		clean_actions()
		update_names_display()
	if listeningForInputs and event is InputEventJoypadButton:
		remap.set_action_button(actionToChange,event)
		clean_actions()
		update_names_display()

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
