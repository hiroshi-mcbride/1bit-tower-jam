extends Node2D


var nodes : Array[Node]
@export var activation_distance: int = 1000


func _ready() -> void:
	nodes = get_children()
	for node in nodes:
		node.process_mode = Node.PROCESS_MODE_DISABLED


func _process(delta: float) -> void:
	var squared_distance = activation_distance * 2
	
	if Player.instance != null:
		squared_distance = global_position.distance_squared_to(Player.instance.global_position)
	
	if squared_distance < activation_distance * activation_distance:
		for node in nodes:
			node.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		for node in nodes:
			node.process_mode = Node.PROCESS_MODE_DISABLED
