class_name BatChase
extends BatState


const STATE_TYPE = StateType.CHASE
const MIN_CHASE_SPEED: float = 60.0
const MAX_CHASE_SPEED: float = 200.0
const STEERING_VALUE: float = 3
const SMOOTHING_VALUE: float = 0.9
var directions: PackedVector2Array = [Vector2(1,0),Vector2(1,-1),Vector2(0,-1),Vector2(-1,-1),Vector2(-1,0),Vector2(-1,1),Vector2(0,1),Vector2(1,1)]


func get_state_type() -> int:
	return state_type_to_int(STATE_TYPE)


func physics_update(delta: float) -> void:
	# Initialze a context map and get the direction to the player
	var context_map: PackedFloat32Array = [0,0,0,0,0,0,0,0]
	var player_direction: Vector2 = (Player.instance.global_position - bat.global_position).normalized()
	
	# Get the best direction index using a loop, dot product and danger array
	var best_index: int = 0
	var best_interest: float = 0
	for index in range(directions.size()):
		var interest = directions[index].dot(player_direction) - bat.danger_sensor_component.danger_array[index]
		context_map[index] = interest
		
		if index != 0 && interest > best_interest:
			best_interest = interest
			best_index = index
	
	# Lerp the enemy's velocity towards the best direction
	var normalized_velocity: Vector2 = bat.get_velocity().normalized()
	var smoothed_direction: Vector2 = normalized_velocity.lerp(directions[best_index], SMOOTHING_VALUE).normalized()
	
	# Calculate the steering force towards the smoothed best direction
	var steering_force: Vector2 = (smoothed_direction - normalized_velocity) * STEERING_VALUE
	
	# Limit the new velocity to a minimum and maximum speed
	var new_velocity = bat.get_velocity() + steering_force
	var new_velocity_length_squared = new_velocity.length_squared()
	if new_velocity_length_squared < MIN_CHASE_SPEED * MIN_CHASE_SPEED:
		new_velocity = new_velocity.normalized() * MIN_CHASE_SPEED
	elif new_velocity_length_squared > MAX_CHASE_SPEED * MAX_CHASE_SPEED:
		new_velocity = new_velocity.normalized() * MAX_CHASE_SPEED
	
	bat.set_velocity(new_velocity)
	super.physics_update(delta)
