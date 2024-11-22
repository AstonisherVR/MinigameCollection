extends Node

# This takes the current screen size and returns the value as Vector2
@onready var screen_size = get_viewport().get_visible_rect().end

# Every time an action happends, It checks if its esc and quits if so
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
