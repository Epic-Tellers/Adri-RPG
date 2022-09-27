extends Control

signal back_pressed

func _ready():
	pass # Replace with function body.

func _on_BackButton_pressed():
	emit_signal("back_pressed")
