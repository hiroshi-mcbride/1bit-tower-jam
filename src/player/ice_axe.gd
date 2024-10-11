class_name IceAxe
extends RigidBody2D

signal axe_hit()

@export var hand: PinJoint2D
@export var hand_torque: float = 45.0
@export var shoulder: PinJoint2D
@export var shoulder_torque: float = 15.0
@export var unflipped_angular_limit_lower: float
@export var unflipped_on_wall_angular_limit_lower: float
@export var flipped_angular_limit_lower: float
@export var flipped_on_wall_angular_limit_lower: float
@export var unflipped_angular_limit_upper: float
@export var unflipped_on_wall_angular_limit_upper: float
@export var flipped_angular_limit_upper: float
@export var flipped_on_wall_angular_limit_upper: float
var unflipped_ray_cast_angle_exclusion_angle: float = 180
var flipped_ray_cast_angle_exclusion_angle: float = 0
@export var ray_cast_angle_exclusion_range: float = 80
@export var ray_cast_dot_limit: float = 0.5

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var trigger: CollisionShape2D = $Area2D/Trigger
@onready var collider: CollisionPolygon2D = $Collider
@onready var ray_cast_2d: RayCast2D = $RayCast2D

var hit_pos: Vector2 = Vector2.ZERO
var hit_angle: float
var is_on_wall: bool = false
var area_entered: bool = false
var ray_entered: bool = false
var dist: Vector2
var ray_cast_angle_exclusion_angle: float
var flipped: bool = false


func _ready() -> void:
	ray_cast_angle_exclusion_angle = unflipped_ray_cast_angle_exclusion_angle


func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	if ray_cast_2d.enabled and ray_cast_2d.is_colliding():
		# Get the global raycast direction
		var global_direction = ray_cast_2d.global_transform.basis_xform(ray_cast_2d.target_position).normalized()
		
		# Prevent the axe from freezing if it hits a floor or ceiling
		var axe_angle = fposmod(rad_to_deg(global_direction.angle()), 360)
		if flipped:
			if axe_angle > fposmod(ray_cast_angle_exclusion_angle - ray_cast_angle_exclusion_range, 360) ||\
			   axe_angle < fposmod(ray_cast_angle_exclusion_angle + ray_cast_angle_exclusion_range, 360):
				return
		else:
			if axe_angle > fposmod(ray_cast_angle_exclusion_angle - ray_cast_angle_exclusion_range, 360) &&\
			   axe_angle < fposmod(ray_cast_angle_exclusion_angle + ray_cast_angle_exclusion_range, 360):
				return
		
		var wall_normal = ray_cast_2d.get_collision_normal()
		hit_angle = wall_normal.angle_to(-global_direction)
		var dot: float = wall_normal.dot(global_direction)
		
		# Freeze the axe if it hits the wall within a certain range of angles
		if dot < -ray_cast_dot_limit or dot > ray_cast_dot_limit:
			hit_pos = ray_cast_2d.get_collision_point()
			dist = hit_pos - ray_cast_2d.global_position
			disable_motors()
			global_translate(dist)
			axe_hit.emit()
			ray_cast_2d.enabled = false
			freeze = true
			is_on_wall = true
			
			# Greaten the angular limits of the hands during grippy time
			hand.angular_limit_lower = deg_to_rad(flipped_on_wall_angular_limit_lower if flipped else unflipped_on_wall_angular_limit_lower)
			hand.angular_limit_upper = deg_to_rad(flipped_on_wall_angular_limit_upper if flipped else unflipped_on_wall_angular_limit_upper)

func swing() -> void:
	shoulder.motor_target_velocity = -shoulder_torque
	shoulder.motor_enabled = true
	hand.motor_target_velocity = -shoulder_torque
	hand.motor_enabled = true
	ray_cast_2d.enabled = true


func drop() -> void:
	is_on_wall = false
	
	# Lessen the angular limits of the hands during loosy time
	hand.angular_limit_lower = deg_to_rad(flipped_angular_limit_lower if flipped else unflipped_angular_limit_lower)
	hand.angular_limit_upper = deg_to_rad(flipped_angular_limit_upper if flipped else unflipped_angular_limit_upper)
	
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


func flip(color_flipped: bool, _distance: float) -> void:
	flipped = color_flipped
	
	# Flip torque directions
	hand_torque = -hand_torque
	shoulder_torque = -shoulder_torque
	
	# Apply rotation based on at what angle the axe hit the wall, and flip angular limits
	if is_on_wall:
		hit_angle = -hit_angle
		rotate(hit_angle * 2)
		hand.angular_limit_lower = deg_to_rad(flipped_on_wall_angular_limit_lower if flipped else unflipped_on_wall_angular_limit_lower)
		hand.angular_limit_upper = deg_to_rad(flipped_on_wall_angular_limit_upper if flipped else unflipped_on_wall_angular_limit_upper)
	else:
		hand.angular_limit_lower = deg_to_rad(flipped_angular_limit_lower if flipped else unflipped_angular_limit_lower)
		hand.angular_limit_upper = deg_to_rad(flipped_angular_limit_upper if flipped else unflipped_angular_limit_upper)
	
	# Flip the sprite
	sprite_2d.flip_v = flipped
	sprite_2d.offset = Vector2(0, 0.0 if flipped else -18.0 )
	
	# Flip all vertices in the Polygon collider
	var new_polygon: PackedVector2Array
	for v in collider.polygon:
		v.y = -v.y
		new_polygon.append(v)
	collider.polygon = new_polygon
	
	# Flip the collision mask
	ray_cast_2d.collision_mask = LayerNames.PHYSICS_2D.BLACK if flipped else LayerNames.PHYSICS_2D.WHITE
	ray_cast_2d.target_position.y = -ray_cast_2d.target_position.y
	ray_cast_angle_exclusion_angle = flipped_ray_cast_angle_exclusion_angle if flipped else unflipped_ray_cast_angle_exclusion_angle
	
	if is_on_wall:
		freeze = true
