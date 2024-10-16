class_name MenuContainer 
extends Control

@export var items: Array[SelectionComponent]

var current_selection: int = 0


func _ready() -> void:
	var i: int = 0
	for item: SelectionComponent in items:
		item.id = i
		i+=1
	
