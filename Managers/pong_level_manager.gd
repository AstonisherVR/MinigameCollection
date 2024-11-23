extends Node
## Manages the Pong level logic, including scores, ball spawning, and game states.
class_name PongLevelManager

signal level_is_pong

@onready var ball_spawner: BallSpawner = %"Ball Spawner"
@onready var ui: UI = %UI

# The current scores for Player 1 & Player 2
var players_scores := {1: 0, 2: 0}

func _ready() -> void:
	print("PongLevelManager initialized.")
	# A check to make it so that when pong manager starts, to asign the level to be pong
	if CurrentLevelManager.current_level != CurrentLevelManager.Levels.LEVEL_PONG:
		CurrentLevelManager.current_level = CurrentLevelManager.Levels.LEVEL_PONG
	#await get_tree().create_timer(0.01).timeout
	#level_is_pong.connect(ui._on_pong_level_started)
	if ui:
		level_is_pong.emit()
		ball_spawner.point_scored.connect(_update_pong_score)

# Updates the score when a point is scored
func _update_pong_score(which_player_scored: String) -> void:
	var player_num: int = 1 if which_player_scored == "player_1_scored" else 2
	players_scores[player_num] += 1
	if ui: ui.update_pong_points(player_num, players_scores[player_num])
	
	# Check for game over condition (example: first to 10 points)
	#if players_scores[player_num] >= 10:
		#game_over.emit()
