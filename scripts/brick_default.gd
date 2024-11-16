extends Block
class_name BrickDefault

@onready var gpu_particles_2d = $GPUParticles2D
@onready var sprite_2d = $Sprite2D


func bump(player_mode: Player.PlayerMode):
	if player_mode == Player.PlayerMode.SMALL:
		super.bump(player_mode)


func _on_bump_area_body_entered(body):
	if body is Player:
		super.bump(body.player_mode)
#		if body.player_mode == Player.PlayerMode.SMALL:
#			super.bump(body.player_mode)
#		elif !gpu_particles_2d.emitting:
#			player can go throught
#			set_collision_layer_value(5, false)
#			gpu_particles_2d.emitting = true
#			sprite_2d.visible = false
#			super.check_for_upper_collisions()
