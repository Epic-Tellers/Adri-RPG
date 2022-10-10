extends Area2D

onready var restPosition = global_position
var player

func activate(pos):
	self.global_position = pos
	var TW = create_tween()
	TW.tween_interval(0.1)
	TW.tween_callback(self, "reset")

func _on_EnemyTeleporter_body_entered(body):
	body.set_global_position(pickDestination() + Vector2(randi() % 14 - 7, randi() % 14 - 7))
	print("Teleported something to: "+str(body.global_position))

func reset():
	self.global_position = restPosition

func pickDestination():
	var dist1 = $Pos1.position.distance_to(player.position)
	var dist2 = $Pos2.position.distance_to(player.position)
	
	if dist2 > dist1:
		return $Pos2.position
	else:
		return $Pos1.position

func assign_player(body):
	self.player = body
