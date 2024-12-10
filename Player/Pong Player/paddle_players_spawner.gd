extends Node
class_name PlayerSpawner

const PADDLE_SCENE: PackedScene = preload("res://Player/Pong Player/paddle_player.tscn")
const PLAYER_MARGIN: float = 15.0 # The distance from the screen edges

@export_category("Paddle - Bot or Not.")
@export var player_1_is_bot: bool
@export var player_2_is_bot: bool

# Positions for the paddles
@onready var paddle_positions: Array[Vector2] = [
	Vector2(PLAYER_MARGIN, GlobalManager.screen_size.y / 2),
	Vector2(GlobalManager.screen_size.x - PLAYER_MARGIN, GlobalManager.screen_size.y / 2)]

func _ready() -> void:
	_spawn_players()
	queue_free() # Removes the spawner after paddles are spawned, cuz it's not needed anymore

## Spawns the paddles and sets their properties
func _spawn_players() -> void:
	for i: int in range(2):
		var new_paddle_player: Paddle = PADDLE_SCENE.instantiate() as Paddle

		# Determines which paddle is controlled by a bot and a player, with player_1_is_bot & player_2_is_bot
		new_paddle_player.is_bot = (i == 0 and player_1_is_bot) or (i == 1 and player_2_is_bot)

		# The second spawned paddle is always player 2
		new_paddle_player.is_player_2 = (i == 1)

		# Renamed to be easier to read in the remote
		new_paddle_player.name = "Paddle_Player_%d" % (i + 1)

		# Position paddle: Player 1 on left, Player 2 on right
		new_paddle_player.global_position = paddle_positions[i]

		# Add the paddle to the scene tree, as a sibling to not get deleted when the spawner gets quee_free()
		add_sibling.call_deferred(new_paddle_player)
