extends Area2D

var player = null
signal player_detected(body)

func _ready():
	if self.connect("player_detected",get_parent(),"_on_player_detected") != OK:
		print("PlayerDetectionZone failed to connect player_detected signal to parent _on_player_detected method")
	
func can_see_player():
	return player != null

func _on_PlayerDetectionZone_body_entered(body):
	player = body
	emit_signal("player_detected", body)

func _on_PlayerDetectionZone_body_exited(_body):
	#player = null
	pass
