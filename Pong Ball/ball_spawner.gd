extends Node
class_name BallSpawner
## Spawns and manages the balls for the Pong game.

signal point_scored

const BALL_SCENE := preload("res://Pong Ball/ball.tscn")
const SPAWN_DELAY := 1.0
@onready var _screen_center: Vector2 = GlobalManager.screen_size / 2

# This spawns the first ball, for now.
func _ready() -> void:
	print("BallSpawner initialized.")
	spawn_ball()

# This code spawns a ball
func spawn_ball() -> void:
	var new_ball := BALL_SCENE.instantiate() as Ball
	if new_ball:
		new_ball.global_position = _screen_center
		new_ball.ball_scored.connect(_on_point_scored)
		add_child(new_ball)
	else:
		print_debug("Error: Failed to spawn ball.")

func _on_point_scored(which_player_scored: String) -> void:
	point_scored.emit(which_player_scored)
	await get_tree().create_timer(SPAWN_DELAY).timeout
	spawn_ball()
