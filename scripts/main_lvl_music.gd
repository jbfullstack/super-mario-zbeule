extends Node2D
class_name MainLvlMusic

@onready var music = $Music
var isBackgroundMusicOn = true

# Called when the node enters the scene tree for the first time.
func _ready():
	GlobalAudioPlayer.play_overworld_music_level()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_music_status()
	
func update_music_status():
	if isBackgroundMusicOn:
		if !music.playing:
			music.play()
	else:
		if music.playing:
			music.stop()
