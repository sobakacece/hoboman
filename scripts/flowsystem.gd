extends Node

# enum with states
# function that changes between states
# each state on enter functions
#signal _state_change(next_state: GameStates)

#var win_screen_scene : PackedScene
var win_screen : Control
const win_screen_path : String = "res://scenes/GameOverScreen.tscn"

enum GameStates {PLAY, OVER} 
var current_state = GameStates.PLAY

func _ready() -> void:
    #win_screen_scene = preload("res://scenes/GameOverScreen.tscn")
    win_screen = preload(win_screen_path).instantiate()
    get_tree().root.add_child.call_deferred(win_screen)
    win_screen.visible = false
    #_state_change.connect(_on_change_state)
    pass

func _on_change_state(next_state: GameStates) -> void:
    match next_state:
        GameStates.PLAY:
            _on_gameplay_state()
        GameStates.OVER:
            _on_gameover_state()
        
        

func _on_gameplay_state() -> void:
    win_screen.visible = false
    get_tree().paused = false

func _on_gameover_state() -> void:
    win_screen.visible = true
    get_tree().paused = true