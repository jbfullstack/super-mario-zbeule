extends AnimatedSprite2D
class_name  PlayerAnimatedSprite

func trigger_animation(velocity: Vector2, direction: int, player_mode: Player.PlayerMode, is_runing: bool):
	var animation_prefix = Player.PlayerMode.keys()[player_mode].to_snake_case()
	var isSliging: bool = false
	
	if not get_parent().is_on_floor():
		if velocity.y < 0:
			play("%s_jump" % animation_prefix)
		else:
			play("%s_fall" % animation_prefix)
			
		#TODO: jump / fall
		# else
			#fall
		
	
	# handle slide animation	
	elif sign(velocity.x) != sign(direction) && velocity.x != 0 && direction !=0:
		play("%s_slide" % animation_prefix)
		isSliging = true
	
	else:
		# handle run and idle animations
		if velocity.x != 0:
			if !is_runing:
				play("%s_walk" % animation_prefix)
			else:
				play("%s_run" % animation_prefix)
		else:
			play("%s_idle" % animation_prefix)


	# handle the sprite direction
	if !isSliging:
		if scale.x == 1 && sign(velocity.x) == -1:
			scale.x = -1
		elif scale.x == -1 && sign(velocity.x) == 1:
			scale.x = 1
	else:
		scale.x = direction
