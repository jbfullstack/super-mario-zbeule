extends Camera2D
class_name CameraMouvement

@export_group("level")
@export var vertical_sync: bool = true
@export_group("")

@onready var player : Player = get_parent().get_node("Player")

@export var debug: bool = true

# Horizontal movement variables
var h_direction = 0          # Current movement direction (-1, 0, 1)
var h_change_pos = 0.0       # Position where the player changed direction
var h_buffer = 50         # Pixel buffer before the camera moves after direction change
var camera_edge_margin = 80         # Pixel buffer before the camera moves after direction change

# Vertical movement variables
var is_camera_unlocked_vertically = false
var viewport_height = 0.0
var viewport_width = 0.0
var third_tiers_of_viewport_width = 0.0
var third_tiers_of_viewport_height = 0.0
var initial_camera_x = 0.0

var target_camera_y = 0.0
var last_player_y_pos_before_jump = 0.0
var is_player_p_meter_before_jump = false


func _ready():
	if player == null:
		push_error("Player node not found. Please assign it in the inspector.")
		return
	# Get the viewport height to calculate camera locking positions
	viewport_width = get_viewport_rect().size.x / zoom.x
	viewport_height = get_viewport_rect().size.y  / zoom.y
	third_tiers_of_viewport_width = viewport_width / 3
	third_tiers_of_viewport_height = viewport_height / 3
	
	target_camera_y = player.global_position.y - third_tiers_of_viewport_height
	last_player_y_pos_before_jump = player.global_position.y
			
	PRINT("viewport_width: " +  str(viewport_width))
	PRINT("viewport_height: " + str(viewport_height))
	initial_camera_x = global_position.x
	if vertical_sync:
		last_player_y_pos_before_jump = player.global_position.y
	
#	global_position = player.global_position
	h_direction = sign(player.velocity.x)
	h_change_pos = player.global_position.x
	
	zoom = Vector2(1.0, 1.0)

func _process(delta):
	if player == null:
		return
	update_horizontal_camera(delta)
	update_vertical_camera(delta)

func update_horizontal_camera(_delta):
	var direction = sign(player.velocity.x)
	if direction != h_direction:
		PRINT("Player changed direction")
		h_change_pos = player.global_position.x
		h_direction = direction
		
		
	if direction != 0:
		var distance_since_change = abs(player.global_position.x - h_change_pos)
		if distance_since_change > h_buffer:
			
			var target_x = player.global_position.x + (third_tiers_of_viewport_width * direction)
#			var target_x =  player.global_position.x
			# move camera again
			global_position.x = lerp(global_position.x, target_x, 0.05)
	

func update_vertical_camera(_delta):
	# update target y if player touch a new part of the ground
	var lerp_speed = 0.1
	
	if player.is_p_meter():
		is_player_p_meter_before_jump = true
	elif player.is_on_floor():
		is_player_p_meter_before_jump = false
		
	if vertical_sync:
		lerp_speed = handle_vertical_camera_unlocked_mouvement(lerp_speed)
	else:
		handle_vertical_camera_locked_mouvement()
	
	#update camera position if diffrent of target
	if target_camera_y != global_position.y:
		global_position.y = lerp(global_position.y, target_camera_y, lerp_speed)

func handle_vertical_camera_unlocked_mouvement(lerp_speed):
	if is_player_p_meter_before_jump:
		target_camera_y = player.global_position.y
	else:
			if player.is_on_floor() && target_camera_y != player.global_position.y - third_tiers_of_viewport_height:
		#		if last_player_y_pos_before_jump -  player.global_position.y  > third_tiers_of_viewport_height:
					target_camera_y = player.global_position.y - third_tiers_of_viewport_height / 2 
					last_player_y_pos_before_jump = player.global_position.y
				
			# If player is falling (moving downward) and not on the floor
			if not player.is_on_floor() and player.velocity.y > 0:
				# Determine if player 'is under' his position before jumping/falling
				if last_player_y_pos_before_jump < player.global_position.y:
					# Calculate the bottom of the screen in world coordinates
					var bottom_of_screen_y = global_position.y + (viewport_height / 2)
					# Calculate the distance between the player and the bottom of the screen
					var distance_to_bottom = bottom_of_screen_y - player.global_position.y
					if distance_to_bottom < 100:
						target_camera_y = player.global_position.y 
						lerp_speed = 1
	
	return lerp_speed

func handle_vertical_camera_locked_mouvement():
	if is_player_p_meter_before_jump && target_camera_y != player.global_position.y:
		target_camera_y = player.global_position.y
	elif target_camera_y != last_player_y_pos_before_jump - third_tiers_of_viewport_height / 2 :
		target_camera_y = last_player_y_pos_before_jump - third_tiers_of_viewport_height / 2 
		

func PRINT(msg: String):
	if debug:
		print(msg)
