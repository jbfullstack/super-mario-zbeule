extends Bonus
class_name CoinCollectable

func _on_body_entered(body):
	if body is Player:
		set_collision_layer_value(6, false)
		set_collision_mask_value(1, false)
		
		GlobalAudioPlayer.play_sound(GlobalAudioPlayer.Sounds.COIN)
	
		play_collect_animation()
		
		get_tree().get_first_node_in_group("level_manager").on_coin_collected()
		

func play_collect_animation():
	var spawn_tween = get_tree().create_tween()
	animated_sprite_2d.play("default", 10, false)
	spawn_tween.tween_property(self, "position", position + Vector2(0, -10), 0.4)
	spawn_tween.tween_callback(queue_free)
