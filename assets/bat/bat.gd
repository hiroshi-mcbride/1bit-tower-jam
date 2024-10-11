class_name Bat
extends CharacterBody2D


@onready var health_component: HealthComponent = $HealthComponent
@onready var state_machine: StateMachine = $StateMachine
@onready var danger_sensor_component: DangerSensorComponent = $DangerSensorComponent
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var squared_distance: int = (1 << 32) - 1


func _ready() -> void:
	health_component.die.connect(die)
	health_component.hit.connect(hit)


func _process(_delta: float) -> void:
	squared_distance = global_position.distance_squared_to(Player.instance.global_position)


func die() -> void:
	queue_free()


func hit() -> void:
	pass


func _on_hurtbox_component_body_entered(_body: Node2D) -> void:
	# When hitting a wll
	die()


func _on_hitbox_component_area_entered(_area: Area2D) -> void:
	# When hitting a player
	die()
