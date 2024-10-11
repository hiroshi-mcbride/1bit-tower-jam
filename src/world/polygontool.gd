@tool
extends CollisionPolygon2D


@export var helper: PolygonToolHelper = get_parent():
	set(value):
		if Engine.is_editor_hint():
			if !is_instance_valid(value):
				push_error("Please assign a valid other_body")
			else:
				helper = value

@export var polygon2d: Polygon2D
@export var other_collision_polygon: CollisionPolygon2D
@export var other_polygon2d: Polygon2D

@export var generate: bool = is_instance_valid(polygon2d):
	set(value):
		if Engine.is_editor_hint():
			if value:
				polygon2d = Polygon2D.new() as Polygon2D
				add_child(polygon2d)
				polygon2d.set_owner(get_tree().edited_scene_root)
				polygon2d.set_name("Polygon2D")
				polygon2d.polygon = polygon
				polygon2d.color = helper.get_color()
				polygon2d.set_script(load("res://src/world/polygon_shape_updater.gd"))
				
				other_collision_polygon = CollisionPolygon2D.new() as CollisionPolygon2D
				helper.other_helper.add_child(other_collision_polygon)
				other_collision_polygon.set_owner(get_tree().edited_scene_root)
				other_collision_polygon.set_name("OtherCollisionPolygon2D")
				other_collision_polygon.polygon = polygon
				
				other_polygon2d = Polygon2D.new() as Polygon2D
				other_collision_polygon.add_child(other_polygon2d)
				other_polygon2d.set_owner(get_tree().edited_scene_root)
				other_polygon2d.set_name("OtherPolygon2D")
				other_polygon2d.polygon = polygon
				other_polygon2d.color = helper.other_helper.get_color()
				other_polygon2d.set_script(load("res://src/world/polygon_shape_updater.gd"))
			else:
				if is_instance_valid(polygon2d):
					polygon2d.queue_free()
				if is_instance_valid(other_collision_polygon):
					other_collision_polygon.queue_free()
				if is_instance_valid(other_polygon2d):
					other_polygon2d.queue_free()
			
			generate = value
