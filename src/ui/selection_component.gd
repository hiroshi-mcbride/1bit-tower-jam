class_name SelectionComponent
extends Control

@export var control_component: Control

var id: int
var active: bool

signal selected(selection_id: int)
signal deselected


func _ready() -> void:
	control_component.focus_entered.connect(_on_selected)
	control_component.mouse_entered.connect(_on_selected)
	control_component.focus_exited.connect(_on_deselected)


func _on_selected() -> void:
	# make sure the component gets focus even if the mouse is only hovering
	if !control_component.has_focus():
		control_component.grab_focus.call_deferred()
	active = true


func _on_deselected() -> void:
	active = false
