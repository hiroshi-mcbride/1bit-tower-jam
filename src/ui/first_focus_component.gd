extends Node

@export var enable_on_start: bool

func _ready() -> void:
	if enable_on_start:
		enable()

func enable() -> void:
	var p = get_parent()
	if p is Control:
		p.grab_focus.call_deferred()
