extends Area2D

func call_all_allies(body):
		for item in get_overlapping_bodies():
			if item != null: #yeah, you can kill enemies in between calls
				item.asign_player(body)
