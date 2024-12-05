extends Line2D

# This is the lenght of the trail 
@export var length : = 10


func _ready() -> void:
	top_level = true

func _physics_process(_delta: float) -> void:
	if !get_parent().is_in_group("Pong Ball"): return
	var parent: CharacterBody2D = get_parent()
	var ball_position: Vector2 = parent.global_position
	modulate = Color(parent.modulate)
	add_point(ball_position, 0)
	if get_point_count() > length:
		remove_point(get_point_count() - 1)
