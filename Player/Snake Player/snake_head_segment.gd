extends Area2D
class_name SnakeBodySegment
signal died

func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Snake Body Part") and area.name != "Snake Body Segment 1":
		#print("I hit " + area.name)
		died.emit()
