extends Node2D

@export var first_menu_file: PackedScene
@export var pause_menu_file: PackedScene
@export var first_level: PackedScene

@onready var canvas_layer: CanvasLayer = $CanvasLayer

var current_level
var first_menu
var current_menu
var pause_menu


func _ready() -> void:
	GlobalSignals.game_started.connect(_on_game_started)
	GlobalSignals.level_changed.connect(_on_level_changed)
	GlobalSignals.menu_changed.connect(_on_menu_changed)
	current_menu = first_menu_file.instantiate()
	canvas_layer.add_child(current_menu)


# Connect a UI button to GlobalSignals.game_started to execute this function
func _on_game_started() -> void:
	current_menu.queue_free()
	load_level.call_deferred(first_level)
	pause_menu = pause_menu_file.instantiate()
	canvas_layer.add_child(pause_menu)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_level_changed(new_level: PackedScene) -> void:
	current_level.queue_free()
	load_level.call_deferred(new_level)

func _on_menu_changed(new_menu: PackedScene) -> void:
	current_menu.queue_free()
	load_menu.call_deferred(new_menu)

func load_level(new_level: PackedScene) -> void:
	current_level = new_level.instantiate()
	add_child(current_level)

func load_menu(new_menu: PackedScene) -> void:
	current_menu = new_menu.instantiate()
	canvas_layer.add_child(current_menu)
