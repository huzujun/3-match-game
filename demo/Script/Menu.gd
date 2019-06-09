extends Control

func _ready():
	$MainMenu.slide_in()

func _on_MainMenu_settings_pressed():
	$MainMenu.slide_out()
	$SettingMenu.slide_in()

func _on_SettingMenu_back_button():
	$SettingMenu.slide_out()
	$MainMenu.slide_in()

func _on_MainMenu_play_pressed():
	get_tree().change_scene("res://Scenes/levels/level_1.tscn")
