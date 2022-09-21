extends Control

onready var world = "res://World2.tscn"
onready var retry = $VBoxContainer/Button
var quotes = []
func _ready():
	randomize()
	retry.grab_focus()
	fill_quotes()
	$VBoxContainer2/Label.text = quotes[randi() % quotes.size()]

func _on_Button_pressed():
	PlayerStats.health = PlayerStats.max_health
	CrManager.reset_CR()
	if get_tree().change_scene(world) != OK:
		print("Error from death scene trying to change scene to world")

func _on_Button2_pressed():
	get_tree().quit()

func fill_quotes():
	quotes = [
		"At least you tried",
		"I've seen better...",
		"Is that really it?",
		"My grandma got further...",
		"Is that all you got?",
		"I expected better...",
		"You died like that? Seriously?",
		"Disappointing...",
		"You weak, pathetic fool",
		"You spoony bard!",
		" - Laugh - ",
		"Better quit for today...",
		"Back here so soon?",
		"Git gud",
		"Look at you, gaming it up!"
	]
