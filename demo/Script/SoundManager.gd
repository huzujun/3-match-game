extends Node
onready var sound_player = $SoundPlayer
onready var music_player = $MusicPlayer
var possible_music = [
preload("res://Sounds/Match 3 Sounds/Music/theme-1.ogg"),
preload("res://Sounds/Match 3 Sounds/Music/theme-2.ogg"),
preload("res://Sounds/Match 3 Sounds/Music/theme-3.ogg")
]
var possible_sounds = [
preload("res://Sounds/Match 3 Sounds/Sounds/1.ogg"),
preload("res://Sounds/Match 3 Sounds/Sounds/3.ogg"),
preload("res://Sounds/Match 3 Sounds/Sounds/4.ogg"),
preload("res://Sounds/Match 3 Sounds/Sounds/5.ogg"),
preload("res://Sounds/Match 3 Sounds/Sounds/6.ogg"),
preload("res://Sounds/Match 3 Sounds/Sounds/7.ogg")
]
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	play_random_music()
	
func play_random_music():
	var tmp = floor(rand_range(0, possible_music.size()))	
	music_player.stream = possible_music[tmp]
	music_player.play()

func play_random_sound():
	var tmp = floor(rand_range(0, possible_sounds.size()))
	sound_player.stream = possible_sounds[tmp]
	sound_player.play()
	
func play_fixed_sound(sound):
	sound_player.stream = possible_sounds[sound]
	sound_player.play()
	
func set_volume():
	if ConfigManager.sound_on:
		music_player.volume_db = -20
		music_player.volume_db = -20
	else:
		music_player.volume_db = -80
		sound_player.volume_db = -80