class_name Player
extends RigidBody2D

@onready var health_component: HealthComponent = $HealthComponent
@onready var ray_cast_2d: RayCast2D = $RayCast2D

@export var ice_axe_left: IceAxe
@export var ice_axe_right: IceAxe
@export var rigidbodies: Array[RigidBody2D]
@export var sprites: Array[CanvasItem]

signal flipped()

static var instance: Player = null
var color_flipped: bool = false
var flip_entered: bool = false
var distance: float
var flip_position: Vector2 = Vector2.ZERO
var saved_spawn_pos: Vector2
var initial_positions = {}


func _enter_tree() -> void:
	# Singleton pattern
	if instance == null:
		instance = self
	if instance != self:
		push_warning("Multiple players found in scene, deleting last loaded")
		queue_free()


func _ready() -> void:
	initial_positions = {"left": ice_axe_left.position, "right": ice_axe_right.position}
	# Get sprite references that are inside other scenes
	sprites.append(ice_axe_left.sprite_2d)
	sprites.append(ice_axe_right.sprite_2d)
	
	# Connect signals
	health_component.die.connect(respawn)
	health_component.hit.connect(hit)
	
	saved_spawn_pos = global_position


func _physics_process(_delta: float) -> void:
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
	
	# These extra checks make climbing smoother
	if ice_axe_left.is_on_wall:
		if !Input.is_action_pressed("axe_left"):
			ice_axe_left.drop()
		ice_axe_right.stop_pulling()
	
	if ice_axe_right.is_on_wall:
		if !Input.is_action_pressed("axe_right"):
			ice_axe_right.drop()
		ice_axe_left.stop_pulling()
	
	# If only one axe is on the wall (clever bool check! -hiro)
	if (ice_axe_left.is_on_wall != ice_axe_right.is_on_wall):
		# Update the flip_position and distance to that axe's hit position
		flip_position = ice_axe_left.hit_pos if ice_axe_left.is_on_wall else ice_axe_right.hit_pos
		distance = flip_position.x - global_position.x
		var is_left_axe: bool = ice_axe_left.is_on_wall
		
		# Color switching logic
		if Input.is_action_just_pressed("color_switch"):
			color_switch(is_left_axe)


func _exit_tree() -> void:
	if instance == self:
		instance = null


func color_switch(_is_left_axe: bool) -> void:
	flip_entered = true
	color_flipped = !color_flipped
	
	var normal: Vector2 = ice_axe_left.wall_normal if _is_left_axe else ice_axe_right.wall_normal
	
	# Get the offset between the body and the wall
	ray_cast_2d.target_position = -normal * 120.0
	var offset: Vector2
	ray_cast_2d.force_raycast_update()
	if ray_cast_2d.is_colliding():
		offset = ray_cast_2d.get_collision_point() - global_position
	
	# Flip player collision masks
	for rigidbody in rigidbodies:
		rigidbody.collision_mask = LayerNames.PHYSICS_2D.BLACK if color_flipped else LayerNames.PHYSICS_2D.WHITE
	ray_cast_2d.collision_mask = LayerNames.PHYSICS_2D.BLACK if color_flipped else LayerNames.PHYSICS_2D.WHITE
	
	# move the player slightly over the flip threshold
	offset *= 1.2
	global_translate(offset)
	
	# Flip ice axe collision masks
	ice_axe_left.flip(color_flipped, offset)
	ice_axe_right.flip(color_flipped, offset)
	
	# Flip player color
	for sprite in sprites:
		if sprite.get_modulate() == Color.WHITE:
			sprite.set_modulate(Color.BLACK)
		elif sprite.get_modulate() == Color.BLACK:
			sprite.set_modulate(Color.WHITE)
		
	
	flipped.emit()
	flip_position = Vector2.ZERO
	distance = 0


func respawn() -> void:
	global_position = saved_spawn_pos
	health_component.gain_health(100)


func hit() -> void:
	if ice_axe_left.is_on_wall:
		ice_axe_left.drop()
	if ice_axe_right.is_on_wall:
		ice_axe_right.drop()
	
	health_component.gain_health(1)
