class_name IceAxe
extends RigidBody2D

@onready var timer: Timer = $Timer

const SWING_VELOCITY = -50.0
const OTHER_SWING_VELOCITY = 25.0
var is_swinging: bool
var joint: PinJoint2D
var other_joint: PinJoint2D


func _ready() -> void:
	pass


func _physics_process(delta: float) -> void:
	if is_swinging:
		pass


func swing(joint: PinJoint2D, other_joint: PinJoint2D) -> void:
	self.joint = joint
	
	is_swinging = true
	joint.motor_target_velocity = SWING_VELOCITY
	other_joint.motor_target_velocity = OTHER_SWING_VELOCITY
	other_joint.motor_enabled = true
	joint.motor_enabled = true
	
	timer.start()


func drop(joint: PinJoint2D, other_joint: PinJoint2D) -> void:
	self.joint = joint
	
	is_swinging = false
	joint.motor_target_velocity = 0
	other_joint.motor_target_velocity = 0
	other_joint.motor_enabled = false
	joint.motor_enabled = false
	
	freeze = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if timer.is_stopped():
		is_swinging = false
	
		if joint:
			joint.motor_target_velocity = 0
			joint.motor_enabled = false
	
		freeze = true
