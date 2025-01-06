extends CharacterBody3D

@onready var nav_agent : NavigationAgent3D = $NavigationAgent3D
@onready var player = GlobalRef.player
@export var speed : float
@export var shooting_distance : float
@export var shoot_delay : float
@export var offset : float
var target_velocity : Vector3
var shoot_timer : SceneTreeTimer
#let's ai be something like:
#look for player with raycast for distance and visibility
#if not found -> move
#if found -> delay -> shoot 

# TODO: Split this shit in state machine
func _process(delta: float) -> void:
	#velocity = Vector3.ZERO
	look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))
	
	if _check_for_player():
		_start_delay()
		target_velocity = Vector3.ZERO;
	else:
		_move()
	#print(_check_for_player())
	velocity = lerp(velocity, target_velocity, delta * 2)
	move_and_slide()


func _move() -> void:

	nav_agent.target_position = player.global_transform.origin
	var next_path_point = nav_agent.get_next_path_position()
	if global_position.distance_to(nav_agent.target_position) > shooting_distance + offset:
		#velocity = (next_path_point - global_position).normalized() * speed
		target_velocity = (next_path_point - global_position).normalized() * speed


func _check_for_player() -> bool:
	var space_state = get_world_3d().direct_space_state
	var to = global_position + global_position.direction_to(player.global_position) * shooting_distance
	var query = PhysicsRayQueryParameters3D.create(global_position, to)
	query.exclude = [self]
	var result = space_state.intersect_ray(query)
	Global.debug([global_position, to])
	if result.get("collider") is Player:
		return true
	
	return false

func _start_delay() -> void:
	if !shoot_timer:
		shoot_timer = get_tree().create_timer(shoot_delay)
		shoot_timer.timeout.connect(_shoot)

func _shoot() -> void:
	print ("shoot")
	shoot_timer = null
