class_name IceAxe
extends RigidBody2D

@export var is_left_hand: bool
@export var hand: PinJoint2D
@export var hand_torque: float

@export var shoulder: PinJoint2D
@export var shoulder_torque: float

@onready var timer: Timer = $Timer

var is_swinging: bool = false
var is_on_wall: bool = false



func _ready() -> void:
	#HACK: pin joint gets super weird at rotations around 180, so i'm rotating the child nodes instead
	if is_left_hand:
		$Sprite2D.rotation_degrees = 180
		$Area2D.rotation_degrees = 180
		$CollisionShape2D.rotation_degrees = 180
	
	timer.timeout.connect(_on_timeout)


func swing() -> void:
	is_swinging = true
	shoulder.motor_target_velocity = -shoulder_torque
	shoulder.motor_enabled = true


func drop() -> void:
	is_on_wall = false
	freeze = false
	is_swinging = false
	shoulder.motor_target_velocity = 0
	timer.start()


func pull() -> void:
	hand.motor_target_velocity = hand_torque
	hand.motor_enabled = true


func stop_pulling() -> void:
	hand.motor_target_velocity = 0
	hand.motor_enabled = false


func hold() -> void:
	is_swinging = false
	shoulder.motor_target_velocity = 0
	shoulder.motor_enabled = false
	is_on_wall = true
	freeze = true


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !timer.is_stopped:
		return
	hold()


func _on_timeout() -> void:
	shoulder.motor_enabled = false
	timer.stop()
