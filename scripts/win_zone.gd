extends Area3D
	
func _ready() -> void:
	self.body_entered.connect(_on_body_entered)

func _on_body_entered(body:Node3D) -> void:
	if body is Player:
		_call_game_over()

func _call_game_over() -> void:
	FlowSystem._on_change_state(FlowSystem.GameStates.OVER)
	pass
