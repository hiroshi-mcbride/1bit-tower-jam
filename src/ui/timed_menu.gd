extends Control

@export var next_scene : PackedScene
@export var time : float
@onready var timer: Timer = $Timer

func _ready() -> void:
	timer.start(time)

func _on_timer_timeout() -> void:
	GlobalSignals.menu_changed.emit(next_scene)
