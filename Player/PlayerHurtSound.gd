extends AudioStreamPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if connect("finished", self, "queue_free") != OK:
		print("Error in PlayerGurtSound trying to connect finished signal to queue_free method")


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
