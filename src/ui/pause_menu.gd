extends Control

@onready var overlay: TextureRect = $ReferenceRect/overlay

signal paused

func _ready() -> void:
	overlay.visible = false
	GlobalSignals.level_reset.connect(_on_restart)
	GlobalSignals.game_won.connect(_on_game_quit)
	GlobalSignals.game_quit.connect(_on_game_quit)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_paused()


func toggle_paused() -> void:
	get_tree().paused = !get_tree().paused
	overlay.visible = get_tree().paused
	if overlay.visible:
		paused.emit()


func _on_restart() -> void:
	get_tree().paused = false
	overlay.visible = false


func _on_game_quit() -> void:
	get_tree().paused = false
	queue_free()
