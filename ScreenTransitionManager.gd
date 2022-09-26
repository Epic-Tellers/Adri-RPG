extends Node

const screenTransitionScene = preload("res://UI/ScreenTransition.tscn")

func transition_to_scene(scenePath):
	var screenTransition = screenTransitionScene.instance()
	add_child(screenTransition)
	yield(screenTransition, "screen_covered")
	if get_tree().change_scene(scenePath) != OK:
		print("Failed to load scene: " + scenePath)
