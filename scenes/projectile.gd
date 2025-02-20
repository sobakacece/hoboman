extends Node

class_name Projectile

@export var projectile_name: String = "Default"
@export var impact_force: float = 500
@export var impact_effect = preload("res://scenes/debug_effect.tscn")
@export var phisical: bool = false

var _phisical_max_speed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if phisical:
		#load RigidBody3D with Collision shape
		pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
