extends Node2D

@export var first_menu_file: PackedScene
@export var main_menu_file: PackedScene
@export var pause_menu_file: PackedScene
@export var first_level_file: PackedScene
@export var win_screen_file: PackedScene

@onready var canvas_layer: CanvasLayer = $CanvasLayer

var current_level: Node2D
var current_level_file: PackedScene
var current_menu: Control
var pause_menu: Control

var reset_enabled: bool = false

func _ready() -> void:
	GlobalSignals.game_started.connect(_on_game_started)
	GlobalSignals.level_changed.connect(_on_level_changed)
	GlobalSignals.menu_changed.connect(_on_menu_changed)
	GlobalSignals.game_won.connect(_on_game_won)
	GlobalSignals.game_quit.connect(_on_game_quit)
	GlobalSignals.level_reset.connect(restart_level)
	current_menu = first_menu_file.instantiate()
	canvas_layer.add_child(current_menu)


# Connect a UI button to GlobalSignals.game_started to execute this function
func _on_game_started() -> void:
	current_menu.queue_free()
	load_level.call_deferred(first_level_file)
	pause_menu = pause_menu_file.instantiate()
	canvas_layer.add_child(pause_menu)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	await get_tree().create_timer(0.2).timeout
	reset_enabled = true


func _on_level_changed(new_level: PackedScene) -> void:
	reset_enabled = false
	current_level.queue_free()
	remove_child(current_level)
	load_level.call_deferred(new_level)
	await get_tree().create_timer(0.2).timeout
	reset_enabled = true


func _on_menu_changed(new_menu: PackedScene) -> void:
	current_menu.queue_free()
	load_menu.call_deferred(new_menu)


func _on_game_won() -> void:
	current_level.queue_free()
	load_menu(win_screen_file)
	await get_tree().create_timer(0.2).timeout
	current_level = null

func _on_game_quit() -> void:
	current_level.queue_free()
	load_menu(main_menu_file)
	await get_tree().create_timer(0.2).timeout
	current_level = null


func restart_level() -> void:
	_on_level_changed(current_level_file)


func load_level(new_level: PackedScene) -> void:
	current_level_file = new_level
	current_level = new_level.instantiate()
	add_child(current_level)


func load_menu(new_menu: PackedScene) -> void:
	current_menu = new_menu.instantiate()
	canvas_layer.add_child(current_menu)
