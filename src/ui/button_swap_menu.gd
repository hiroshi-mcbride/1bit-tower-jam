extends BaseButton

@export var new_menu: PackedScene

func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	GlobalSignals.menu_changed.emit(new_menu)
