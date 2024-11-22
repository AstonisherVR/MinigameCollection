extends Node
## Manages transitions and states for all levels in the game. 
## Used for switching between levels, handle global game events, and signal UI updates.

signal level_changed(level_name: String)
#signal game_over

enum Levels {
	LEVEL_PLAYGROUND,
	LEVEL_PONG,
	LEVEL_SNAKE,
	LEVEL_FLAPPY_BIRD,
	LEVEL_SPACE_INVADERS
}

@export var level_scenes: Dictionary = {
	Levels.LEVEL_PLAYGROUND: preload("res://Levels/playground.tscn"),
	Levels.LEVEL_PONG: preload("res://Levels/level_pong.tscn"),
	Levels.LEVEL_SNAKE: preload("res://Levels/level_snake.tscn"),
	Levels.LEVEL_FLAPPY_BIRD: preload("res://Levels/level_flappy_bird.tscn"),
	#Levels.LEVEL_SPACE_INVADERS: preload("res://Levels/"),
	}

var current_level := Levels.LEVEL_PONG

## This should be called when the level needs to be changed
func change_current_level_to(new_level: Levels) -> void:
	if current_level == new_level: return
	_unload_current_level()
	current_level = new_level
	print(get_tree().current_scene.name, " Old Level.")
	_load_current_level()
	_emit_changed_level(new_level)
	print(get_tree().current_scene.name, " New Level.")
	print("Level changed to: ", new_level)

func _load_current_level() -> void:
	var level_scene = level_scenes[current_level]
	if level_scene:
		var new_level_instance = level_scene.instantiate()
		get_tree().current_scene.add_child(new_level_instance)

func _unload_current_level() -> void:
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()

func _emit_changed_level(level: Levels) -> void:
	level_changed.emit(level)
