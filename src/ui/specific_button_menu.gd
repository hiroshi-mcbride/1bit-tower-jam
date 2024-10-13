extends Control

@export var next_scene: PackedScene
@export var pressing_starts_game: bool
@export var actions: Array[StringName]
var multiple_actions

var triggered: bool = false

func _ready() -> void:
	if actions.size() == 0:
		printerr("no actions assigned to menu " + name)
		return
	else:
		for a: StringName in actions:
			if !InputMap.has_action(a):
				printerr("Action " + a + " not valid")

func _process(delta: float) -> void:
	if triggered:
		return
	var i: int = 0
	for a: StringName in actions:
		if Input.is_action_pressed(a):
			i+=1
	if i == actions.size():
		triggered = true
		if !pressing_starts_game && next_scene != null:
			GlobalSignals.menu_changed.emit(next_scene)
		elif pressing_starts_game:
			GlobalSignals.game_started.emit()
