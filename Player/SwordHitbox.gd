extends "res://Overlap/Hitbox.gd"

var knockback_vector = Vector2.ZERO #it gets updated in the player script in move_state
var originalKnockback

func _ready():
	originalKnockback = self.KNOCKBACK_FORCE

func augment_knockback(factor):
	self.KNOCKBACK_FORCE = originalKnockback*factor
