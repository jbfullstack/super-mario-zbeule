extends Camera2D
class_name CameraMouvement

@export_group("level")
@export var lock: bool = false
@export var horizontal_sync: bool = true
@export var vertical_sync: bool = true
@export_group("")

@onready var player : Player = get_parent().get_node("Player")

@export var debug: bool = true

# Horizontal movement variables
var h_direction = 0          # Current movement direction (-1, 0, 1)
var h_change_pos = 0.0       # Position where the player changed direction
var h_buffer = 50         # Pixel buffer before the camera moves after direction change
var camera_edge_margin = 80         # Pixel buffer before the camera moves after direction change

var zoom_grain = 0.01

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
	
#	zoom = Vector2(1.0, 1.0)

func _process(delta):
	if player == null:
		return
		
	handle_zoom()
		
	if !lock:
		update_horizontal_camera(delta)
		update_vertical_camera(delta)
	
	handle_shake(delta)

func update_horizontal_camera(_delta):
	if horizontal_sync:
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
		
func handle_zoom():
	var zoomed = false
	
	if Input.is_action_pressed("zoom_in"):
		zoom.x += zoom_grain
		zoom.y += zoom_grain
		zoomed = true
	elif Input.is_action_pressed("zoom_out"):
		zoom.x -= zoom_grain
		zoom.y -= zoom_grain
		zoomed = true
	
	if zoomed:
		viewport_width = get_viewport_rect().size.x / zoom.x
		viewport_height = get_viewport_rect().size.y  / zoom.y

var _timer = 0
var _last_shook_timer = 0.0
var _period_in_ms = 0.0
var _amplitude = 0.0
var _duration = 0.0
var _previous_x = 0.0
var _previous_y = 0.0
var _last_offset = Vector2(0, 0)

func handle_shake(delta):
	if _timer == 0:
		return
		
	_last_shook_timer = _last_shook_timer + delta
	
	while _last_shook_timer > _period_in_ms:
		_last_shook_timer = _last_shook_timer - _period_in_ms
		var intensity = _amplitude * (1 - ((_duration - _timer) / _duration))
		var new_x = randf_range(-1.0, 1.0)
		var x_component = intensity * (_previous_x + (delta * (new_x - _previous_x)))
		var new_y = randf_range(-1.0, 1.0)
		var y_component = intensity * (_previous_y + (delta * (new_y - _previous_y)))
		_previous_x = new_x
		_previous_y = new_y
		
		var new_offset = Vector2(x_component, y_component)
		set_offset(get_offset() - _last_offset + new_offset)
		_last_offset = new_offset
		_timer = _timer - delta
		if _timer <= 0:
			_timer = 0
			set_offset(get_offset() - _last_offset)
			
func shake(duration, frequency, amplitude):
	if frequency == 0: return
	_duration = duration
	_timer = duration
	_period_in_ms = 1.0 / frequency
	_amplitude = amplitude
	_previous_x =  randf_range(-1.0, 1.0)
	_previous_y =  randf_range(-1.0, 1.0)
	set_offset(get_offset() - _last_offset)
	_last_offset = Vector2(0, 0)


func PRINT(msg: String):
	if debug:
		print(msg)
