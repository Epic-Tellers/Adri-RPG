extends Node2D

export var CHANGE_SCENES_DELAY = 2
onready var spawnPointHolder = $YSort/SpawnPoints
onready var camera = $Camera2D
onready var deathScene = "res://DeathScene.tscn"
const NextLevelCollider = preload("res://NextLevelColider.tscn")
const HealHeart = preload("res://World/RotatingHeart.tscn")
var changeScenesTimer = null
var enemiesInScene = 0

func _ready():
	var spawnPointsArray = spawnPointHolder.get_children()
	var spawnPointsNumber = spawnPointsArray.size()
	CrManager.IncrementCR()
	var enemiesToSpawn = CrManager.getEnemiesToSpawn()
	enemiesInScene = enemiesToSpawn.size()
	for item in enemiesToSpawn:
		var targetPoint = spawnPointsArray[(randi() % spawnPointsNumber)]
		targetPoint.add_child(item)
		item.connect("died",self,"_on_enemy_death")
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

func _on_enemy_death(pos):
	enemiesInScene -= 1
	if enemiesInScene <= 0:
		last_enemy_death(pos)

func _on_grass_died(pos):
	if randi()%4 == 0:
		var healHeart = HealHeart.instance()
		self.add_child(healHeart)
		healHeart.global_position = pos	
	pass

func last_enemy_death(pos):
	var nextLevelCollider = NextLevelCollider.instance()
	add_child(nextLevelCollider)
	nextLevelCollider.global_position = pos
	
