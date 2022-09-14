extends Area2D

onready var pickUpgradeScreen = "res://PickUpgradeScreen.tscn"

func _on_NextLevelColider_body_entered(_body):
	print("Player going to pick upgrades")
	get_tree().change_scene(pickUpgradeScreen)
