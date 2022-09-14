extends Area2D

export var NextLevel = ""

func _on_NextLevelColider_body_entered(_body):
	print("Player going to next level")
	get_tree().change_scene(NextLevel)
