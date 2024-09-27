extends Control

@onready var overlay: ColorRect = $overlay


func _ready() -> void:
	overlay.visible = false


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		toggle_paused()


func toggle_paused() -> void:
	get_tree().paused = not get_tree().paused
	overlay.visible = get_tree().paused
	if overlay.visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		#btn_resume.grab_focus()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_game_quit() -> void:
	get_tree().paused = false
	queue_free()
