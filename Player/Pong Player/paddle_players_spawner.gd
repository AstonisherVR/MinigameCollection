extends Node
class_name PlayerSpawner

# Preload the player scene
const PADDLE_SCENE := preload("res://Player/Pong Player/paddle_player.tscn")
const PLAYER_MARGIN := 25  # Distance from screen edges

# This is when the players get spawned
func _ready() -> void:
	_spawn_players()

# This is the two paddle players spawning logic
func _spawn_players() -> void:
	for i in range(2):
		var new_paddle_player := PADDLE_SCENE.instantiate() as Paddle
		
		# Configurations for the new paddle's peoperties
		new_paddle_player.is_player_2 = (i == 1) # Set the Player 2 flag
		#new_paddle_player.is_bot = (i == 1)  # Second player is bot
		new_paddle_player.name = "Paddle_Player_%d" % (i + 1)
		
		# Position paddle: Player 1 on left, Player 2 on right
		new_paddle_player.global_position = Vector2((i * (GlobalManager.screen_size.x - 
		2 * PLAYER_MARGIN)) + PLAYER_MARGIN, GlobalManager.screen_size.y / 2)
		
		add_sibling.call_deferred(new_paddle_player)
	queue_free()
