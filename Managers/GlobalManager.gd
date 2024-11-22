extends Node

# This takes the current screen size and returns the value as Vector2
@onready var screen_size = get_viewport().get_visible_rect().end
#var current_score: int

#func _ready() -> void:
	#pass
#
#func _process(delta: float) -> void:
	#pass

func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		get_tree().quit()
