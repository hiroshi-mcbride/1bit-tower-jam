@tool
class_name PolygonToolHelper
extends StaticBody2D


@export var other_helper: PolygonToolHelper:
	set(value):
		if Engine.is_editor_hint():
			if !is_instance_valid(value) || value == self:
				push_error("Please assign a valid other_body")
			else:
				other_helper = value

@export var color: Color

func get_color() -> Color:
	return color
