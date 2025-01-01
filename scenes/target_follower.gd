extends Node3D


@export var lag_speed = 10
@export var offset: Vector3
@export var lag = true
@export var target: Node3D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not target:
		target = get_parent()
	set_as_top_level(true)

func _process(delta: float) -> void:
	var target_pos = target.global_position + offset
	
	if lag:
		var direction_to_target = target_pos - global_position
		global_position += (direction_to_target / 2) * delta * lag_speed
	else:
		global_position = target_pos
