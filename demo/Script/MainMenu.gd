extends CanvasLayer

signal play_pressed
signal settings_pressed

func slide_in():
	$AnimationPlayer.play("slide_in")
	
func slide_out():
	$AnimationPlayer.play_backwards("slide_in")
	
func _on_play_pressed():
	emit_signal("play_pressed")
	
func _on_setting_pressed():
	emit_signal("settings_pressed")
