extends CanvasLayer

var is_out = false
func slide_in():
	$AnimationPlayer.play("slide_in")
	
func slide_out():
	$AnimationPlayer.play_backward("slide_in")

func _on_grid_game_over():
	slide_in()

func _on_ContinueButton_pressed():
	get_tree().change_scene("res://Scenes/LevelSelectScene.tscn")

onready var label = $"MarginContainer/TextureRect/VBoxContainer/Label"
func _on_grid_game_win(score):
	label.text = String(score)
	slide_in()
