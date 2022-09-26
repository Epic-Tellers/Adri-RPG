extends Area2D

onready var pickUpgradeScreen = "res://PickUpgradeScreen.tscn"

func _on_NextLevelColider_body_entered(_body):
	#FancyFade.wipe_left(pickUpgradeScreen.pickUpgradeScreen().instance())
	print("Player going to pick upgrades")
#	if get_tree().change_scene(pickUpgradeScreen) != OK:
#		print("Error in NextLevelCollider trying to change scene to: " + pickUpgradeScreen)
	ScreenTransitionManager.transition_to_scene(pickUpgradeScreen)
	
