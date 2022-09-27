extends Control

var soulDisplayed = 0

func _ready():
	if PlayerSaveInfo.connect("added_batsoul",self,"_on_added_batsoul") != OK:
		print("Error in SoulUI trying to connect PlayerSaveInfo's added_batsoul signal to _on_added_batsoul method")
	soulDisplayed = int(soulDisplayed)
	$Label.text = str(soulDisplayed)

func _on_added_batsoul():
	update_soul_displayed()
	var TW = create_tween()
	#TW.tween_property(self,"speed",TARGET_SPEED,1.0)
	TW.tween_property($Icon,"rect_scale",Vector2(1.4,1.4),0.15)
	TW.tween_property($Icon,"rect_scale",Vector2(1.0,1.0),0.05)
	$Label.text = str(soulDisplayed)
	
func update_soul_displayed():
	soulDisplayed = PlayerStats.batSoulsThisRun
