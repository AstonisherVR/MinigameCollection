extends Button

func _on_pressed() -> void:
	# Use the enum value
	CurrentLevelManager.change_current_level_to(CurrentLevelManager.Levels.LEVEL_PONG)
