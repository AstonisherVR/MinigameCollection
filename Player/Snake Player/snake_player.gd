extends Node

class_name SnakePlayer
signal snake_died

@export_category("Snake Parameters")
@export_range(0.05, 2.0, 0.005) var move_delay: float = 0.15  # Delay of the snakes' movement from one position to the next

@onready var prediction_position_sprite_debugger: Sprite2D = %"Prediction Position Sprite Debuger"
@onready var movement_timer: Timer = %"Movement Timer"
@onready var head_body_part: SnakeBodySegment = %"Snake Head Segment"
@onready var body_parts: Array[SnakeBodySegment] = [head_body_part]	# Store the segment instances
@onready var previous_positions: Array[Vector2] = [head_body_part.position]

var predicted_position: Vector2
var predicted_direction: Vector2
var direction: Vector2
const GRID_SIZE: int = 64

# Reference to the body segment scene
const SNAKE_BODY_SEGMENT: PackedScene = preload("res://Player/Snake Player/snake_body_segment.tscn")

const POSSIBLE_INPUTS: Dictionary = {
	"up": Vector2.UP,
	"ui_up": Vector2.UP,
	"down": Vector2.DOWN,
	"ui_down": Vector2.DOWN,
	"left": Vector2.LEFT,
	"ui_left": Vector2.LEFT,
	"right": Vector2.RIGHT,
	"ui_right": Vector2.RIGHT}

func _ready() -> void:
	# TODO Start when first input
	_start_movement_timer()
	head_body_part.died.connect(die)

func _process(_delta: float) -> void:
	# For testing purposes only
	if OS.is_debug_build():
		_update_debugger_position()
		_testing_adding_segments()
	else:
		prediction_position_sprite_debugger.visible = false

func _on_movement_timer_timeout() -> void:
	# Prevents 180-degree turns
	if predicted_direction != -direction:
		direction = predicted_direction
	predicted_direction = direction

	_update_snake_body_movement()
	_update_rotation()
	_update_predicted_position()
	_start_movement_timer()

func _input(_event: InputEvent) -> void:
	_handle_direction()

func _update_snake_body_movement() -> void:
	# Moves the head
	head_body_part.position += direction * GRID_SIZE

	# Adjusts the positions to match the body parts
	previous_positions.push_front(head_body_part.position)
	if previous_positions.size() > body_parts.size():
		previous_positions.resize(body_parts.size())

	# Updates the body segments' positions
	for i: int in range(1, body_parts.size()):			# Starts at 1 to avoid moving the head
		body_parts[i].position = previous_positions[i]	# Sets their corresponding positions

func _update_rotation() -> void:
	# Updates the head rotation
	head_body_part.rotation_degrees = (direction.angle() * 180 / PI) + 90

	# Updates body segment rotations based on their direction
	for i: int in range(1, body_parts.size()):
		if i < previous_positions.size():
			var segment_direction: Vector2 = (previous_positions[i] - previous_positions[i - 1]).normalized()
			body_parts[i].rotation_degrees = (segment_direction.angle() * 180 / PI) + 90

## Creates a new segment and adds it to the snake
func add_body_segment() -> void:
	var new_body_segment: SnakeBodySegment = SNAKE_BODY_SEGMENT.instantiate() as SnakeBodySegment
	add_child(new_body_segment)

	var last_segment: SnakeBodySegment = body_parts[-1]
	new_body_segment.position = last_segment.position
	new_body_segment.name = "Snake Body Segment " + str(body_parts.size())

	previous_positions.append(last_segment.position)
	body_parts.append(new_body_segment)

## Handles the player input and changes direction
func _handle_direction() -> void:
	for action: String in POSSIBLE_INPUTS:
		if Input.is_action_just_pressed(action):
			predicted_direction = POSSIBLE_INPUTS[action]
			_update_predicted_position()
			return

## Updates the predicted position
func _update_predicted_position() -> void:
	predicted_position = head_body_part.position + predicted_direction * GRID_SIZE

## Updates the timer properties and restarts the movement
func _start_movement_timer() -> void:
	movement_timer.wait_time = move_delay
	movement_timer.start()

## Updates the position of the debug sprite
func _update_debugger_position() -> void:
	prediction_position_sprite_debugger.global_position = predicted_position

## TODO Death of the snake
func die() -> void:
	snake_died.emit()
	movement_timer.stop()
	#queue_free()

## Debug function for adding segments
func _testing_adding_segments() -> void:
	if OS.is_debug_build():
		if Input.is_action_pressed("ui_text_indent"):
			add_body_segment()
		if Input.is_action_just_pressed("ui_end"):
			head_body_part.position = Vector2(640, 320)
