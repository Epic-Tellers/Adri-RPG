extends Control

signal back_pressed

onready var backButton = $Panel/MainScreenOptions/Holder/BackButton
onready var windowModeButton = $Panel/MainScreenOptions/Holder/HBoxContainer/ButtonWindowMode
onready var musicRangeControl = $Panel/MainScreenOptions/Holder/MusicVolumeContainer/RangeControl
onready var sfxRangeControl = $Panel/MainScreenOptions/Holder/SfxVolumeContainer/RangeControl
onready var options = $Panel/MainScreenOptions

onready var controls = $Panel/ControlsMenu
onready var controlBackButton = $Panel/ControlsMenu/ControlsBackButton

var fullscreen = true

func _ready():
	update_display()
	windowModeButton.grab_focus()
	musicRangeControl.connect("percentage_changed", self, "_on_music_volume_changed")
	sfxRangeControl.connect("percentage_changed", self, "_on_sfx_volume_changed")
	update_initial_volume_settings()

func _on_music_volume_changed(percent):
	update_bus_volume("Music", percent)
	
func _on_sfx_volume_changed(percent):
	update_bus_volume("SFX", percent)

func update_initial_volume_settings(): 
	var musicPercent = get_bus_volume_percent("Music")
	musicRangeControl.set_current_percentatge(musicPercent)
	var sfxPercent = get_bus_volume_percent("SFX")
	sfxRangeControl.set_current_percentatge(sfxPercent)
	
func get_bus_volume_percent(busName):
	var busIdx = AudioServer.get_bus_index(busName)
	var volumePercent = db2linear(AudioServer.get_bus_volume_db(busIdx))
	return volumePercent

func update_bus_volume(busName, volumePercent):
	var busIdx = AudioServer.get_bus_index(busName)
	AudioServer.set_bus_volume_db(busIdx, linear2db(volumePercent))

func update_display():
	windowModeButton.text = "FULLSCREEN" if fullscreen else "WINDOWED"


func _on_ButtonWindowMode_pressed():
	fullscreen = false if fullscreen else true
	OS.window_fullscreen = fullscreen
	print("got to change mode to: "+str(fullscreen))
	update_display()

func _on_BackButton_pressed():
	emit_signal("back_pressed")

func _on_Controls_pressed():
	toggle_visibility_options()
	controlBackButton.grab_focus()
	
func toggle_visibility_options():
	options.visible = !options.visible
	controls.visible = !controls.visible

func _on_ControlsBackButton_pressed():
	toggle_visibility_options()
	windowModeButton.grab_focus()
