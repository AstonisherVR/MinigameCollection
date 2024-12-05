extends CanvasLayer
## Handles all UI-related functionality, adapting and responding to the game states.
class_name UI

@onready var pong_panel: Panel = %"Pong Panel"
@onready var pong_player_1_score_label: Label = %"Player 1 Score Label"
@onready var pong_player_2_score_label: Label = %"Player 2 Score Label"

@onready var snake_panel: Panel = %"Snake Panel"
@onready var snake_score_label: Label = %"Snake Score Label"

func _ready() -> void:
	#print("UI initialized.")
	_initialize_corresponding_ui(get_tree().current_scene.name.to_upper())
	if not CurrentLevelManager.level_changed.is_connected(_on_level_changed):
		CurrentLevelManager.level_changed.connect(_on_level_changed)

func _on_level_changed(level_name: String) -> void:
	_initialize_corresponding_ui(level_name)

func _initialize_corresponding_ui(level_name: String) -> void:
	_hide_all()
	match level_name:
		"LEVEL PONG", "LEVEL_PONG":
			_pong_level_started()
		"LEVEL SNAKE", "LEVEL_SNAKE":
			_snake_level_started()
		"LEVEL FLAPPY BIRD", "LEVEL_FLAPPY_BIRD":
			_flappy_bird_level_started()
		"LEVEL SPACE INVADERS", "LEVEL_SPACE_INVADERS":
			_space_invaders_level_started()
		"PLAYGROUND":
			print("It be playground")

func _hide_all() -> void:
	pong_panel.hide()
	snake_panel.hide()

func _pong_level_started() -> void:
	pong_panel.show()
	_reset_pong_scores()

func _snake_level_started() -> void:
	snake_panel.show()
	_reset_snake_score()

func _flappy_bird_level_started() -> void:
	pass

func _space_invaders_level_started() -> void:
	pass

## Resets the pong scores to zero
func _reset_pong_scores() -> void:
	for i: int in range(2):
		update_pong_points(i, 0)  # Resets Player 1 and Player 2 scores to 0

func _reset_snake_score() -> void:
	update_snake_points(0)

func update_pong_points(pong_player_num: int, point_amount: int) -> void:
	match pong_player_num:
		1: pong_player_1_score_label.text = "%d"%(point_amount) # Update Player 1's score
		2: pong_player_2_score_label.text = "%d"%(point_amount) # Update Player 2's score

func update_snake_points(point_amount: int) -> void:
	snake_score_label.text = "%d"%(point_amount) # Update Player 1's score

func _on_game_over() -> void:
	print("Game Over")
	_reset_pong_scores()
