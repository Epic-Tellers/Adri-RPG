extends HBoxContainer

var currentPercentage = 1.0
signal percentage_changed

func _ready():
	$SubtractButton.connect("pressed",self,"_on_button_pressed", [-.1])
	$AddButton.connect("pressed",self,"_on_button_pressed",[.1])
	
func _on_button_pressed(change):
	set_current_percentatge(currentPercentage + change)

func set_current_percentatge(percent):
	currentPercentage = clamp(percent, 0,1)
	var labelNumber = currentPercentage * 10
	labelNumber = round(labelNumber)
	$Label.text = str(labelNumber)
	emit_signal("percentage_changed", currentPercentage)
