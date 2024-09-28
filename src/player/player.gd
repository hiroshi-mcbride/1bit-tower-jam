extends Node2D

@export var ice_axe_left: IceAxe
@export var ice_axe_right: IceAxe
@export var rigidbodies: Array[RigidBody2D]
@export var sprites: Array[CanvasItem]

var color_flipped: bool = false

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
	if ice_axe_right.is_on_wall:
		if !Input.is_action_pressed("axe_right"):
			ice_axe_right.drop()
		ice_axe_left.stop_pulling()
	
	if ice_axe_left.is_on_wall:
		if !Input.is_action_pressed("axe_left"):
			ice_axe_left.drop()
		ice_axe_right.stop_pulling()
	
	# Color switching logic
	if Input.is_action_just_pressed("color_switch") && (ice_axe_left.is_on_wall || ice_axe_right.is_on_wall):
		# Flip player collision masks & rigidbodies
		for rigidbody in rigidbodies:
			# TEMP warp
			translate(Vector2(-25 if color_flipped else 25,0))
			
			rigidbody.collision_mask = LayerNames.PHYSICS_2D.WHITE if color_flipped else !LayerNames.PHYSICS_2D.WHITE
			rigidbody.collision_mask = LayerNames.PHYSICS_2D.BLACK if !color_flipped else !LayerNames.PHYSICS_2D.BLACK
			
			# Flip rigidbodies (& sprites)
			rigidbody.apply_scale(Vector2(-1,1))
		
		# Flip ice axe collision masks & rigidbodies
		ice_axe_left.flip(color_flipped)
		ice_axe_right.flip(color_flipped)
		
		# Flip player color
		for sprite in sprites:
			if sprite.get_modulate() == Color.WHITE:
				sprite.set_modulate(Color.BLACK)
			elif sprite.get_modulate() == Color.BLACK:
				sprite.set_modulate(Color.WHITE)
		
		color_flipped = !color_flipped
