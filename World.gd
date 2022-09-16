extends Node2D

export var CHANGE_SCENES_DELAY = 2
onready var spawnPointHolder = $YSort/SpawnPoints
onready var camera = $Camera2D
onready var deathScene = "res://DeathScene.tscn"
var changeScenesTimer = null

func _ready():
	var spawnPointsArray = spawnPointHolder.get_children()
	var spawnPointsNumber = spawnPointsArray.size()
	CrManager.IncrementCR()
	var enemiesToSpawn = CrManager.getEnemiesToSpawn()
	for item in enemiesToSpawn:
		var targetPoint = spawnPointsArray[(randi() % spawnPointsNumber)]
		targetPoint.add_child(item)
	create_scene_timer()
	PlayerStats.connect("no_health",self,"start_scene_timer")
	
func create_scene_timer():
	changeScenesTimer = Timer.new()
	changeScenesTimer.connect("timeout",self, "_on_timer_timeout")
	add_child(changeScenesTimer)
	
func start_scene_timer():
	if changeScenesTimer != null:
		changeScenesTimer.start(CHANGE_SCENES_DELAY)
	
func _on_timer_timeout():
	get_tree().change_scene(deathScene)
