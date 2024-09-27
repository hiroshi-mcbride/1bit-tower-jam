extends Node2D

@export var ice_axe_left: IceAxe
@export var ice_axe_right: IceAxe

@onready var left_pivot: PinJoint2D = $Shoulder_Q
@onready var right_pivot: PinJoint2D = $Shoulder_E


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("axe_left") && !ice_axe_right.is_swinging:
		ice_axe_left.swing(left_pivot, right_pivot)
	
	if Input.is_action_just_released("axe_left"):
		ice_axe_left.drop(left_pivot, right_pivot)
	
	if Input.is_action_just_pressed("axe_right") && !ice_axe_left.is_swinging:
		ice_axe_right.swing(right_pivot, left_pivot)
	
	if Input.is_action_just_released("axe_right"):
		ice_axe_right.drop(right_pivot, left_pivot)
