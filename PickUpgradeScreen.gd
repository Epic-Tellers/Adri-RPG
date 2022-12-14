extends Control

onready var button1 = $VBoxContainer/HBoxContainer/Button1
onready var button2 = $VBoxContainer/HBoxContainer/Button2
onready var button3 = $VBoxContainer/HBoxContainer/Button3

onready var text1 = $VBoxContainer/HBoxContainer2/Row1/Upgrade1/RichTextLabel
onready var text2 = $VBoxContainer/HBoxContainer2/Row1/Upgrade2/RichTextLabel
onready var text3 = $VBoxContainer/HBoxContainer2/Row1/Upgrade3/RichTextLabel
onready var text4 = $VBoxContainer/HBoxContainer2/Row2/Upgrade4/RichTextLabel
onready var text5 = $VBoxContainer/HBoxContainer2/Row2/Upgrade5/RichTextLabel
onready var text6 = $VBoxContainer/HBoxContainer2/Row2/Upgrade6/RichTextLabel

onready var nextWaveLabel = $NextWavePanel/NextWaveLabel

var upgradeButton1
var upgradeButton2
var upgradeButton3

onready var richLabel = $VBoxContainer/Panel/RichTextLabel
# Player upgrade array in an int[6]
# Each position in the array codifies for an upgrade. 
# The number on the position, number of instances player has of that upgrade.
# pos 0 : Berserker: Take +1 from everythinh, do +1 on everything
# pos 1 : Resilient: Max hp +1
# pos 2 : Sorcerer: On attack, shoot a fireball
# pos 3 : Dancer: Rolling decreases charge time on charged attack
# pos 4 : Babe Ruth: More knockback on ememies. Increased movement speed.
# pos 5 : Echo: Releasing a charged attack makes it trigger an additional time 
var UPGRADES = ["Berserker", "Resilient", "Sorcerer", "Dancer", "Babe Ruth", "Echo"]
var UPGRADES_DESCRIPTION = ["Take +1 damage from all sources, do +1 damage on all sources", "+1 Max HP + instant full heal", "Doing a normal attack will shoot a magic projectile from the sword", "Rolling decreases the charge timer of your next charged attack", "Increases pushback dealt to enemies on hit. Move slightly faster","Doing a charged attack makes an additional AoE trigger"]
onready var worlds = ["res://World1.tscn", "res://World2.tscn"]
signal picked_upgrade(position)

func _ready():
	if self.connect("picked_upgrade",PlayerStats,"on_upgrade_picked") != OK:
		print("Error in pickUpgradeScreen trying to connect picked_upgrade signal to on_upgrade_picked method")
	randomize()
	var aux = [0,1,2,3,4,5]
	aux.shuffle()
	upgradeButton1 = aux.pop_back()
	upgradeButton2 = aux.pop_back()
	upgradeButton3 = aux.pop_back()
	button1.text = UPGRADES[upgradeButton1]
	button2.text = UPGRADES[upgradeButton2]
	button3.text = UPGRADES[upgradeButton3]
	updateUpgradeCounter()
	button1.grab_focus()
	nextWaveLabel.text = "Current wave: " + str(CrManager.get_wave_number()) +"\n"+ "\nNext boss wave: " + str(CrManager.waves_for_next_boss()) 
	

func change_scene():
	print("Player going to next level")
	worlds.shuffle()
	var scene = worlds.back()
#	if get_tree().change_scene(scene) != OK:
#		print("Error in PickUpgradeScreen trying to change scene to: " +String(scene))
	ScreenTransitionManager.transition_to_scene(scene)
	#FancyFade.wipe_right(scene)

func updateUpgradeCounter():
	# ["Berserker", "Resilient", "Sorcerer", "Dancer", "Babe Ruth", "Echo"]
	text1.text = "Berserker: " + String(PlayerStats.upgradeArrayStats[0])
	text2.text  = "Resilient: " + String(PlayerStats.upgradeArrayStats[1])
	text3.text  = "Sorcerer: " + String(PlayerStats.upgradeArrayStats[2])
	text4.text  = "Dancer: " + String(PlayerStats.upgradeArrayStats[3])
	text5.text  = "BabeRuth: " + String(PlayerStats.upgradeArrayStats[4])
	text6.text  = "Echo: " + String(PlayerStats.upgradeArrayStats[5])

func _on_Button1_pressed():
	emit_signal("picked_upgrade",upgradeButton1)
	print("picked upgrade on position: "+String(upgradeButton1))
	change_scene()


func _on_Button2_pressed():
	emit_signal("picked_upgrade",upgradeButton2)
	print("picked upgrade on position: "+String(upgradeButton2))
	change_scene()


func _on_Button3_pressed():
	emit_signal("picked_upgrade",upgradeButton3)
	print("picked upgrade on position: "+String(upgradeButton3))
	change_scene()


func _on_Button1_focus_entered():
	richLabel.text = UPGRADES_DESCRIPTION[upgradeButton1]
	

func _on_Button1_mouse_entered():
	richLabel.text = UPGRADES_DESCRIPTION[upgradeButton1]


func _on_Button1_focus_exited():
	richLabel.text = ""


func _on_Button1_mouse_exited():
	richLabel.text = ""


func _on_Button2_focus_entered():
	richLabel.text = UPGRADES_DESCRIPTION[upgradeButton2]


func _on_Button2_mouse_entered():
	richLabel.text = UPGRADES_DESCRIPTION[upgradeButton2]


func _on_Button2_focus_exited():
	richLabel.text = "" # Replace with function body.


func _on_Button2_mouse_exited():
	richLabel.text = "" # Replace with function body.


func _on_Button3_focus_entered():
	richLabel.text = UPGRADES_DESCRIPTION[upgradeButton3]


func _on_Button3_mouse_entered():
	richLabel.text = UPGRADES_DESCRIPTION[upgradeButton3]


func _on_Button3_focus_exited():
	richLabel.text = "" # Replace with function body.


func _on_Button3_mouse_exited():
	richLabel.text = "" # Replace with function body.
