extends Area2D
class_name SnakeBodySegment

func _on_area_entered(area: Area2D) -> void:
	print(area.name)
