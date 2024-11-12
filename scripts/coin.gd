extends AnimatedSprite2D
class_name Coin


func _ready():
	var spawn_tween = get_tree().create_tween()
	
	GlobalAudioPlayer.play_sound(GlobalAudioPlayer.Sounds.COIN)
	
	spawn_tween.tween_property(self, "position", position + Vector2(0, -40), .3)
	spawn_tween.chain().tween_property(self, "position", position, .3)
	spawn_tween.tween_callback(queue_free)
