extends Node

var currentCR = 0
export(Array, String) var EnemiesPath #list of paths to scenes of enemies
export var CR_INCREMENT = 3
var enemiesArray = [] #list of instanced enemies

func _ready():
	for item in EnemiesPath:
		var newEnemy = load(item)
		enemiesArray.append(newEnemy)

func IncrementCR():
	currentCR += CR_INCREMENT

func getEnemiesToSpawn():
	var auxEnemiesArray = enemiesArray.duplicate()
	var enemiesToSpawn = []
	var CRBudget = currentCR
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
	return enemiesToSpawn
