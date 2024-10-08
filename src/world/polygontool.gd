@tool
extends CollisionPolygon2D

@export var helper: PolygonToolHelper = get_parent():
	set(value):
		if Engine.is_editor_hint():
			if !is_instance_valid(value):
				push_error("Please assign a valid other_body")
			else:
				helper = value

var vis_polygon: Polygon2D
var other_collision_polygon: CollisionPolygon2D
var other_polygon: Polygon2D

@export var generate: bool = false:
	set(value):
		if Engine.is_editor_hint():
			if value:
				vis_polygon = Polygon2D.new() as Polygon2D
				add_child(vis_polygon)
				vis_polygon.set_owner(get_tree().edited_scene_root)
				vis_polygon.set_name("Polygon2D")
				vis_polygon.polygon = polygon
				vis_polygon.color = helper.get_color()
				
				other_collision_polygon = CollisionPolygon2D.new() as CollisionPolygon2D
			
				helper.other_helper.add_child(other_collision_polygon)
				other_collision_polygon.set_owner(get_tree().edited_scene_root)
				other_collision_polygon.set_name("OtherCollisionPolygon2D")
				other_collision_polygon.polygon = polygon
			
				other_polygon = Polygon2D.new() as Polygon2D
				other_collision_polygon.add_child(other_polygon)
				other_polygon.set_owner(get_tree().edited_scene_root)
				other_polygon.set_name("OtherPolygon2D")
				other_polygon.polygon = polygon
				other_polygon.color = helper.other_helper.get_color()
			else:
				vis_polygon.queue_free()
				other_collision_polygon.queue_free()
				other_polygon.queue_free()
			generate = value
