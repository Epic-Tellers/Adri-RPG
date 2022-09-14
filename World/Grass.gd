extends Node2D

func _ready():
	pass # Replace with function body.

const GrassEffect = preload("res://Effects/GrassEffect.tscn")

func create_grass_effect():
	var grassEffect = GrassEffect.instance()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position #the first one, from GrassEffect. The second one, from the owner of the script!	

func _on_Hurtbox_area_entered():
	create_grass_effect()
	queue_free() #the object that is owner of this line (in this case, Grass) is added to a QUEUE of nodes to be FREE (destroyed). It waits until the end of the frame.
