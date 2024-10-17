class_name VolumeSlider
extends Slider

@export var type: AudioManager.VolumeType

func _ready() -> void:
	set_value_no_signal(db_to_linear(AudioServer.get_bus_volume_db(type)))
	value_changed.connect(_on_value_changed)
	mouse_entered.connect(_on_mouse_entered)

func _on_mouse_entered() -> void:
	grab_focus.call_deferred()

func _on_value_changed(value: float) -> void:
	GlobalSignals.volume_changed.emit(type, linear_to_db(value))
