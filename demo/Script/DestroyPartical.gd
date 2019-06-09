extends Particles2D
 
func _ready():
	emitting = true

func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
