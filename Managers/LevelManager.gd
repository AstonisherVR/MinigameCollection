extends Node
@export_enum("LEVEL_PLAYGROUND", "LEVEL_PONG", "LEVEL_SNAKE", "LEVEL_FLAPPY_BIRD", "LEVEL_SPACE_INVADERS") var current_level := "LEVEL_PONG"

func _ready() -> void:
	print(get_tree().current_scene)
	print(get_tree().current_scene.get_index())
#
#func _process(delta: float) -> void:
	#pass
