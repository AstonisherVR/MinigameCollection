extends Node
class_name PongLevelManager

# Reference to the ball spawner node
@onready var ball_spawner: BallSpawner = %"Ball Spawner"
## Reference to the UI node
@onready var ui: UI = %UI

# Tracks the current score for player 1
var player_1_points: int
# Tracks the current score for player 2
var player_2_points: int

func _ready() -> void:
	ball_spawner.point_scored.connect(change_score)

# Updates the score when a point is scored
func change_score(which_player_scored: String) -> void:
	if which_player_scored == "player_1_scored":
		player_1_points += 1
		ui.update_pong_points(1, player_1_points)
	else:
		player_2_points += 1
		ui.update_pong_points(2, player_2_points)
