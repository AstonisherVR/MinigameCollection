extends Node

class_name SnakeFruitSpawner
## Spawns and manages the fruits for the Snake game.

signal fruit_eaten

const GRID_SIZE: int = 64

@export_category("Fruit Parameters")

const FRUIT_TSCNS: Array[PackedScene] = [preload("res://Snake Fruit/base_fruit.tscn"),
										preload("res://Snake Fruit/apple_fruit.tscn")]

func _ready() -> void:
	_spawn_fruit()  # Spawns the first fruit.

## Spawns a randomly picked fruit at a grid-aligned position.
func _spawn_fruit() -> void:
	# Instantiate a random fruit scene
	var new_fruit_tscn: PackedScene = FRUIT_TSCNS.pick_random()
	var new_fruit_instance: BaseFruit = new_fruit_tscn.instantiate() as BaseFruit
	add_child(new_fruit_instance)

	# Connects the fruits' eaten signal
	new_fruit_instance.fruit_eaten.connect(_on_fruit_eaten)

	# Calculate random grid-aligned position within bounds
	var max_x_index: int = floor(GlobalManager.screen_size.x / GRID_SIZE)
	var max_y_index: int = floor(GlobalManager.screen_size.y / GRID_SIZE)
	var fruit_x_position: float = randi_range(0, max_x_index - 1) * GRID_SIZE
	var fruit_y_position: float = randi_range(0, max_y_index - 1) * GRID_SIZE

	# Assigns the new position to the fruit
	new_fruit_instance.global_position = Vector2(fruit_x_position, fruit_y_position)

## Handles the event when a fruit is eaten.
func _on_fruit_eaten() -> void:
	fruit_eaten.emit()
	_spawn_fruit()
