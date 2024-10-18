extends Node

enum VolumeType {GLOBAL, MUSIC, SFX, }

func _ready() -> void:
	
	GlobalSignals.volume_changed.connect(_on_volume_changed)



func _on_volume_changed(type: VolumeType, value: float) -> void:
	AudioServer.set_bus_volume_db(type, value)
