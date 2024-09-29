class_name IceAxe
extends RigidBody2D

@export var is_left_hand: bool
@export var hand: PinJoint2D
@export var hand_torque: float
@export var flipped_angular_limit_lower: float
@export var flipped_angular_limit_upper: float
@export var shoulder: PinJoint2D
@export var shoulder_torque: float

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var area_2d: Area2D = $Area2D
@onready var trigger: CollisionShape2D = $Area2D/Trigger
@onready var collider: CollisionPolygon2D = $Collider


var is_on_wall: bool = false
var flipped: bool = false
var area_entered: bool = false


func _ready() -> void:
	#HACK: pin joint gets super weird at rotations around 180, so i'm rotating the child nodes instead
	if is_left_hand:
		$Sprite2D.rotation_degrees = 180
		area_2d.rotation_degrees = 180
		collider.rotation_degrees = 180
		center_of_mass.x = -center_of_mass.x


func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	if area_entered and is_on_wall:
		# TODO: store collision point and normal
		# and maybe push back the axe a bit so it doesn't overlap with the wall?
		freeze = true
		area_entered = false


func swing() -> void:
	freeze = false
	shoulder.motor_target_velocity = -shoulder_torque
	shoulder.motor_enabled = true
	hand.motor_target_velocity = -shoulder_torque
	hand.motor_enabled = true


func drop() -> void:
	is_on_wall = false
	freeze = false
	disable_motors()


func disable_motors() -> void:
	shoulder.motor_target_velocity = 0
	shoulder.motor_enabled = false
	hand.motor_target_velocity = 0
	hand.motor_enabled = false


func _on_area_2d_body_entered(_body: Node2D) -> void:
	area_entered = true
	is_on_wall = true
	#freeze = true
	disable_motors()


func pull() -> void:
	hand.motor_target_velocity = hand_torque
	hand.motor_enabled = true


func stop_pulling() -> void:
	hand.motor_target_velocity = 0
	hand.motor_enabled = false


func flip(color_flipped: bool) -> void:
	hand_torque = -hand_torque
	shoulder_torque = -shoulder_torque
	
	# Make sure all sub-components are properly flipped
	trigger.position.y = 8 if color_flipped else -8
	sprite_2d.flip_v = !color_flipped
	center_of_mass.y = -center_of_mass.y
	
	# flip all vertices in the Polygon collider
	var new_polygon: PackedVector2Array
	for v in collider.polygon:
		v.y = -v.y
		new_polygon.append(v)
	collider.polygon = new_polygon
	
	var temp_limit = rad_to_deg(hand.angular_limit_lower)
	hand.angular_limit_lower = deg_to_rad(flipped_angular_limit_lower)
	flipped_angular_limit_lower = temp_limit
	
	temp_limit = rad_to_deg(hand.angular_limit_upper)
	hand.angular_limit_upper = deg_to_rad(flipped_angular_limit_upper)
	flipped_angular_limit_upper = temp_limit
	
	area_2d.collision_mask = LayerNames.PHYSICS_2D.WHITE if color_flipped else !LayerNames.PHYSICS_2D.WHITE
	area_2d.collision_mask = LayerNames.PHYSICS_2D.BLACK if !color_flipped else !LayerNames.PHYSICS_2D.BLACK
	
	freeze = true
