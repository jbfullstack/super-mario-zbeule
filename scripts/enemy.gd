extends FreezableArea2D
class_name Enemy

const POINTS_LABEL_SCENE = preload("res://scenes/points_label.tscn")

@export var horizontal_speed = 20
@export var vertical_speed = 100

@onready var ray_cast_2d = $RayCast2D as RayCast2D

@export var is_dead = false


func get_score():
	return 100

func _process(delta):
	if handle_game_freeze():
		return
		
	position.x -= delta * horizontal_speed
	
	if !ray_cast_2d.is_colliding():
		position.y += delta * vertical_speed

func die():
	is_dead = true
	horizontal_speed = 0
#	vertical_speed = 0
	animated_sprite_2d.play("dead")
	GlobalAudioPlayer.play_sound(GlobalAudioPlayer.Sounds.STOMP)

func die_from_hit():
	set_collision_layer_value(3, false)
	set_collision_mask_value(3, false)
	
	rotation_degrees = 180
	vertical_speed = 0
	horizontal_speed = 0
	
	GlobalAudioPlayer.play_sound(GlobalAudioPlayer.Sounds.ENEMY_DIE_FROM_HIT)
	
	var die_tween = get_tree().create_tween()
	die_tween.tween_property(self, "position", position + Vector2(0, -25), .2)
	die_tween.chain().tween_property(self, "position", position + Vector2(0, 500), 4)
	die_tween.tween_callback(queue_free)
	
	var points_label = POINTS_LABEL_SCENE.instantiate()
	points_label.position = self.position + Vector2(-20, -20)
	get_tree().root.add_child(points_label)

func _on_area_entered(area):
	if area is Koopa and area.isInShell and area.horizontal_speed != 0:
		self.die_from_hit()
