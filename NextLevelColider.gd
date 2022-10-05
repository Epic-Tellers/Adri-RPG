extends Area2D

onready var pickUpgradeScreen = "res://PickUpgradeScreen.tscn"
onready var tpSound = $AudioStreamPlayer

func _on_NextLevelColider_body_entered(body):
	if body.is_in_group("Player"):
	#FancyFade.wipe_left(pickUpgradeScreen.pickUpgradeScreen().instance())
		print("Player going to pick upgrades")
#	if get_tree().change_scene(pickUpgradeScreen) != OK:
#		print("Error in NextLevelCollider trying to change scene to: " + pickUpgradeScreen)
		tpSound.play()
		body.turn_white()
		body.set_state_none()
		var TW = create_tween()
		TW.tween_property(body,"scale",Vector2(0.1,1),0.3).set_trans(Tween.TRANS_EXPO)
		TW.tween_property(body,"position",Vector2(0,-110),0.2).as_relative()	
		yield(TW,"finished")
		ScreenTransitionManager.transition_to_scene(pickUpgradeScreen)
