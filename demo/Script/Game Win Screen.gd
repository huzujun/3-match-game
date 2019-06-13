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

func _on_GoalHolder_game_won():
	if is_out == false:
		is_out = true
		slide_in()