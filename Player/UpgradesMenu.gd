extends Control

signal back_pressed
onready var batSoulLabel = $Panel/MainScreen/Holder/Icon/Label

#var UPGRADES = ["Resonant", "Archmage", "Herculean"]
var UPGRADES_DESCRIPTION = ["Enemies dying from an Echo wave spawn an Echo wave.", "Your sorcerer fireball now spawns an AoE on hit.", "Killing an enemy has a 5% to restore health." ]
onready var upgradeText = $Panel/MainScreen/DescriptionPanel/DescriptionText
onready var resonantBuyButton = $Panel/MainScreen/Upgrades/BuyResonantButton
onready var archmageBuyButton = $Panel/MainScreen/Upgrades/BuyArchmageButton
onready var herculeanBuyButton = $Panel/MainScreen/Upgrades/BuyHerculeanButton
onready var resonantLabel = $Panel/MainScreen/Upgrades/ResonantLabel
onready var archmageLabel = $Panel/MainScreen/Upgrades/ArchmageLabel
onready var herculeanLabel = $Panel/MainScreen/Upgrades/HerculeanLabel
onready var nopeSound =  $FailSound
onready var currency = $Panel/MainScreen/Holder/Icon

var resonantCost = 0
var archmageCost = 0
var herculeanCost = 0

func _ready():
	update_batsoul_label()
	$Panel/BackButton.grab_focus()
	updateBuyLabels()

func updateBuyLabels():
	resonantCost = pow(int(PlayerStats.upgradeArrayStats[6]),2) * 100 + 200
	archmageCost = pow(int(PlayerStats.upgradeArrayStats[7]),2) * 100 + 200
	herculeanCost = pow(int(PlayerStats.upgradeArrayStats[8]),2)  * 100 + 200
	resonantBuyButton.text = "Cost: " + str(resonantCost)
	archmageBuyButton.text = "Cost: " + str(archmageCost)
	herculeanBuyButton.text = "Cost: " + str(herculeanCost)
	resonantLabel.text = "Resonant. Stacks: "+ str(PlayerStats.upgradeArrayStats[6])
	archmageLabel.text = "Archmage. Stacks: "+ str(PlayerStats.upgradeArrayStats[7])
	herculeanLabel.text = "Herculean. Stacks: "+ str(PlayerStats.upgradeArrayStats[8])
	
func _on_BackButton_pressed():
	emit_signal("back_pressed")

func update_batsoul_label():
	batSoulLabel.text = str(PlayerSaveInfo.batSouls)

func failed_transaction():
	nopeSound.play()
	var TW = create_tween()
	TW.tween_property(currency,"rect_scale",Vector2(1.2,1.2),0.3).set_trans(Tween.TRANS_CUBIC)
	TW.tween_property(currency,"rect_scale",Vector2(1.0,1.0),0.3)

func _on_BuyResonantButton_pressed():	
	if PlayerSaveInfo.batSouls >= resonantCost:
		PlayerSaveInfo.add_resonant_stack()
		PlayerSaveInfo.batSouls -= resonantCost
		update_batsoul_label()
		updateBuyLabels()
		PlayerSaveInfo._save_game()
	else:
		failed_transaction()
func _on_BuyArchmageButton_pressed():
	if PlayerSaveInfo.batSouls >= archmageCost:
		PlayerSaveInfo.add_archmage_stack()
		PlayerSaveInfo.batSouls -= archmageCost
		update_batsoul_label()
		updateBuyLabels()
		PlayerSaveInfo._save_game()
	else:
		failed_transaction()
func _on_BuyHerculeanButton_pressed():
	if PlayerSaveInfo.batSouls >= herculeanCost:
		PlayerSaveInfo.add_herculean_stack()
		PlayerSaveInfo.batSouls -= herculeanCost
		update_batsoul_label()
		updateBuyLabels()
		PlayerSaveInfo._save_game()
	else:
		failed_transaction()

#-------------------- DESCRIPTION UPDATING ------------------------------

func _on_BuyResonantButton_focus_entered():
	upgradeText.text = UPGRADES_DESCRIPTION[0]
func _on_BuyResonantButton_focus_exited():
	upgradeText.text = ""
func _on_BuyResonantButton_mouse_entered():
	upgradeText.text = UPGRADES_DESCRIPTION[0]
func _on_BuyResonantButton_mouse_exited():
	upgradeText.text = ""
func _on_BuyArchmageButton_focus_entered():
	upgradeText.text = UPGRADES_DESCRIPTION[1]
func _on_BuyArchmageButton_focus_exited():
	upgradeText.text = ""
func _on_BuyArchmageButton_mouse_entered():
	upgradeText.text = UPGRADES_DESCRIPTION[1]
func _on_BuyArchmageButton_mouse_exited():
	upgradeText.text = ""
func _on_BuyHerculeanButton_focus_entered():
	upgradeText.text = UPGRADES_DESCRIPTION[2]
func _on_BuyHerculeanButton_focus_exited():
	upgradeText.text = ""
func _on_BuyHerculeanButton_mouse_entered():
	upgradeText.text = UPGRADES_DESCRIPTION[2]
func _on_BuyHerculeanButton_mouse_exited():
	upgradeText.text = ""
