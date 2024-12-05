extends Area2D
class_name BaseFruit
signal fruit_eaten

func _on_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.name == "Snake Body Segments":
		fruit_eaten.emit()
		queue_free()
