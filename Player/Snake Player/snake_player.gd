extends Area2D

class_name Snake

@export_category("Snake Parameters")
@export var move_speed := 3000.0		# How fast the snake moves
@export var segment_spacing := 60.0

var direction: Vector2
var body_segments: Array[SnakeBodySegment]
var positions_history: Array[Vector2]
var growing := false

const SNAKE_BODY_SEGMENT = preload("res://Player/Snake Player/snake_body.tscn")

const POSSIBLE_INPUTS := {
	"up": [Vector2.UP, 0],
	"ui_up": [Vector2.UP, 0],
	"down": [Vector2.DOWN, 180],
	"ui_down": [Vector2.DOWN, 180],
	"left": [Vector2.LEFT, -90],
	"ui_left": [Vector2.LEFT, -90],
	"right": [Vector2.RIGHT, 90],
	"ui_right": [Vector2.RIGHT, 90]
}

func _physics_process(delta: float) -> void:
	_movement(delta)

	# Store position for trailing segments
	#func update_body_segments():
	for i in body_segments.size():
		var target_pos = positions_history[max(0, positions_history.size() - 1 - int(segment_spacing * (i + 1) / move_speed / delta))]
		body_segments[i].global_position = target_pos

func _input(_event: InputEvent) -> void:
	testing_adding_segments()
	_handle_direction()

func _add_body_segment() -> void:
	var new_body_segment := SNAKE_BODY_SEGMENT.instantiate() as SnakeBodySegment
	add_child(new_body_segment)
	body_segments.append(new_body_segment)

func _movement(delta) -> void:
	position += direction * move_speed * delta
	positions_history.push_back(position)

func _handle_direction() -> void:
	for action in POSSIBLE_INPUTS:
		if Input.is_action_just_pressed(action):
			var dir_data = POSSIBLE_INPUTS[action]
			var new_direction = dir_data[0]
			var new_rotation = dir_data[1]
			if new_direction != -direction:
				direction = new_direction
				rotation_degrees = new_rotation
				return

func die() -> void:
	queue_free()

## PLACEHOLDER
func testing_adding_segments() -> void:
	if Input.is_action_pressed("ui_accept"):
		_add_body_segment()
