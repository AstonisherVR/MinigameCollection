extends Node
class_name BallSpawner

signal point_scored

const BALL_SCENE := preload("res://Pong Ball/ball.tscn")
const SPAWN_DELAY := 1.0
@onready var _screen_center: Vector2 = GlobalManager.screen_size / 2

# This spawns the first ball, for now.
func _ready() -> void:
	_spawn_ball()

# This code spawns a ball
func _spawn_ball() -> void:
	var new_ball := BALL_SCENE.instantiate() as Ball
	new_ball.global_position = _screen_center
	new_ball.ball_scored.connect(_on_point_scored)
	add_sibling.call_deferred(new_ball)

func _on_point_scored(which_player_scored: String) -> void:
	point_scored.emit(which_player_scored)
	await get_tree().create_timer(SPAWN_DELAY).timeout
	_spawn_ball()

#func _process(delta: float) -> void:
