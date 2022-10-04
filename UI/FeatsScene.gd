extends Control

signal back_pressed

func _ready():
	$VBoxContainer/Container/Number.text = str(PlayerSaveInfo.enemiesKilled)
	$VBoxContainer/Container2/Wave.text = str(PlayerSaveInfo.highestFloor)
	$VBoxContainer/FeatsBackButton.grab_focus()

func _on_FeatsBackButton_pressed():
	emit_signal("back_pressed")
