extends Ball

# Reset ball parameters instead of queue_free
func _score_ball():
	global_position = GlobalManager.screen_size / 2
	current_speed = initial_speed
	direction = _random_start_direction()
