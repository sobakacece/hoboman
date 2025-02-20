extends Node3D


@export var lag_speed = 10
@export var offset: Vector3
@export var lag = true
@export var is_top_level = true
@export var target: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not target:
		target = get_parent()
	set_as_top_level(is_top_level)

func _physics_process(delta: float) -> void:
	var target_pos = target.global_position + offset
	
	if lag:
		var direction_to_target = target_pos - global_position
		var scaled_direction = (direction_to_target / 2) * delta * lag_speed
		if direction_to_target.length() > scaled_direction.length():
			global_position += scaled_direction
		else:
			global_position = target_pos
	else:
		global_position = target_pos
