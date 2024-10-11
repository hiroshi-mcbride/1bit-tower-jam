class_name BatIdle
extends BatState


const STATE_TYPE = StateType.IDLE
const CHASE_START_DISTANCE: float = 125.0


func get_state_type() -> int:
	return state_type_to_int(STATE_TYPE)


func update(_delta: float) -> void:
	if bat.squared_distance < CHASE_START_DISTANCE * CHASE_START_DISTANCE:
		finished.emit(state_type_to_int(StateType.CHASE))


func physics_update(delta: float) -> void:
	bat.set_velocity(Vector2.ZERO)
	super.physics_update(delta)
