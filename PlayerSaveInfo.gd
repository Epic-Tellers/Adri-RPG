extends Node

signal added_batsoul

var highestFloor = 0 setget set_highest_floor, get_highest_floor
var enemiesKilled = 0 setget set_enemies_killed, get_enemies_killed
var batSouls = 0 setget set_bat_souls, get_bat_souls
var timeSpent = 0 setget set_time_spent, get_time_spent

var _save := SaveGameAsJSON.new()

func _ready():
	_create_or_load_save()

func set_highest_floor(value):
	_save.highestFloor = value

func get_highest_floor():
	return _save.highestFloor

func set_enemies_killed(value):
	_save.enemiesKilled = value

func get_enemies_killed():
	return _save.enemiesKilled

func set_bat_souls(value):
	_save.batSouls = value

func addBatSoul():
	_save.batSouls += 1
	emit_signal("added_batsoul")
	
func get_bat_souls():
	return _save.batSouls

func set_time_spent(value):
	_save.timeSpent = value
	
func get_time_spent():
	return _save.timeSpent

func _create_or_load_save() -> void:
	if _save.save_exists():
		_save.load_savegame()
	else:
		_save.highestFloor = 0
		_save.enemiesKilled = 0
		_save.batSouls = 0
		_save.timeSpent = 0
		_save.write_savegame()

	PlayerSaveInfo.highestFloor = _save.highestFloor
	PlayerSaveInfo.enemiesKilled = _save.enemiesKilled
	PlayerSaveInfo.batSouls = _save.batSouls
	PlayerSaveInfo.timeSpent = _save.timeSpent

func _save_game() -> void:
	_save.write_savegame()

