extends Node
class_name WalllSpawner

# Preload the wall scene
const WALL_SCENE := preload("res://Wall/wall.tscn")

# This spawns the walls
func _ready() -> void:
	_spawn_walls()

func _spawn_walls() -> void:
	for i in range(2):
		var new_wall = WALL_SCENE.instantiate()
		new_wall.global_position = Vector2(GlobalManager.screen_size.x / 2, (i * GlobalManager.screen_size.y))
		add_sibling.call_deferred(new_wall) # Use call_deferred for safe node addition
	queue_free()
