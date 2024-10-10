class_name BatState
extends State


enum StateType {INVALID, IDLE, CHASE}

var bat: Bat


func _ready() -> void:
	await owner.ready
	bat = owner as Bat


func physics_update(_delta: float) -> void:
	bat.move_and_slide()
	super.physics_update(_delta)
	

func get_state_type() -> int:
	return state_type_to_int(StateType.INVALID)


func string_to_state_type(state: int) -> StateType:
	return StateType.find_key(state)


func state_type_to_int(state: StateType) -> int:
	return int(state)
