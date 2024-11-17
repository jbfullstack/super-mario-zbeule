extends StaticBody2D
class_name HorizontalPipe


@export var is_traversable = false
@export var destination_level: LevelNamesManager.Levels
@export var destination_position: Vector2


func _on_pipe_area_2d_body_entered(body):
	if is_traversable && body is Player:
		body.enter_horizontal_pipe(self)
