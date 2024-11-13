extends AnimatedSprite2D
class_name  PlayerAnimatedSprite

var frame_count = 0

var is_shooting = false

func trigger_animation(velocity: Vector2, direction: int, player_mode: Player.PlayerMode, is_runing: bool):
	var animation_prefix = Player.PlayerMode.keys()[player_mode].to_snake_case()
	
	var isSliding: bool = false
	
	if !is_shooting:
		if not get_parent().is_on_floor():
			if velocity.y < 0:
				play("%s_jump" % animation_prefix)
			else:
				play("%s_fall" % animation_prefix)
		
		# handle slide animation	
		elif sign(velocity.x) != sign(direction) && velocity.x != 0 && direction !=0:
			play("%s_slide" % animation_prefix)
			isSliding = true
		
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
	if !isSliding:
		if scale.x == 1 && sign(velocity.x) == -1:
			scale.x = -1
		elif scale.x == -1 && sign(velocity.x) == 1:
			scale.x = 1
	else:
		scale.x = direction

func play_shoot():
	is_shooting = true
	get_parent().animation.play("shoot")

func _on_animation_finished():
	print("finished: ", animation)
	if animation == "small_to_big":
		reset_player_properties()
		match get_parent().player_mode:
			Player.PlayerMode.BIG:
				get_parent().player_mode = Player.PlayerMode.SMALL
			Player.PlayerMode.SMALL:
				get_parent().player_mode = Player.PlayerMode.BIG
	elif animation == "small_to_shooting":
		reset_player_properties()
		match get_parent().player_mode:
			Player.PlayerMode.SHOOTING:
				get_parent().player_mode = Player.PlayerMode.SMALL
			Player.PlayerMode.SMALL:
				get_parent().player_mode = Player.PlayerMode.SHOOTING
	elif animation == "big_to_shooting":
		reset_player_properties()
		match get_parent().player_mode:
			Player.PlayerMode.SHOOTING:
				get_parent().player_mode = Player.PlayerMode.BIG
			Player.PlayerMode.BIG:
				get_parent().player_mode = Player.PlayerMode.SHOOTING
	elif animation == "shoot":
		print("shooting terminated")
		is_shooting = false
#		get_parent().set_physics_process(true)
		play("shooting_idle")

		
func reset_player_properties():
	offset = Vector2.ZERO
	get_parent().set_physics_process(true)
	get_parent().set_collision_layer_value(1, true)
	get_parent().is_touchable = true
	frame_count = 0


func _on_frame_changed():
		# Keep foot position logically during transformation
		if animation == "small_to_big" or animation == "small_to_shooting":
			var player_mode = get_parent().player_mode
			var offset_val = 5
			
			if player_mode == Player.PlayerMode.SMALL and frame_count == 0:
				get_parent().position.y -= offset_val
				
			frame_count += 1
#

			if player_mode == Player.PlayerMode.SMALL:
				if frame_count % 2 == 1:
					offset = Vector2(0, -offset_val if player_mode == Player.PlayerMode.BIG else 0)
				else:
					offset = Vector2(0, 0 if player_mode == Player.PlayerMode.BIG else offset_val)
			else:
				if frame_count % 2 == 1:
					offset = Vector2(0, 0 if player_mode == Player.PlayerMode.BIG else -offset_val)
				else:
					offset = Vector2(0, offset_val if player_mode == Player.PlayerMode.BIG else 0)
