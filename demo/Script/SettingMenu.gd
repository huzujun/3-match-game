extends CanvasLayer

signal theme_change
signal sound_change
signal back_button
export (Texture) var sound_on
export (Texture) var sound_off
var sound

func slide_in():
	$AnimationPlayer.play("slide_in")
	
func slide_out():
	$AnimationPlayer.play_backwards("slide_in")
	
func _on_theme_pressed():
	emit_signal("theme_change")

func _on_sound_pressed():
	sound = !sound
	change_sound_texture()

func _on_back_pressed():
	emit_signal("back_button")

func _on_Menu_read_sound():
	change_sound_texture()

func change_sound_texture():
	if sound == true:
		$"MarginContainer/Graphic and button/Button/sound".texture_normal = sound_on
	else:
		$"MarginContainer/Graphic and button/Button/sound".texture_normal = sound_off

func _ready():
	sound = ConfigManager.sound_on
	change_sound_texture()
	ConfigManager.save_config()
