extends Area2D
class_name BaseFruit
signal fruit_eaten

func _on_area_entered(area: Area2D) -> void:
	if area.name == "Snake Head":
		fruit_eaten.emit()
		queue_free()
