@tool
extends CollisionPolygon2D

@export var other_polygon: Polygon2D

@export var generate: bool = false:
	set(value):
		if value == true:
			polygon = other_polygon.polygon
		generate = value
