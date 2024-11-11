extends Control
class_name PauseMenu

@onready var animation_blur = $AnimationBlur

func _ready():
	animation_blur.play("RESET")
	

func _process(delta):
	manage_state()

func resume():
	get_tree().paused = false
	animation_blur.play_backwards("blur")
	
func pause():
	get_tree().paused = true
	animation_blur.play("blur")

func manage_state():
	
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
		resume()
	

func _on_resume_pressed():
	resume()


func _on_quit_pressed():
	get_tree().quit()
