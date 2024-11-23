extends Node
## Manages transitions and states for all levels in the game. 
## Used for switching between levels, handle global game events, and signal UI updates.

## Emitted when level changes. Passes the level name as a string.
signal level_changed(level_name: String)
## Emitted before level change begins
#signal level_change_started
## Emitted after level change is complete
#signal level_change_completed

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
	if current_level == new_level: return
	# Store the old level for cleanup
	var level_scene = level_scenes[new_level]
	if !level_scene: return
	if level_scene:
		# Instance new scene before freeing old one
		var new_level_instance = level_scene.instantiate()
		get_tree().root.add_child(new_level_instance)

		# Cleanup old scene and notify
		get_tree().current_scene.queue_free()
		level_changed.emit(Levels.keys()[current_level])

		# Update current level and scene
		current_level = new_level
		get_tree().current_scene = new_level_instance

	print("Level changed to: ", Levels.keys()[current_level])

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_released("one"):
		change_current_level_to(Levels.LEVEL_PONG)
	if Input.is_action_just_released("two"):
		change_current_level_to(Levels.LEVEL_SNAKE)
	if Input.is_action_just_released("three"):
		change_current_level_to(Levels.LEVEL_FLAPPY_BIRD)
	if Input.is_action_just_released("four"):
		change_current_level_to(Levels.LEVEL_PLAYGROUND)
	#if Input.is_action_just_released("one"):
		#change_current_level_to(Levels.LEVEL_PONG)
