extends Node3D
class_name Firearm

@export var between_shots_delay: float = 0.5 #(firing speed)
@export var spread_cone_degree: float = 15.0
@export var projectiles_per_load: int = 50
@export var projectiles_loaded: int = projectiles_per_load
@export var projectiles_per_shot: int = 10
@export var reload_time: float = 0.5
@export var projectile: Projectile 
@export var shooting_point: Node3D
var available: bool = true # tells if can be used elsewhere

func _ready() -> void:
	if not projectiles_loaded:
		projectiles_loaded = projectiles_per_load
	if not projectile:
		projectile = load("res://scenes/Projectiles/Projectile.tscn").instantiate()
	if not shooting_point:
		shooting_point = self

func pull_the_trigger() -> Array:
	var impulse_vectors = [Vector3.ZERO]
	if projectiles_loaded > 0 and available:
		impulse_vectors = shoot()
	elif projectiles_loaded <= 0 and available:
		reload()
	return impulse_vectors

func shoot() -> Array:
	var impulse_vectors = []
	
	# Create multiple projectiles within the spread cone
	for i in range(min(projectiles_loaded, projectiles_per_shot)):
		# Get the forward direction in global space
		var forward = global_basis.z.normalized()
		var up = global_basis.y.normalized()
		var right = global_basis.x.normalized()
		
		# Calculate random spread
		var random_angle = randf() * PI * 2.0  # Random angle around the cone
		var random_radius = randf() * sin(deg_to_rad(spread_cone_degree))  # Random radius within cone
		
		# Calculate the spread direction
		var vertical_offset = right * (random_radius * cos(random_angle))
		var horizontal_offset = up * (random_radius * sin(random_angle))
		var spread_direction = (forward + vertical_offset + horizontal_offset).normalized()
		
		# Calculate impulse for this projectile
		var impulse = spread_direction * projectile.impact_force
		
		
		var intersect_object = Global.get_object_of_raycast(-impulse, shooting_point)
		if intersect_object is RigidBody3D: #імпульс цілі має передавати проджектайл, якщо він фізичний
			intersect_object.apply_impulse(-impulse)
			
		var intersect_Vector3 = Global.get_Vector3_of_raycast(-impulse, shooting_point)
		if intersect_Vector3:
			var effect_instance = projectile.impact_effect.instantiate()
			effect_instance.global_transform.origin = intersect_Vector3
			# Add the effect to the current scene (or choose a more appropriate parent if needed)
			get_tree().current_scene.add_child(effect_instance)

		
		impulse_vectors.push_front(impulse)
	
	# Handle ammo consumption
	projectiles_loaded = max(0, projectiles_loaded - projectiles_per_shot)
	
	start_cooldown(between_shots_delay)
	return impulse_vectors  # Return average impulse



func start_cooldown(timer, callback_func = null):
	available = false
	var cooldown_timer = get_tree().create_timer(timer)
	cooldown_timer.timeout.connect(_on_cooldown_complete)
	cooldown_timer.timeout.connect(func(): cooldown_timer.timeout.disconnect(_on_cooldown_complete))  # Clean up connection
	if callback_func:
		callback_func.call()
	#play_animation(shoot_animation, between_shots_delay)

func _on_cooldown_complete():
	available = true

func reload():
	start_cooldown(reload_time, Callable(self, "load"))
	#play_animation(reload_animation, reload_time)


func load():	
	projectiles_loaded = projectiles_per_load

func _on_reload_complete():
	projectiles_loaded = projectiles_per_load
	available = true
