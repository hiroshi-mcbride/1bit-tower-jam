extends RigidBody2D

@export var ice_axe_left: IceAxe
@export var ice_axe_right: IceAxe
@export var rigidbodies: Array[RigidBody2D]
@export var sprites: Array[CanvasItem]

var color_flipped: bool = false
var flip_entered: bool = false
var distance: float
var flip_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	sprites.append(ice_axe_left.sprite_2d)
	sprites.append(ice_axe_right.sprite_2d)


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
		
		# Color switching logic
		if Input.is_action_just_pressed("color_switch"):
			color_switch()


func color_switch() -> void:
	flip_entered = true
	
	# Flip player collision masks
	for rigidbody in rigidbodies:
		rigidbody.collision_mask = LayerNames.PHYSICS_2D.WHITE if color_flipped else LayerNames.PHYSICS_2D.BLACK
	
	# Flip everything visually
	global_translate(Vector2(-distance if color_flipped else distance, 0))
	
	# Flip ice axe collision masks
	ice_axe_left.flip(color_flipped, distance)
	ice_axe_right.flip(color_flipped, distance)
		
	# Flip player color
	for sprite in sprites:
		if sprite.get_modulate() == Color.WHITE:
			sprite.set_modulate(Color.BLACK)
		elif sprite.get_modulate() == Color.BLACK:
			sprite.set_modulate(Color.WHITE)
		
	color_flipped = !color_flipped
	flip_position = Vector2.ZERO
	distance = 0


func _integrate_forces(_state: PhysicsDirectBodyState2D) -> void:
	pass
