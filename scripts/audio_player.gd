extends Node
class_name AudioPlayer

@onready var background_stream = $backgroundStream
@onready var audio_stream_player_jumping = $sfx/AudioStreamPlayer_jumping
@onready var audio_stream_player_stomp = $sfx/AudioStreamPlayer_stomp
@onready var audio_stream_player_mario_die = $sfx/AudioStreamPlayer_mario_die
@onready var audio_stream_player_enemy_die_from_hit = $sfx/AudioStreamPlayer_enemy_die_from_hit

@onready var audio_stream_player_block_hit = $sfx/AudioStreamPlayer_block_hit
@onready var audio_stream_player_power_up = $sfx/AudioStreamPlayer_power_up
@onready var audio_stream_player_coin = $sfx/AudioStreamPlayer_coin
@onready var audio_stream_player_yoshi_coin = $sfx/AudioStreamPlayer_yoshi_coin

@onready var audio_stream_player_power_down = $sfx/AudioStreamPlayer_power_down
@onready var audio_stream_player_shroom_appears = $sfx/AudioStreamPlayer_shroom_appears
@onready var audio_stream_player_fireball = $sfx/AudioStreamPlayer_fireball
@onready var audio_stream_player_enter_pipe = $sfx/AudioStreamPlayer_enter_pipe




const overworld_level_music = preload("res://assets/sounds/overworld_1.wav")

enum Sounds {
	JUMP,
	SHOOT,
	MARIO_DIE,
	STOMP,
	FIRE,
	ENEMY_DIE_FROM_HIT,
	ENTER_PIPE,
	BLOCK_HIT,
	POWER_UP,
	POWER_DOWN,
	SHROOM_APPEARS,
	COIN,
	YOSHI_COIN,
	PAUSE
}

func _play_music(music: AudioStream, volume = 0.0):
	print("play music ", music)
	if background_stream.stream != music:
		background_stream.stream = music
		background_stream.volume_db = volume
	
	if !background_stream.playing:
		background_stream.play()

func stop_music():
	if background_stream.playing:
		background_stream.stop()
	
func play_overworld_music_level():
	_play_music(overworld_level_music)

func play_sound(sound: Sounds):
	if sound == Sounds.JUMP && audio_stream_player_jumping.playing == false:
		audio_stream_player_jumping.play()
	if sound == Sounds.STOMP:
		audio_stream_player_stomp.play()
	if sound == Sounds.MARIO_DIE && audio_stream_player_mario_die.playing == false:
		audio_stream_player_mario_die.play()
	if sound == Sounds.ENEMY_DIE_FROM_HIT:
		audio_stream_player_enemy_die_from_hit.play()
	if sound == Sounds.ENTER_PIPE:
		audio_stream_player_enter_pipe.play()
	if sound == Sounds.FIRE:
		audio_stream_player_fireball.play()
	if sound == Sounds.BLOCK_HIT && audio_stream_player_block_hit.playing == false:
		audio_stream_player_block_hit.play()
	if sound == Sounds.POWER_UP && audio_stream_player_power_up.playing == false:
		audio_stream_player_power_up.play()
	if sound == Sounds.POWER_DOWN && audio_stream_player_power_down.playing == false:
		audio_stream_player_power_down.play()
	if sound == Sounds.SHROOM_APPEARS:
		audio_stream_player_shroom_appears.play()
	if sound == Sounds.COIN:
		audio_stream_player_coin.play()
	if sound == Sounds.YOSHI_COIN:
		audio_stream_player_yoshi_coin.play()
	if sound == Sounds.PAUSE:
		audio_stream_player_yoshi_coin.play()
		
		
