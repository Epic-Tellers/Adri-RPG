extends Control

onready var worlds = ["res://World1.tscn", "res://World2.tscn"]
onready var mainScene = "res://MainScreen.tscn"
onready var retry = $VBoxContainer/Button
var quotes = []
func _ready():
	randomize()
	retry.grab_focus()
	fill_quotes()
	$VBoxContainer2/Label.text = quotes[randi() % quotes.size()]
	PlayerStats.reset_upgrades()
	PlayerStats.health = PlayerStats.initialMaxHealth
	PlayerStats.max_health = PlayerStats.initialMaxHealth
	CrManager.reset_CR()
	add_bat_souls()
	PlayerSaveInfo._save_game()
	
func _on_Button_pressed():
	worlds.shuffle()
	var scene = mainScene #worlds.back()
	ScreenTransitionManager.transition_to_scene(scene)
#	if get_tree().change_scene(scene) != OK:
#		print("Error in DeathScene trying to change scene to: " +String(scene))
#	FancyFade.pixelated_noise(scene)

func _on_Button2_pressed():
	get_tree().quit()

func add_bat_souls():
	# Display an animation or something that shows the souls getting stashed?
	PlayerStats.batSoulsThisRun = 0

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
		"Look at you, gaming it up!",
		"I'm not angry, just disappointed",
		"Was that a bug? Or lack of skill?",
		"I worry about you, seriously",
		"Perhaps I should just do it",
		"Are your hands on vacation?",
		"Did your controller unplug?"
	]
