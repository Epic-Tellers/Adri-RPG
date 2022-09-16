extends Camera2D

onready var topLeft = $Limits/TopLeft
onready var bottomRight = $Limits/BottomRight
var zooming = false

func _ready():
	limit_top = topLeft.position.y
	limit_left = topLeft.position.x
	limit_bottom = bottomRight.position.y
	limit_right = bottomRight.position.x
	PlayerStats.connect("no_health",self,"death_zoom")

func _process(delta):
	if (zooming):
		zoom_slowly()

func death_zoom():
	zooming = true

func zoom_slowly():
	zoom *= 0.99
