extends CanvasLayer

func _on_Quit_pressed():
	get_tree().change_scene("res://Scenes/Menu.tscn")


func _on_Restart_pressed():
	get_tree().reload_current_scene()

func slide_in():
	$AnimationPlayer.play("slide_in")
	
func _on_grid_game_over():
	slide_in()
