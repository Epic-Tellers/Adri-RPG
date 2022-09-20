extends Control

var hearts = 4 setget set_hearts
var max_hearts = 4 setget set_max_hearts

onready var heartUIFull = $HeartUIFull
onready var heartUIEmpty = $HeartUIEmpty
const UI_HEART_WIDTH = 15 #15 because thats how much pixel wide is each heart

func set_hearts(value):
	hearts = clamp(value,0,max_hearts)
	if heartUIFull != null:
		heartUIFull.rect_size.x = hearts * UI_HEART_WIDTH 

func set_max_hearts(value):
	max_hearts = max(value,1)
	self.hearts = min(hearts, max_hearts)
	if heartUIEmpty != null:
		heartUIEmpty.rect_size.x = max_hearts * UI_HEART_WIDTH

func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	if PlayerStats.connect("health_changed",self, "set_hearts") != OK:
		print("Error in Health UI trying to connect health_changed signal to set_hearts method")
	if PlayerStats.connect("max_health_changed",self, "set_max_hearts") != OK:
		print("Error in Health UI trying to connect max_health_changed signal to set_max_hearts method")
