extends Control

func _ready():
	$Main.slide_in()

func _on_Main_settings_pressed():
	$Setting.slide_in()
	$Main.slide_out()


func _on_Setting_back_button():
	$Main.slide_in()
	$Setting.slide_out()


func _on_Main_play_pressed():
	get_tree().change_scene("res://Scenes/levels/level_1.tscn")
