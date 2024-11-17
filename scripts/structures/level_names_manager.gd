extends Node
class_name LevelNames

var data: SceneData = SceneData.new()

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

func set_player_mode(mode: Player.PlayerMode):
	data.last_player_mode = mode
	
func set_return_point(destination: Vector2):
	data.return_point = destination

func has_return_point():
	return data.return_point != null && data.return_point != Vector2.ZERO

func return_point():
	return data.return_point
	
func player_mode():
	return data.last_player_mode
