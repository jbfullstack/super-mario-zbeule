extends Enemy
class_name Koopa


const KOOPA_FULL_COLL_SHAPE_POSITION = Vector2(0, 5)
const KOOPA_FULL_COLL_SHAPE = preload("res://resources/collision_shapes/koopa_full_collision_shape.tres")
const KOOPA_SHELL_COLL_SHAPE = preload("res://resources/collision_shapes/koopa_shell_collision_shape.tres")

@onready var collision_shape_2d = $CollisionShape2D
var isInShell = false

func _ready():
	collision_shape_2d.shape = KOOPA_FULL_COLL_SHAPE

func die():	
	if !isInShell:
		super.die()
		collision_shape_2d.set_deferred("shape", KOOPA_SHELL_COLL_SHAPE)
		collision_shape_2d.set_deferred("position", KOOPA_FULL_COLL_SHAPE_POSITION)
		isInShell = true
		
