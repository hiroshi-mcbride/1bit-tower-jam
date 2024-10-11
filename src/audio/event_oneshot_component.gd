extends Node

func _ready() -> void:
	owner = get_parent()
	assert(owner is AudioStreamPlayer2D)

func _on_invoke() -> void:
	owner.play()
