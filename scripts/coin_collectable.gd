extends Bonus
class_name CoinCollectable

@export var is_floating_animated: bool = true
var floating_delta: float = 0.15
var floating_steps: int = 10
var current_floating_step: int = 0
var current_waiting_floating_step: int = 0
var waiting_floating_steps: int = 4
var floating_direction: int = 1
var floating_offset: int = 0 

func _ready():
	
	floating_offset = get_tree().get_first_node_in_group("level_manager").coin_counter_for_animation
	get_tree().get_first_node_in_group("level_manager").coin_counter_for_animation += 1
	current_floating_step = floating_offset % floating_steps
	
func _process(delta):
	if is_floating_animated:
		if current_floating_step < floating_steps:
			if current_waiting_floating_step == waiting_floating_steps:
				current_waiting_floating_step = 0
				current_floating_step += 1
				position.y -= floating_delta * floating_direction
			else:
				current_waiting_floating_step += 1
		else:
			floating_direction *= -1
			current_floating_step = 0

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
