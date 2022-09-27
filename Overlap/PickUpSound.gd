extends AudioStreamPlayer


func _on_PickUpSound_finished():
	queue_free()
