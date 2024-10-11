@tool
extends Polygon2D


@export var collision_polygon: CollisionPolygon2D = get_parent()
@export var connect_update_shape: bool:
	set(value):
		if Engine.is_editor_hint():
			collision_polygon = get_parent()
			collision_polygon.draw.connect(update_polygon_shape)
			connect_update_shape = value


func _init() -> void:
	if Engine.is_editor_hint():
		collision_polygon = get_parent()
		collision_polygon.draw.connect(update_polygon_shape)


func _ready() -> void:
	if Engine.is_editor_hint():
		collision_polygon = get_parent()
		collision_polygon.draw.connect(update_polygon_shape)


func update_polygon_shape() -> void:
	if Engine.is_editor_hint():
		if !is_instance_valid(collision_polygon):
			collision_polygon = get_parent()
		polygon = collision_polygon.polygon
