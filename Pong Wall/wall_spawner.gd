extends Node
class_name WalllSpawner

# Preload the wall scene
const WALL_SCENE := preload("res://Pong Wall/wall.tscn")

# The walls get spawned at the start
func _ready() -> void:
	#print("WalllSpawner initialized.")
	_spawn_walls()

# This spawns the walls
func _spawn_walls() -> void:
	for i: int in range(2):
		var new_wall := WALL_SCENE.instantiate() as PhysicsBody2D
		new_wall.global_position = Vector2(GlobalManager.screen_size.x / 2, (i * GlobalManager.screen_size.y))
		add_sibling.call_deferred(new_wall) # Use call_deferred for safe node addition
	queue_free()
