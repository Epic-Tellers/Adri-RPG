extends Control

func _ready():
	if PlayerSaveInfo.connect("added_batsoul",self,"_on_added_batsoul") != OK:
		print("Error in SoulUI trying to connect PlayerSaveInfo's added_batsoul signal to _on_added_batsoul method")
	update_soul_displayed()

func _on_added_batsoul():
	var TW = create_tween()
	#TW.tween_property(self,"speed",TARGET_SPEED,1.0)
	TW.tween_property($Icon,"rect_scale",Vector2(1.4,1.4),0.15)
	TW.tween_property($Icon,"rect_scale",Vector2(1.0,1.0),0.05)
	yield(TW, "finished")
	update_soul_displayed()
	
func update_soul_displayed():
	$Label.text = str(PlayerStats.batSoulsThisRun)
