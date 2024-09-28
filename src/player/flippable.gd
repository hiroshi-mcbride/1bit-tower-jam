class_name Flippable extends Node2D

var is_flipped: bool = false:
	get:
		return is_flipped
	set(value):
		for n in get_children():
			n.position.x = -n.position.x
			if n is Sprite2D:
				n.flip_h = !n.flip_h
		
		is_flipped = value
