extends CanvasLayer

signal theme_change
signal sound_change
signal back_button
export (Texture) var sound_on
export (Texture) var sound_off

func slide_in():
	$AnimationPlayer.play("slide_in")
	
func slide_out():
	$AnimationPlayer.play_backwards("slide_in")
	
func _on_theme_pressed():
	emit_signal("theme_change")

func _on_sound_pressed():
	ConfigManager.sound_on = !ConfigManager.sound_on
	change_sound_texture()
	ConfigManager.save_config()
	SoundManager.set_volume()
	SoundManager.play_fixed_sound(0)

func _on_back_pressed():
	SoundManager.play_fixed_sound(0)
	emit_signal("back_button")

func _on_Menu_read_sound():
	change_sound_texture()

func change_sound_texture():
	if ConfigManager.sound_on == true:
		$"MarginContainer/Graphic and button/Button/sound".texture_normal = sound_on
	else:
		$"MarginContainer/Graphic and button/Button/sound".texture_normal = sound_off

func _ready():
	change_sound_texture()
	ConfigManager.save_config()
