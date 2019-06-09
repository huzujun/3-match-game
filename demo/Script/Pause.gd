extends CanvasLayer
func slide_in():
	$AnimationPlayer.play("slide_in")
	
func slide_out():
	$AnimationPlayer.play_backwards("slide_in")
	
func _on_Quit_pressed():
	get_tree().quit()

func _on_Continue_pressed():
	get_tree().paused = false
	slide_out()

func _on_button_ui_pause_game():
	slide_in()