extends "res://Overlap/Hitbox.gd"

var originalKnockback

func _ready():
	originalKnockback = self.KNOCKBACK_FORCE

func augment_knockback(factor):
	self.KNOCKBACK_FORCE = originalKnockback*factor
