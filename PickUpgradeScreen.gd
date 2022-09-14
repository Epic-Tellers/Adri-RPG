extends Control

onready var button1 = $HBoxContainer/Button1
onready var button2 = $HBoxContainer/Button2
onready var button3 = $HBoxContainer/Button3

var PlaceHolderUpgradeArray = [1,2,3,4,5,6]
var PlaceHolderWorldArray = ["res://World.tscn","res://World2.tscn"]

func _ready():
	button1.text = "Upgrade Number: " + assign_upgrade()
	button3.text = "Upgrade Number: " + assign_upgrade()
	button2.text = "Upgrade Number: " + assign_upgrade()

func assign_upgrade():
	PlaceHolderUpgradeArray.shuffle()
	var upgradeNumber = String(PlaceHolderUpgradeArray[0])
	#do something with that number?
	return upgradeNumber


func _on_Button1_pressed():
	#do something with this upgrade?
	print("Player going to next level")
	PlaceHolderWorldArray.shuffle()
	get_tree().change_scene(PlaceHolderWorldArray[0])


func _on_Button2_pressed():
	#do something with this upgrade?
	print("Player going to next level")
	PlaceHolderWorldArray.shuffle()
	get_tree().change_scene(PlaceHolderWorldArray[0])


func _on_Button3_pressed():
	#do something with this upgrade?
	print("Player going to next level")
	PlaceHolderWorldArray.shuffle()
	get_tree().change_scene(PlaceHolderWorldArray[0])
