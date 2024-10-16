extends SelectionComponent

@onready var arrow: Control = $Arrow


func _on_selected() -> void:
	super()
	arrow.visible = true


func _on_deselected() -> void:
	super()
	arrow.visible = false
