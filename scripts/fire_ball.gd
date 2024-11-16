extends FreezableArea2D
class_name FireBall

@onready var ray_cast_2d = $RayCast2D
var horizontal_speed = 200
var vertical_speed = 100
var amplitude = 20
var is_moving_up = false

var direction
var vertical_mouvement_start_position

func _process(delta):
	if handle_game_freeze():
		return
		
	position.x += delta * horizontal_speed * direction
	if ray_cast_2d.is_colliding():
		is_moving_up = true
		vertical_mouvement_start_position = position
			
	if is_moving_up:
		position.y -= vertical_speed * delta
		if vertical_mouvement_start_position.y - amplitude >= position.y:
			is_moving_up = false
			
	else:
		position.y += delta * vertical_speed


func _on_area_entered(area):
	if area is Enemy:		
		GlobalAudioPlayer.play_sound(GlobalAudioPlayer.Sounds.ENEMY_DIE_FROM_HIT)
		get_tree().get_first_node_in_group("level_manager").spawn_points_label(area)
		area.die()
	queue_free()


func _on_body_entered(_body):
	queue_free()
