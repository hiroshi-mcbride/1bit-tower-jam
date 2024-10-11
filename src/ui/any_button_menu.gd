extends Control

@export var next_scene : PackedScene
@export var pressing_starts_game: bool

func _input(event: InputEvent) -> void:
	if event.is_pressed():
		if !pressing_starts_game && next_scene != null:
			GlobalSignals.menu_changed.emit(next_scene)
		else:
			GlobalSignals.game_started.emit()
