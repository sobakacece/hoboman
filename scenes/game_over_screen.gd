extends Control

@export var win_button : Button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	win_button.pressed.connect(_restart)


func _restart() -> void:
	print("restart")
	FlowSystem._on_change_state(FlowSystem.GameStates.PLAY)
	get_tree().reload_current_scene()
