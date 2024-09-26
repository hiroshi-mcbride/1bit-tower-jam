extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pressed.connect(_on_pressed)
	pass # Replace with function body.

func _on_pressed():
	GlobalSignals.game_started.emit()
