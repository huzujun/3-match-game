extends Control

signal read_sound
func _ready():
	$MainMenu.slide_in()

func _on_MainMenu_settings_pressed():
	emit_signal("read_sound")
	$MainMenu.slide_out()
	$SettingMenu.slide_in()

func _on_SettingMenu_back_button():
	$SettingMenu.slide_out()
	$MainMenu.slide_in()

func _on_MainMenu_play_pressed():
	get_tree().change_scene("res://Scenes/LevelSelectScene.tscn")

func _on_SettingMenu_sound_change():
	ConfigManager.sound_on = !ConfigManager.sound_on