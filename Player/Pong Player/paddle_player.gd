extends CharacterBody2D
## The Player and Bot Logic will be here
class_name Paddle

@export_category("Paddle Configuration")
@export var move_speed := 500.0				# How fast the paddle moves
@export var is_player_2 := false			# If true, uses Player 2 controls
@export var is_bot := false					# If true, paddle is AI controlled (And automatically Player 2)
#Bot Specific Values 🡻						
@export var bot_movement_threshold := 3.0	# Minimum distance before paddle moves. Also prevents jittering
@export var bot_reaction_factor := 0.25		# How fast the bot reacts. Lower = faster bot reactions
@onready var bot_detection_area: Area2D = %BotDetectionArea2D # Reference to the detection area
@onready var bot_area_collision: CollisionShape2D = bot_detection_area.get_child(0) # Reference to the detection's area collision shape
var _current_ball: Ball						# Variable to store the current ball for the bot to track

# Dictionary to store input mappings for both players
var _input_actions: Dictionary = {
	"up": "up",
	"down": "down",
	"player2_up": "ui_up",
	"player2_down": "ui_down"
}

func _ready() -> void:
	# Enable/disable ball detection based on if it's a bot
	bot_area_collision.set_deferred("disabled", !is_bot)
	if is_bot: is_player_2 = true
	# Puts the bot_detection_area in the center
	bot_detection_area.global_position = GlobalManager.screen_size/2

func _physics_process(delta: float) -> void:
	_update_movement()
	move_and_slide()

# Regular updates (for bot logic)
func _process(_delta: float) -> void:
	if is_bot: _update_ball_reference()

## Updates which ball the bot is tracking
func _update_ball_reference() -> void:
	var balls := bot_detection_area.get_overlapping_bodies()
	_current_ball = balls[0] if !balls.is_empty() else null

## Updates the vertical movement velocity of the players and bot
func _update_movement() -> void:
	velocity.y = move_speed * _get_movement_direction()

## Returns The two Players movement direction (Player 1, Player 2 or Bot)
func _get_movement_direction() -> float:
	return _get_bot_direction() if is_bot else _get_player_direction()

## Handles player input for movement
func _get_player_direction() -> float:
	var up_action = _input_actions["player2_up" if is_player_2 else "up"]
	var down_action = _input_actions["player2_down" if is_player_2 else "down"]
	return Input.get_axis(up_action, down_action)

## Calculates bot movement based on ball position. Returns Bot movement direction
func _get_bot_direction() -> float:
	var ball_pos := _get_ball_position()
	var distance := ball_pos.y - position.y # The vertical distance between paddle and ball
	return 0.0 if abs(distance) <= bot_movement_threshold else \
		clamp(distance / (move_speed * bot_reaction_factor), -1.0, 1.0)

## Gets current ball position. If no ball is detected, return current paddle position to stay in place
func _get_ball_position() -> Vector2:
	return _current_ball.position if _current_ball else position