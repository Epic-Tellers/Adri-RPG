extends Node2D

export var CHANGE_SCENES_DELAY = 2
onready var spawnPointHolder = $YSort/SpawnPoints
onready var camera = $Camera2D
onready var enemyTeleporter = $EnemyTeleporter
onready var deathScene = "res://DeathScene.tscn"
const NextLevelCollider = preload("res://NextLevelColider.tscn")
const HealHeart = preload("res://World/RotatingHeart.tscn")
const PauseScene = preload("res://PauseMenu.tscn")
const BossWaveScene = preload("res://UI/BossWaveBanner.tscn")
const NormalWaveScene = preload("res://UI/RegularWaveBanner.tscn")
const TeleportParticles = preload("res://Enemies/EnemyTeleport.tscn")
var changeScenesTimer = null
var enemiesInScene = 0
var player = null

func _ready():
	#map logic
	create_scene_timer()
	if PlayerStats.connect("no_health",self,"start_scene_timer") != OK:
		print("Error in World.gd trying to connect no_health signal to start_scene_timer method")
	
	#checking CR and check if that correlates to boss floor
	CrManager.IncrementCR()
	if CrManager.check_if_boss_floor():
		var bossBanner = BossWaveScene.instance()
		$CanvasLayer.add_child(bossBanner)
	else:
		var normalBanner = NormalWaveScene.instance()
		$CanvasLayer.add_child(normalBanner)
	
	#spawn thy enemies
	var spawnPointsArray = spawnPointHolder.get_children()
	var spawnPointsNumber = spawnPointsArray.size()
	var enemiesToSpawn = CrManager.getEnemiesToSpawn()
	print("There are these enemies to spwan: "+ String(enemiesToSpawn))
	enemiesInScene = enemiesToSpawn.size()
	for item in enemiesToSpawn:
		var targetPoint = spawnPointsArray[(randi() % spawnPointsNumber)]
		targetPoint.add_child(item)
		item.position += Vector2(randi() % 40 - 20, randi() % 40 - 20)
		item.connect("died",self,"_on_enemy_death")
		item.connect("requestTeleport",self,"_on_enemy_requested_teleport")
		item.asign_player(player)
	
	#and save progress!
	PlayerSaveInfo._save_game()
	
	#player sharing
	enemyTeleporter.assign_player(player)

func _unhandled_input(event):
	if (event.is_action_pressed("pause")):
		var pauseInstance = PauseScene.instance()
		add_child(pauseInstance)
func create_scene_timer():
	changeScenesTimer = null
	changeScenesTimer = Timer.new()
	if (changeScenesTimer.connect("timeout",self, "_on_timer_timeout")) != OK:
		print("Error in world trying to connect timeout to _on_timer_timeout")
	self.call_deferred("add_child", changeScenesTimer)
	#add_child(changeScenesTimer)
	
func start_scene_timer():
	#basically, this is on player death
	if changeScenesTimer != null:
		changeScenesTimer.start(CHANGE_SCENES_DELAY)
	
func _on_timer_timeout():
#	if get_tree().change_scene(deathScene) != OK:
#		print("Error in World.gd trying to change scene to: " + deathScene)
	ScreenTransitionManager.transition_to_scene(deathScene)
	
func _on_enemy_death(pos):
	PlayerSaveInfo.enemiesKilled += 1
	enemiesInScene -= 1
	if enemiesInScene == 0: #we don't do <= bc we get stacked signals and multiple portal spawns
		#print("On spawn, there were enemies: " + String(enemiesInScene))
		last_enemy_death(pos)
	if player != null:
		if is_instance_valid(player):
			player.resonant_spawn_halo(pos)
			player.spawnAllyBat(pos)
			PlayerStats.herculean_heal()
#	var isLevelDone = true
#	for spawnPoint in spawnPointHolder.get_children():
#		if spawnPoint.get_children() != []:
#			for eachEnemy in spawnPoint.get_children():
#				if is_instance_valid(eachEnemy):
#					isLevelDone = false
#	if isLevelDone:
#		last_enemy_death(pos)

func _on_grass_died(pos):
	if randi()%4 == 0:
		var healHeart = HealHeart.instance()
		self.call_deferred("add_child",healHeart)
		healHeart.global_position = pos	
	pass

func last_enemy_death(pos):
	var nextLevelCollider = NextLevelCollider.instance()
	#self.add_child(nextLevelCollider)
	self.call_deferred("add_child",nextLevelCollider)
	nextLevelCollider.global_position = pos

func _on_player_spawn(spawnedPlayer):
	player = spawnedPlayer

func _on_enemy_requested_teleport(pos):
	enemyTeleporter.activate(pos)
	var particles = TeleportParticles.instance()
	#get_tree().current_scene.call_deferred("add_child", soulDrop)
	get_tree().current_scene.add_child(particles)
	particles.global_position = pos
