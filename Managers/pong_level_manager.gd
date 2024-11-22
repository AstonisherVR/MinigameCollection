extends Node
## Manages the Pong level logic, including scores, ball spawning, and game states.
class_name PongLevelManager

#signal pong_game_over

# Reference to the ball spawner node
@onready var ball_spawner: BallSpawner = %"Ball Spawner"
## Reference to the UI node
@onready var ui: UI = %UI

# The current score for Player 1 & Player 2
var players_scores := {1: 0, 2: 0}

func _ready() -> void:
	print("PongLevelManager initialized.")
	ball_spawner.point_scored.connect(_update_score)

# Updates the score when a point is scored
func _update_score(which_player_scored: String) -> void:
	var player_num: int = 1 if which_player_scored == "player_1_scored" else 2
	players_scores[player_num] += 1
	ui.update_pong_points(player_num, players_scores[player_num])
