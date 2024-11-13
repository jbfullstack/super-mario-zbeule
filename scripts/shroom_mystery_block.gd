extends Shroom
class_name ShroomMysteryBloc

func _ready():
	GlobalAudioPlayer.play_sound(GlobalAudioPlayer.Sounds.SHROOM_APPEARS)
	var spawn_tween = get_tree().create_tween()
	spawn_tween.tween_property(self, "position", position + Vector2(0, -15), .4)
	spawn_tween.tween_callback(func (): 
		allow_horizontal_movement = true
		is_eatable = true
	)



func _on_body_entered(body):
	if is_eatable:
		if body is Player:
			body.eat_mushroom_red_from_mistery_block()
			queue_free()
