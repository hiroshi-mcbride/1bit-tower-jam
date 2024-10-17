extends BaseButton

@export var previous_menu: Control
@export var submenu: Submenu

func _ready() -> void:
	pressed.connect(_on_pressed)
	submenu.closed.connect(_on_submenu_closed)


func _on_pressed() -> void:
	submenu.process_mode = Node.PROCESS_MODE_INHERIT
	submenu.visible = true
	submenu.opened.emit()
	previous_menu.visible = false
	previous_menu.process_mode = Node.PROCESS_MODE_DISABLED


func _on_submenu_closed() -> void:
	previous_menu.process_mode = Node.PROCESS_MODE_INHERIT
	previous_menu.visible = true
	grab_focus.call_deferred()
