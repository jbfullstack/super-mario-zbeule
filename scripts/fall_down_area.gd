extends Area2D
class_name FallDownArea

func _on_body_entered(body):
	if body is Player:
		body.die(true)
	else:
		body.queue_free()


func _on_area_entered(area):
	area.queue_free()
