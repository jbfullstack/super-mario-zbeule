extends Node
class_name LevelManager

signal points_scored(points: int)

const POINTS_LABEL_SCENE = preload("res://scenes/points_label.tscn")

var coin_counter_for_animation: int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func on_coin_collected():
	print("COIN COLLECTED")

func spawn_points_label(enemy: Enemy):
	var points_label = POINTS_LABEL_SCENE.instantiate()
	points_label.set_score_value(enemy.get_score())
	points_label.position = enemy.position + Vector2(-20, -20)
	get_tree().root.add_child(points_label)
	points_scored.emit(enemy.get_score())
