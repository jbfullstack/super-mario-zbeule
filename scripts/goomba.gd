extends Enemy
class_name Goomba

func die():
	super.die()
	set_collision_layer_value(3, false)
	set_collision_mask_value(1, false)
