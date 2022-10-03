extends Node

signal added_batsoul

var highestFloor = 0 setget set_highest_floor, get_highest_floor
var enemiesKilled = 0 setget set_enemies_killed, get_enemies_killed
var batSouls = 0 setget set_bat_souls, get_bat_souls
var timeSpent = 0 setget set_time_spent, get_time_spent
var resonantStacks = 0 setget set_resonantStacks, get_resonantStacks
var archmageStacks = 0 setget set_archmageStacks, get_archmageStacks
var herculeanStacks = 0 setget set_herculeanStacks, get_herculeanStacks


var _save := SaveGameAsJSON.new()

func _ready():
	#save file: coins, highest floor, etc.
	_create_or_load_save() 
	#check for input remap file
	var directory = Directory.new();
	var doFileExists = directory.dir_exists("user://my_remap.tres")
	if doFileExists:
		var remap = load("user://my_remap.tres")
		remap.apply_remap()
	else:
		print("No control remap file exists")

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

func set_resonantStacks(value):
	_save.resonantStacks = value

func add_resonant_stack():
	_save.resonantStacks += 1
	PlayerStats.upgradeArrayStats[6] += 1
	
func get_resonantStacks():
	return _save.resonantStacks
	
func set_archmageStacks(value):
	_save.archmageStacks = value

func add_archmage_stack():
	_save.archmageStacks += 1
	PlayerStats.upgradeArrayStats[7] += 1
	
func get_archmageStacks():
	return _save.archmageStacks
	
func set_herculeanStacks(value):
	_save.herculeanStacks = value

func add_herculean_stack():
	_save.herculeanStacks += 1
	PlayerStats.upgradeArrayStats[8] += 1
	
func get_herculeanStacks():
	return _save.herculeanStacks

func _create_or_load_save() -> void:
	if _save.save_exists():
		_save.load_savegame()
	else:
		_save.highestFloor = 0
		_save.enemiesKilled = 0
		_save.batSouls = 0
		_save.timeSpent = 0
		_save.resonantStacks = 0
		_save.archmageStacks = 0
		_save.herculeanStacks = 0
		_save.write_savegame()

	PlayerSaveInfo.highestFloor = _save.highestFloor
	PlayerSaveInfo.enemiesKilled = _save.enemiesKilled
	PlayerSaveInfo.batSouls = _save.batSouls
	PlayerSaveInfo.timeSpent = _save.timeSpent
	PlayerSaveInfo.resonantStacks = _save.resonantStacks
	PlayerSaveInfo.archmageStacks = _save.archmageStacks
	PlayerSaveInfo.herculeanStacks = _save.herculeanStacks
	
	PlayerStats.upgradeArrayStats[6] = _save.resonantStacks
	PlayerStats.upgradeArrayStats[7] = _save.archmageStacks
	PlayerStats.upgradeArrayStats[8] = _save.herculeanStacks

func _save_game() -> void:
	_save.write_savegame()

