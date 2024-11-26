extends Node
## Manages the Snake level logic.
class_name SnakeLevelManager

@onready var ui: UI = %UI
@onready var snake_fruit_spawner: SnakeFruitSpawner = %"Snake Fruit Spawner"
@onready var snake_player: SnakePlayer = %"Snake Player"

#@onready var snake_grid: TileMapLayer = %"Snake Grid"
#@onready var grid_size = snake_grid.tile_set.tile_size

var fruits_eaten := 0
var game_stared: bool

func _ready() -> void:
	#print("SnakeLevelManager initialized.")
	if snake_fruit_spawner: snake_fruit_spawner.fruit_eaten.connect(_update_fruit_score)

# Updates the score when a point is scored
func _update_fruit_score() -> void:
	fruits_eaten += 1
	if ui: ui.update_snake_points(fruits_eaten)
	snake_player.add_body_segment()
