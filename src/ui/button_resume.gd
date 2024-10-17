extends BaseButton

signal resumed


func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	resumed.emit()
