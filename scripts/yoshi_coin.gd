extends CoinCollectable
class_name YoshiCoin


func play_collect_animation():
#	var spawn_tween = get_tree().create_tween()
#	animated_sprite_2d.play("default", 10, false)
#	spawn_tween.tween_property(self, "position", position + Vector2(0, -10), 0.4)
#	spawn_tween.tween_callback(queue_free)

	var tween = get_tree().create_tween().bind_node(self).set_trans(Tween.TRANS_ELASTIC)
#	tween.tween_property(self, "position", position + Vector2(0, -10), 0.1)
	tween.tween_property(self, "modulate", Color.RED, 0.1)
	tween.tween_property(self, "scale", Vector2(), 1)
	tween.tween_callback(queue_free)

