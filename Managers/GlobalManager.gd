extends Node
## Provides global utilities like screen size, over level data, input handling, and quit functionality.

# This takes the current screen size and returns the value as Vector2
@onready var screen_size = get_viewport().get_visible_rect().size

# Every time an action happends, It checks if its esc and quits if so
func _input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		print_rich("[color=orange][b]Game Exited![/b][/color]")
		#await get_tree().create_timer(0.01).timeout
		get_tree().quit()

#func _ready() -> void: speed_up_engine_time(12)

func speed_up_engine_time(time: float) -> void:
	Engine.time_scale = time
