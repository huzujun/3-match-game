extends TextureRect

signal pause_game
signal hint
signal plus
func _on_Pause_pressed():
	emit_signal("pause_game")
	get_tree().paused = true

func _on_Hint_pressed():
	emit_signal("hint")

func _on_PlusTime_pressed():
	emit_signal("plus")