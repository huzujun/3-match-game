extends Control

signal read_sound
onready var theme1 = $"TextureRect"

var theme_picture = [
preload("res://art/主题2/主题2/background2.png"),
preload("res://art/background.png"),
]
onready var helpMenu = $"PopupMenu"
var now = 1

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

func _on_SettingMenu_theme_change():
	now ^= 1
	theme1.texture = theme_picture[now]

func _on_MainMenu_help():
	$MainMenu.slide_out()
	helpMenu.popup()


func _on_PopupMenu_popup_hide():
	$MainMenu.slide_in()
