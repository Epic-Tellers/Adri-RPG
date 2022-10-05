extends Node
export var max_health = 1 setget set_max_health #var appears in editor
export var invincible = false
var health = max_health setget set_health #values put in editor are updated on ready!
var berserkerModifier = 0 #makes you take more damage
var died = false
var initialMaxHealth
var batSoulsThisRun = 0

var upgradeArrayStats = [0,0,0,0,0,0,0,0,0] setget upgrades_changed #for more info, go to Player.gd
#var upgradeArray = [0,0,0,0,0,0] setget upgrade_array_got_changed #updated from a signal fired on a setget on PlayerStats
#Each position in the array codifies for an upgrade. The number on the position, number of instances player has of that upgrade.
# pos 0 : Berserker: Take +1 from everythinh, do +1 on everything
# pos 1 : Resilient: Max hp +1
# pos 2 : Sorcerer: On attack, shoot a fireball
# pos 3 : Dancer: Rolling decreases charge time on charged attack
# pos 4 : Babe Ruth: More knockback on ememies. Increased movement speed.
# pos 5 : Echo: Releasing a charged attack makes it trigger an additional time 

# ---> These 3 do not reset ever, you can BUY them outside game multiple times
# pos 6 : Resonant (Unlockable upgrade): Enemies that die from an Echo wave spawn an Echo wave. Amount of echo waves increases with each combined stack of Dancer and Echo
# pos 7 : Archmage (Unlockable upgrade): Your fireball now spawns an AoE on hit. Reach and speed increases with each combined stack of Sorcerer and BabeRuth
# pos 8 : Herculean (Unlockable upgrade): Killing an enemy restores health. Amount of health restored increases with each combined stack of Berserker and Resilient

signal no_health
signal upgrades_change(newArray)
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
	if value < health:
		value -= berserkerModifier
	if invincible:
		health = max_health
	else:
		health = value
		emit_signal("health_changed", health)
		if health <= 0:
			if !died :
				emit_signal("no_health")
				died = true
	
func heal(value):
	if (health + value) <= max_health:
		self.health += value
	else:
		self.health = max_health

func herculean_heal():
	var stacks = upgradeArrayStats[8] 
	if stacks > 0:
		var aux = randi() % 100
		if aux < stacks*10:
			heal(1)

func _ready():
	self.health = max_health
	initialMaxHealth = max_health

func set_berskerker_modifier(value):
	berserkerModifier = value

func on_upgrade_picked(position):
	self.upgradeArrayStats[position] += 1
	
func upgrades_changed(newArray):
	emit_signal("upgrades_change", newArray)

func reset_upgrades():
	#upgradeArrayStats = [0,0,0,0,0,0]
	for item in 6: #we only want to reset the in-run upgrades
		upgradeArrayStats[item] = 0
	
	self.upgradeArrayStats = upgradeArrayStats
	
