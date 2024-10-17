extends Node

func _ready() -> void:
	var p = get_parent()
	if p is Control:
		p.grab_focus.call_deferred()
