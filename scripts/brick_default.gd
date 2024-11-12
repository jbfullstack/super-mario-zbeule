extends Block
class_name BrickDefault


func bump(player_mode: Player.PlayerMode):
	if player_mode == Player.PlayerMode.SMALL:
		super.bump(player_mode)


func _on_bump_area_body_entered(body):
	if body is Player:
		super.bump(body.player_mode)
