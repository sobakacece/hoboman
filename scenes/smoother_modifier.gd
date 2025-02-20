extends Node

@export var target: RigidBody3D
@export var rotation_max_deg_per_sec: float
@export var movement_max_units_per_sec: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not target:
		target = get_parent() as RigidBody3D
	if not target:
		push_warning("Smoother Modifier: Parent is not a RigidBody3D!")

func _physics_process(delta: float) -> void:
	if not target:
		return
		
	# Smooth linear velocity
	var current_speed = target.linear_velocity.length()
	if current_speed > movement_max_units_per_sec:
		target.linear_velocity = target.linear_velocity.normalized() * movement_max_units_per_sec
	
	# Smooth angular velocity
	var max_angular_speed = deg_to_rad(rotation_max_deg_per_sec)
	var current_angular_speed = target.angular_velocity.length()
	if current_angular_speed > max_angular_speed:
		target.angular_velocity = target.angular_velocity.normalized() * max_angular_speed
