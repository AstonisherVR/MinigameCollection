extends CharacterBody2D
class_name Ball

# Signal emitted when a player scores (ball goes off screen)
signal ball_scored

# === Ball Movement Configuration ===
@export_category("Movement")
# Initial speed of the ball when spawned
@export var initial_speed := 500.0
# Maximum speed the ball can possibly move at
@export var max_speed := 1600.0 
# How much faster the ball gets each time it hits a paddle
@export var acceleration_speed := 150.0

# The ball's current speed - starts at initial_speed
@onready var current_speed := initial_speed
# The ball's current direction - set randomly at start
@onready var direction := _random_start_direction()
# Maximum vertical component of the bounce direction

# Limits how steeply the ball can bounce (0.6 = 60% of full vertical angle)
const MAX_Y_VECTOR := 0.6

func _physics_process(delta: float) -> void:
	#print(current_speed)
	_ball_movement(delta)

# Moves the ball and handles bouncing off paddles and walls
func _ball_movement(delta) -> void:
	# Try to move the ball and check if it hits anything
	var collision := move_and_collide(direction * current_speed * delta) 
	# If we hit something...
	if collision:
		var collider = collision.get_collider()
		# If we hit a paddle, speed up the ball and calculate new bounce direction based on where it hit the paddle
		if collider.is_in_group("Paddles"):
			current_speed = min(current_speed + acceleration_speed, max_speed)
			direction = _calculate_bounce_direction(collider)
		# If we hit a wall, simply bounce off at the same angle
		else: direction = direction.bounce(collision.get_normal())

# Figures out how the ball should bounce off a paddle
func _calculate_bounce_direction(collider) -> Vector2:
	# Find where the ball hit the paddle
	var ball_y_pos := position.y
	var paddle_y_pos: float = collider.position.y
	var distance := ball_y_pos - paddle_y_pos
	var new_direction: Vector2
	
	# Reverse horizontal direction (if going right, now go left & vice versa)
	new_direction.x = -sign(direction.x)
	
	# Calculate vertical bounce angle based on where ball hits the paddle:
	# - Hit center = straight bounce
	# - Hit top = bounce upward
	# - Hit bottom = bounce downward
	new_direction.y = (distance / (collider.get_node("CollisionShape2D").shape.extents.y)) * MAX_Y_VECTOR
	
	return new_direction.normalized()  # Normalized to maintain consistent speed

# Generates a random starting direction when ball spawns
func _random_start_direction() -> Vector2:
	var new_direction: Vector2 
	# Randomly go left or right
	new_direction.x = [-1, 1].pick_random()
	# Add a random up/down angle
	new_direction.y = randf_range(-MAX_Y_VECTOR, MAX_Y_VECTOR)
	return new_direction.normalized()

func _score_ball() -> void:
	# Check which player scored based on ball direction
	if direction.x > 0: ball_scored.emit("player_1_scored")
	else: ball_scored.emit("player_2_scored")
	# Remove the ball
	queue_free()
	
	# Testing code (commented out) to reset ball instead of removing it
	#global_position = GlobalManager.screen_size / 2
	#current_speed = initial_speed
	#direction = random_start_direction()

# Makes the ball gradually fade out (Just in case I want to add powers for the players)
func _make_invisible() -> void:
	modulate = modulate * 0.96

# Called when ball goes off screen - triggers scoring
func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	_score_ball()
