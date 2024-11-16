extends CharacterBody2D
class_name Player

#signal points_scored(points: int)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum PlayerMode {
	SMALL,
	BIG,
	SHOOTING
}

#const POINTS_LABEL_SCENE = preload("res://scenes/points_label.tscn")
const BIG_MARIO_COLL_SHAPE = preload("res://resources/collision_shapes/big_mario_collision_shape.tres")
const SMALL_MARIO_COLL_SHAPE = preload("res://resources/collision_shapes/small_mario_collision_shape.tres")
const FIRE_BALL_SCENE = preload("res://scenes/fire_ball.tscn")

#@export_group("camera sync")
#@export var camera_sync: Camera2D
#@export var should_camera_sync: bool = true
#@export_group("")

@onready var animation = $animation as PlayerAnimatedSprite
@onready var area_collision_sape = $Area2D/AreaCollisionSape
@onready var body_collision_sape = $BodyCollisionSape
@onready var fire_ball_spawn_point = $FireBallSpawnPoint


#@export_group("Locomotion")
#@export var run_speed_damping = 0.5
#@export var speed = 75.0
#@export var jump_velocity = -400
#@export_group("")
#
#@export_group("Stomping enemies")
#@export var min_stomp_degree = 35
#@export var max_stomp_degree = 145
#@export var stomp_y_velocity = -150
#@export_group("")

var player_mode = PlayerMode.SMALL
var is_dead: bool = false
var is_invisible: bool = false
var is_touchable:bool = true

# wye
@onready var speed = 75.0
@onready var jump_velocity = -400
@onready var min_stomp_degree = 35
@onready var max_stomp_degree = 145
@onready var stomp_y_velocity = -150

@onready var max_walk_speed: float = 75.0
@onready var max_run_speed: float = 135.0
@onready var max_sprint_speed: float = 135.0

@onready var walk_accel: float = 337.5
@onready var stop_decel: float = 225

@onready var p_meter_starting_speed: float = 131.25
@onready var max_p_meter: float = 1.867

var p_meter: float = 0.0
var facing_dir = -1
# wye end

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		GlobalAudioPlayer.play_sound(GlobalAudioPlayer.Sounds.JUMP)
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5
		
	if Input.is_action_just_pressed("shoot") and player_mode == PlayerMode.SHOOTING and !animation.is_shooting:
		shoot()

	var direction = Input.get_axis("left", "right")
	if is_on_floor() and abs(velocity.x) >= p_meter_starting_speed and Input.is_action_pressed("shoot"):
		p_meter = min(p_meter + 2 * delta, max_p_meter)
	else:
		p_meter = max(p_meter - delta, 0)
		
	if direction:
		var max_speed: float = max_walk_speed
		if Input.is_action_pressed("shoot"):
			max_speed = max_run_speed
		if p_meter == max_p_meter:
			max_speed = max_sprint_speed
		velocity.x = move_toward(velocity.x, direction * max_speed, walk_accel * delta)
		facing_dir = direction
		
	else:
		velocity.x = move_toward(velocity.x, 0, stop_decel * delta)
	
	animation.trigger_animation(velocity, direction, player_mode, is_p_meter() )

	move_and_slide()

#func _process(delta):
#	# camera sync
#	if should_camera_sync:
#		if global_position.x > camera_sync.global_position.x:
#			camera_sync.global_position.x = global_position.x

func is_p_meter():
	return ( p_meter >= max_p_meter)

func _on_area_2d_area_entered(area):
	if area is Enemy:
		handle_enemy_collision(area)

func handle_enemy_collision(enemy: Enemy):
	if enemy == null or is_dead:
		printerr("player collided with null enemy or player dead")
		return
		
	if !is_touchable:
		printerr("player collided with enemy but player not touchable")
		return
	
	# manage enemy is Koopa in shell
	if is_instance_of(enemy, Koopa) and (enemy as Koopa).isInShell:
		enemy.on_stomp(global_position)
		get_tree().get_first_node_in_group("level_manager").spawn_points_label(enemy)
	else:
		var angle_of_collision = rad_to_deg(position.angle_to_point(enemy.position))
		if angle_of_collision > min_stomp_degree && max_stomp_degree > angle_of_collision:
			enemy.die()
			on_enemy_stomp()
			get_tree().get_first_node_in_group("level_manager").spawn_points_label(enemy)
		elif !enemy.is_dead:
			die()

func on_enemy_stomp():
	velocity.y = stomp_y_velocity

#func spawn_points_label(enemy: Enemy):
#	var points_label = POINTS_LABEL_SCENE.instantiate()
#	points_label.set_score_value(enemy.get_score())
#	points_label.position = enemy.position + Vector2(-20, -20)
#	get_tree().root.add_child(points_label)
#	points_scored.emit(enemy.get_score())

func die():
	if player_mode == PlayerMode.SMALL:
		is_dead = true
		GlobalAudioPlayer.stop_music()
		GlobalAudioPlayer.play_sound(GlobalAudioPlayer.Sounds.MARIO_DIE)
		set_collision_layer_value(1, false)
		set_physics_process(false)
		
		animation.play("death")
		var death_tween = get_tree().create_tween()
		death_tween.tween_property(self, "position", position + Vector2(0, -48), .5)
		death_tween.chain().tween_property(self, "position", position + Vector2(0, 256), 3.5)
		# TODO: manage menu restart etc..
		death_tween.tween_callback(func (): get_tree().reload_current_scene())
		
	else:
		big_to_small()

func eat_mushroom_red_from_mistery_block():
	if player_mode == PlayerMode.SMALL:
		handle_player_transformation(true)
		animation.play("small_to_big")
		
func eat_flower_from_mistery_block():
	handle_player_transformation(true)
	if player_mode == PlayerMode.SMALL:
		animation.play("small_to_shooting")
	elif player_mode == PlayerMode.BIG:
		animation.play("big_to_shooting")
	
func big_to_small():
	print("Mario Big to small")
	handle_player_transformation(false)
	var animation_name = "small_to_big" if player_mode == PlayerMode.BIG else "small_to_shooting"
	animation.play(animation_name, 1.0, true)
	
func handle_player_transformation(power_up: bool):
	GlobalGameState.freeze()
	set_physics_process(false)
	is_touchable = false
	set_collision_layer_value(1, false)	
	
	if power_up:
		GlobalAudioPlayer.play_sound(GlobalAudioPlayer.Sounds.POWER_UP)
	else:
		GlobalAudioPlayer.play_sound(GlobalAudioPlayer.Sounds.POWER_DOWN)
		
	set_collision_shape(!power_up)

func set_collision_shape(is_small: bool):
	var collision_shape = SMALL_MARIO_COLL_SHAPE if is_small else BIG_MARIO_COLL_SHAPE
	area_collision_sape.set_deferred("shape", collision_shape)
	body_collision_sape.set_deferred("shape", collision_shape)
	
	
func shoot():
	print("shoot")
#	set_physics_process(false)
	velocity.y =0
	animation.play_shoot()
	GlobalAudioPlayer.play_sound(GlobalAudioPlayer.Sounds.FIRE)
	var fireball = FIRE_BALL_SCENE.instantiate()
	fireball.direction = sign(animation.scale.x)
	fireball.global_position = fire_ball_spawn_point.global_position
	get_tree().root.add_child(fireball)

