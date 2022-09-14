extends Node2D

onready var spawnPointHolder = $YSort/SpawnPoints

func _ready():
	var spawnPointsArray = spawnPointHolder.get_children()
	var spawnPointsNumber = spawnPointsArray.size()
	CrManager.IncrementCR()
	var enemiesToSpawn = CrManager.getEnemiesToSpawn()
	for item in enemiesToSpawn:
		var targetPoint = spawnPointsArray[(randi() % spawnPointsNumber)]
		targetPoint.add_child(item)
