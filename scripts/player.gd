# player.gd
extends RigidBody3D
class_name Player

@export_category("Movement")
@export var slowdown : float = 10.0
@export var rotation_speed : float = 5.0

@export_category("Shoot")
@export var shoot_cd : float = 0.5
@export var shoot_force : float = 10.0
@export var linear_dumper = 120
@export var angular_dumper = 10

var camera : Camera3D
var shoot_timer : SceneTreeTimer
var torso : Node3D
var shotgun : Node3D

var object_in_scope : Node

func _init() -> void:
	GlobalRef.player = self

func _ready() -> void:
	camera = $Suspention/SpringArm3D/Camera3D
	torso = $Suspention/Torso
	shotgun = $Suspention/Torso/Shotgun

func _input(event: InputEvent) -> void:
	if (event.is_action_pressed("shoot") && !shoot_timer):
		shoot()
		shoot_timer = get_tree().create_timer(shoot_cd, false, true)
		shoot_timer.timeout.connect(func() : shoot_timer = null)
		
func _physics_process(delta: float) -> void:
	var space_state = get_world_3d().direct_space_state
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var ray_normal = camera.project_ray_normal(mouse_pos)
	var query = PhysicsRayQueryParameters3D.create(from, from + ray_normal * 1000)
	
	query.exclude = [self]
	
	var result = space_state.intersect_ray(query)
	if result:
		object_in_scope = result.collider#.get_parent()
		# Torso rotation (yaw/left-right only)
		var target_point = Vector3(result.position.x, torso.global_position.y, result.position.z)
		var direction = (target_point - torso.global_position).normalized()
		var torso_target_basis = Basis.looking_at(direction, Vector3.UP)
		torso.basis = torso.basis.slerp(torso_target_basis, rotation_speed * delta)
		
		const MAX_PITCH = PI/4  # 45 degrees
		# Shotgun rotation (pitch/up-down only)
		var to_target = result.position - shotgun.global_position
		var pitch = atan2(to_target.y, sqrt(to_target.x * to_target.x + to_target.z * to_target.z))
		pitch = clamp(pitch, -MAX_PITCH, MAX_PITCH)
		var pitch_basis = Basis(Vector3.RIGHT, pitch)  # Rotate around local X axis
		shotgun.basis = pitch_basis
		
		Global.debug([shotgun.global_position, result.position])
	
	dumping(delta)

func dumping(delta):
	var linear_dump = -linear_velocity * delta * linear_dumper
	var linear_dump_force = Vector3(linear_dump.x, 0, linear_dump.z)
	apply_force(linear_dump_force)
	
	var breaks = 30 if Input.is_action_pressed("break") else 1
	
	var angular_dump = -angular_velocity * delta * angular_dumper * breaks
	var angular_dump_force = Vector3(angular_dump.x, angular_dump.y, angular_dump.z)
	apply_torque(angular_dump_force)
	
func break_handler():
	#if on ground
	#transform horizontal velocity into vertical impulse with the floowing formula:
	#var vertical_impulse = 1 / angular_velocity.length()**10 + 1
	pass

func shoot():
	# Forward is positive Z in local space
	var forward = shotgun.global_basis.z.normalized()  # Using basis.z directly
	apply_impulse(forward * shoot_force)
	if object_in_scope is RigidBody3D:
		object_in_scope.apply_impulse(-forward * shoot_force)
