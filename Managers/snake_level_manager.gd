extends Node
## Manages the Snake level logic.
class_name SnakeLevelManager

signal level_is_snake

@onready var ui: UI = %UI

# The current scores for Player 1 & Player 2
var players_scores := {1: 0, 2: 0}

func _ready() -> void:
	print("SnakeLevelManager initialized.")
	#level_is_snake.connect(ui._on_snake_level_started)
	level_is_snake.emit()
