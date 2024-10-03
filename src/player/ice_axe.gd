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
@onready var trigger: CollisionShape2D = $Area2D/Trigger
@onready var collider: CollisionPolygon2D = $Collider
@onready var ray_cast_2d: RayCast2D = $RayCast2D

var hit_pos: Vector2 = Vector2.ZERO
var is_on_wall: bool = false
var area_entered: bool = false
var ray_entered: bool = false
var dist: Vector2


func _ready() -> void:
	#HACK: pin joint gets super weird at rotations around 180, so i'm rotating the child nodes instead
	if is_left_hand:
		$Sprite2D.rotation_degrees = 180
		collider.rotation_degrees = 180
		ray_cast_2d.position.x = - ray_cast_2d.position.x
		ray_cast_2d.target_position = -ray_cast_2d.target_position
		center_of_mass.x = -center_of_mass.x


func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	if !ray_cast_2d.enabled:
		return
	
	if ray_cast_2d.is_colliding() and !ray_entered:
		_state.integrate_forces()
		
		var global_direction = ray_cast_2d.global_transform.basis_xform(ray_cast_2d.target_position).normalized()
		print(rad_to_deg(global_direction.angle()))
		if rad_to_deg(global_direction.angle()) > 60 or rad_to_deg(global_direction.angle()) < -60:
			return
		var normal = ray_cast_2d.get_collision_normal()
		var dot: float = ray_cast_2d.get_collision_normal().dot(global_direction)
		if dot < -0.5 or dot > 0.5:
			ray_entered = true
			dist = ray_cast_2d.get_collision_point() - ray_cast_2d.global_position
			disable_motors()
	
	if ray_entered:
		global_translate(dist)
		ray_entered = false
		ray_cast_2d.enabled = false
		is_on_wall = true
	
	if is_on_wall:
		_state.linear_velocity = Vector2.ZERO
		_state.angular_velocity = 0
		freeze = true
	


func swing() -> void:
	shoulder.motor_target_velocity = -shoulder_torque
	shoulder.motor_enabled = true
	hand.motor_target_velocity = -shoulder_torque
	hand.motor_enabled = true
	ray_cast_2d.enabled = true


func drop() -> void:
	is_on_wall = false
	ray_cast_2d.enabled = false
	freeze = false
	disable_motors()


func disable_motors() -> void:
	shoulder.motor_target_velocity = 0
	shoulder.motor_enabled = false
	hand.motor_target_velocity = 0
	hand.motor_enabled = false


func pull() -> void:
	hand.motor_target_velocity = hand_torque
	hand.motor_enabled = true


func stop_pulling() -> void:
	hand.motor_target_velocity = 0
	hand.motor_enabled = false


func flip(color_flipped: bool, distance: float) -> void:
	# Flip torque directions
	hand_torque = -hand_torque
	shoulder_torque = -shoulder_torque
	
	# Remove the previous translation if the ice axe is on the wall,
	# and calculate the x offset between the ice axe and trigger
	var offset = 0
	if is_on_wall:
		#offset = area_2d.get_child(0).global_position.x - global_position.x
		global_translate(Vector2(distance if color_flipped else -distance, 0))
	
	# Flip the sprite
	sprite_2d.flip_v = !color_flipped
	sprite_2d.offset = Vector2(0, -48.0 if color_flipped else 0)
	
	# Flip all vertices in the Polygon collider
	var new_polygon: PackedVector2Array
	for v in collider.polygon:
		v.y = -v.y
		new_polygon.append(v)
	collider.polygon = new_polygon
	
	# Apply the offset after flipping
	global_translate(Vector2(offset, 0))
	
	# Flip angular limits
	var temp_limit = rad_to_deg(hand.angular_limit_lower)
	hand.angular_limit_lower = deg_to_rad(flipped_angular_limit_lower)
	flipped_angular_limit_lower = temp_limit
	
	temp_limit = rad_to_deg(hand.angular_limit_upper)
	hand.angular_limit_upper = deg_to_rad(flipped_angular_limit_upper)
	flipped_angular_limit_upper = temp_limit
	
	# Flip the collision mask
	ray_cast_2d.collision_mask = LayerNames.PHYSICS_2D.WHITE if color_flipped else LayerNames.PHYSICS_2D.BLACK
	
	if is_on_wall:
		freeze = true
		is_on_wall = false
