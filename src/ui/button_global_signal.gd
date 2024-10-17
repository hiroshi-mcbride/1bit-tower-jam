extends BaseButton


@export var signal_name: StringName


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	GlobalSignals.emit_signal(signal_name)
