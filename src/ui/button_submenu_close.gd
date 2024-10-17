extends BaseButton

@export var parent_submenu: Submenu

func _ready() -> void:
	pressed.connect(_on_pressed)


func _on_pressed() -> void:
	parent_submenu.visible = false
	parent_submenu.closed.emit()
	parent_submenu.process_mode = Node.PROCESS_MODE_DISABLED
