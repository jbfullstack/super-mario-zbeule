extends Enemy
class_name Goomba

func die():
	super.die()
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
	
	get_tree().create_timer(1.5).timeout.connect(queue_free)


#func _on_visible_on_screen_notifier_2d_screen_exited():
#	queue_free()
func _process(delta):
	super._process(delta)
	if is_dead:
		rotate(0.2)
