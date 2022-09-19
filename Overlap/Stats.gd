extends Node
export var max_health = 1 setget set_max_health #var appears in editor
export var invincible = false
var health = max_health setget set_health #values put in editor are updated on ready!

signal no_health
signal health_changed(value)
signal max_health_changed(value)

func set_max_health(value):
	max_health = value
	self.health = min(health, max_health)
	emit_signal("max_health_changed", max_health)

func set_health(value):
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
