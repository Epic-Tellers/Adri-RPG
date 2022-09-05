extends Node
export var max_health = 1 #var appears in editor
onready var health = max_health setget set_health #values put in editor are updated on ready!

signal no_health

func set_health(value):
	health = value
	if health <= 0:
		emit_signal("no_health")
