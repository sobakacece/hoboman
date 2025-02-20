extends Node

@export var target: RigidBody3D
@export var alignment_speed_deg_per_sec: float = 90.0
@export var alignment_strength: float = 10.0  # Higher values = stronger correction


func _ready() -> void:
	if not target:
		target = get_parent() as RigidBody3D
	if not target:
		push_warning("Up Aligner: Parent is not a RigidBody3D!")

func _physics_process(delta: float) -> void:
	if not target:
		return
	
	# Get current up vector in global space
	var current_up = target.global_transform.basis.y
	var desired_up = Vector3.UP
	
	# Calculate the rotation needed
	var axis = current_up.cross(desired_up).normalized()
	var angle = current_up.angle_to(desired_up)
	
	# Skip if we're already aligned
	if angle < 0.001:
		# Apply damping to prevent oscillation
		target.angular_velocity = target.angular_velocity.lerp(Vector3.ZERO, 0.1)
		return
	
	# Calculate target angular velocity
	var max_angle = deg_to_rad(alignment_speed_deg_per_sec)
	var target_angular_velocity = axis * min(angle * alignment_strength, max_angle)
	
	# Remove any y-component to prevent rolling
	target_angular_velocity.y = 0
	
	# Smoothly adjust the angular velocity
	target.angular_velocity = target.angular_velocity.lerp(target_angular_velocity, 0.2)
	
	# Optional: Add damping to y-axis rotation to prevent spinning
	target.angular_velocity.y *= 0.9
