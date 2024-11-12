extends Label
class_name PointsLabel

@onready var score:int = 100


# Called when the node enters the scene tree for the first time.
func _ready():
	var label_tween = get_tree().create_tween()
	label_tween.tween_property(self, "position", position + Vector2(0, -10), .4)
	label_tween.tween_callback(queue_free)

func set_score_value(new_score: int):
	score = new_score
	self.text = str(score)
	
