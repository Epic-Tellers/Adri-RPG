extends StaticBody2D


func _on_Shake_area_entered(_area):
	var TW = create_tween()
	TW.tween_property(self, "position", Vector2(position.x+1, position.y),0.1).set_trans(Tween.TRANS_BOUNCE)
	TW.tween_property(self, "position", Vector2(position.x-1, position.y),0.1).set_trans(Tween.TRANS_BOUNCE)
	TW.tween_property(self, "position", Vector2(position.x, position.y),0.1).set_trans(Tween.TRANS_BOUNCE)
