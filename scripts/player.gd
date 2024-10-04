extends CharacterBody3D


var last_mouse_position
@export_category("Movement")
@export var slowdown : float

@export_category("Shoot")
@export var shoot_cd : float
@export var shoot_force : float
#nodes
var camera
var spring_arm

#temp_nodes
var shoot_timer : SceneTreeTimer

func _ready() -> void:
	camera = $SpringArm3D/PlayerCamera
	spring_arm = $SpringArm3D

func _input(event: InputEvent) -> void:
	if (event is InputEventMouse):
		track_mouse_position(event)
	
	if (event.is_action("shoot") && !shoot_timer):
		shoot()
		shoot_timer = get_tree().create_timer(shoot_cd, false, true)
		shoot_timer.timeout.connect(func() : shoot_timer = null)
		
func _physics_process(delta: float) -> void:

	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	#var input_dir := Input.get_vector("left", "right", "forward", "back")
	#var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	#if direction:
		#velocity.x = direction.x * SPEED
		#velocity.z = direction.z * SPEED
	#else:
		velocity.x = move_toward(velocity.x, 0, slowdown)
		velocity.z = move_toward(velocity.z, 0, slowdown)

	move_and_slide()

func track_mouse_position(event : InputEventMouse):
	var from = camera.project_ray_origin(event.position)
	last_mouse_position = from + camera.project_ray_normal(event.position) * 10
	look_at(Vector3 (last_mouse_position.x, 0, last_mouse_position.z))

func shoot():
	velocity.x += transform.basis.z.x * shoot_force
	velocity.z += transform.basis.z.z * shoot_force
