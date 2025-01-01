# camera_behavior.gd
extends Camera3D

@export var pan_coefficient := 0.001
@export var transition_speed = 60
var viewport_center : Vector2

func _ready() -> void:
	viewport_center = get_viewport().get_visible_rect().size / 2

func _process(delta: float) -> void:
	var mouse_position = get_viewport().get_mouse_position()
	var mouse_offset = mouse_position - viewport_center
	
	var pan_offset = Vector3(
		mouse_offset.x * pan_coefficient,  # Reversed X
		-mouse_offset.y * pan_coefficient,  # Y was already correct
		0
	)
	
	var target_pos = global_position + pan_offset
	var direction_to_target = target_pos - global_position
	global_position += (direction_to_target / 2 ) * delta * transition_speed
