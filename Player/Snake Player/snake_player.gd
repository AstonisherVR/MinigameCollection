extends Node2D

class_name SnakePlayer

@export_category("Snake Parameters")
@export_range(0.025, 2.0, 0.005) var move_delay: float = 0.15	# The delay of the snake to move from the previous to the next position

@onready var movement_timer: Timer = %"Movement Timer"

@onready var prediction_position_sprite_debuger: Sprite2D = %"Prediction Position Sprite Debuger"

var body_parts: Array[SnakeBodySegment]	# Store actual segment instances
var body_positions: Array[Vector2]		# Store positions for trailing effect
var direction: Vector2
var predicted_position: Vector2
var grid_size := 64

var predicted_direction: Vector2
# Reference to the body segment scene
const SNAKE_BODY_SEGMENT := preload("res://Player/Snake Player/snake_body.tscn")

const POSSIBLE_INPUTS :={
	"up": Vector2.UP,
	"ui_up": Vector2.UP,
	"down": Vector2.DOWN,
	"ui_down": Vector2.DOWN,
	"left": Vector2.LEFT,
	"ui_left": Vector2.LEFT,
	"right": Vector2.RIGHT,
	"ui_right": Vector2.RIGHT,}

func _ready() -> void:
	_update_predicted_position()
	_configure_movement_timer()

func _process(_delta: float) -> void:
	prediction_position_sprite_debuger.global_position = predicted_position
	testing_adding_segments()

func _on_movement_timer_timeout() -> void:
	# Prevents 180-degree turns
	if predicted_direction != -direction:
		direction = predicted_direction
	_update_movement()
	_update_rotation()
	_update_predicted_position()
	_configure_movement_timer()

func _input(_event: InputEvent) -> void:
	_handle_direction()

func _update_movement() -> void:
	#var tween = create_tween()
	#tween.tween_property(self, "position", predicted_position, move_delay)
	position += direction * grid_size 

func _update_rotation() -> void:
	if (direction.x + 2 * direction.y) * 90 != -180:
		rotation_degrees = (direction.x + 2 * direction.y) * 90
	else: rotation_degrees = 0

func _handle_direction() -> void:
	for action in POSSIBLE_INPUTS:
		if Input.is_action_just_pressed(action):
			_update_predicted_direction(action)
			_update_predicted_position()
			return

func _update_predicted_direction(input_action: String) -> void:
	predicted_direction = POSSIBLE_INPUTS[input_action]

func _update_predicted_position() -> void:
	predicted_position = position + predicted_direction * grid_size

## Create new segment and add it to the snake
func add_body_segment() -> void:
	var new_body_segment := SNAKE_BODY_SEGMENT.instantiate() as SnakeBodySegment
	add_child(new_body_segment)
	#new_body_segment.global_position = body_positions[]
	#body_parts.append(new_body_segment)

## Updates the new time and starts the movement again 
func _configure_movement_timer() -> void:
	movement_timer.wait_time = move_delay
	movement_timer.start()

## TEST FUNCTION
func testing_adding_segments() -> void:
	if Input.is_action_pressed("ui_accept"):
		add_body_segment()

func die() -> void:
	queue_free()
