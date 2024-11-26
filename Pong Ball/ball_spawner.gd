extends Node
class_name BallSpawner
## Spawns and manages the balls for the Pong game.

signal point_scored

# Access to the ball scene
const BALL_SCENE := preload("res://Pong Ball/ball.tscn")

@export_category("Ball Parameters")
# Initial speed of the ball when spawned
@export var initial_speed := 500.0
# Maximum speed the ball can possibly move at
@export var max_speed := 1600.0 
# How much faster the ball gets each time it hits a paddle
@export var acceleration_speed := 150.0
# The delay in which the ball spawns after a player scores
@export var spawn_delay := 0.1
# Quick access to the screens' center for the ball to spawn at
@onready var _screen_center: Vector2 = GlobalManager.screen_size / 2

# This spawns the first ball, for now.
func _ready() -> void:
	#print("BallSpawner initialized.")
	_spawn_ball()

# This code spawns a ball
func _spawn_ball() -> void:
	var new_ball := BALL_SCENE.instantiate() as Ball
	if new_ball:
		new_ball.initial_speed = initial_speed
		new_ball.max_speed = max_speed
		new_ball.acceleration_speed = acceleration_speed
		new_ball.global_position = _screen_center
		new_ball.ball_scored.connect(_on_point_scored)
		add_child(new_ball)
	else:
		print_debug("Error: Failed to spawn ball.")

func _on_point_scored(which_player_scored: String) -> void:
	point_scored.emit(which_player_scored)
	await get_tree().create_timer(spawn_delay).timeout
	_spawn_ball()
