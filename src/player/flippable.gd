class_name Flippable extends Node2D

var is_flipped: bool = false:
	get:
		return is_flipped
	set(value):
		for sprites in find_children("*", "Sprite2D", false):
			sprites.flip_h = !sprites.flip_h
		
		is_flipped = value
