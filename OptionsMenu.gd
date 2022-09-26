extends Control

signal back_pressed

onready var backButton = $Panel/MainScreen/Holder/BackButton
onready var windowModeButton = $Panel/MainScreen/Holder/HBoxContainer/ButtonWindowMode

var fullscreen = false

func _ready():
	update_display()
	windowModeButton.grab_focus()

func update_display():
	windowModeButton.text = "WINDOWED" if !fullscreen else "FULLSCREEN"


func _on_ButtonWindowMode_pressed():
	fullscreen = !fullscreen
	OS.window_fullscreen = fullscreen
	update_display()

func _on_BackButton_pressed():
	emit_signal("back_pressed")
