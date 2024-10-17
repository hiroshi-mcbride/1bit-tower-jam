class_name ButtonWrapper
extends Control

@export var button_component: BaseButton

@onready var arrow: Control = $Arrow

var id: int

signal selected(selection_id: int)
signal deselected


func _ready() -> void:
	button_component.focus_entered.connect(_on_selected)
	button_component.mouse_entered.connect(_on_selected)
	button_component.focus_exited.connect(_on_deselected)


func _on_selected() -> void:
	arrow.visible = true
	# make sure the component gets focus even if the mouse is only hovering
	if !button_component.has_focus():
		button_component.grab_focus.call_deferred()


func _on_deselected() -> void:
	arrow.visible = false
