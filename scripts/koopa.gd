extends Enemy
class_name Koopa


const KOOPA_FULL_COLL_SHAPE_POSITION = Vector2(0, 5)
const KOOPA_SHELL_COLL_SHAPE_POSITION = Vector2(0, 0)
const KOOPA_FULL_COLL_SHAPE = preload("res://resources/collision_shapes/koopa_full_collision_shape.tres")
const KOOPA_SHELL_COLL_SHAPE = preload("res://resources/collision_shapes/koopa_shell_collision_shape.tres")


const slide_speed = 200

@onready var collision_shape_2d = $CollisionShape2D
var isInShell = false

func _ready():
	ray_cast_2d.exclude_parent = true
	collision_shape_2d.shape = KOOPA_FULL_COLL_SHAPE
	
func _process(delta):
	position.x -= delta * horizontal_speed
	
	if !ray_cast_2d.is_colliding():
		position.y += delta * vertical_speed

func die():
	if !isInShell:
		super.die()
		collision_shape_2d.set_deferred("shape", KOOPA_SHELL_COLL_SHAPE)
		collision_shape_2d.set_deferred("position", KOOPA_SHELL_COLL_SHAPE_POSITION)
		ray_cast_2d.target_position = Vector2(0, 8)
		isInShell = true
	print("CollisionShape2D Position after die():", collision_shape_2d.position)


func get_score():
	return 200

func on_stomp(player_pos: Vector2):
	set_collision_mask_value(1, false)
	set_collision_layer_value(3, false)
	set_collision_layer_value(4, true)

	GlobalAudioPlayer.play_sound(GlobalAudioPlayer.Sounds.STOMP)
	print("da stomp")
	animated_sprite_2d.play("slide")
	
	var movement_direction = 1 if player_pos.x <= global_position.x else -1
	horizontal_speed = -movement_direction * slide_speed
