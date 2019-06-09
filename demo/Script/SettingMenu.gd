extends CanvasLayer

signal theme_change
signal sound_change
signal back_button

func slide_in():
	$AnimationPlayer.play("slide_in")
	
func slide_out():
	$AnimationPlayer.play_backwards("slide_in")
	
func _on_theme_pressed():
	emit_signal("theme_change")

func _on_sound_pressed():
	emit_signal("sound_change")

func _on_back_pressed():
	emit_signal("back_button")
