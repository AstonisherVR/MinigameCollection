extends CanvasLayer
class_name UI

@onready var pong_panel: Panel = %"Pong Panel"
@onready var pong_player_1_score_label: Label = %"Player 1 Score Label"
@onready var pong_player_2_score_label: Label = %"Player 2 Score Label"

func _ready() -> void:
	show_corresponding_ui()

func show_corresponding_ui():
	match LevelManager.current_level:
		"LEVEL_PONG":
			reset_pong_scores()
			pong_panel.show()  # Show pong panel for "LEVEL_PONG"
		"LEVEL_SNAKE":
			pong_panel.hide()
		"LEVEL_FLAPPY_BIRD":
			pong_panel.hide()
		"LEVEL_SPACE_INVADERS":
			pong_panel.hide()

func update_pong_points(pong_player_num: int, point_amount: int) -> void:
	match pong_player_num:
		1: pong_player_1_score_label.text = str(point_amount) # Update Player 1's score
		2: pong_player_2_score_label.text = str(point_amount) # Update Player 2's score

func on_game_over():
	pass

# Resets the pong scores to the initial values
func reset_pong_scores() -> void:
	update_pong_points(1, 0)  # Reset Player 1's score to 0
	update_pong_points(2, 0)  # Reset Player 2's score to 0
	pong_panel.hide()  # Hide pong panel by default
