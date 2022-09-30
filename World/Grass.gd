extends Node2D

const GrassEffect = preload("res://Effects/GrassEffect.tscn")
signal grass_died(pos)

func _ready():
	var world = get_tree().current_scene
	if self.connect("grass_died",world,"_on_grass_died") != OK:
		print("Error in Grass trying to connect grass_died signal to _on_grass_died method")

func create_grass_effect():
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position #the first one, from GrassEffect. The second one, from the owner of the script!	

func _on_Grass_area_entered(_area):
	create_grass_effect()
	#emit_signal("grass_died", global_position)
	queue_free() #the object that is owner of this line (in this case, Grass) is added to a QUEUE of nodes to be FREE (destroyed). It waits until the end of the frame.
