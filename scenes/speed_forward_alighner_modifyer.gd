extends Node

@export var target: RigidBody3D
@export var speed_target: RigidBody3D  # Reference RigidBody3D for speed calculation
@export var alignment_strength: float = 10.0
@export var min_velocity_threshold: float = 0.1
@export var inverted: bool = false
@export var forward: Vector3 = Vector3.FORWARD

func _ready() -> void:
	if not target:
		target = get_parent() as RigidBody3D
	if not speed_target:
		speed_target = get_parent() as RigidBody3D

func _physics_process(delta: float) -> void:
	if not target or not speed_target:
		return
	
	var velocity = speed_target.linear_velocity if not inverted else -speed_target.linear_velocity
	var speed = velocity.length()
	
	# Don't align if barely moving
	if speed < min_velocity_threshold:
		target.angular_velocity = target.angular_velocity.lerp(Vector3.ZERO, 0.1)
		return
	
	# Project movement direction onto the XZ plane
	var movement_direction = velocity.normalized()
	movement_direction.y = 0
	if movement_direction.length_squared() == 0.0:
		return  # Avoid zero-length direction
	movement_direction = movement_direction.normalized()
	
	# Get current forward vector (projected onto XZ plane)
	var current_forward = -target.global_transform.basis.z
	current_forward.y = 0
	current_forward = current_forward.normalized()
	
	# Calculate the angle between the current forward and the desired movement direction
	var angle = current_forward.angle_to(movement_direction)
	if angle < 0.001:
		target.angular_velocity = target.angular_velocity.lerp(Vector3.ZERO, 0.1)
		return
	
	# Determine rotation direction using the cross product's Y component
	var cross_y = current_forward.cross(movement_direction).y
	var sign = 1.0 if cross_y >= 0 else -1.0
	
	# Use global up (Y-axis) for rotation axis
	var axis = Vector3.UP
	
	# Base maximum rotation rate on the current speed
	var max_rotation_rate = speed * PI  # Adjust multiplier to taste
	var angular_velocity_magnitude = min(angle * alignment_strength, max_rotation_rate)
	
	# Calculate target angular velocity with the proper rotation direction
	var target_angular_velocity = axis * sign * angular_velocity_magnitude
	
	# Smoothly adjust the angular velocity
	target.angular_velocity = target.angular_velocity.lerp(target_angular_velocity, 0.2)
