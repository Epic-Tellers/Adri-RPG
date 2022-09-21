extends Node
export var max_health = 1 setget set_max_health #var appears in editor
export var invincible = false
var health = max_health setget set_health #values put in editor are updated on ready!
var berserkerModifier = 0 #makes you take more damage

var initialMaxHealth

var upgradeArrayStats = [0,0,1,0,0,0] setget upgrades_changed #for more info, go to Player.gd
#var upgradeArray = [0,0,0,0,0,0] setget upgrade_array_got_changed #updated from a signal fired on a setget on PlayerStats
#Each position in the array codifies for an upgrade. The number on the position, number of instances player has of that upgrade.
# pos 0 : Berserker: Take +1 from everythinh, do +1 on everything
# pos 1 : Resilient: Max hp +1
# pos 2 : Sorcerer: On attack, shoot a fireball
# pos 3 : Dancer: Rolling decreases charge time on charged attack
# pos 4 : Babe Ruth: More knockback on ememies. Increased movement speed.
# pos 5 : Echo: Releasing a charged attack makes it trigger an additional time 

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
	health = value
	emit_signal("health_changed", health)
	if health <= 0:
		emit_signal("no_health")
	if invincible:
		health = max_health
	
func heal(value):
	if (health + value) <= max_health:
		self.health += value
	else:
		self.health = max_health

func _ready():
	self.health = max_health
	initialMaxHealth = max_health

func set_berskerker_modifier(value):
	berserkerModifier = value

func on_upgrade_picked(position):
	self.upgradeArrayStats[position] += 1
	
func upgrades_changed(newArray):
	emit_signal("upgrades_change", newArray)
	
