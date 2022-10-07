extends Area2D

onready var restPosition = global_position
var player

func activate(pos):
	self.global_position = pos
	var TW = create_tween()
	TW.tween_interval(0.1)
	TW.tween_callback(self, "reset")

func _on_EnemyTeleporter_body_entered(body):
	body.set_global_position(pickDestination() + Vector2(randi() % 10 - 5, randi() % 10 - 5))
	print("Teleported something to: "+str(body.global_position))

func reset():
	self.global_position = restPosition

func pickDestination():
	if $Pos1.position.distance_to(player) > $Pos2.position.distance_to(player):
		return $Pos1.position
	else:
		return $Pos2.position
