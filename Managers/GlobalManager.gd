extends Node
## Provides global utilities like screen size, over level data, input handling, and quit functionality.

# This takes the current screen size and returns the value as Vector2
@onready var screen_size = get_viewport().get_visible_rect().size

# Every time an action happends, It checks if its esc and quits if so
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		print("Exiting game.")
		get_tree().quit()
