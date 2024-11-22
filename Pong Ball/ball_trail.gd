extends Line2D

# This is the lenght of the trail 
@export var length : = 10
var ball_position: Vector2

func _ready() -> void:
	top_level = true

func _physics_process(_delta: float) -> void:
	if !get_parent().is_in_group("Pong Ball"): return
	modulate = Color(get_parent().modulate)
	ball_position = get_parent().global_position
	add_point(ball_position, 0)
	if get_point_count() > length:
		remove_point(get_point_count() - 1)
