extends Node2D

@export var ice_axe_left: IceAxe
@export var ice_axe_right: IceAxe
@export var rigidbodies: Array[RigidBody2D]

@onready var left_pivot: PinJoint2D = $Shoulder_Q
@onready var right_pivot: PinJoint2D = $Shoulder_E


func _physics_process(delta: float) -> void:
	# Climbing logic
	if Input.is_action_just_pressed("axe_left"):
		ice_axe_left.swing()
		if ice_axe_right.is_on_wall:
			ice_axe_right.pull()
	
	if Input.is_action_just_released("axe_left"):
		ice_axe_left.drop()
		ice_axe_right.stop_pulling()
	
	if Input.is_action_just_pressed("axe_right"):
		ice_axe_right.swing()
		if ice_axe_left.is_on_wall:
			ice_axe_left.pull()
	
	if Input.is_action_just_released("axe_right"):
		ice_axe_right.drop()
		ice_axe_left.stop_pulling()
	
	if ice_axe_right.is_on_wall:
		if !Input.is_action_pressed("axe_right"):
			ice_axe_right.drop()
		ice_axe_left.stop_pulling()
	
	if ice_axe_left.is_on_wall:
		if !Input.is_action_pressed("axe_left"):
			ice_axe_left.drop()
		ice_axe_right.stop_pulling()
	
	# Switching sides
	if Input.is_action_just_released("color_switch"):
		# Flip player collision masks
		for rigidbody in rigidbodies:
			if rigidbody.get_collision_mask_value(1):
				rigidbody.set_collision_mask_value(1, false)
				rigidbody.set_collision_mask_value(2, true)
			else:
				rigidbody.set_collision_mask_value(1, true)
				rigidbody.set_collision_mask_value(2, false)
			
			rigidbody.apply_scale(Vector2(-1,1))
		
		translate(Vector2(200,0))
		# Flip player sprites
		
		# Flip player color
