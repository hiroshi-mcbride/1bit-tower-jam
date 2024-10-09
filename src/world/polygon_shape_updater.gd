@tool
extends Polygon2D


@export var collision_polygon: CollisionPolygon2D = get_parent()


func _init():
	if Engine.is_editor_hint():
		collision_polygon.draw.connect(update_polygon_shape)


func update_polygon_shape():
	if Engine.is_editor_hint():
		polygon = collision_polygon.polygon
