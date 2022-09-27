class_name SaveGameAsJSON
extends Reference

const SAVE_GAME_PATH = "user://save.json"

#All we want to save
var highestFloor = 0
var enemiesKilled = 0
var batSouls = 0
var timeSpent = 0

var version := 1

var _file := File.new()

func save_exists() -> bool:
	return _file.file_exists(SAVE_GAME_PATH)

func write_savegame() -> void:
	var error := _file.open(SAVE_GAME_PATH, File.WRITE)
	if error != OK:
		printerr("Could not open the file %s. Aborting save operation. Error code: %s" % [SAVE_GAME_PATH, error])
		return

	var data := {
		"highestFloor": highestFloor,
		"enemiesKilled": enemiesKilled,
		"batSouls": batSouls,
		"timeSpent": timeSpent
	}
	
	print("Data on write: "+ str(data))
	
	var json_string := JSON.print(data)
	_file.store_string(json_string)
	_file.close()


func load_savegame() -> void:
	var error := _file.open(SAVE_GAME_PATH, File.READ)
	if error != OK:
		printerr("Could not open the file %s. Aborting load operation. Error code: %s" % [SAVE_GAME_PATH, error])
		return

	var content := _file.get_as_text()
	_file.close()

	var data: Dictionary = JSON.parse(content).result
	highestFloor = data.highestFloor
	enemiesKilled = data.enemiesKilled
	batSouls = data.batSouls
	timeSpent = data.timeSpent
	print("File loaded. Floor,Kills,Souls,Times = " + str(highestFloor) + ", " + str(enemiesKilled) + ", " + str(batSouls) + ", " + str(timeSpent))
