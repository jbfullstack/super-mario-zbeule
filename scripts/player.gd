extends CharacterBody2D
class_name Player

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

enum PlayerMode {
	SMALL,
	BIG,
	SHOOTING
}

enum Sounds {
	JUMP,
	SHOOT,
	DIE
}

@onready var animation = $animation as PlayerAnimatedSprite
@onready var area_collision_sape = $Area2D/AreaCollisionSape
@onready var body_collision_sape = $BodyCollisionSape
@onready var jump_sound = $AudioStreamPlayer_jumping



@export_group("Locomotion")
@export var run_speed_damping = 0.5
@export var speed = 200.0
@export var jump_velocity = -350
@export_group("")

var player_mode = PlayerMode.SMALL



func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	handle_jump()
	
	handle_direction_x(delta)

	move_and_slide()


func handle_jump():
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		play_sound(Sounds.JUMP)

	# Manage short jump if jump btn released	
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5

func handle_direction_x(delta):
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = lerp(velocity.x, speed * direction, run_speed_damping * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta)
		
	animation.trigger_animation(velocity, direction, player_mode)


func play_sound(sound):
	if sound == Sounds.JUMP && jump_sound.playing == false:
		jump_sound.play()
