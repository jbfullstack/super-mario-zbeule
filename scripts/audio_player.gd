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


const overworld_level_music = preload("res://assets/sounds/overworld_1.wav")

enum Sounds {
	JUMP,
	SHOOT,
	MARIO_DIE,
	STOMP,
	ENEMY_DIE_FROM_HIT,
	BLOCK_HIT,
	POWER_UP,
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
	print("play sound", sound)
	if sound == Sounds.JUMP && audio_stream_player_jumping.playing == false:
		audio_stream_player_jumping.play()
	if sound == Sounds.STOMP:
		audio_stream_player_stomp.play()
	if sound == Sounds.MARIO_DIE && audio_stream_player_mario_die.playing == false:
		audio_stream_player_mario_die.play()
	if sound == Sounds.ENEMY_DIE_FROM_HIT:
		audio_stream_player_enemy_die_from_hit.play()
	if sound == Sounds.BLOCK_HIT && audio_stream_player_block_hit.playing == false:
		audio_stream_player_block_hit.play()
	if sound == Sounds.POWER_UP && audio_stream_player_power_up.playing == false:
		audio_stream_player_power_up.play()
	if sound == Sounds.COIN:
		audio_stream_player_coin.play()
	if sound == Sounds.YOSHI_COIN:
		audio_stream_player_yoshi_coin.play()
	if sound == Sounds.PAUSE:
		audio_stream_player_yoshi_coin.play()
