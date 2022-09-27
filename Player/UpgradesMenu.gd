extends Control

signal back_pressed
onready var batSoulLabel = $Panel/MainScreen/Holder/Icon/Label

func _ready():
	update_batsoul_label()
	$Panel/MainScreen/Holder/BackButton.grab_focus()

func _on_BackButton_pressed():
	emit_signal("back_pressed")

func update_batsoul_label():
	batSoulLabel.text = str(PlayerSaveInfo.batSouls)
