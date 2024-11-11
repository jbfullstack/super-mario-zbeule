extends Area2D
class_name  Enemy

@export var horizontal_speed = 20
@export var vertical_speed = 100

@onready var ray_cast_2d = $RayCast2D as RayCast2D
@onready var animated_sprite_2d = $AnimatedSprite2D as AnimatedSprite2D

@export var is_dead = false


func _process(delta):
	position.x -= delta * horizontal_speed
	
	if !ray_cast_2d.is_colliding():
		position.y += delta * vertical_speed

func die():
	is_dead = true
	horizontal_speed = 0
	vertical_speed = 0
	animated_sprite_2d.play("dead")
