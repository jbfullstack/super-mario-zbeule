extends Node
class_name LevelNames

var last_player_mode: Player.PlayerMode

enum Levels {
	OVERWORLD_01,
	UNDERWORLD_01
}

func get_scene_path(level: Levels):
	match level:
		Levels.OVERWORLD_01:
			return "res://scenes/main.tscn"
		Levels.UNDERWORLD_01:
			return "res://scenes/levels/01/underground_01.tscn"
		_:
			printerr("Level not defined, can't be loaded: ", level)
