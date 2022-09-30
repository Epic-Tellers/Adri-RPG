extends StaticBody2D

const Leaves = preload("res://Effects/GrassEffect.tscn")

func _ready():
	pass # Replace with function body.


func _on_HitColision_area_entered(_area):
	var leaves = Leaves.instance()
	self.add_child(leaves)
	leaves.position -= Vector2(7,20)
	var TW = create_tween()
	TW.tween_property(self, "position", Vector2(position.x+1, position.y),0.1).set_trans(Tween.TRANS_BOUNCE)
	TW.tween_property(self, "position", Vector2(position.x-1, position.y),0.1).set_trans(Tween.TRANS_BOUNCE)
	TW.tween_property(self, "position", Vector2(position.x, position.y),0.1).set_trans(Tween.TRANS_BOUNCE)
