extends CanvasLayer
class_name UI
## Handles all UI-related functionality, dynamically responding to game state changes.

@onready var pong_panel: Panel = %"Pong Panel"
@onready var pong_player_1_score_label: Label = %"Player 1 Score Label"
@onready var pong_player_2_score_label: Label = %"Player 2 Score Label"

# TODO scan for current level managers, like: PongLevelManager, SnakeLevelManager, etc.
# TODO And then hook their signals automaticly to coresponf to the ui_stuff.
func _ready() -> void:
	print("UI initialized.")
	# Access CurrentLevelManager through autoload
	if not CurrentLevelManager.level_changed.is_connected(_on_level_changed):
		CurrentLevelManager.level_changed.connect(_on_level_changed)

func update_pong_points(pong_player_num: int, point_amount: int) -> void:
	match pong_player_num:
		1: pong_player_1_score_label.text = str(point_amount) # Update Player 1's score
		2: pong_player_2_score_label.text = str(point_amount) # Update Player 2's score

func _on_game_over() -> void:
	print("Game Over.")
	_reset_pong_scores()

func _on_level_changed(level_name: String) -> void:
	_initialize_corresponding_ui(level_name)

func _initialize_corresponding_ui(level_name: String) -> void:
	#pong_panel.visible = level_name == "LEVEL_PONG"
	match level_name:
		"LEVEL_PONG":
			_pong_level_started()
		"LEVEL_SNAKE", "LEVEL_FLAPPY_BIRD", "LEVEL_SPACE_INVADERS":
			pong_panel.hide()

## Resets the pong scores to the initial values
func _reset_pong_scores() -> void:
	update_pong_points(1, 0)  # Reset Player 1's score to 0
	update_pong_points(2, 0)  # Reset Player 2's score to 0

func _pong_level_started() -> void:
	pong_panel.show()
	_reset_pong_scores()

func _snake_level_started() -> void:
	pong_panel.hide()

func _flappy_bird_level_started() -> void:
	pong_panel.hide()

func _space_invaders_level_started() -> void:
	pong_panel.hide()
