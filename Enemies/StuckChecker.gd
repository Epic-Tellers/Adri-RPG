extends Node2D

signal stucked
var lastSavedPosition = Vector2.ZERO
onready var timer = $StuckCheckerTimer

export var TIME = 8.0
export var DISTANCE = 50.0

func _ready():
	lastSavedPosition = global_position
	timer.start(TIME)

func _on_StuckCheckerTimer_timeout():
	if global_position.distance_to(lastSavedPosition) < DISTANCE:
		emit_signal("stucked")
	lastSavedPosition = global_position
	timer.start(TIME)
