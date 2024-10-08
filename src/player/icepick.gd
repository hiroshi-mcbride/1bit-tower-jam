class_name IceAxe
extends RigidBody2D

@export var is_left_hand: bool
@export var hand: PinJoint2D
@export var hand_torque: float
@export var shoulder: PinJoint2D
@export var shoulder_torque: float

@onready var timer: Timer = $Timer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D

var is_on_wall: bool = false
var flipped: bool = false


func _ready() -> void:
	#HACK: pin joint gets super weird at rotations around 180, so i'm rotating the child nodes instead
	if is_left_hand:
		$Sprite2D.rotation_degrees = 180
		$Area2D.rotation_degrees = 180
		$CollisionShape2D.rotation_degrees = 180
	
	timer.timeout.connect(_on_timeout)


func swing() -> void:
	shoulder.motor_target_velocity = -shoulder_torque
	shoulder.motor_enabled = true


func drop() -> void:
	is_on_wall = false
	freeze = false
	shoulder.motor_target_velocity = 0
	timer.start()


func pull() -> void:
	hand.motor_target_velocity = hand_torque
	hand.motor_enabled = true


func stop_pulling() -> void:
	hand.motor_target_velocity = 0
	hand.motor_enabled = false


func hold() -> void:
	shoulder.motor_target_velocity = 0
	shoulder.motor_enabled = false
	is_on_wall = true
	freeze = true


func _on_area_2d_body_entered(_body: Node2D) -> void:
	if !timer.is_stopped:
		return
	hold()


func _on_timeout() -> void:
	shoulder.motor_enabled = false
	timer.stop()


func flip(color_flipped: bool) -> void:
	hand_torque = -hand_torque
	shoulder_torque = -shoulder_torque
	
	var temp_lower = hand.angular_limit_lower
	hand.angular_limit_lower = -hand.angular_limit_upper
	hand.angular_limit_upper = -temp_lower
	
	area_2d.collision_mask = LayerNames.PHYSICS_2D.WHITE if color_flipped else !LayerNames.PHYSICS_2D.WHITE
	area_2d.collision_mask = LayerNames.PHYSICS_2D.BLACK if !color_flipped else !LayerNames.PHYSICS_2D.BLACK
