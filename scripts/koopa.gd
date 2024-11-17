extends Enemy
class_name Koopa


const KOOPA_FULL_COLL_SHAPE_POSITION = Vector2(0, 5)
const KOOPA_SHELL_COLL_SHAPE_POSITION = Vector2(0, 0)
const KOOPA_FULL_COLL_SHAPE = preload("res://resources/collision_shapes/koopa_full_collision_shape.tres")
const KOOPA_SHELL_COLL_SHAPE = preload("res://resources/collision_shapes/koopa_shell_collision_shape.tres")


const slide_speed = 200

@onready var collision_shape_2d = $CollisionShape2D

var isInShell = false

# animation 
@onready var base_scale: Vector2 = scale
@onready var sprite_deform_scale: Vector2 = Vector2(0.8, 0.8)

var is_just_stomped = false

func _ready():
	ray_cast_2d.exclude_parent = true
	collision_shape_2d.shape = KOOPA_FULL_COLL_SHAPE
	
func _physics_process(delta):
	super._physics_process(delta)
	
	# squish jump effect
#	if is_just_stomped:
#		print("lerp")
#		scale.y = lerp(base_scale.y, base_scale.y * sprite_deform_scale.y, 0.5)
#		if scale.y ==  sprite_deform_scale.y:
#			is_just_stomped = false
#	elif scale.y != base_scale.y:
#		scale.y = base_scale.y

func die():
	is_just_stomped = true
	if !isInShell:
		super.die()
		collision_shape_2d.set_deferred("shape", KOOPA_SHELL_COLL_SHAPE)
		collision_shape_2d.set_deferred("position", KOOPA_SHELL_COLL_SHAPE_POSITION)
		ray_cast_2d.target_position = Vector2(0, 8)
		isInShell = true


func get_score():
	return 200

func on_stomp(player_pos: Vector2):
	set_collision_mask_value(1, false)
	set_collision_layer_value(3, false)
	set_collision_layer_value(4, true)

	GlobalAudioPlayer.play_sound(GlobalAudioPlayer.Sounds.STOMP)
	is_just_stomped = true
	
	var movement_direction = 1 if player_pos.x <= global_position.x else -1
	horizontal_speed = -movement_direction * slide_speed
	

	if movement_direction == -1:
		animated_sprite_2d.play_backwards("slide")
	else:
		animated_sprite_2d.play("slide")


#func _on_visible_on_screen_notifier_2d_screen_exited():
#	queue_free()


#func _on_body_entered(body):
#	pass # Replace with function body.


func _on_visible_on_screen_notifier_2d_screen_entered():
	set_process(true)
