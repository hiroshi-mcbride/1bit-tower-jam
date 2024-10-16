extends BaseButton


func _ready() -> void:
	pressed.connect(_on_pressed)
	#grab_focus.call_deferred()

func _on_pressed() -> void:
	GlobalSignals.game_started.emit()
