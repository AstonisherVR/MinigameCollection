extends Node
class_name SnakeFruitSpawner
## Spawns and manages the fruits for the Snake game.

signal fruit_eaten

@export_category("Fruit Parameters")

@onready var fruit_scenes: Array[PackedScene] = [preload("res://Snake Fruit/base_fruit.tscn"),
												preload("res://Snake Fruit/apple_fruit.tscn")]

# This spawns the first fruit, for now.
func _ready() -> void:
	#print("SnakeFruitSpawner initialized.")
	_spawn_fuit()

# This code spawns a fruit
func _spawn_fuit() -> void:
	var new_fruit: PackedScene = fruit_scenes.pick_random()
	var new_fruit_instance := new_fruit.instantiate() as BaseFruit
	if new_fruit:
		add_child(new_fruit_instance)
		new_fruit_instance.fruit_eaten.connect(_on_fruit_eaten)
		# TEMP
		new_fruit_instance.global_position = Vector2(randi_range(0, 528), randi_range(0, 400))
	else:
		print_debug("Error: Failed to spawn fruit.")

func _on_fruit_eaten() -> void:
	fruit_eaten.emit()
	_spawn_fuit()
