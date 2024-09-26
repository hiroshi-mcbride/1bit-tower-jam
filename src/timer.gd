extends Timer

@export var level2:PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeout.connect(_on_timeout)


func _on_timeout():
	print("aaaa")
	GlobalSignals.level_changed.emit(level2)
