extends Node2D

@export var main_menu_file: PackedScene
@export var pause_menu_file: PackedScene
@export var first_level: PackedScene

@onready var canvas_layer: CanvasLayer = $CanvasLayer

var current_level
var main_menu
var pause_menu


func _ready() -> void:
	GlobalSignals.game_started.connect(_on_game_started)
	GlobalSignals.level_changed.connect(_on_level_changed)
	main_menu = main_menu_file.instantiate()
	canvas_layer.add_child(main_menu)


# Connect a UI button to GlobalSignals.game_started to execute this function
func _on_game_started() -> void:
	main_menu.queue_free()
	load_level.call_deferred(first_level)
	pause_menu = pause_menu_file.instantiate()
	canvas_layer.add_child(pause_menu)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_level_changed(new_level: PackedScene) -> void:
	current_level.queue_free()
	load_level.call_deferred(new_level)


func load_level(new_level: PackedScene) -> void:
	current_level = new_level.instantiate()
	add_child(current_level)
