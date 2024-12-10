extends Node
## Manages transitions and states for all levels in the game.
## Used for switching between levels, handle global game events, and signal UI updates.

## Emitted when level changes. Passes the level name as a string.
signal level_changed(level_name: String)

enum Levels {
	LEVEL_PLAYGROUND,
	LEVEL_PONG,
	LEVEL_SNAKE,
	LEVEL_FLAPPY_BIRD
	#,LEVEL_SPACE_INVADERS
}
## Currently active level
var current_level: Levels

var level_scenes: Dictionary = {
	Levels.LEVEL_PLAYGROUND: preload("res://Levels/playground.tscn"),
	Levels.LEVEL_PONG: preload("res://Levels/level_pong.tscn"),
	Levels.LEVEL_SNAKE: preload("res://Levels/level_snake.tscn"),
	Levels.LEVEL_FLAPPY_BIRD: preload("res://Levels/level_flappy_bird.tscn")
	#,Levels.LEVEL_SPACE_INVADERS: preload("res://Levels/"),
	}

## This should be called when the level needs to be changed
func change_current_level_to(new_level: Levels) -> void:
	# Early returns for invalid cases
	if current_level == new_level: return
	var level_scene: PackedScene = level_scenes[new_level]
	if !level_scene: return
	# Instance new scene
	var new_level_instance: Node = level_scene.instantiate()
	# Get the current scene for cleanup
	var previous_scene: Node = get_tree().current_scene
	# Add new scene to tree
	get_tree().root.add_child(new_level_instance)
	# Set as current scene BEFORE removing old scene
	print_rich("[color=green][b]Level changed to:[/b][/color] ", new_level_instance.name)
	get_tree().current_scene = new_level_instance
	# Remove old scene if it exists
	if previous_scene: previous_scene.queue_free()
	# Update state and emit signal
	current_level = new_level
	level_changed.emit(Levels.keys()[current_level])

func _input(_event: InputEvent) -> void:
	if OS.is_debug_build():
		if Input.is_action_just_released("one"):
			change_current_level_to(Levels.LEVEL_PONG)
		elif Input.is_action_just_released("two"):
			change_current_level_to(Levels.LEVEL_SNAKE)
		elif Input.is_action_just_released("three"):
			change_current_level_to(Levels.LEVEL_FLAPPY_BIRD)
		elif Input.is_action_just_released("four"):
			change_current_level_to(Levels.LEVEL_PLAYGROUND)
		#elif Input.is_action_just_released("one"):
			#change_current_level_to(Levels.LEVEL_PONG)
