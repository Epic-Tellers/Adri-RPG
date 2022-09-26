extends HBoxContainer

var currentPercentage = 1.0
signal percentage_changed

func _ready():
	if $SubtractButton.connect("pressed",self,"_on_button_pressed", [-.1]) != OK:
		print("Failed to connect pressed signal from subtract button to range control")
	if $AddButton.connect("pressed",self,"_on_button_pressed",[.1]) != OK:
		print("Failed to connect pressed signal from Add button to range control")
	
func _on_button_pressed(change):
	set_current_percentatge(currentPercentage + change)

func set_current_percentatge(percent):
	currentPercentage = clamp(percent, 0,1)
	var labelNumber = currentPercentage * 10
	labelNumber = round(labelNumber)
	$Label.text = str(labelNumber)
	emit_signal("percentage_changed", currentPercentage)
