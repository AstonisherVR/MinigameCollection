extends Node
class_name PlayerSpawner

# Access to the player scene
const PADDLE_SCENE := preload("res://Player/Pong Player/paddle_player.tscn")
const PLAYER_MARGIN := 15 # Distance from screen edges

@export_category("Paddle - Bot or Not.")
@export var player_1_is_bot: bool
@export var player_2_is_bot: bool

# The two posible positions for the paddles
@onready var paddle_positions =	[Vector2(PLAYER_MARGIN, GlobalManager.screen_size.y / 2),
								Vector2(GlobalManager.screen_size.x - PLAYER_MARGIN,
								GlobalManager.screen_size.y / 2)]

# The players get spawned at the start
func _ready() -> void:
	print("PlayerSpawner initialized.")
	_spawn_players()

# This is the two paddle players spawning logic
func _spawn_players() -> void:
	for i in range(2):
		var new_paddle_player := PADDLE_SCENE.instantiate() as Paddle
		if new_paddle_player:
			# Determines which paddle is controlled by a bot and a player, using player_1_is_bot/player_2_is_bot
			var is_bot = (i == 0 and player_1_is_bot) or (i == 1 and player_2_is_bot)
			new_paddle_player.is_bot = is_bot
			# The second spawned paddle is always player 2
			new_paddle_player.is_player_2 = (i == 1)
			# Renamed to be easier to read in the remote
			new_paddle_player.name = "Paddle_Player_%d" % (i + 1)
			# Position paddle: Player 1 on left, Player 2 on right
			new_paddle_player.global_position = paddle_positions[i]
			add_sibling.call_deferred(new_paddle_player)
		else:
			print_debug("Error: Failed to spawn paddle player.")
	queue_free()	# Removes the spawner after paddles are spawned
