extends Node

var currentCR = 0
export(Array, String) var EnemiesPath #list of paths to scenes of enemies
export(Array, int) var Ponderings #relative to position in Enemies Path.
export var CR_INCREMENT = 3
export var BOSS_FLOORS = 5 #keeps track every how many floors does a boss wave spawn
export (bool) var ACTIVATE_SPAWN = true
var enemiesArray = [] #list of instanced enemies

func _ready():
	for item in EnemiesPath:
		var newEnemy = load(item)
		enemiesArray.append(newEnemy)

func IncrementCR():
	currentCR += CR_INCREMENT
	update_highest_floor()

func waves_for_next_boss():
	var nextBossWave = BOSS_FLOORS
	var currentWave = get_wave_number()
	while nextBossWave < currentWave:
		nextBossWave += BOSS_FLOORS
	return nextBossWave

func get_wave_number():
	if CR_INCREMENT != 0:
		return currentCR / CR_INCREMENT
	else:
		return 0

func check_if_boss_floor():
	if currentCR % BOSS_FLOORS == 0:
		return true
	else:
		return false

func update_highest_floor():
	var currentFloor = currentCR / CR_INCREMENT
	PlayerSaveInfo.highestFloor = max(currentFloor, PlayerSaveInfo.highestFloor)
	
func reset_CR():
	currentCR = 0

func getEnemiesToSpawn():
	var auxEnemiesArray = enemiesArray.duplicate()
	var enemiesToSpawn = []
	var CRBudget = currentCR
	
	for i in enemiesArray.size():
		for j in Ponderings[i]:
			auxEnemiesArray.append(auxEnemiesArray[i])
	
	if check_if_boss_floor():
		CRBudget *= 2
		
	while CRBudget > 0:
		auxEnemiesArray.shuffle()
		var randomEnemy = auxEnemiesArray.back()
		var newEnemy = randomEnemy.instance()
		var enemyCR = newEnemy.CR_VALUE
		if CRBudget >= enemyCR:
			enemiesToSpawn.append(newEnemy)
			CRBudget -= enemyCR
		else:
			auxEnemiesArray.pop_back()
	
	if (ACTIVATE_SPAWN):
		return enemiesToSpawn
	else: 
		return []
