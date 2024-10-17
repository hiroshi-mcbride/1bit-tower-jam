extends Node

func _ready() -> void:
	enable()

func enable() -> void:
	var p = get_parent()
	if p is Control:
		p.grab_focus.call_deferred()
