extends CharacterBody2D
class_name Player

signal points_scored(points: int)

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum PlayerMode {
	SMALL,
	BIG,
	SHOOTING
}

const POINTS_LABEL_SCENE = preload("res://scenes/points_label.tscn")

@onready var animation = $animation as PlayerAnimatedSprite
@onready var area_collision_sape = $Area2D/AreaCollisionSape
@onready var body_collision_sape = $BodyCollisionSape

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
	
	animation.trigger_animation(velocity, direction, player_mode, ( p_meter == 1.867) )
	
	move_and_slide()

#
#func _physics_process(delta):
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y += gravity * delta
#
#	handle_jump()
#
#	handle_direction_x(delta)
#
#	move_and_slide()
#
#
#func handle_jump():
#	if Input.is_action_just_pressed("jump") and is_on_floor():
#		velocity.y = jump_velocity
#		play_sound(Sounds.JUMP)
#
#	# Manage short jump if jump btn released	
#	if Input.is_action_just_released("jump") and velocity.y < 0:
#		velocity.y *= 0.5
#
#func handle_direction_x(delta):
#	var direction = Input.get_axis("left", "right")
#	if direction:
#		velocity.x = lerp(velocity.x, speed * direction, run_speed_damping * delta)
#	else:
#		velocity.x = move_toward(velocity.x, 0, speed * delta)

	
#
#

#
#
func _on_area_2d_area_entered(area):
	if area is Enemy:
		handle_enemy_collision(area)

func handle_enemy_collision(enemy: Enemy):
	if enemy == null:
		printerr("player collided with null enemy")
		return
	
	# manage enemy is Koopa in shell
	if is_instance_of(enemy, Koopa) and (enemy as Koopa).isInShell:
		enemy.on_stomp(global_position)
		spawn_points_label(enemy)
	else:
		var angle_of_collision = rad_to_deg(position.angle_to_point(enemy.position))
		if angle_of_collision > min_stomp_degree && max_stomp_degree > angle_of_collision:
			enemy.die()
			on_enemy_stomp()
			spawn_points_label(enemy)
		elif !enemy.is_dead:
			die()

func on_enemy_stomp():
	velocity.y = stomp_y_velocity

func spawn_points_label(enemy: Enemy):
	var points_label = POINTS_LABEL_SCENE.instantiate()
	points_label.set_score_value(enemy.get_score())
	points_label.position = enemy.position + Vector2(-20, -20)
	get_tree().root.add_child(points_label)
	points_scored.emit(enemy.get_score())

func die():
	GlobalAudioPlayer.play_sound(GlobalAudioPlayer.Sounds.MARIO_DIE)
	print("Mario die")
